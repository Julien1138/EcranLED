----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         EcranLED
--              . 
--! @file         EcranLED_tb.vhd
--              . 
-- Type           Test Bench
--              . 
--! @author       J. AUPART
--              . 
--! @version      1.0
--              . 
--! @date         23/08/2013
--              . 
----------------|-------------------------------------------------------------
-- Description  : Test bench du module EcranLED
--                
----------------|-------------------------------------------------------------
-- Historique   : 
-- 
-- Version 1.0    23/08/2013     J. AUPART
-- 
----------------|-------------------------------------------------------------
-- Commentaires :
-- 
--         1.0  : Création
-- 
----------------|-------------------------------------------------------------


--! use standard library
library ieee;
--! use logic elements
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.pkg_driver.all;


entity EcranLED_tb is
end EcranLED_tb;

---------------------------------  Description du test bench  -------------------------------------
--! Test haut niveau.
---------------------------------------------------------------------------------------------------

architecture bench_EcranLED of EcranLED_tb is
   
   component EcranLED is
      port
      (
         io_clk_i             : in  std_logic;
         
         io_spi_ss1_i         : in  std_logic;  --! Chip select SPI
         io_spi_ss2_i         : in  std_logic;  --! Chip select SPI
         io_spi_sck_i         : in  std_logic;  --! Signal d'horloge SPI
         io_spi_mosi_i        : in  std_logic;  --! Données SPI entrantes
         io_spi_miso_o        : out std_logic;  --! Données SPI sortantes
         
      -- Interface drivers carte LED n°1
         io_driver_1_dclk_o   : out std_logic;  --! Horloge de données du driver de LED
         io_driver_1_latch_o  : out std_logic;  --! Latch du driver de LED
         io_driver_1_sdi1_o   : out std_logic;  --! Donnée entrante du driver de LED n°1
         io_driver_1_sdi2_o   : out std_logic;  --! Donnée entrante du driver de LED n°2
         io_driver_1_sdi3_o   : out std_logic;  --! Donnée entrante du driver de LED n°3
         io_driver_1_gclk_o   : out std_logic;  --! Horloge de PWM du driver de LED
         
      -- Interface drivers carte LED n°2
         io_driver_2_dclk_o   : out std_logic;  --! Horloge de données du driver de LED
         io_driver_2_latch_o  : out std_logic;  --! Latch du driver de LED
         io_driver_2_sdi1_o   : out std_logic;  --! Donnée entrante du driver de LED n°1
         io_driver_2_sdi2_o   : out std_logic;  --! Donnée entrante du driver de LED n°2
         io_driver_2_sdi3_o   : out std_logic;  --! Donnée entrante du driver de LED n°3
         io_driver_2_gclk_o   : out std_logic;  --! Horloge de PWM du driver de LED
         
      -- Interface drivers carte LED n°3
         io_driver_3_dclk_o   : out std_logic;  --! Horloge de données du driver de LED
         io_driver_3_latch_o  : out std_logic;  --! Latch du driver de LED
         io_driver_3_sdi1_o   : out std_logic;  --! Donnée entrante du driver de LED n°1
         io_driver_3_sdi2_o   : out std_logic;  --! Donnée entrante du driver de LED n°2
         io_driver_3_sdi3_o   : out std_logic;  --! Donnée entrante du driver de LED n°3
         io_driver_3_gclk_o   : out std_logic;  --! Horloge de PWM du driver de LED
         
      -- Interface drivers carte LED n°4
         io_driver_4_dclk_o   : out std_logic;  --! Horloge de données du driver de LED
         io_driver_4_latch_o  : out std_logic;  --! Latch du driver de LED
         io_driver_4_sdi1_o   : out std_logic;  --! Donnée entrante du driver de LED n°1
         io_driver_4_sdi2_o   : out std_logic;  --! Donnée entrante du driver de LED n°2
         io_driver_4_sdi3_o   : out std_logic;  --! Donnée entrante du driver de LED n°3
         io_driver_4_gclk_o   : out std_logic;  --! Horloge de PWM du driver de LED
         
      -- Interface drivers carte LED n°5
         io_driver_5_dclk_o   : out std_logic;  --! Horloge de données du driver de LED
         io_driver_5_latch_o  : out std_logic;  --! Latch du driver de LED
         io_driver_5_sdi1_o   : out std_logic;  --! Donnée entrante du driver de LED n°1
         io_driver_5_sdi2_o   : out std_logic;  --! Donnée entrante du driver de LED n°2
         io_driver_5_sdi3_o   : out std_logic;  --! Donnée entrante du driver de LED n°3
         io_driver_5_gclk_o   : out std_logic;  --! Horloge de PWM du driver de LED
         
      -- Interface drivers carte LED n°6
         io_driver_6_dclk_o   : out std_logic;  --! Horloge de données du driver de LED
         io_driver_6_latch_o  : out std_logic;  --! Latch du driver de LED
         io_driver_6_sdi1_o   : out std_logic;  --! Donnée entrante du driver de LED n°1
         io_driver_6_sdi2_o   : out std_logic;  --! Donnée entrante du driver de LED n°2
         io_driver_6_sdi3_o   : out std_logic;  --! Donnée entrante du driver de LED n°3
         io_driver_6_gclk_o   : out std_logic;  --! Horloge de PWM du driver de LED
         
      -- DEBUG
         io_LED_o             : out std_logic_vector(7 downto 0)
      );
   end component;
   
-- Signaux globaux
   signal s_io_clk             : std_logic := '1';
   
   signal s_io_spi_ss1         : std_logic := '1';  --! Chip select SPI
   signal s_io_spi_ss2         : std_logic := '1';  --! Chip select SPI
   signal s_io_spi_sck         : std_logic := '0';  --! Signal d'horloge SPI
   signal s_io_spi_mosi        : std_logic := 'Z';  --! Données SPI entrantes
   
   signal s_spi_start   : std_logic;
   signal s_spi_data    : std_logic_vector(7 downto 0);
   
   constant CST_CLK_PERIODE   : time := 20 ns;  --! 50 MHz
   constant CST_SPI_PERIODE   : time := 200 ns; --! 5 MHz
   
begin
   
   s_io_clk   <= not s_io_clk after CST_CLK_PERIODE/2;
   
   process
   begin
      s_spi_start <= '0';
      s_spi_data <= (others => '0');
      wait for 10 us;
	  
   -- image loupée
      if s_io_spi_ss1 /= '1' then
         wait until s_io_spi_ss1 = '1';
      end if;
      s_spi_start <= '1';
      s_spi_data <= X"A2";
      wait until s_io_spi_ss1 = '0';
      s_spi_start <= '0';
      
      wait until s_io_spi_ss1 = '1';
      s_spi_start <= '1';
      s_spi_data <= X"04";
      wait until s_io_spi_ss1 = '0';
      s_spi_start <= '0';
      
      wait until s_io_spi_ss1 = '1';
      s_spi_start <= '1';
      s_spi_data <= X"00";
      wait until s_io_spi_ss1 = '0';
      s_spi_start <= '0';
      
      wait until s_io_spi_ss1 = '1';
      s_spi_start <= '1';
      s_spi_data <= X"00";
      wait until s_io_spi_ss1 = '0';
      s_spi_start <= '0';
      
   -- Ligne 1
      loop_ligne : for ligne in 0 to 56 loop
         if s_io_spi_ss1 /= '1' then
            wait until s_io_spi_ss1 = '1';
         end if;
         s_spi_start <= '1';
         s_spi_data <= X"A2";
         wait until s_io_spi_ss1 = '0';
         s_spi_start <= '0';
         
         wait until s_io_spi_ss1 = '1';
         s_spi_start <= '1';
         s_spi_data <= conv_std_logic_vector(ligne, 8);
         wait until s_io_spi_ss1 = '0';
         s_spi_start <= '0';
         
         loop_colonne : for colonne in 0 to 191 loop
            loop_couleur : for couleur in 0 to 2 loop
               wait until s_io_spi_ss1 = '1';
               s_spi_start <= '1';
               s_spi_data <= conv_std_logic_vector(ligne+colonne+couleur, 8);
               wait until s_io_spi_ss1 = '0';
               s_spi_start <= '0';
            end loop;
         end loop;
      end loop;
      
      wait;
   end process;
   
   prc_serialiseur : process
   begin
      s_io_spi_ss1   <= '1';
      s_io_spi_sck   <= '0';
      s_io_spi_mosi  <= 'Z';
      
      if s_spi_start /= '1' then
         wait until s_spi_start = '1';
      end if;
      s_io_spi_ss1   <= '0';
      s_io_spi_sck   <= '0', '1' after CST_SPI_PERIODE/2;
      s_io_spi_mosi  <= s_spi_data(7);
      wait for CST_SPI_PERIODE;
      s_io_spi_ss1   <= '0';
      s_io_spi_sck   <= '0', '1' after CST_SPI_PERIODE/2;
      s_io_spi_mosi  <= s_spi_data(6);
      wait for CST_SPI_PERIODE;
      s_io_spi_ss1   <= '0';
      s_io_spi_sck   <= '0', '1' after CST_SPI_PERIODE/2;
      s_io_spi_mosi  <= s_spi_data(5);
      wait for CST_SPI_PERIODE;
      s_io_spi_ss1   <= '0';
      s_io_spi_sck   <= '0', '1' after CST_SPI_PERIODE/2;
      s_io_spi_mosi  <= s_spi_data(4);
      wait for CST_SPI_PERIODE;
      s_io_spi_ss1   <= '0';
      s_io_spi_sck   <= '0', '1' after CST_SPI_PERIODE/2;
      s_io_spi_mosi  <= s_spi_data(3);
      wait for CST_SPI_PERIODE;
      s_io_spi_ss1   <= '0';
      s_io_spi_sck   <= '0', '1' after CST_SPI_PERIODE/2;
      s_io_spi_mosi  <= s_spi_data(2);
      wait for CST_SPI_PERIODE;
      s_io_spi_ss1   <= '0';
      s_io_spi_sck   <= '0', '1' after CST_SPI_PERIODE/2;
      s_io_spi_mosi  <= s_spi_data(1);
      wait for CST_SPI_PERIODE;
      s_io_spi_ss1   <= '0';
      s_io_spi_sck   <= '0', '1' after CST_SPI_PERIODE/2;
      s_io_spi_mosi  <= s_spi_data(0);
      wait for CST_SPI_PERIODE;
      s_io_spi_ss1   <= '0';
      s_io_spi_sck   <= '0';
      s_io_spi_mosi  <= 'Z';
      wait for 2*CST_SPI_PERIODE;
   end process;
   
   uut : EcranLED
   port map
   (
      io_clk_i             => s_io_clk,
      
      io_spi_ss1_i         => s_io_spi_ss1,
      io_spi_ss2_i         => s_io_spi_ss2,
      io_spi_sck_i         => s_io_spi_sck,
      io_spi_mosi_i        => s_io_spi_mosi,
      io_spi_miso_o        => open,
      
   -- Interface drivers carte LED n°1
      io_driver_1_dclk_o   => open,
      io_driver_1_latch_o  => open,
      io_driver_1_sdi1_o   => open,
      io_driver_1_sdi2_o   => open,
      io_driver_1_sdi3_o   => open,
      io_driver_1_gclk_o   => open,
      
   -- Interface drivers carte LED n°2
      io_driver_2_dclk_o   => open,
      io_driver_2_latch_o  => open,
      io_driver_2_sdi1_o   => open,
      io_driver_2_sdi2_o   => open,
      io_driver_2_sdi3_o   => open,
      io_driver_2_gclk_o   => open,
      
   -- Interface drivers carte LED n°3
      io_driver_3_dclk_o   => open,
      io_driver_3_latch_o  => open,
      io_driver_3_sdi1_o   => open,
      io_driver_3_sdi2_o   => open,
      io_driver_3_sdi3_o   => open,
      io_driver_3_gclk_o   => open,
      
   -- Interface drivers carte LED n°4
      io_driver_4_dclk_o   => open,
      io_driver_4_latch_o  => open,
      io_driver_4_sdi1_o   => open,
      io_driver_4_sdi2_o   => open,
      io_driver_4_sdi3_o   => open,
      io_driver_4_gclk_o   => open,
      
   -- Interface drivers carte LED n°5
      io_driver_5_dclk_o   => open,
      io_driver_5_latch_o  => open,
      io_driver_5_sdi1_o   => open,
      io_driver_5_sdi2_o   => open,
      io_driver_5_sdi3_o   => open,
      io_driver_5_gclk_o   => open,
      
   -- Interface drivers carte LED n°6
      io_driver_6_dclk_o   => open,
      io_driver_6_latch_o  => open,
      io_driver_6_sdi1_o   => open,
      io_driver_6_sdi2_o   => open,
      io_driver_6_sdi3_o   => open,
      io_driver_6_gclk_o   => open,
      
   -- DEBUG
      io_LED_o             => open
   );
   
end architecture bench_EcranLED;
