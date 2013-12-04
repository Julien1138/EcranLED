----------------|-------------------------------------------------------------
--              . 
-- Project        EcranLED
--              . 
--! @file         E_SPI.vhd
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
use work.Pkg_SPI.all;

entity E_SPI is
   port
   (
      rst_i : in std_logic;
      clk_i : in std_logic;
   );
end entity E_SPI;

---------------------------DESCRIPTION DU MODULE---------------------------
--! 
---------------------------------------------------------------------------

architecture A_SPI of E_SPI is
   
   --
   -- Déclaration des signaux
   --
   
begin
   
   --! Process : \n
   --! Description :
   prc_ : process(rst_i, clk_i)
   begin
      if rst_pci_i = '1' then
         
      elsif rising_edge(clk_i) then
         
      end if;
   end process;
   
   
end architecture A_SPI;
