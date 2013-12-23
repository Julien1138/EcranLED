----------------------------------------------------------------------
-- Design Name    : SPI_Lib
-- Module Name    : E_SPI_DataReader
--
--! @file E_SPI_DataReader.vhd
--! @brief Serialises SPI data
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
--                                           Correction des bornes du registre à décalage
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
--! @brief Edge Generator
--! @details 
--
entity E_SPI_DataReader is
   port
   (
      rst_i          : in std_logic;         --! Global reset
      clk_i          : in std_logic;         --! Global clock
      
      TopReadData_i  : in std_logic;         --! Request for an input data sample
      SerialData_i   : in std_logic;         --! SPI Data input
      
      TopShowData_i  : in std_logic;         --! Request to show deserialized data on the output port
      Data_o         : out std_logic_vector  --! Deserialized Data
   );
end E_SPI_DataReader;

architecture A_SPI_DataReader of E_SPI_DataReader is
   
   signal s_Data  : std_logic_vector(Data_o'range);
   
begin
   
   --
   -- Process : prc_Sampler
   --! @brief SPI Data sampler
   --
   prc_Sampler : process(rst_i, clk_i)
   begin
      if rst_i = '1' then
         s_Data <= (s_Data'range => '0');
      elsif rising_edge(clk_i) then
         
         if TopReadData_i = '1' then
            s_Data <= s_Data(s_Data'high-1 downto s_Data'low) & SerialData_i;
         end if;
         
      end if;
   end process;
   
   --
   -- Process : prc_ShowData
   --! @brief Show deserialized data
   --
   prc_ShowData : process(rst_i, clk_i)
   begin
      if rst_i = '1' then
         Data_o <= (Data_o'range => '0');
      elsif rising_edge(clk_i) then
         
         if TopShowData_i = '1' then
            Data_o <= s_Data;
         end if;
         
      end if;
   end process;
   
end A_SPI_DataReader;
