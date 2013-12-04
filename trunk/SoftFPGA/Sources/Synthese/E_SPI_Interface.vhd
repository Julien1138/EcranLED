----------------|-------------------------------------------------------------
--              . 
-- Project        EcranLED
--              . 
--! @file         E_SPI_Interface.vhd
--              . 
-- Type           Synthétisable
--              . 
--! @author       J. AUPART
--              . 
--! @version      1.0
--              . 
--! @date         04 Décembre 2013
--              . 
----------------|-------------------------------------------------------------
-- Description  : 
--                
----------------|-------------------------------------------------------------
-- Historique   : 
-- 
-- Version 1.0    04/12/2013     J. AUPART
-- 
----------------|-------------------------------------------------------------
-- Commentaires :
-- 
--         1.0  : Création
-- 
----------------|-------------------------------------------------------------

--
-- Déclaration des bibliothèques
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.Pkg_SPI_Interface.all;

entity E_SPI_Interface is
   port
   (
      -- Signaux globaux
      rst_i          : in  std_logic;
      clk_i          : in  std_logic;
      
      -- Interface SPI
      io_spi_sclk    : in  std_logic;
      io_spi_ss      : in  std_logic;
      io_spi_mosi    : in  std_logic;
      io_spi_miso    : out std_logic;
      
      -- Interface codec
      spi_recue_o    : out std_logic;
      spi_data_in_o  : out std_logic_vector(7 downto 0);
      spi_envoyee_o  : out std_logic;
      spi_data_out_i : in  std_logic_vector(7 downto 0);
   );
end entity E_SPI_Interface;

---------------------------DESCRIPTION DU MODULE---------------------------
--! 
---------------------------------------------------------------------------

architecture A_SPI_Interface of E_SPI_Interface is
   
   --
   -- Déclaration des signaux
   --
   s_compteur_bits   : std_logic_vector(2 downto 0);  -- Compteur de bits
   
begin
   
   --! Process : \n
   --! Description :
   prc_ : process(rst_i, clk_i)
   begin
      if rst_pci_i = '1' then
         
      elsif rising_edge(clk_i) then
         
      end if;
   end process;
   
   
end architecture A_SPI_Interface;
