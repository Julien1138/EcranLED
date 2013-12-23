----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         affichage_traitements_balance_couleurs.vhd
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
-- Description  : Balance des couleurs sur l'image
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

entity affichage_traitements_balance_couleurs is
   generic
   (
      GNR_AFFICHAGE_TRAITEMENTS_COEFFICIENT_ROUGE  : std_logic_vector( 7 downto 0) := X"B5";  --! Coefficient à appliquer à la couleur rouge
      GNR_AFFICHAGE_TRAITEMENTS_COEFFICIENT_VERT   : std_logic_vector( 7 downto 0) := X"FF";  --! Coefficient à appliquer à la couleur verte
      GNR_AFFICHAGE_TRAITEMENTS_COEFFICIENT_BLEU   : std_logic_vector( 7 downto 0) := X"6E"   --! Coefficient à appliquer à la couleur bleue
   );
   port
   (
   -- Signaux globaux
      rst_opt_i            : in  std_logic;                       --! Signal de reset vidéo
      clk_opt_i            : in  std_logic;                       --! Signal d'horloge vidéo
      
   -- Données image entrée
      lecture_enable_i     : in  std_logic;                       --! Enable données image
      lecture_donnees_i    : in  std_logic_vector(15 downto 0);   --! Données image
      
   -- Infos données image entrée
      num_chaine_driver_i  : in  std_logic_vector( 1 downto 0);   --! Numéro de la chaine de driver
      num_driver_i         : in  std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
      num_sortie_driver_i  : in  std_logic_vector( 3 downto 0);   --! Numéro de la sortie du driver concerné
      couleur_pixel_i      : in  std_logic_vector( 1 downto 0);   --! Couleur du pixel
      
   -- Données image sortie
      lecture_enable_o     : out std_logic;                       --! Enable données image
      lecture_donnees_o    : out std_logic_vector(15 downto 0);   --! Données image
      
   -- Infos données image sortie
      num_chaine_driver_o  : out std_logic_vector( 1 downto 0);   --! Numéro de la chaine de driver
      num_driver_o         : out std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
      num_sortie_driver_o  : out std_logic_vector( 3 downto 0);   --! Numéro de la sortie du driver concerné
      couleur_pixel_o      : out std_logic_vector( 1 downto 0)    --! Couleur du pixel
   );
end affichage_traitements_balance_couleurs;

-----------------------------------  Description du module  ---------------------------------------
--! Balance des couleurs sur l'image
---------------------------------------------------------------------------------------------------

architecture rtl_affichage_traitements_balance_couleurs of affichage_traitements_balance_couleurs is
   
   signal s_coefficient_couleur  : std_logic_vector( 7 downto 0); --! Coefficient de correction de la couleur
   
   signal s_mult_result          : std_logic_vector(23 downto 0); --! Résultat de la multiplication
   
begin
   
---------------------------------------------------------------------------------------------------
-- Process : prc_balance_couleurs
-- Détail : Balance des couleurs
---------------------------------------------------------------------------------------------------
   prc_balance_couleurs : process(rst_opt_i, clk_opt_i)
   begin
      if rst_opt_i = '1' then
         lecture_enable_o     <= '0';
         lecture_donnees_o    <= (others => '0');
         num_chaine_driver_o  <= (others => '0');
         num_driver_o         <= (others => '0');
         num_sortie_driver_o  <= (others => '0');
         couleur_pixel_o      <= (others => '0');
      elsif rising_edge(clk_opt_i) then
         lecture_enable_o     <= lecture_enable_i;
         lecture_donnees_o    <= s_mult_result(23 downto 8);
         num_chaine_driver_o  <= num_chaine_driver_i;
         num_driver_o         <= num_driver_i;
         num_sortie_driver_o  <= num_sortie_driver_i;
         couleur_pixel_o      <= couleur_pixel_i;
      end if;
   end process;
   
   s_coefficient_couleur <= GNR_AFFICHAGE_TRAITEMENTS_COEFFICIENT_ROUGE when couleur_pixel_i = CST_AFFICHAGE_TRAITEMENTS_ROUGE else
                            GNR_AFFICHAGE_TRAITEMENTS_COEFFICIENT_VERT  when couleur_pixel_i = CST_AFFICHAGE_TRAITEMENTS_VERT  else
                            GNR_AFFICHAGE_TRAITEMENTS_COEFFICIENT_BLEU  when couleur_pixel_i = CST_AFFICHAGE_TRAITEMENTS_BLEU  else
                            (others => '1');
   
   affichage_traitements_balance_couleurs_mult_inst : affichage_traitements_balance_couleurs_mult
   port map
   (
      a  => s_coefficient_couleur,
      b  => lecture_donnees_i,
      p  => s_mult_result
   );
   
end architecture rtl_affichage_traitements_balance_couleurs;
