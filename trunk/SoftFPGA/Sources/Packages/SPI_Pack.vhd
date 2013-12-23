--------------------------------------------------------------------
-- Design Name    : SPI_Lib
-- Module Name    : SPI_Pack
--
--! @file SPI_Pack.vhd
--! @brief SPI package of the SPI Library
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

package SPI_Pack is

   constant CPOL   : integer := 1;
   constant CPHA   : integer := 0;
      
-- Top-Level Modules

   component E_SPI_SlaveReader
      generic
      (
         g_Mode   : std_logic_vector(1 downto 0)
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
   end component;
   
-- Low-Level Modules
   

   component E_SPI_EdgeDetector
      port
      (
         rst_i          : in std_logic;   --! Global reset
         clk_i          : in std_logic;   --! Global clock
         
         Signal_i       : in std_logic;   --! Input signal (SCK or SS)
         
         TopRising_o    : out std_logic;  --! RisingEdge detected
         TopFalling_o   : out std_logic   --! FallingEdge detected
      );
   end component;
   
   component E_SPI_DataReader
      port
      (
         rst_i          : in std_logic;         --! Global reset
         clk_i          : in std_logic;         --! Global clock
         
         TopReadData_i  : in std_logic;         --! Request for an input data sample
         SerialData_i   : in std_logic;         --! SPI Data input
         
         TopShowData_i  : in std_logic;         --! Request tou show deserialized data on the output port
         Data_o         : out std_logic_vector  --! Deserialized Data
      );
   end component;

   
end SPI_Pack;
