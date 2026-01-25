LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY hps_demo IS
    PORT (
        CLOCK_50 : IN STD_LOGIC;
        KEY      : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        SW       : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        LEDR     : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		
        memory_mem_a                    : OUT   STD_LOGIC_VECTOR(14 DOWNTO 0);
        memory_mem_ba                   : OUT   STD_LOGIC_VECTOR(2 DOWNTO 0);
        memory_mem_ck                   : OUT   STD_LOGIC;
        memory_mem_ck_n                 : OUT   STD_LOGIC;
        memory_mem_cke                  : OUT   STD_LOGIC;
        memory_mem_cs_n                 : OUT   STD_LOGIC;
        memory_mem_ras_n                : OUT   STD_LOGIC;
        memory_mem_cas_n                : OUT   STD_LOGIC;
        memory_mem_we_n                 : OUT   STD_LOGIC;
        memory_mem_reset_n              : OUT   STD_LOGIC;
        memory_mem_dq                   : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        memory_mem_dqs                  : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        memory_mem_dqs_n                : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        memory_mem_odt                  : OUT   STD_LOGIC;
        memory_mem_dm                   : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
        memory_oct_rzqin                : IN    STD_LOGIC;
        
        hps_io_hps_io_emac1_inst_TX_CLK : OUT   STD_LOGIC;
        hps_io_hps_io_emac1_inst_TXD0   : OUT   STD_LOGIC;
        hps_io_hps_io_emac1_inst_TXD1   : OUT   STD_LOGIC;
        hps_io_hps_io_emac1_inst_TXD2   : OUT   STD_LOGIC;
        hps_io_hps_io_emac1_inst_TXD3   : OUT   STD_LOGIC;
        hps_io_hps_io_emac1_inst_RXD0   : IN    STD_LOGIC;
        hps_io_hps_io_emac1_inst_MDIO   : INOUT STD_LOGIC;
        hps_io_hps_io_emac1_inst_MDC    : OUT   STD_LOGIC;
        hps_io_hps_io_emac1_inst_RX_CTL : IN    STD_LOGIC;
        hps_io_hps_io_emac1_inst_TX_CTL : OUT   STD_LOGIC;
        hps_io_hps_io_emac1_inst_RX_CLK : IN    STD_LOGIC;
        hps_io_hps_io_emac1_inst_RXD1   : IN    STD_LOGIC;
        hps_io_hps_io_emac1_inst_RXD2   : IN    STD_LOGIC;
        hps_io_hps_io_emac1_inst_RXD3   : IN    STD_LOGIC;
        hps_io_hps_io_qspi_inst_IO0     : INOUT STD_LOGIC;
        hps_io_hps_io_qspi_inst_IO1     : INOUT STD_LOGIC;
        hps_io_hps_io_qspi_inst_IO2     : INOUT STD_LOGIC;
        hps_io_hps_io_qspi_inst_IO3     : INOUT STD_LOGIC;
        hps_io_hps_io_qspi_inst_SS0     : OUT   STD_LOGIC;
        hps_io_hps_io_qspi_inst_CLK     : OUT   STD_LOGIC;
        hps_io_hps_io_sdio_inst_CMD     : INOUT STD_LOGIC;
        hps_io_hps_io_sdio_inst_D0      : INOUT STD_LOGIC;
        hps_io_hps_io_sdio_inst_D1      : INOUT STD_LOGIC;
        hps_io_hps_io_sdio_inst_CLK     : OUT   STD_LOGIC;
        hps_io_hps_io_sdio_inst_D2      : INOUT STD_LOGIC;
        hps_io_hps_io_sdio_inst_D3      : INOUT STD_LOGIC;
        hps_io_hps_io_usb1_inst_D0      : INOUT STD_LOGIC;
        hps_io_hps_io_usb1_inst_D1      : INOUT STD_LOGIC;
        hps_io_hps_io_usb1_inst_D2      : INOUT STD_LOGIC;
        hps_io_hps_io_usb1_inst_D3      : INOUT STD_LOGIC;
        hps_io_hps_io_usb1_inst_D4      : INOUT STD_LOGIC;
        hps_io_hps_io_usb1_inst_D5      : INOUT STD_LOGIC;
        hps_io_hps_io_usb1_inst_D6      : INOUT STD_LOGIC;
        hps_io_hps_io_usb1_inst_D7      : INOUT STD_LOGIC;
        hps_io_hps_io_usb1_inst_CLK     : IN    STD_LOGIC;
        hps_io_hps_io_usb1_inst_STP     : OUT   STD_LOGIC;
        hps_io_hps_io_usb1_inst_DIR     : IN    STD_LOGIC;
        hps_io_hps_io_usb1_inst_NXT     : IN    STD_LOGIC;
        hps_io_hps_io_spim1_inst_CLK    : OUT   STD_LOGIC;
        hps_io_hps_io_spim1_inst_MOSI   : OUT   STD_LOGIC;
        hps_io_hps_io_spim1_inst_MISO   : IN    STD_LOGIC;
        hps_io_hps_io_spim1_inst_SS0    : OUT   STD_LOGIC;
        hps_io_hps_io_uart0_inst_RX     : IN    STD_LOGIC;
        hps_io_hps_io_uart0_inst_TX     : OUT   STD_LOGIC;
        hps_io_hps_io_i2c0_inst_SDA     : INOUT STD_LOGIC;
        hps_io_hps_io_i2c0_inst_SCL     : INOUT STD_LOGIC;
        hps_io_hps_io_i2c1_inst_SDA     : INOUT STD_LOGIC;
        hps_io_hps_io_i2c1_inst_SCL     : INOUT STD_LOGIC;
        hps_io_hps_io_gpio_inst_GPIO53  : INOUT STD_LOGIC;
        hps_io_hps_io_gpio_inst_GPIO54  : INOUT STD_LOGIC
    );
END hps_demo;

ARCHITECTURE Structure OF hps_demo IS
    
    component hps_systeem is
        port (
            buttons_export                           : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- export
            clk_clk                                  : in    std_logic                     := 'X';             -- clk
            hps_io_hps_io_emac1_inst_TX_CLK          : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
            hps_io_hps_io_emac1_inst_TXD0            : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
            hps_io_hps_io_emac1_inst_TXD1            : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
            hps_io_hps_io_emac1_inst_TXD2            : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
            hps_io_hps_io_emac1_inst_TXD3            : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
            hps_io_hps_io_emac1_inst_RXD0            : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
            hps_io_hps_io_emac1_inst_MDIO            : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
            hps_io_hps_io_emac1_inst_MDC             : out   std_logic;                                        -- hps_io_emac1_inst_MDC
            hps_io_hps_io_emac1_inst_RX_CTL          : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
            hps_io_hps_io_emac1_inst_TX_CTL          : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
            hps_io_hps_io_emac1_inst_RX_CLK          : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
            hps_io_hps_io_emac1_inst_RXD1            : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
            hps_io_hps_io_emac1_inst_RXD2            : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
            hps_io_hps_io_emac1_inst_RXD3            : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
            hps_io_hps_io_qspi_inst_IO0              : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO0
            hps_io_hps_io_qspi_inst_IO1              : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO1
            hps_io_hps_io_qspi_inst_IO2              : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO2
            hps_io_hps_io_qspi_inst_IO3              : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO3
            hps_io_hps_io_qspi_inst_SS0              : out   std_logic;                                        -- hps_io_qspi_inst_SS0
            hps_io_hps_io_qspi_inst_CLK              : out   std_logic;                                        -- hps_io_qspi_inst_CLK
            hps_io_hps_io_sdio_inst_CMD              : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
            hps_io_hps_io_sdio_inst_D0               : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
            hps_io_hps_io_sdio_inst_D1               : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
            hps_io_hps_io_sdio_inst_CLK              : out   std_logic;                                        -- hps_io_sdio_inst_CLK
            hps_io_hps_io_sdio_inst_D2               : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
            hps_io_hps_io_sdio_inst_D3               : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
            hps_io_hps_io_usb1_inst_D0               : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
            hps_io_hps_io_usb1_inst_D1               : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
            hps_io_hps_io_usb1_inst_D2               : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
            hps_io_hps_io_usb1_inst_D3               : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
            hps_io_hps_io_usb1_inst_D4               : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
            hps_io_hps_io_usb1_inst_D5               : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
            hps_io_hps_io_usb1_inst_D6               : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
            hps_io_hps_io_usb1_inst_D7               : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
            hps_io_hps_io_usb1_inst_CLK              : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
            hps_io_hps_io_usb1_inst_STP              : out   std_logic;                                        -- hps_io_usb1_inst_STP
            hps_io_hps_io_usb1_inst_DIR              : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
            hps_io_hps_io_usb1_inst_NXT              : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
            hps_io_hps_io_spim1_inst_CLK             : out   std_logic;                                        -- hps_io_spim1_inst_CLK
            hps_io_hps_io_spim1_inst_MOSI            : out   std_logic;                                        -- hps_io_spim1_inst_MOSI
            hps_io_hps_io_spim1_inst_MISO            : in    std_logic                     := 'X';             -- hps_io_spim1_inst_MISO
            hps_io_hps_io_spim1_inst_SS0             : out   std_logic;                                        -- hps_io_spim1_inst_SS0
            hps_io_hps_io_uart0_inst_RX              : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
            hps_io_hps_io_uart0_inst_TX              : out   std_logic;                                        -- hps_io_uart0_inst_TX
            hps_io_hps_io_i2c0_inst_SDA              : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
            hps_io_hps_io_i2c0_inst_SCL              : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
            hps_io_hps_io_i2c1_inst_SDA              : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
            hps_io_hps_io_i2c1_inst_SCL              : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
            hps_io_hps_io_gpio_inst_GPIO53           : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
            hps_io_hps_io_gpio_inst_GPIO54           : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
            leds_export                              : out   std_logic_vector(9 downto 0);                     -- export
            memory_mem_a                             : out   std_logic_vector(14 downto 0);                    -- mem_a
            memory_mem_ba                            : out   std_logic_vector(2 downto 0);                     -- mem_ba
            memory_mem_ck                            : out   std_logic;                                        -- mem_ck
            memory_mem_ck_n                          : out   std_logic;                                        -- mem_ck_n
            memory_mem_cke                           : out   std_logic;                                        -- mem_cke
            memory_mem_cs_n                          : out   std_logic;                                        -- mem_cs_n
            memory_mem_ras_n                         : out   std_logic;                                        -- mem_ras_n
            memory_mem_cas_n                         : out   std_logic;                                        -- mem_cas_n
            memory_mem_we_n                          : out   std_logic;                                        -- mem_we_n
            memory_mem_reset_n                       : out   std_logic;                                        -- mem_reset_n
            memory_mem_dq                            : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
            memory_mem_dqs                           : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
            memory_mem_dqs_n                         : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
            memory_mem_odt                           : out   std_logic;                                        -- mem_odt
            memory_mem_dm                            : out   std_logic_vector(3 downto 0);                     -- mem_dm
            memory_oct_rzqin                         : in    std_logic                     := 'X';             -- oct_rzqin
            reset_reset_n                            : in    std_logic                     := 'X';             -- reset_n
            a_7_segment_encoder_0_conduit_end_export : out   std_logic_vector(41 downto 0);                    -- export
            switches_export                          : in    std_logic_vector(9 downto 0)  := (others => 'X')  -- export
        );
    end component hps_systeem;


BEGIN
    u0 : COMPONENT hps_systeem
        PORT MAP(
            clk_clk                         => CLOCK_50,
            reset_reset_n                   => KEY(0),
            buttons_export(2)               => KEY(3),
			buttons_export(1)               => KEY(2),
			buttons_export(0)               => KEY(1),
            leds_export                     => LEDR,
            
			a_7_segment_encoder_0_conduit_end_export(6 downto 0) => HEX0,
			a_7_segment_encoder_0_conduit_end_export(13 downto 7) => HEX1,
			a_7_segment_encoder_0_conduit_end_export(20 downto 14) => HEX2,
			a_7_segment_encoder_0_conduit_end_export(27 downto 21) => HEX3,
			a_7_segment_encoder_0_conduit_end_export(34 downto 28) => HEX4,
			a_7_segment_encoder_0_conduit_end_export(41 downto 35) => HEX5,
			switches_export                          => SW,
			
            hps_io_hps_io_emac1_inst_TX_CLK => hps_io_hps_io_emac1_inst_TX_CLK,
            hps_io_hps_io_emac1_inst_TXD0   => hps_io_hps_io_emac1_inst_TXD0,
            hps_io_hps_io_emac1_inst_TXD1   => hps_io_hps_io_emac1_inst_TXD1,
            hps_io_hps_io_emac1_inst_TXD2   => hps_io_hps_io_emac1_inst_TXD2,
            hps_io_hps_io_emac1_inst_TXD3   => hps_io_hps_io_emac1_inst_TXD3,
            hps_io_hps_io_emac1_inst_RXD0   => hps_io_hps_io_emac1_inst_RXD0,
            hps_io_hps_io_emac1_inst_MDIO   => hps_io_hps_io_emac1_inst_MDIO,
            hps_io_hps_io_emac1_inst_MDC    => hps_io_hps_io_emac1_inst_MDC,
            hps_io_hps_io_emac1_inst_RX_CTL => hps_io_hps_io_emac1_inst_RX_CTL,
            hps_io_hps_io_emac1_inst_TX_CTL => hps_io_hps_io_emac1_inst_TX_CTL,
            hps_io_hps_io_emac1_inst_RX_CLK => hps_io_hps_io_emac1_inst_RX_CLK,
            hps_io_hps_io_emac1_inst_RXD1   => hps_io_hps_io_emac1_inst_RXD1,
            hps_io_hps_io_emac1_inst_RXD2   => hps_io_hps_io_emac1_inst_RXD2,
            hps_io_hps_io_emac1_inst_RXD3   => hps_io_hps_io_emac1_inst_RXD3,
            hps_io_hps_io_qspi_inst_IO0     => hps_io_hps_io_qspi_inst_IO0,
            hps_io_hps_io_qspi_inst_IO1     => hps_io_hps_io_qspi_inst_IO1,
            hps_io_hps_io_qspi_inst_IO2     => hps_io_hps_io_qspi_inst_IO2,
            hps_io_hps_io_qspi_inst_IO3     => hps_io_hps_io_qspi_inst_IO3,
            hps_io_hps_io_qspi_inst_SS0     => hps_io_hps_io_qspi_inst_SS0,
            hps_io_hps_io_qspi_inst_CLK     => hps_io_hps_io_qspi_inst_CLK,
            hps_io_hps_io_sdio_inst_CMD     => hps_io_hps_io_sdio_inst_CMD,
            hps_io_hps_io_sdio_inst_D0      => hps_io_hps_io_sdio_inst_D0,
            hps_io_hps_io_sdio_inst_D1      => hps_io_hps_io_sdio_inst_D1,
            hps_io_hps_io_sdio_inst_CLK     => hps_io_hps_io_sdio_inst_CLK,
            hps_io_hps_io_sdio_inst_D2      => hps_io_hps_io_sdio_inst_D2,
            hps_io_hps_io_sdio_inst_D3      => hps_io_hps_io_sdio_inst_D3,
            hps_io_hps_io_usb1_inst_D0      => hps_io_hps_io_usb1_inst_D0,
            hps_io_hps_io_usb1_inst_D1      => hps_io_hps_io_usb1_inst_D1,
            hps_io_hps_io_usb1_inst_D2      => hps_io_hps_io_usb1_inst_D2,
            hps_io_hps_io_usb1_inst_D3      => hps_io_hps_io_usb1_inst_D3,
            hps_io_hps_io_usb1_inst_D4      => hps_io_hps_io_usb1_inst_D4,
            hps_io_hps_io_usb1_inst_D5      => hps_io_hps_io_usb1_inst_D5,
            hps_io_hps_io_usb1_inst_D6      => hps_io_hps_io_usb1_inst_D6,
            hps_io_hps_io_usb1_inst_D7      => hps_io_hps_io_usb1_inst_D7,
            hps_io_hps_io_usb1_inst_CLK     => hps_io_hps_io_usb1_inst_CLK,
            hps_io_hps_io_usb1_inst_STP     => hps_io_hps_io_usb1_inst_STP,
            hps_io_hps_io_usb1_inst_DIR     => hps_io_hps_io_usb1_inst_DIR,
            hps_io_hps_io_usb1_inst_NXT     => hps_io_hps_io_usb1_inst_NXT,
            hps_io_hps_io_spim1_inst_CLK    => hps_io_hps_io_spim1_inst_CLK,
            hps_io_hps_io_spim1_inst_MOSI   => hps_io_hps_io_spim1_inst_MOSI,
            hps_io_hps_io_spim1_inst_MISO   => hps_io_hps_io_spim1_inst_MISO,
            hps_io_hps_io_spim1_inst_SS0    => hps_io_hps_io_spim1_inst_SS0,
            hps_io_hps_io_uart0_inst_RX     => hps_io_hps_io_uart0_inst_RX,
            hps_io_hps_io_uart0_inst_TX     => hps_io_hps_io_uart0_inst_TX,
            hps_io_hps_io_i2c0_inst_SDA     => hps_io_hps_io_i2c0_inst_SDA,
            hps_io_hps_io_i2c0_inst_SCL     => hps_io_hps_io_i2c0_inst_SCL,
            hps_io_hps_io_i2c1_inst_SDA     => hps_io_hps_io_i2c1_inst_SDA,
            hps_io_hps_io_i2c1_inst_SCL     => hps_io_hps_io_i2c1_inst_SCL,
            hps_io_hps_io_gpio_inst_GPIO53  => hps_io_hps_io_gpio_inst_GPIO53,
            hps_io_hps_io_gpio_inst_GPIO54  => hps_io_hps_io_gpio_inst_GPIO54,
            memory_mem_a                    => memory_mem_a,
            memory_mem_ba                   => memory_mem_ba,
            memory_mem_ck                   => memory_mem_ck,
            memory_mem_ck_n                 => memory_mem_ck_n,
            memory_mem_cke                  => memory_mem_cke,
            memory_mem_cs_n                 => memory_mem_cs_n,
            memory_mem_ras_n                => memory_mem_ras_n,
            memory_mem_cas_n                => memory_mem_cas_n,
            memory_mem_we_n                 => memory_mem_we_n,
            memory_mem_reset_n              => memory_mem_reset_n,
            memory_mem_dq                   => memory_mem_dq,
            memory_mem_dqs                  => memory_mem_dqs,
            memory_mem_dqs_n                => memory_mem_dqs_n,
            memory_mem_odt                  => memory_mem_odt,
            memory_mem_dm                   => memory_mem_dm,
            memory_oct_rzqin                => memory_oct_rzqin
        );

END Structure;
