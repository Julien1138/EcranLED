----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         affichage.vhd
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
-- Description  : Pilotage des drivers de LED
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

entity affichage is
   port
   (
   -- Signaux globaux
      rst_aff_i               : in  std_logic;                       --! Signal de reset affichage
      clk_aff_i               : in  std_logic;                       --! Signal d'horloge affichage
      driver_dclk_i           : in  std_logic;                       --! Horloge de données du driver de LED (synchrone de clk_aff_i)
      
   -- Commande
      rafraichissement_i      : in  std_logic;
      luminosite_i            : in  std_logic_vector( 7 downto 0);   --! Réglage de luminosité
      coefficient_rouge_i     : in  std_logic_vector( 7 downto 0);  --! Coefficient à appliquer à la couleur rouge
      coefficient_vert_i      : in  std_logic_vector( 7 downto 0);  --! Coefficient à appliquer à la couleur verte
      coefficient_bleu_i      : in  std_logic_vector( 7 downto 0);  --! Coefficient à appliquer à la couleur bleue
      
   -- Interface mémoire image
      -- Commandes
      lecture_enable_o        : out std_logic;                       --! Enable lecture pixel
      
      -- Adresse du pixel à lire
      num_chaine_driver_o     : out std_logic_vector( 1 downto 0);   --! Numéro de la chaine de driver
      num_driver_o            : out std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
      num_sortie_driver_o     : out std_logic_vector( 3 downto 0);   --! Numéro de la sortie du driver concerné
      
      -- Données image lues
      lecture_enable_i        : in  std_logic;                       --! Enable données image
      lecture_donnees_i       : in  std_logic_vector( 7 downto 0);   --! Données image
      
      -- Infos données image lues
      num_chaine_driver_i     : in  std_logic_vector( 1 downto 0);   --! Numéro de la chaine de driver
      num_driver_i            : in  std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
      num_sortie_driver_i     : in  std_logic_vector( 3 downto 0);   --! Numéro de la sortie du driver concerné
      couleur_pixel_i         : in  std_logic_vector( 1 downto 0);   --! Couleur du pixel
      
   -- Interface drivers
      io_driver_dclk_o        : out std_logic;                       --! Horloge de données du driver de LED
      io_driver_latch_o       : out std_logic;                       --! Latch du driver de LED
      io_driver_sdi1_o        : out std_logic;                       --! Donnée entrante du driver de LED n°1
      io_driver_sdi2_o        : out std_logic;                       --! Donnée entrante du driver de LED n°2
      io_driver_sdi3_o        : out std_logic                        --! Donnée entrante du driver de LED n°3
   );
end affichage;

-----------------------------------  Description du module  ---------------------------------------
--! Ce module gère l'affichage et ses traitements
---------------------------------------------------------------------------------------------------

architecture rtl_affichage of affichage is
   
   -- Commande
   signal s_rafraichissement              : std_logic;                     --! Rafraichissement de l'affichage
   
   -- Status
   signal s_fifo_driver_full              : std_logic;                     --! La FIFO de pilotage des drivers est pleine
   signal s_fifo_driver_empty             : std_logic;                     --! La FIFO de pilotage des drivers est vide
   
   -- Sortie traitement
   signal s_traitement_lecture_enable    : std_logic;                     --! Enable données image
   signal s_traitement_lecture_donnees   : std_logic_vector( 7 downto 0); --! Données image
   signal s_traitement_num_chaine_driver : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_traitement_num_driver        : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_traitement_num_sortie_driver : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
   
   -- Interface sérialiseur
   signal s_ser_start                     : std_logic;                     --! Demande de nouvelle transmission
   signal s_ser_data_latch                : std_logic;                     --! Demande de latch des données
   signal s_ser_global_latch              : std_logic;                     --! Demande de latch global
   signal s_ser_write_config              : std_logic;                     --! Demande de latch d'écriture de configuration
   signal s_ser_data1                     : std_logic_vector(15 downto 0); --! Données à sérialiser sur la chaine de drivers n°1
   signal s_ser_data2                     : std_logic_vector(15 downto 0); --! Données à sérialiser sur la chaine de drivers n°2
   signal s_ser_data3                     : std_logic_vector(15 downto 0); --! Données à sérialiser sur la chaine de drivers n°3
   signal s_ser_end                       : std_logic;                     --! Fin de transmission
   
begin
   
   affichage_ordonnanceur_inst : affichage_ordonnanceur
   port map
   (
   -- Signaux globaux
      rst_aff_i            => rst_aff_i,
      clk_aff_i            => clk_aff_i,
      
   -- Commande
      configuration_i      => '0',
      rafraichissement_i   => rafraichissement_i,
      
   -- Status
      fifo_driver_full_i   => s_fifo_driver_full,
      fifo_driver_empty_i  => s_fifo_driver_empty,
      
   -- Interface mémoire
      lecture_image_en_o   => lecture_enable_o,
      num_chaine_driver_o  => num_chaine_driver_o,
      num_driver_o         => num_driver_o,
      num_sortie_driver_o  => num_sortie_driver_o
   );
   
   affichage_traitements_inst : affichage_traitements
   port map
   (
   -- Signaux globaux
      rst_opt_i            => rst_aff_i,
      clk_opt_i            => clk_aff_i,
      
   -- Paramétrage
      luminosite_i         => luminosite_i,
      coefficient_rouge_i  => coefficient_rouge_i,
      coefficient_vert_i   => coefficient_vert_i,
      coefficient_bleu_i   => coefficient_bleu_i,
      
   -- Données image entrée
      lecture_enable_i     => lecture_enable_i,
      lecture_donnees_i    => lecture_donnees_i,
      
   -- Infos données image entrée
      num_chaine_driver_i  => num_chaine_driver_i,
      num_driver_i         => num_driver_i,
      num_sortie_driver_i  => num_sortie_driver_i,
      couleur_pixel_i      => couleur_pixel_i,
      
   -- Données image sortie
      lecture_enable_o     => s_traitement_lecture_enable,
      lecture_donnees_o    => s_traitement_lecture_donnees,
      
   -- Infos données image sortie
      num_chaine_driver_o  => s_traitement_num_chaine_driver,
      num_driver_o         => s_traitement_num_driver,
      num_sortie_driver_o  => s_traitement_num_sortie_driver,
      couleur_pixel_o      => open
   );
   
   affichage_serialiseur_inst : affichage_serialiseur
   port map
   (
   -- Signaux globaux
      rst_aff_i            => rst_aff_i,
      clk_aff_i            => clk_aff_i,
      driver_dclk_i        => driver_dclk_i,
      
   -- Données image entrée
      lecture_enable_i     => s_traitement_lecture_enable,
      lecture_donnees_i    => s_traitement_lecture_donnees,
      
   -- Infos données image entrée
      num_chaine_driver_i  => s_traitement_num_chaine_driver,
      num_driver_i         => s_traitement_num_driver,
      num_sortie_driver_i  => s_traitement_num_sortie_driver,
      
   -- Status FIFO
      fifo_driver_full_o   => s_fifo_driver_full,
      fifo_driver_empty_o  => s_fifo_driver_empty,
      
   -- Interface drivers
      io_driver_dclk_o     => io_driver_dclk_o,
      io_driver_latch_o    => io_driver_latch_o,
      io_driver_sdi1_o     => io_driver_sdi1_o,
      io_driver_sdi2_o     => io_driver_sdi2_o,
      io_driver_sdi3_o     => io_driver_sdi3_o
   );
   
end architecture rtl_affichage;
