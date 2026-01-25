#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/interrupt.h>
#include <linux/fs.h>
#include <linux/miscdevice.h>
#include <linux/of.h>
#include <linux/io.h>
#include <linux/uaccess.h>

#define DEVNAME "reactie_button"

static void __iomem *pio_ptr;
static int irq_number;
static struct fasync_struct *async_queue = NULL;

static irqreturn_t irq_handler(int irq, void *dev_id)
{
	
    iowrite32(0xF, pio_ptr + 12);

    if (async_queue) {
        kill_fasync(&async_queue, SIGIO, POLL_IN);
    }

    return IRQ_HANDLED;
}

static int my_dev_fasync(int fd, struct file *filp, int on) {
    return fasync_helper(fd, filp, on, &async_queue);
}

static int my_dev_open(struct inode *inode, struct file *file) { return 0; }

static int my_dev_release(struct inode *inode, struct file *file) {
    my_dev_fasync(-1, file, 0);
    return 0;
}

static const struct file_operations my_dev_fops = {
    .owner = THIS_MODULE,
    .open = my_dev_open,
    .release = my_dev_release,
    .fasync = my_dev_fasync,
};

static struct miscdevice my_device = {
    .minor = MISC_DYNAMIC_MINOR,
    .name = DEVNAME,
    .fops = &my_dev_fops,
};

static int init_handler(struct platform_device *pdev)
{
    int ret;

    pio_ptr = devm_platform_ioremap_resource(pdev, 0);
    if (IS_ERR(pio_ptr)) return PTR_ERR(pio_ptr);

    irq_number = platform_get_irq(pdev, 0);
    if (irq_number < 0) return irq_number;

    ret = misc_register(&my_device);
    if (ret) return ret;

    ret = request_irq(irq_number, irq_handler, 0, DEVNAME, NULL);
    if (ret) {
        misc_deregister(&my_device);
        return ret;
    }

    iowrite32(0xF, pio_ptr + 8);
    iowrite32(0xF, pio_ptr + 12);

    pr_info(DEVNAME ": Driver loaded on IRQ %d\n", irq_number);
    return 0;
}

static int clean_handler(struct platform_device *pdev)
{
    free_irq(irq_number, NULL);
    misc_deregister(&my_device);
    pr_info(DEVNAME ": Driver removed\n");
    return 0;
}

static const struct of_device_id my_of_match[] = {
    { .compatible = "csc10,button" },
    { }
};
MODULE_DEVICE_TABLE(of, my_of_match);

static struct platform_driver my_driver = {
    .driver = {
        .name = DEVNAME,
        .owner = THIS_MODULE,
        .of_match_table = my_of_match,
    },
    .probe = init_handler,
    .remove = clean_handler,
};

module_platform_driver(my_driver);
MODULE_LICENSE("GPL");