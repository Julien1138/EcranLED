----------------|-------------------------------------------------------------
--              . 
-- Project        EcranLED
--              . 
--! @file         EcranLED.vhd
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
use work.pkg_driver.all;

entity EcranLED is
   port
   (
      io_clk_i             : in  std_logic;
      
      io_spi_ss1_i         : in  std_logic;  --! Chip select SPI
      io_spi_ss2_i         : in  std_logic;  --! Chip select SPI
      io_spi_sck_i         : in  std_logic;  --! Signal d'horloge SPI
      io_spi_mosi_i        : in  std_logic;  --! Données SPI entrantes
      io_spi_miso_o        : out std_logic;  --! Données SPI sortantes
      
   -- Interface drivers carte LED n°1
      io_driver_1_dclk_o   : out std_logic;  --! Horloge de données du driver de LED
      io_driver_1_latch_o  : out std_logic;  --! Latch du driver de LED
      io_driver_1_sdi1_o   : out std_logic;  --! Donnée entrante du driver de LED n°1
      io_driver_1_sdi2_o   : out std_logic;  --! Donnée entrante du driver de LED n°2
      io_driver_1_sdi3_o   : out std_logic;  --! Donnée entrante du driver de LED n°3
      io_driver_1_gclk_o   : out std_logic;  --! Horloge de PWM du driver de LED
      
   -- Interface drivers carte LED n°2
      io_driver_2_dclk_o   : out std_logic;  --! Horloge de données du driver de LED
      io_driver_2_latch_o  : out std_logic;  --! Latch du driver de LED
      io_driver_2_sdi1_o   : out std_logic;  --! Donnée entrante du driver de LED n°1
      io_driver_2_sdi2_o   : out std_logic;  --! Donnée entrante du driver de LED n°2
      io_driver_2_sdi3_o   : out std_logic;  --! Donnée entrante du driver de LED n°3
      io_driver_2_gclk_o   : out std_logic;  --! Horloge de PWM du driver de LED
      
   -- Interface drivers carte LED n°3
      io_driver_3_dclk_o   : out std_logic;  --! Horloge de données du driver de LED
      io_driver_3_latch_o  : out std_logic;  --! Latch du driver de LED
      io_driver_3_sdi1_o   : out std_logic;  --! Donnée entrante du driver de LED n°1
      io_driver_3_sdi2_o   : out std_logic;  --! Donnée entrante du driver de LED n°2
      io_driver_3_sdi3_o   : out std_logic;  --! Donnée entrante du driver de LED n°3
      io_driver_3_gclk_o   : out std_logic;  --! Horloge de PWM du driver de LED
      
   -- Interface drivers carte LED n°4
      io_driver_4_dclk_o   : out std_logic;  --! Horloge de données du driver de LED
      io_driver_4_latch_o  : out std_logic;  --! Latch du driver de LED
      io_driver_4_sdi1_o   : out std_logic;  --! Donnée entrante du driver de LED n°1
      io_driver_4_sdi2_o   : out std_logic;  --! Donnée entrante du driver de LED n°2
      io_driver_4_sdi3_o   : out std_logic;  --! Donnée entrante du driver de LED n°3
      io_driver_4_gclk_o   : out std_logic;  --! Horloge de PWM du driver de LED
      
   -- Interface drivers carte LED n°5
      io_driver_5_dclk_o   : out std_logic;  --! Horloge de données du driver de LED
      io_driver_5_latch_o  : out std_logic;  --! Latch du driver de LED
      io_driver_5_sdi1_o   : out std_logic;  --! Donnée entrante du driver de LED n°1
      io_driver_5_sdi2_o   : out std_logic;  --! Donnée entrante du driver de LED n°2
      io_driver_5_sdi3_o   : out std_logic;  --! Donnée entrante du driver de LED n°3
      io_driver_5_gclk_o   : out std_logic;  --! Horloge de PWM du driver de LED
      
   -- Interface drivers carte LED n°6
      io_driver_6_dclk_o   : out std_logic;  --! Horloge de données du driver de LED
      io_driver_6_latch_o  : out std_logic;  --! Latch du driver de LED
      io_driver_6_sdi1_o   : out std_logic;  --! Donnée entrante du driver de LED n°1
      io_driver_6_sdi2_o   : out std_logic;  --! Donnée entrante du driver de LED n°2
      io_driver_6_sdi3_o   : out std_logic;  --! Donnée entrante du driver de LED n°3
      io_driver_6_gclk_o   : out std_logic;  --! Horloge de PWM du driver de LED
      
   -- DEBUG
      io_LED_o             : out std_logic_vector(7 downto 0)
   );
end entity EcranLED;

---------------------------DESCRIPTION DU MODULE---------------------------
--! 
---------------------------------------------------------------------------

architecture rtl_EcranLED of EcranLED is
   
-- Signaux du module horloge
   signal s_rst_aff     : std_logic;   --! Signal de reset affichage
   signal s_clk_aff     : std_logic;   --! Signal d'horloge affichage
   signal s_driver_dclk : std_logic;   --! Horloge de données du driver de LED (synchrone de clk_aff_i)
   signal s_driver_gclk : std_logic;   --! Horloge de PWM du driver de LED (synchrone de clk_aff_i)
   
   signal s_spi_ss1     : std_logic;  --! Chip select SPI
   signal s_spi_sck     : std_logic;  --! Signal d'horloge SPI
   signal s_spi_mosi    : std_logic;  --! Données SPI entrantes
   
   signal s_spi_nouvelles_donnees   : std_logic;
   signal s_spi_donnees             : std_logic_vector(7 downto 0);
   
   signal s_ecriture_en1      : std_logic;
   signal s_ecriture_en2      : std_logic;
   signal s_ecriture_en3      : std_logic;
   signal s_ecriture_en4      : std_logic;
   signal s_ecriture_en5      : std_logic;
   signal s_ecriture_en6      : std_logic;
   signal s_ecriture_adresse  : std_logic_vector(12 downto 0);
   signal s_ecriture_donnees  : std_logic_vector( 7 downto 0);
   
   signal s_rafraichissement  : std_logic;
      
   -- Paramètres
   signal s_luminosite           : std_logic_vector( 7 downto 0);   --! Réglage de luminosité
   
-- Signaux de l'interface de lecture le la mémoire image n°1
   -- Interface de lecture
   signal s_lecture_enable_in_1     : std_logic;                     --! Enable lecture pixel
   signal s_num_chaine_driver_in_1  : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_num_driver_in_1         : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_num_sortie_driver_in_1  : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
      
   -- Données image lues
   signal s_lecture_enable_out_1    : std_logic;                     --! Enable données image
   signal s_lecture_donnees_out_1   : std_logic_vector( 7 downto 0); --! Données image
      
   -- Infos données image lues
   signal s_num_chaine_driver_out_1 : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_num_driver_out_1        : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_num_sortie_driver_out_1 : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
   signal s_couleur_pixel_out_1     : std_logic_vector( 1 downto 0); --! Couleur du pixel
   
   -- Paramètres couleur
   signal s_coefficient_rouge_1  : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
   signal s_coefficient_vert_1   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
   signal s_coefficient_bleu_1   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
   
-- Signaux de l'interface de lecture le la mémoire image n°2
   -- Interface de lecture
   signal s_lecture_enable_in_2     : std_logic;                     --! Enable lecture pixel
   signal s_num_chaine_driver_in_2  : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_num_driver_in_2         : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_num_sortie_driver_in_2  : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
      
   -- Données image lues
   signal s_lecture_enable_out_2    : std_logic;                     --! Enable données image
   signal s_lecture_donnees_out_2   : std_logic_vector( 7 downto 0); --! Données image
      
   -- Infos données image lues
   signal s_num_chaine_driver_out_2 : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_num_driver_out_2        : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_num_sortie_driver_out_2 : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
   signal s_couleur_pixel_out_2     : std_logic_vector( 1 downto 0); --! Couleur du pixel
   
   -- Paramètres couleur
   signal s_coefficient_rouge_2  : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
   signal s_coefficient_vert_2   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
   signal s_coefficient_bleu_2   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
   
-- Signaux de l'interface de lecture le la mémoire image n°3
   -- Interface de lecture
   signal s_lecture_enable_in_3     : std_logic;                     --! Enable lecture pixel
   signal s_num_chaine_driver_in_3  : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_num_driver_in_3         : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_num_sortie_driver_in_3  : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
      
   -- Données image lues
   signal s_lecture_enable_out_3    : std_logic;                     --! Enable données image
   signal s_lecture_donnees_out_3   : std_logic_vector( 7 downto 0); --! Données image
      
   -- Infos données image lues
   signal s_num_chaine_driver_out_3 : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_num_driver_out_3        : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_num_sortie_driver_out_3 : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
   signal s_couleur_pixel_out_3     : std_logic_vector( 1 downto 0); --! Couleur du pixel
   
   -- Paramètres couleur
   signal s_coefficient_rouge_3  : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
   signal s_coefficient_vert_3   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
   signal s_coefficient_bleu_3   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
   
-- Signaux de l'interface de lecture le la mémoire image n°4
   -- Interface de lecture
   signal s_lecture_enable_in_4     : std_logic;                     --! Enable lecture pixel
   signal s_num_chaine_driver_in_4  : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_num_driver_in_4         : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_num_sortie_driver_in_4  : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
      
   -- Données image lues
   signal s_lecture_enable_out_4    : std_logic;                     --! Enable données image
   signal s_lecture_donnees_out_4   : std_logic_vector( 7 downto 0); --! Données image
      
   -- Infos données image lues
   signal s_num_chaine_driver_out_4 : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_num_driver_out_4        : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_num_sortie_driver_out_4 : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
   signal s_couleur_pixel_out_4     : std_logic_vector( 1 downto 0); --! Couleur du pixel
   
   -- Paramètres couleur
   signal s_coefficient_rouge_4  : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
   signal s_coefficient_vert_4   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
   signal s_coefficient_bleu_4   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
   
-- Signaux de l'interface de lecture le la mémoire image n°5
   -- Interface de lecture
   signal s_lecture_enable_in_5     : std_logic;                     --! Enable lecture pixel
   signal s_num_chaine_driver_in_5  : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_num_driver_in_5         : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_num_sortie_driver_in_5  : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
      
   -- Données image lues
   signal s_lecture_enable_out_5    : std_logic;                     --! Enable données image
   signal s_lecture_donnees_out_5   : std_logic_vector( 7 downto 0); --! Données image
      
   -- Infos données image lues
   signal s_num_chaine_driver_out_5 : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_num_driver_out_5        : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_num_sortie_driver_out_5 : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
   signal s_couleur_pixel_out_5     : std_logic_vector( 1 downto 0); --! Couleur du pixel
   
   -- Paramètres couleur
   signal s_coefficient_rouge_5  : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
   signal s_coefficient_vert_5   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
   signal s_coefficient_bleu_5   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
   
-- Signaux de l'interface de lecture le la mémoire image n°6
   -- Interface de lecture
   signal s_lecture_enable_in_6     : std_logic;                     --! Enable lecture pixel
   signal s_num_chaine_driver_in_6  : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_num_driver_in_6         : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_num_sortie_driver_in_6  : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
      
   -- Données image lues
   signal s_lecture_enable_out_6    : std_logic;                     --! Enable données image
   signal s_lecture_donnees_out_6   : std_logic_vector( 7 downto 0); --! Données image
      
   -- Infos données image lues
   signal s_num_chaine_driver_out_6 : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_num_driver_out_6        : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_num_sortie_driver_out_6 : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
   signal s_couleur_pixel_out_6     : std_logic_vector( 1 downto 0); --! Couleur du pixel
   
   -- Paramètres couleur
   signal s_coefficient_rouge_6  : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
   signal s_coefficient_vert_6   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
   signal s_coefficient_bleu_6   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
   
begin

   horloges_inst : horloges
   port map
   (
   -- Signaux externes
      io_clk_i       => io_clk_i,
      
   -- Domaine d'horloge affichage
      rst_aff_o      => s_rst_aff,
      clk_aff_o      => s_clk_aff,
      driver_dclk_o  => s_driver_dclk,
      driver_gclk_o  => s_driver_gclk
   );
   
   input_filter_inst_spi_sck : input_filter
   generic map
   (
      GNR_SIZE => 5
   )
   port map
   (
      rst_aff_i   => s_rst_aff,
      clk_aff_i   => s_clk_aff,
      
      in_i        => io_spi_sck_i,
      out_o       => s_spi_sck
   );
   
   input_filter_inst_spi_ss1 : input_filter
   generic map
   (
      GNR_SIZE => 5
   )
   port map
   (
      rst_aff_i   => s_rst_aff,
      clk_aff_i   => s_clk_aff,
      
      in_i        => io_spi_ss1_i,
      out_o       => s_spi_ss1
   );
   
   input_filter_inst_spi_mosi : input_filter
   generic map
   (
      GNR_SIZE => 5
   )
   port map
   (
      rst_aff_i   => s_rst_aff,
      clk_aff_i   => s_clk_aff,
      
      in_i        => io_spi_mosi_i,
      out_o       => s_spi_mosi
   );
   
   spi_receiver_inst : spi_receiver
   port map
   (
      rst_aff_i      => s_rst_aff,
      clk_aff_i      => s_clk_aff,
      
      io_sck_i       => s_spi_sck,
      io_ss_i        => s_spi_ss1,
      io_mosi_i      => s_spi_mosi,
      
      nouv_donnee_o  => s_spi_nouvelles_donnees,
      donnee_o       => s_spi_donnees
   );
   io_spi_miso_o <= io_spi_mosi_i;
   
   -- Interpreteur
   interpreteur_inst : interpreteur
   port map
   (
   -- Signaux globaux
      rst_aff_i            => s_rst_aff,
      clk_aff_i            => s_clk_aff,
      
   -- Interface SPI
      NewData_i            => s_spi_nouvelles_donnees,
      Data_i               => s_spi_donnees,
      
   -- Interface d'écriture de l'image
      ecriture_en1_o       => s_ecriture_en1,
      ecriture_en2_o       => s_ecriture_en2,
      ecriture_en3_o       => s_ecriture_en3,
      ecriture_en4_o       => s_ecriture_en4,
      ecriture_en5_o       => s_ecriture_en5,
      ecriture_en6_o       => s_ecriture_en6,
      ecriture_adresse_o   => s_ecriture_adresse,
      ecriture_donnees_o   => s_ecriture_donnees,
      
   -- Mise à jour de l'affichage
      rafraichissement_o   => s_rafraichissement,
      
   -- Paramètres
      luminosite_o         => s_luminosite,
      coefficient_rouge_1_o=> s_coefficient_rouge_1,
      coefficient_vert_1_o => s_coefficient_vert_1,
      coefficient_bleu_1_o => s_coefficient_bleu_1,
      coefficient_rouge_2_o=> s_coefficient_rouge_2,
      coefficient_vert_2_o => s_coefficient_vert_2,
      coefficient_bleu_2_o => s_coefficient_bleu_2,
      coefficient_rouge_3_o=> s_coefficient_rouge_3,
      coefficient_vert_3_o => s_coefficient_vert_3,
      coefficient_bleu_3_o => s_coefficient_bleu_3,
      coefficient_rouge_4_o=> s_coefficient_rouge_4,
      coefficient_vert_4_o => s_coefficient_vert_4,
      coefficient_bleu_4_o => s_coefficient_bleu_4,
      coefficient_rouge_5_o=> s_coefficient_rouge_5,
      coefficient_vert_5_o => s_coefficient_vert_5,
      coefficient_bleu_5_o => s_coefficient_bleu_5,
      coefficient_rouge_6_o=> s_coefficient_rouge_6,
      coefficient_vert_6_o => s_coefficient_vert_6,
      coefficient_bleu_6_o => s_coefficient_bleu_6
   );
   
   memoire_image_1 : memoire_image
   port map
   (
   -- Signaux globaux
      rst_aff_i            => s_rst_aff,
      clk_aff_i            => s_clk_aff,
      
   -- Interface d'écriture de l'image
      ecriture_en_i        => s_ecriture_en1,
      ecriture_adresse_i   => s_ecriture_adresse,
      ecriture_donnees_i   => s_ecriture_donnees,
      
   -- Interface de lecture
      lecture_enable_i     => s_lecture_enable_in_1,
      num_chaine_driver_i  => s_num_chaine_driver_in_1,
      num_driver_i         => s_num_driver_in_1,
      num_sortie_driver_i  => s_num_sortie_driver_in_1,
      
   -- Données image lues
      lecture_enable_o     => s_lecture_enable_out_1,
      lecture_donnees_o    => s_lecture_donnees_out_1,
      
   -- Infos données image lues
      num_chaine_driver_o  => s_num_chaine_driver_out_1,
      num_driver_o         => s_num_driver_out_1,
      num_sortie_driver_o  => s_num_sortie_driver_out_1,
      couleur_pixel_o      => s_couleur_pixel_out_1
   );
   
   memoire_image_2 : memoire_image
   port map
   (
   -- Signaux globaux
      rst_aff_i            => s_rst_aff,
      clk_aff_i            => s_clk_aff,
      
   -- Interface d'écriture de l'image
      ecriture_en_i        => s_ecriture_en2,
      ecriture_adresse_i   => s_ecriture_adresse,
      ecriture_donnees_i   => s_ecriture_donnees,
      
   -- Interface de lecture
      lecture_enable_i     => s_lecture_enable_in_2,
      num_chaine_driver_i  => s_num_chaine_driver_in_2,
      num_driver_i         => s_num_driver_in_2,
      num_sortie_driver_i  => s_num_sortie_driver_in_2,
      
   -- Données image lues
      lecture_enable_o     => s_lecture_enable_out_2,
      lecture_donnees_o    => s_lecture_donnees_out_2,
      
   -- Infos données image lues
      num_chaine_driver_o  => s_num_chaine_driver_out_2,
      num_driver_o         => s_num_driver_out_2,
      num_sortie_driver_o  => s_num_sortie_driver_out_2,
      couleur_pixel_o      => s_couleur_pixel_out_2
   );
   
   memoire_image_3 : memoire_image
   port map
   (
   -- Signaux globaux
      rst_aff_i            => s_rst_aff,
      clk_aff_i            => s_clk_aff,
      
   -- Interface d'écriture de l'image
      ecriture_en_i        => s_ecriture_en3,
      ecriture_adresse_i   => s_ecriture_adresse,
      ecriture_donnees_i   => s_ecriture_donnees,
      
   -- Interface de lecture
      lecture_enable_i     => s_lecture_enable_in_3,
      num_chaine_driver_i  => s_num_chaine_driver_in_3,
      num_driver_i         => s_num_driver_in_3,
      num_sortie_driver_i  => s_num_sortie_driver_in_3,
      
   -- Données image lues
      lecture_enable_o     => s_lecture_enable_out_3,
      lecture_donnees_o    => s_lecture_donnees_out_3,
      
   -- Infos données image lues
      num_chaine_driver_o  => s_num_chaine_driver_out_3,
      num_driver_o         => s_num_driver_out_3,
      num_sortie_driver_o  => s_num_sortie_driver_out_3,
      couleur_pixel_o      => s_couleur_pixel_out_3
   );
   
   memoire_image_4 : memoire_image
   port map
   (
   -- Signaux globaux
      rst_aff_i            => s_rst_aff,
      clk_aff_i            => s_clk_aff,
      
   -- Interface d'écriture de l'image
      ecriture_en_i        => s_ecriture_en4,
      ecriture_adresse_i   => s_ecriture_adresse,
      ecriture_donnees_i   => s_ecriture_donnees,
      
   -- Interface de lecture
      lecture_enable_i     => s_lecture_enable_in_4,
      num_chaine_driver_i  => s_num_chaine_driver_in_4,
      num_driver_i         => s_num_driver_in_4,
      num_sortie_driver_i  => s_num_sortie_driver_in_4,
      
   -- Données image lues
      lecture_enable_o     => s_lecture_enable_out_4,
      lecture_donnees_o    => s_lecture_donnees_out_4,
      
   -- Infos données image lues
      num_chaine_driver_o  => s_num_chaine_driver_out_4,
      num_driver_o         => s_num_driver_out_4,
      num_sortie_driver_o  => s_num_sortie_driver_out_4,
      couleur_pixel_o      => s_couleur_pixel_out_4
   );
   
   memoire_image_5 : memoire_image
   port map
   (
   -- Signaux globaux
      rst_aff_i            => s_rst_aff,
      clk_aff_i            => s_clk_aff,
      
   -- Interface d'écriture de l'image
      ecriture_en_i        => s_ecriture_en5,
      ecriture_adresse_i   => s_ecriture_adresse,
      ecriture_donnees_i   => s_ecriture_donnees,
      
   -- Interface de lecture
      lecture_enable_i     => s_lecture_enable_in_5,
      num_chaine_driver_i  => s_num_chaine_driver_in_5,
      num_driver_i         => s_num_driver_in_5,
      num_sortie_driver_i  => s_num_sortie_driver_in_5,
      
   -- Données image lues
      lecture_enable_o     => s_lecture_enable_out_5,
      lecture_donnees_o    => s_lecture_donnees_out_5,
      
   -- Infos données image lues
      num_chaine_driver_o  => s_num_chaine_driver_out_5,
      num_driver_o         => s_num_driver_out_5,
      num_sortie_driver_o  => s_num_sortie_driver_out_5,
      couleur_pixel_o      => s_couleur_pixel_out_5
   );
   
   memoire_image_6 : memoire_image
   port map
   (
   -- Signaux globaux
      rst_aff_i            => s_rst_aff,
      clk_aff_i            => s_clk_aff,
      
   -- Interface d'écriture de l'image
      ecriture_en_i        => s_ecriture_en6,
      ecriture_adresse_i   => s_ecriture_adresse,
      ecriture_donnees_i   => s_ecriture_donnees,
      
   -- Interface de lecture
      lecture_enable_i     => s_lecture_enable_in_6,
      num_chaine_driver_i  => s_num_chaine_driver_in_6,
      num_driver_i         => s_num_driver_in_6,
      num_sortie_driver_i  => s_num_sortie_driver_in_6,
      
   -- Données image lues
      lecture_enable_o     => s_lecture_enable_out_6,
      lecture_donnees_o    => s_lecture_donnees_out_6,
      
   -- Infos données image lues
      num_chaine_driver_o  => s_num_chaine_driver_out_6,
      num_driver_o         => s_num_driver_out_6,
      num_sortie_driver_o  => s_num_sortie_driver_out_6,
      couleur_pixel_o      => s_couleur_pixel_out_6
   );
   
   affichage_inst1 : affichage -- U5_1 AW_4 S7_6
   port map
   (
   -- Signaux globaux
      rst_aff_i               => s_rst_aff,
      clk_aff_i               => s_clk_aff,
      driver_dclk_i           => s_driver_dclk,
      
   -- Commande
      rafraichissement_i      => s_rafraichissement,
      luminosite_i            => s_luminosite,
      coefficient_rouge_i     => s_coefficient_rouge_1,--X"6C",
      coefficient_vert_i      => s_coefficient_vert_1,--X"3D",
      coefficient_bleu_i      => s_coefficient_bleu_1,--X"1F",
      
   -- Interface mémoire image
      -- Commandes
      lecture_enable_o        => s_lecture_enable_in_1,
      
      -- Adresse du pixel à lire
      num_chaine_driver_o     => s_num_chaine_driver_in_1,
      num_driver_o            => s_num_driver_in_1,
      num_sortie_driver_o     => s_num_sortie_driver_in_1,
      
      -- Données image lues
      lecture_enable_i        => s_lecture_enable_out_1,
      lecture_donnees_i       => s_lecture_donnees_out_1,
      
      -- Infos données image lues
      num_chaine_driver_i     => s_num_chaine_driver_out_1,
      num_driver_i            => s_num_driver_out_1,
      num_sortie_driver_i     => s_num_sortie_driver_out_1,
      couleur_pixel_i         => s_couleur_pixel_out_1,
      
   -- Interface drivers
      io_driver_dclk_o        => io_driver_1_dclk_o,
      io_driver_latch_o       => io_driver_1_latch_o,
      io_driver_sdi1_o        => io_driver_1_sdi1_o,
      io_driver_sdi2_o        => io_driver_1_sdi2_o,
      io_driver_sdi3_o        => io_driver_1_sdi3_o
   );
   io_driver_1_gclk_o <= s_driver_gclk;
   
   affichage_inst2 : affichage -- U5_1 V9_5 T_7
   port map
   (
   -- Signaux globaux
      rst_aff_i               => s_rst_aff,
      clk_aff_i               => s_clk_aff,
      driver_dclk_i           => s_driver_dclk,
      
   -- Commande
      rafraichissement_i      => s_rafraichissement,
      luminosite_i            => s_luminosite,
      coefficient_rouge_i     => s_coefficient_rouge_2,--X"40",
      coefficient_vert_i      => s_coefficient_vert_2,--X"3C",
      coefficient_bleu_i      => s_coefficient_bleu_2,--X"21",
      
   -- Interface mémoire image
      -- Commandes
      lecture_enable_o        => s_lecture_enable_in_2,
      
      -- Adresse du pixel à lire
      num_chaine_driver_o     => s_num_chaine_driver_in_2,
      num_driver_o            => s_num_driver_in_2,
      num_sortie_driver_o     => s_num_sortie_driver_in_2,
      
      -- Données image lues
      lecture_enable_i        => s_lecture_enable_out_2,
      lecture_donnees_i       => s_lecture_donnees_out_2,
      
      -- Infos données image lues
      num_chaine_driver_i     => s_num_chaine_driver_out_2,
      num_driver_i            => s_num_driver_out_2,
      num_sortie_driver_i     => s_num_sortie_driver_out_2,
      couleur_pixel_i         => s_couleur_pixel_out_2,
      
   -- Interface drivers
      io_driver_dclk_o        => io_driver_2_dclk_o,
      io_driver_latch_o       => io_driver_2_latch_o,
      io_driver_sdi1_o        => io_driver_2_sdi1_o,
      io_driver_sdi2_o        => io_driver_2_sdi2_o,
      io_driver_sdi3_o        => io_driver_2_sdi3_o
   );
   io_driver_2_gclk_o <= s_driver_gclk;
   
   affichage_inst3 : affichage -- U5_1 V9_5 T_7
   port map
   (
   -- Signaux globaux
      rst_aff_i               => s_rst_aff,
      clk_aff_i               => s_clk_aff,
      driver_dclk_i           => s_driver_dclk,
      
   -- Commande
      rafraichissement_i      => s_rafraichissement,
      luminosite_i            => s_luminosite,
      coefficient_rouge_i     => s_coefficient_rouge_3,--X"40",
      coefficient_vert_i      => s_coefficient_vert_3,--X"3C",
      coefficient_bleu_i      => s_coefficient_bleu_3,--X"21",
      
   -- Interface mémoire image
      -- Commandes
      lecture_enable_o        => s_lecture_enable_in_3,
      
      -- Adresse du pixel à lire
      num_chaine_driver_o     => s_num_chaine_driver_in_3,
      num_driver_o            => s_num_driver_in_3,
      num_sortie_driver_o     => s_num_sortie_driver_in_3,
      
      -- Données image lues
      lecture_enable_i        => s_lecture_enable_out_3,
      lecture_donnees_i       => s_lecture_donnees_out_3,
      
      -- Infos données image lues
      num_chaine_driver_i     => s_num_chaine_driver_out_3,
      num_driver_i            => s_num_driver_out_3,
      num_sortie_driver_i     => s_num_sortie_driver_out_3,
      couleur_pixel_i         => s_couleur_pixel_out_3,
      
   -- Interface drivers
      io_driver_dclk_o        => io_driver_3_dclk_o,
      io_driver_latch_o       => io_driver_3_latch_o,
      io_driver_sdi1_o        => io_driver_3_sdi1_o,
      io_driver_sdi2_o        => io_driver_3_sdi2_o,
      io_driver_sdi3_o        => io_driver_3_sdi3_o
   );
   io_driver_3_gclk_o <= s_driver_gclk;
   
   affichage_inst4 : affichage -- U5_1 V9_5 T_7
   port map
   (
   -- Signaux globaux
      rst_aff_i               => s_rst_aff,
      clk_aff_i               => s_clk_aff,
      driver_dclk_i           => s_driver_dclk,
      
   -- Commande
      rafraichissement_i      => s_rafraichissement,
      luminosite_i            => s_luminosite,
      coefficient_rouge_i     => s_coefficient_rouge_4,--X"40",
      coefficient_vert_i      => s_coefficient_vert_4,--X"3C",
      coefficient_bleu_i      => s_coefficient_bleu_4,--X"21",
      
   -- Interface mémoire image
      -- Commandes
      lecture_enable_o        => s_lecture_enable_in_4,
      
      -- Adresse du pixel à lire
      num_chaine_driver_o     => s_num_chaine_driver_in_4,
      num_driver_o            => s_num_driver_in_4,
      num_sortie_driver_o     => s_num_sortie_driver_in_4,
      
      -- Données image lues
      lecture_enable_i        => s_lecture_enable_out_4,
      lecture_donnees_i       => s_lecture_donnees_out_4,
      
      -- Infos données image lues
      num_chaine_driver_i     => s_num_chaine_driver_out_4,
      num_driver_i            => s_num_driver_out_4,
      num_sortie_driver_i     => s_num_sortie_driver_out_4,
      couleur_pixel_i         => s_couleur_pixel_out_4,
      
   -- Interface drivers
      io_driver_dclk_o        => io_driver_4_dclk_o,
      io_driver_latch_o       => io_driver_4_latch_o,
      io_driver_sdi1_o        => io_driver_4_sdi1_o,
      io_driver_sdi2_o        => io_driver_4_sdi2_o,
      io_driver_sdi3_o        => io_driver_4_sdi3_o
   );
   io_driver_4_gclk_o <= s_driver_gclk;
   
   affichage_inst5 : affichage -- U5_1 V9_5 T_7
   port map
   (
   -- Signaux globaux
      rst_aff_i               => s_rst_aff,
      clk_aff_i               => s_clk_aff,
      driver_dclk_i           => s_driver_dclk,
      
   -- Commande
      rafraichissement_i      => s_rafraichissement,
      luminosite_i            => s_luminosite,
      coefficient_rouge_i     => s_coefficient_rouge_5,--X"40",
      coefficient_vert_i      => s_coefficient_vert_5,--X"3C",
      coefficient_bleu_i      => s_coefficient_bleu_5,--X"21",
      
   -- Interface mémoire image
      -- Commandes
      lecture_enable_o        => s_lecture_enable_in_5,
      
      -- Adresse du pixel à lire
      num_chaine_driver_o     => s_num_chaine_driver_in_5,
      num_driver_o            => s_num_driver_in_5,
      num_sortie_driver_o     => s_num_sortie_driver_in_5,
      
      -- Données image lues
      lecture_enable_i        => s_lecture_enable_out_5,
      lecture_donnees_i       => s_lecture_donnees_out_5,
      
      -- Infos données image lues
      num_chaine_driver_i     => s_num_chaine_driver_out_5,
      num_driver_i            => s_num_driver_out_5,
      num_sortie_driver_i     => s_num_sortie_driver_out_5,
      couleur_pixel_i         => s_couleur_pixel_out_5,
      
   -- Interface drivers
      io_driver_dclk_o        => io_driver_5_dclk_o,
      io_driver_latch_o       => io_driver_5_latch_o,
      io_driver_sdi1_o        => io_driver_5_sdi1_o,
      io_driver_sdi2_o        => io_driver_5_sdi2_o,
      io_driver_sdi3_o        => io_driver_5_sdi3_o
   );
   io_driver_5_gclk_o <= s_driver_gclk;
   
   affichage_inst6 : affichage -- U5_1 V9_5 T_7
   port map
   (
   -- Signaux globaux
      rst_aff_i               => s_rst_aff,
      clk_aff_i               => s_clk_aff,
      driver_dclk_i           => s_driver_dclk,
      
   -- Commande
      rafraichissement_i      => s_rafraichissement,
      luminosite_i            => s_luminosite,
      coefficient_rouge_i     => s_coefficient_rouge_6,--X"40",
      coefficient_vert_i      => s_coefficient_vert_6,--X"3C",
      coefficient_bleu_i      => s_coefficient_bleu_6,--X"21",
      
   -- Interface mémoire image
      -- Commandes
      lecture_enable_o        => s_lecture_enable_in_6,
      
      -- Adresse du pixel à lire
      num_chaine_driver_o     => s_num_chaine_driver_in_6,
      num_driver_o            => s_num_driver_in_6,
      num_sortie_driver_o     => s_num_sortie_driver_in_6,
      
      -- Données image lues
      lecture_enable_i        => s_lecture_enable_out_6,
      lecture_donnees_i       => s_lecture_donnees_out_6,
      
      -- Infos données image lues
      num_chaine_driver_i     => s_num_chaine_driver_out_6,
      num_driver_i            => s_num_driver_out_6,
      num_sortie_driver_i     => s_num_sortie_driver_out_6,
      couleur_pixel_i         => s_couleur_pixel_out_6,
      
   -- Interface drivers
      io_driver_dclk_o        => io_driver_6_dclk_o,
      io_driver_latch_o       => io_driver_6_latch_o,
      io_driver_sdi1_o        => io_driver_6_sdi1_o,
      io_driver_sdi2_o        => io_driver_6_sdi2_o,
      io_driver_sdi3_o        => io_driver_6_sdi3_o
   );
   io_driver_6_gclk_o <= s_driver_gclk;
   
   io_LED_o <= (others => '0');
   
end architecture rtl_EcranLED;
