----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         affichage_traitements.vhd
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
-- Description  : Traitements sur l'image
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

entity affichage_traitements is
   port
   (
   -- Signaux globaux
      rst_opt_i            : in  std_logic;                       --! Signal de reset vidéo
      clk_opt_i            : in  std_logic;                       --! Signal d'horloge vidéo
      
   -- Paramétrage
      luminosite_i         : in  std_logic_vector( 7 downto 0);   --! Réglage de luminosité
      
   -- Données image entrée
      lecture_enable_i     : in  std_logic;                       --! Enable données image
      lecture_donnees_i    : in  std_logic_vector( 7 downto 0);   --! Données image
      
   -- Infos données image entrée
      num_chaine_driver_i  : in  std_logic_vector( 1 downto 0);   --! Numéro de la chaine de driver
      num_driver_i         : in  std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
      num_sortie_driver_i  : in  std_logic_vector( 3 downto 0);   --! Numéro de la sortie du driver concerné
      couleur_pixel_i      : in  std_logic_vector( 1 downto 0);   --! Couleur du pixel
      
   -- Données image sortie
      lecture_enable_o     : out std_logic;                       --! Enable données image
      lecture_donnees_o    : out std_logic_vector( 7 downto 0);   --! Données image
      
   -- Infos données image sortie
      num_chaine_driver_o  : out std_logic_vector( 1 downto 0);   --! Numéro de la chaine de driver
      num_driver_o         : out std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
      num_sortie_driver_o  : out std_logic_vector( 3 downto 0);   --! Numéro de la sortie du driver concerné
      couleur_pixel_o      : out std_logic_vector( 1 downto 0)    --! Couleur du pixel
   );
end affichage_traitements;

-----------------------------------  Description du module  ---------------------------------------
--! Chaine de traitements sur l'image
---------------------------------------------------------------------------------------------------

architecture rtl_affichage_traitements of affichage_traitements is
   
   -- Entrée
   signal s_entree_lecture_enable               : std_logic;                     --! Enable données image
   signal s_entree_lecture_donnees              : std_logic_vector(15 downto 0); --! Données image
   signal s_entree_num_chaine_driver            : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_entree_num_driver                   : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_entree_num_sortie_driver            : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
   signal s_entree_couleur_pixel                : std_logic_vector( 1 downto 0); --! Couleur du pixel
   
   -- Balance couleurs
   signal s_balance_couleurs_lecture_enable     : std_logic;                     --! Enable données image
   signal s_balance_couleurs_lecture_donnees    : std_logic_vector(15 downto 0); --! Données image
   signal s_balance_couleurs_num_chaine_driver  : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_balance_couleurs_num_driver         : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_balance_couleurs_num_sortie_driver  : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
   signal s_balance_couleurs_couleur_pixel      : std_logic_vector( 1 downto 0); --! Couleur du pixel
   
   -- Luminosité
   signal s_luminosite_lecture_enable           : std_logic;                     --! Enable données image
   signal s_luminosite_lecture_donnees          : std_logic_vector(15 downto 0); --! Données image
   signal s_luminosite_num_chaine_driver        : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_luminosite_num_driver               : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_luminosite_num_sortie_driver        : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
   signal s_luminosite_couleur_pixel            : std_logic_vector( 1 downto 0); --! Couleur du pixel
   
begin

   s_entree_lecture_enable       <= lecture_enable_i;
   s_entree_lecture_donnees      <= lecture_donnees_i & X"00";
   s_entree_num_chaine_driver    <= num_chaine_driver_i;
   s_entree_num_driver           <= num_driver_i;
   s_entree_num_sortie_driver    <= num_sortie_driver_i;
   s_entree_couleur_pixel        <= couleur_pixel_i;
   
   noir_et_blanc_gen : if CST_AFFICHAGE_TRAITEMENTS_COULEUR = '0' generate
      s_balance_couleurs_lecture_enable      <= s_entree_lecture_enable;
      s_balance_couleurs_lecture_donnees     <= s_entree_lecture_donnees;
      s_balance_couleurs_num_chaine_driver   <= s_entree_num_chaine_driver;
      s_balance_couleurs_num_driver          <= s_entree_num_driver;
      s_balance_couleurs_num_sortie_driver   <= s_entree_num_sortie_driver;
      s_balance_couleurs_couleur_pixel       <= s_entree_couleur_pixel;
   end generate;
   
   couleur_gen : if CST_AFFICHAGE_TRAITEMENTS_COULEUR = '1' generate
      affichage_traitements_balance_couleurs_inst : affichage_traitements_balance_couleurs
      port map
      (
      -- Signaux globaux
         rst_opt_i            => rst_opt_i,
         clk_opt_i            => clk_opt_i,
         
      -- Données image entrée
         lecture_enable_i     => s_entree_lecture_enable,
         lecture_donnees_i    => s_entree_lecture_donnees,
         
      -- Infos données image entrée
         num_chaine_driver_i  => s_entree_num_chaine_driver,
         num_driver_i         => s_entree_num_driver,
         num_sortie_driver_i  => s_entree_num_sortie_driver,
         couleur_pixel_i      => s_entree_couleur_pixel,
         
      -- Données image sortie
         lecture_enable_o     => s_balance_couleurs_lecture_enable,
         lecture_donnees_o    => s_balance_couleurs_lecture_donnees,
         
      -- Infos données image sortie
         num_chaine_driver_o  => s_balance_couleurs_num_chaine_driver,
         num_driver_o         => s_balance_couleurs_num_driver,
         num_sortie_driver_o  => s_balance_couleurs_num_sortie_driver,
         couleur_pixel_o      => s_balance_couleurs_couleur_pixel
      );
   end generate;
   
   affichage_traitements_luminosite_inst : affichage_traitements_luminosite
   port map
   (
   -- Signaux globaux
      rst_opt_i            => rst_opt_i,
      clk_opt_i            => clk_opt_i,
      
   -- Paramétrage
      luminosite_i         => luminosite_i,
      
   -- Données image entrée
      lecture_enable_i     => s_balance_couleurs_lecture_enable,
      lecture_donnees_i    => s_balance_couleurs_lecture_donnees,
      
   -- Infos données image entrée
      num_chaine_driver_i  => s_balance_couleurs_num_chaine_driver,
      num_driver_i         => s_balance_couleurs_num_driver,
      num_sortie_driver_i  => s_balance_couleurs_num_sortie_driver,
      couleur_pixel_i      => s_balance_couleurs_couleur_pixel,
      
   -- Données image sortie
      lecture_enable_o     => s_luminosite_lecture_enable,
      lecture_donnees_o    => s_luminosite_lecture_donnees,
      
   -- Infos données image sortie
      num_chaine_driver_o  => s_luminosite_num_chaine_driver,
      num_driver_o         => s_luminosite_num_driver,
      num_sortie_driver_o  => s_luminosite_num_sortie_driver,
      couleur_pixel_o      => s_luminosite_couleur_pixel
   );
   
   lecture_enable_o     <= s_luminosite_lecture_enable;
   lecture_donnees_o    <= s_luminosite_lecture_donnees(15 downto 8);
   num_chaine_driver_o  <= s_luminosite_num_chaine_driver;
   num_driver_o         <= s_luminosite_num_driver;
   num_sortie_driver_o  <= s_luminosite_num_sortie_driver;
   couleur_pixel_o      <= s_luminosite_couleur_pixel;
   
end architecture rtl_affichage_traitements;
