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
      
   -- Interface drivers carte LED n°1
      io_driver_1_dclk_o   : out std_logic;                       --! Horloge de données du driver de LED
      io_driver_1_latch_o  : out std_logic;                       --! Latch du driver de LED
      io_driver_1_sdi1_o   : out std_logic;                       --! Donnée entrante du driver de LED n°1
      io_driver_1_sdi2_o   : out std_logic;                       --! Donnée entrante du driver de LED n°2
      io_driver_1_sdi3_o   : out std_logic;                       --! Donnée entrante du driver de LED n°3
      io_driver_1_gclk_o   : out std_logic;                       --! Horloge de PWM du driver de LED
      
   -- Interface drivers carte LED n°2
      io_driver_2_dclk_o   : out std_logic;                       --! Horloge de données du driver de LED
      io_driver_2_latch_o  : out std_logic;                       --! Latch du driver de LED
      io_driver_2_sdi1_o   : out std_logic;                       --! Donnée entrante du driver de LED n°1
      io_driver_2_sdi2_o   : out std_logic;                       --! Donnée entrante du driver de LED n°2
      io_driver_2_sdi3_o   : out std_logic;                       --! Donnée entrante du driver de LED n°3
      io_driver_2_gclk_o   : out std_logic;                       --! Horloge de PWM du driver de LED
      
   -- Interface drivers carte LED n°3
      io_driver_3_dclk_o   : out std_logic;                       --! Horloge de données du driver de LED
      io_driver_3_latch_o  : out std_logic;                       --! Latch du driver de LED
      io_driver_3_sdi1_o   : out std_logic;                       --! Donnée entrante du driver de LED n°1
      io_driver_3_sdi2_o   : out std_logic;                       --! Donnée entrante du driver de LED n°2
      io_driver_3_sdi3_o   : out std_logic;                       --! Donnée entrante du driver de LED n°3
      io_driver_3_gclk_o   : out std_logic;                       --! Horloge de PWM du driver de LED
      
   -- Interface drivers carte LED n°4
      io_driver_4_dclk_o   : out std_logic;                       --! Horloge de données du driver de LED
      io_driver_4_latch_o  : out std_logic;                       --! Latch du driver de LED
      io_driver_4_sdi1_o   : out std_logic;                       --! Donnée entrante du driver de LED n°1
      io_driver_4_sdi2_o   : out std_logic;                       --! Donnée entrante du driver de LED n°2
      io_driver_4_sdi3_o   : out std_logic;                       --! Donnée entrante du driver de LED n°3
      io_driver_4_gclk_o   : out std_logic;                       --! Horloge de PWM du driver de LED
      
   -- Interface drivers carte LED n°5
      io_driver_5_dclk_o   : out std_logic;                       --! Horloge de données du driver de LED
      io_driver_5_latch_o  : out std_logic;                       --! Latch du driver de LED
      io_driver_5_sdi1_o   : out std_logic;                       --! Donnée entrante du driver de LED n°1
      io_driver_5_sdi2_o   : out std_logic;                       --! Donnée entrante du driver de LED n°2
      io_driver_5_sdi3_o   : out std_logic;                       --! Donnée entrante du driver de LED n°3
      io_driver_5_gclk_o   : out std_logic;                       --! Horloge de PWM du driver de LED
      
   -- Interface drivers carte LED n°6
      io_driver_6_dclk_o   : out std_logic;                       --! Horloge de données du driver de LED
      io_driver_6_latch_o  : out std_logic;                       --! Latch du driver de LED
      io_driver_6_sdi1_o   : out std_logic;                       --! Donnée entrante du driver de LED n°1
      io_driver_6_sdi2_o   : out std_logic;                       --! Donnée entrante du driver de LED n°2
      io_driver_6_sdi3_o   : out std_logic;                       --! Donnée entrante du driver de LED n°3
      io_driver_6_gclk_o   : out std_logic                        --! Horloge de PWM du driver de LED
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
   
   signal s_rafraichissement  : std_logic;
   
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
   
   s_rafraichissement <= '1';
   
   memoire_image_1 : memoire_image
   port map
   (
   -- Signaux globaux
      rst_aff_i            => s_rst_aff,
      clk_aff_i            => s_clk_aff,
      
   -- Interface d'écriture de l'image
      ecriture_en_i        => '0',
      ecriture_adresse_i   => (others => '0'),
      ecriture_donnees_i   => (others => '0'),
      
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
   
   affichage_inst1 : affichage
   port map
   (
   -- Signaux globaux
      rst_aff_i               => s_rst_aff,
      clk_aff_i               => s_clk_aff,
      driver_dclk_i           => s_driver_dclk,
      
   -- Commande
      rafraichissement_i      => s_rafraichissement,
      maj_luminosite_toggle_i => '0',
      luminosite_i            => X"00",
      
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
   
end architecture rtl_EcranLED;
