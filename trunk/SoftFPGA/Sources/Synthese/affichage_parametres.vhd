----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         affichage_parametres.vhd
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
-- Description  : Paramètrage de l'affichage
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

entity affichage_parametres is
   port
   (
   -- Signaux globaux
      rst_aff_i               : in  std_logic;                       --! Signal de reset affichage
      clk_aff_i               : in  std_logic;                       --! Signal d'horloge affichage
      
   -- Paramètres
      maj_luminosite_toggle_i : in  std_logic;                       --! Mise à jour de la luminosité (inversion du signal à chaque fois)
      luminosite_i            : in  std_logic_vector( 7 downto 0);   --! Réglage de luminosité
         
   -- Status
      mise_a_jour_i           : in  std_logic;                       --! Mise à jour des paramètres
      
   -- Paramétrage synchronisé
      luminosite_o            : out std_logic_vector( 7 downto 0)    --! Réglage de luminosité
   );
end affichage_parametres;

-----------------------------------  Description du module  ---------------------------------------
--! Changement de domaine de fréquence des différents paramètres d'affichage
---------------------------------------------------------------------------------------------------

architecture rtl_affichage_parametres of affichage_parametres is
   
   signal s_maj_luminosite_toggle_i_d     : std_logic;                     --! Signal maj_luminosite_toggle_i retardé une fois dans le domaine d'horloge d'affichage
   signal s_maj_luminosite_toggle_i_dd    : std_logic;                     --! Signal maj_luminosite_toggle_i retardé deux fois dans le domaine d'horloge d'affichage
   signal s_maj_luminosite_toggle_i_ddd   : std_logic;                     --! Signal maj_luminosite_toggle_i retardé trois fois dans le domaine d'horloge d'affichage
   signal s_luminosite_sync               : std_logic_vector( 7 downto 0); --! Signal luminosite_i resynchronisé dans le domaine d'horloge d'affichage
   signal s_luminosite                    : std_logic_vector( 7 downto 0); --! Signal luminosite_i mis à jour entre deux images
   
begin
   
---------------------------------------------------------------------------------------------------
-- Process : prc_luminosite
-- Détail : Réglage de luminosité
---------------------------------------------------------------------------------------------------
   prc_luminosite : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_maj_luminosite_toggle_i_d   <= '0';
         s_maj_luminosite_toggle_i_dd  <= '0';
         s_maj_luminosite_toggle_i_ddd <= '0';
         s_luminosite_sync             <= X"3F";   -- Initialisation à 25 %
         s_luminosite                  <= X"3F";   -- Initialisation à 25 %
      elsif rising_edge(clk_aff_i) then
         
         s_maj_luminosite_toggle_i_d   <= maj_luminosite_toggle_i;
         s_maj_luminosite_toggle_i_dd  <= s_maj_luminosite_toggle_i_d;
         s_maj_luminosite_toggle_i_ddd <= s_maj_luminosite_toggle_i_dd;
         
         if s_maj_luminosite_toggle_i_ddd /= s_maj_luminosite_toggle_i_dd then
            if luminosite_i < X"01" then  -- Seuillage
               s_luminosite_sync <= X"01";
            else
               s_luminosite_sync <= luminosite_i;
            end if;
         else
            s_luminosite_sync <= s_luminosite_sync;
         end if;
         
         if mise_a_jour_i = '1' then
            s_luminosite <= s_luminosite_sync;
         else
            s_luminosite <= s_luminosite;
         end  if;
         
      end if;
   end process;
   luminosite_o <= s_luminosite;
   
end architecture rtl_affichage_parametres;
