----------------------------------------------------------------------
-- Design Name    : SPI_Lib
-- Module Name    : E_SPI_EdgeDetector
--
--! @file E_SPI_EdgeDetector.vhd
--! @brief Control signal edge detector of the SPI Library
--
--! @author J. Aupart
--! @version 1.1
--! @date 25 novembre 2011
-- 
-- -----------------------------------------------------------------
-- Revision List
-- Version        Author(s)      Date        Changes
--
-- 1.0            J.Aupart       22/06/11    Creation    
-- 1.1            J.Aupart       25/11/11    Suppression de l'utilisation de la library numeric_bit
--------------------------------------------------------------------

--
-- Déclaration des bibliothèques
--
library ieee;
use ieee.std_logic_1164.all;

library SPI_Lib;
use SPI_Lib.SPI_Pack.all;

--
-- Déclaration de l’entité 
--! @brief Edge Detector
--! @details 
--
entity E_SPI_EdgeDetector is
   port
   (
      rst_i          : in std_logic;   --! Global reset
      clk_i          : in std_logic;   --! Global clock
      
      Signal_i       : in std_logic;   --! Input signal (SCK or SS)
      
      TopRising_o    : out std_logic;  --! RisingEdge detected
      TopFalling_o   : out std_logic   --! FallingEdge detected
   );
end E_SPI_EdgeDetector;

architecture A_SPI_EdgeDetector of E_SPI_EdgeDetector is
   
   signal s_Signal_d : std_logic;
   
begin
   
   --
   -- Process : prc_SignalDelay
   --! @brief Delay input signal
   --
   prc_SignalDelay : process(rst_i, clk_i, Signal_i)
   begin
      if rst_i = '1' then
         s_Signal_d <= Signal_i;
      elsif rising_edge(clk_i) then
         
         s_Signal_d <= Signal_i;
         
      end if;
   end process;
   TopRising_o  <= '1' when s_Signal_d = '0' and Signal_i = '1' else
                   '0';
   TopFalling_o <= '1' when s_Signal_d = '1' and Signal_i = '0' else
                   '0';
   
end A_SPI_EdgeDetector;
