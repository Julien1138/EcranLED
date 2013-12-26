----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         input_filter.vhd
--              . 
-- Type           Synthétisable
--              . 
--! @author       J. AUPART
--              . 
--! @version      1.0
--              . 
--! @date         14/11/2013
--              . 
----------------|-------------------------------------------------------------
-- Description  : Interprétation des données SPI reçues
--                
----------------|-------------------------------------------------------------
-- Historique   : 
-- 
-- Version 1.0    14/11/2013     J. AUPART
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

entity input_filter is
   generic
   (
      GNR_SIZE : integer := 5
   );
   port
   (
   -- Signaux globaux
      rst_aff_i   : in  std_logic;                       --! Signal de reset affichage
      clk_aff_i   : in  std_logic;                       --! Signal d'horloge affichage
      
      in_i        : in  std_logic;
      out_o       : out std_logic
   );
end input_filter;

-----------------------------------  Description du module  ---------------------------------------
--! 
---------------------------------------------------------------------------------------------------

architecture rtl_input_filter of input_filter is
   
   -- Machine d'état
   signal s_vecteur  : std_logic_vector(GNR_SIZE-1 downto 0);
   signal s_out      : std_logic;
   
begin
   
---------------------------------------------------------------------------------------------------
-- Process : prc_filtre
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_filtre : process(rst_aff_i, clk_aff_i, in_i)
   begin
      if rst_aff_i = '1' then
         s_vecteur <= (others => in_i);
         s_out <= in_i;
      elsif rising_edge(clk_aff_i) then
         
         s_vecteur <= s_vecteur(GNR_SIZE-2 downto 0) & in_i;
         
         if s_vecteur = (s_vecteur'range => '0') then
            s_out <= '0';
         elsif s_vecteur = (s_vecteur'range => '1') then
            s_out <= '1';
         else
            s_out <= s_out;
         end if;
         
      end if;
   end process;
   out_o <= s_out;
   
end architecture rtl_input_filter;
