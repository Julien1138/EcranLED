----------------|-------------------------------------------------------------
--              . 
-- Project        EcranLED
--              . 
--! @file         E_EcranLED.vhd
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
use work.Pkg_EcranLED.all;

entity E_EcranLED is
   port
   (
      io_clk_i    : in std_logic
   );
end entity E_EcranLED;

---------------------------DESCRIPTION DU MODULE---------------------------
--! 
---------------------------------------------------------------------------

architecture A_EcranLED of E_EcranLED is
   
   --
   -- Déclaration des signaux
   --
   
begin
   
   
end architecture A_EcranLED;
