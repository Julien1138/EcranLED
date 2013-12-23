----------------------------------------------------------------------
-- Design Name    : SPI_Lib
-- Module Name    : E_SPI_SlaveReader
--
--! @file E_SPI_SlaveReader.vhd
--! @brief Slave Reader
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
-- Mode        CPOL    CPHA
-- 0 (0,0)     0        0
-- 1 (0,1)     0        1
-- 2 (1,0)     1        0
-- 3 (1,1)     1        1
--
-- CPOL indicates the polarity of the clock when idle
-- CPHA indicates the phase of the clock. CPHA=0 means sample on the leading (first) clock edge, while CPHA=1 means
--            sample on the trailing (second) clock edge, regardless of whether that clock edge is rising or falling
-- See http://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus
--


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
entity E_SPI_SlaveReader is
   generic
   (
      g_Mode   : std_logic_vector(1 downto 0) := "00"
   );
   port
   (
      rst_i       : in std_logic;         --! Global reset
      clk_i       : in std_logic;         --! Global clock
      
      SCK_i       : in std_logic;         --! SPI SCK signal
      SS_i        : in std_logic;         --! SPI SS signal
      MOSI_i      : in std_logic;         --! SPI MOSI signal
      
      NewData_o   : out std_logic;        --! Burst when new data avaliable
      Data_o      : out std_logic_vector  --! Deserialized data
   );
end E_SPI_SlaveReader;

architecture A_SPI_SlaveReader of E_SPI_SlaveReader is
   
   signal s_SCKTopRising   : std_logic;
   signal s_SCKTopFalling  : std_logic;
   
   signal s_ShowData : std_logic;
   
   signal s_TopReadData : std_logic;
   
begin
   
   --
   -- Instance : ins_SCKEdgeDetector
   -- Sequencer
   --
   ins_SCKEdgeDetector : E_SPI_EdgeDetector
   port map
   (
      rst_i          => rst_i,
      clk_i          => clk_i,
      
      Signal_i       => SCK_i,
      
      TopRising_o    => s_SCKTopRising,
      TopFalling_o   => s_SCKTopFalling
   );
   
   --
   -- Instance : ins_SSEdgeDetector
   -- Sequencer
   --
   ins_SSEdgeDetector : E_SPI_EdgeDetector
   port map
   (
      rst_i          => rst_i,
      clk_i          => clk_i,
      
      Signal_i       => SS_i,
      
      TopRising_o    => s_ShowData,
      TopFalling_o   => open
   );
   
   process(rst_i, clk_i)
   begin
      if rst_i = '1' then
         NewData_o <= '0';
      elsif rising_edge(clk_i) then
         NewData_o <= s_ShowData;
      end if;
   end process;
   
   --
   -- Instance : ins_DataReader
   -- Sequencer
   --
   ins_DataReader : E_SPI_DataReader
   port map
   (
      rst_i          => rst_i,
      clk_i          => clk_i,
      
      TopReadData_i  => s_TopReadData,
      SerialData_i   => MOSI_i,
      
      TopShowData_i  => s_ShowData,
      Data_o         => Data_o
   );
   
   s_TopReadData <= '0'             when SS_i = '1' else
                    s_SCKTopRising  when g_Mode(CPOL) = '0' and g_Mode(CPHA) = '0' else
                    s_SCKTopFalling when g_Mode(CPOL) = '0' and g_Mode(CPHA) = '1' else
                    s_SCKTopFalling when g_Mode(CPOL) = '1' and g_Mode(CPHA) = '0' else
                    s_SCKTopRising  when g_Mode(CPOL) = '1' and g_Mode(CPHA) = '1' else
                    '0';
   
end A_SPI_SlaveReader;
