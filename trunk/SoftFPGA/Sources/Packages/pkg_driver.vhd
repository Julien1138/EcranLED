----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         pkg_driver.vhd
--              . 
-- Type           Package
--              . 
--! @author       J. AUPART
--              . 
--! @version      1.0
--              . 
--! @date         14/11/2013
--              . 
----------------|-------------------------------------------------------------
-- Description  : Package du FPGA Driver
--                
----------------|-------------------------------------------------------------
-- Historique   : 
-- 
-- Version 1.0    14/11/2013     J. AUPART
-- 
----------------|-------------------------------------------------------------
-- Commentaires :
-- 
--         1.0  : Cr�ation
-- 
----------------|-------------------------------------------------------------


--! use standard library
library ieee;
--! use logic elements
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-----------------------------------  Description du package  --------------------------------------
--! Le package pkg_driver contient les d�claration des constantes et des modules du FPGA Driver.\n
---------------------------------------------------------------------------------------------------

package pkg_driver is
---------------------------------------------------------------------------------------------------
-- D�claration des constantes
---------------------------------------------------------------------------------------------------
   
   ------------------------------------------------------------------------------------------------
   -- Constantes du module horloges
   ------------------------------------------------------------------------------------------------
   constant CST_HORLOGES_DEMI_PERIODE_DCLK_DRIVER        : std_logic_vector( 7 downto 0) := X"0F";    --! Demi-periode de l'horloge de donn�es du driver de LED (horloge affichage @ 30 MHz)
   constant CST_HORLOGES_DEMI_PERIODE_GCLK_DRIVER        : std_logic_vector( 7 downto 0) := X"0F";    --! Demi-periode de l'horloge de PWM du driver de LED (horloge affichage @ 30 MHz)
   
   ------------------------------------------------------------------------------------------------
   -- Constantes du module interpreteur
   ------------------------------------------------------------------------------------------------
   constant CST_INTERPRETEUR_FILTRE_NUMERO_AFFICHEUR     : std_logic                     := '1';      --! Activation du filtre du num�ro d'afficheur dans les trames re�ues
   constant CST_INTERPRETEUR_NUMERO_AFFICHEUR_BROADCAST  : std_logic_vector( 7 downto 0) := X"0E";    --! Valeur de num�ro d'afficheur pour le broadcast
   constant CST_INTERPRETEUR_ADRESSE_LUMINOSITE          : std_logic_vector(11 downto 0) := X"001";   --! Adresse du param�tre de luminosit�
   constant CST_INTERPRETEUR_ADRESSE_MAJ_IMAGE           : std_logic_vector(11 downto 0) := X"49E";   --! Adresse de mise � jour de l'image � afficher
   constant CST_INTERPRETEUR_ADRESSE_DEFILEMENT          : std_logic_vector(11 downto 0) := X"FFD";   --! Adresse de l'activation du d�filement
   constant CST_INTERPRETEUR_ADRESSE_AFFICHEUR_ETEINT    : std_logic_vector(11 downto 0) := X"FFC";   --! Adresse d'extinction de l'afficheur
   
   ------------------------------------------------------------------------------------------------
   -- Constantes du module affichage
   ------------------------------------------------------------------------------------------------
   constant CST_AFFICHAGE_RAFRAICHISSEMENT_PERIODE_RAFRAICHISSEMENT  : std_logic_vector(31 downto 0) := X"0000AFC8"; --! 1.5 ms (horloge affichage @ 30 MHz)
   constant CST_AFFICHAGE_ORDONNANCEUR_IDX_DERNIER_DRIVER            : std_logic_vector( 7 downto 0) := X"7D";       --! 125
   constant CST_AFFICHAGE_TRAITEMENTS_COULEUR                        : std_logic                     := '1';         --! 0 = N&B; 1 = Couleur
   constant CST_AFFICHAGE_TRAITEMENTS_BLANC                          : std_logic_vector( 1 downto 0) := "00";        --! Le pixel est de couleur blanche
   constant CST_AFFICHAGE_TRAITEMENTS_ROUGE                          : std_logic_vector( 1 downto 0) := "01";        --! Le pixel est de couleur rouge
   constant CST_AFFICHAGE_TRAITEMENTS_VERT                           : std_logic_vector( 1 downto 0) := "10";        --! Le pixel est de couleur verte
   constant CST_AFFICHAGE_TRAITEMENTS_BLEU                           : std_logic_vector( 1 downto 0) := "11";        --! Le pixel est de couleur bleue
   constant CST_AFFICHAGE_SERIALISEUR_DATA_LATCH_LENGTH              : std_logic_vector( 3 downto 0) := "0001";      --!  1
   constant CST_AFFICHAGE_SERIALISEUR_GLOBAL_LATCH_LENGTH            : std_logic_vector( 3 downto 0) := "0011";      --!  3
   constant CST_AFFICHAGE_SERIALISEUR_WRITE_CONFIG_LATCH_LENGTH      : std_logic_vector( 3 downto 0) := "1011";      --! 11
   
---------------------------------------------------------------------------------------------------
-- D�claration des composants
---------------------------------------------------------------------------------------------------
   
   ------------------------------------------------------------------------------------------------
   -- Composants du module horloges
   ------------------------------------------------------------------------------------------------
   component horloges is
      port
      (
      -- Signaux externes
         io_clk_i       : in  std_logic;  --! Horloge externe (50 MHz)
         
      -- Domaine d'horloge affichage
         rst_aff_o      : out std_logic;  --! Signal de reset affichage
         clk_aff_o      : out std_logic;  --! Signal d'horloge affichage
         driver_dclk_o  : out std_logic;  --! Horloge de donn�es du driver de LED (synchrone de clk_aff_i)
         driver_gclk_o  : out std_logic   --! Horloge de PWM du driver de LED (synchrone de clk_aff_i)
      );
   end component;

   ------------------------------------------------------------------------------------------------
   -- Composants du module memoire_image
   ------------------------------------------------------------------------------------------------
   component memoire_image is
      port
      (
      -- Signaux globaux
         rst_aff_i            : in  std_logic;                       --! Signal de reset vid�o
         clk_aff_i            : in  std_logic;                       --! Signal d'horloge vid�o
         
      -- Interface d'�criture de l'image
         ecriture_en_i        : in  std_logic;                       --! Write enable de la m�moire image
         ecriture_adresse_i   : in  std_logic_vector(12 downto 0);   --! Adresse d'�criture des donn�es image
         ecriture_donnees_i   : in  std_logic_vector( 7 downto 0);   --! Donn�es image
         
      -- Commandes
         lecture_enable_i     : in  std_logic;                       --! Enable lecture pixel
         num_chaine_driver_i  : in  std_logic_vector( 1 downto 0);   --! Num�ro de la chaine de driver
         num_driver_i         : in  std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
         num_sortie_driver_i  : in  std_logic_vector( 3 downto 0);   --! Num�ro de la sortie du driver concern�
         
      -- Donn�es image lues
         lecture_enable_o     : out std_logic;                       --! Enable donn�es image
         lecture_donnees_o    : out std_logic_vector( 7 downto 0);   --! Donn�es image
         
      -- Infos donn�es image lues
         num_chaine_driver_o  : out std_logic_vector( 1 downto 0);   --! Num�ro de la chaine de driver
         num_driver_o         : out std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
         num_sortie_driver_o  : out std_logic_vector( 3 downto 0);   --! Num�ro de la sortie du driver concern�
         couleur_pixel_o      : out std_logic_vector( 1 downto 0)    --! Couleur du pixel
      );
   end component;
   
   component memoire_image_memoire is
      port
      (
         clka: in std_logic;
         wea: in std_logic_vector(0 downto 0);
         addra: in std_logic_vector(12 downto 0);
         dina: in std_logic_vector(7 downto 0);
         douta: out std_logic_vector(7 downto 0);
         clkb: in std_logic;
         web: in std_logic_vector(0 downto 0);
         addrb: in std_logic_vector(12 downto 0);
         dinb: in std_logic_vector(7 downto 0);
         doutb: out std_logic_vector(7 downto 0)
      );
   end component;
   
   component memoire_image_dpram is
      port
      (
         data        : in  std_logic_vector( 7 downto 0);
         rdaddress   : in  std_logic_vector(11 downto 0);
         rdclock     : in  std_logic;
         wraddress   : in  std_logic_vector(11 downto 0);
         wrclock     : in  std_logic;
         wren        : in  std_logic;
         q           : out std_logic_vector( 7 downto 0)
      );
   end component;
   
   component memoire_image_adressage is
      port
      (
      -- Signaux globaux
         rst_aff_i            : in  std_logic;                       --! Signal de reset affichage
         clk_aff_i            : in  std_logic;                       --! Signal d'horloge affichage
         
      -- Position pixel
         lecture_enable_i     : in  std_logic;                       --! Enable lecture pixel
         num_chaine_driver_i  : in  std_logic_vector( 1 downto 0);   --! Num�ro de la chaine de driver
         num_driver_i         : in  std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
         num_sortie_driver_i  : in  std_logic_vector( 3 downto 0);   --! Num�ro de la sortie du driver concern�
         
      -- Infos pixel de sortie
         num_chaine_driver_o  : out std_logic_vector( 1 downto 0);   --! Num�ro de la chaine de driver
         num_driver_o         : out std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
         num_sortie_driver_o  : out std_logic_vector( 3 downto 0);   --! Num�ro de la sortie du driver concern�
         couleur_pixel_o      : out std_logic_vector( 1 downto 0);   --! Couleur du pixel
         
      -- Interface m�moire image
         lecture_enable_o     : out std_logic;                       --! Enable lecture pixel
         adresse_o            : out std_logic_vector(12 downto 0)    --! Adresse d'�criture des donn�es image
      );
   end component;
   
   ------------------------------------------------------------------------------------------------
   -- Composants du module affichage
   ------------------------------------------------------------------------------------------------
   
   component affichage is
      generic
      (
         GNR_AFFICHAGE_TRAITEMENTS_COEFFICIENT_ROUGE  : std_logic_vector( 7 downto 0) := X"B5";  --! Coefficient � appliquer � la couleur rouge
         GNR_AFFICHAGE_TRAITEMENTS_COEFFICIENT_VERT   : std_logic_vector( 7 downto 0) := X"FF";  --! Coefficient � appliquer � la couleur verte
         GNR_AFFICHAGE_TRAITEMENTS_COEFFICIENT_BLEU   : std_logic_vector( 7 downto 0) := X"6E"   --! Coefficient � appliquer � la couleur bleue
      );
      port
      (
      -- Signaux globaux
         rst_aff_i               : in  std_logic;                       --! Signal de reset affichage
         clk_aff_i               : in  std_logic;                       --! Signal d'horloge affichage
         driver_dclk_i           : in  std_logic;                       --! Horloge de donn�es du driver de LED (synchrone de clk_aff_i)
         
      -- Commande
         rafraichissement_i      : in  std_logic;
         maj_luminosite_toggle_i : in  std_logic;                       --! Mise � jour de la luminosit� (inversion du signal � chaque fois)
         luminosite_i            : in  std_logic_vector( 7 downto 0);   --! R�glage de luminosit�
         
      -- Interface m�moire image
         -- Commandes
         lecture_enable_o        : out std_logic;                       --! Enable lecture pixel
         
         -- Adresse du pixel � lire
         num_chaine_driver_o     : out std_logic_vector( 1 downto 0);   --! Num�ro de la chaine de driver
         num_driver_o            : out std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
         num_sortie_driver_o     : out std_logic_vector( 3 downto 0);   --! Num�ro de la sortie du driver concern�
         
         -- Donn�es image lues
         lecture_enable_i        : in  std_logic;                       --! Enable donn�es image
         lecture_donnees_i       : in  std_logic_vector( 7 downto 0);   --! Donn�es image
         
         -- Infos donn�es image lues
         num_chaine_driver_i     : in  std_logic_vector( 1 downto 0);   --! Num�ro de la chaine de driver
         num_driver_i            : in  std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
         num_sortie_driver_i     : in  std_logic_vector( 3 downto 0);   --! Num�ro de la sortie du driver concern�
         couleur_pixel_i         : in  std_logic_vector( 1 downto 0);   --! Couleur du pixel
         
      -- Interface drivers
         io_driver_dclk_o        : out std_logic;                       --! Horloge de donn�es du driver de LED
         io_driver_latch_o       : out std_logic;                       --! Latch du driver de LED
         io_driver_sdi1_o        : out std_logic;                       --! Donn�e entrante du driver de LED n�1
         io_driver_sdi2_o        : out std_logic;                       --! Donn�e entrante du driver de LED n�2
         io_driver_sdi3_o        : out std_logic                        --! Donn�e entrante du driver de LED n�3
      );
   end component;
   
   component affichage_parametres is
      port
      (
      -- Signaux globaux
         rst_aff_i               : in  std_logic;                       --! Signal de reset affichage
         clk_aff_i               : in  std_logic;                       --! Signal d'horloge affichage
         
      -- Param�tres
         maj_luminosite_toggle_i : in  std_logic;                       --! Mise � jour de la luminosit� (inversion du signal � chaque fois)
         luminosite_i            : in  std_logic_vector( 7 downto 0);   --! R�glage de luminosit�
            
      -- Status
         mise_a_jour_i           : in  std_logic;                       --! Mise � jour des param�tres
         
      -- Param�trage synchronis�
         luminosite_o            : out std_logic_vector( 7 downto 0)    --! R�glage de luminosit�
      );
   end component;
   
   component affichage_ordonnanceur is
      port
      (
      -- Signaux globaux
         rst_aff_i            : in  std_logic;                       --! Signal de reset affichage
         clk_aff_i            : in  std_logic;                       --! Signal d'horloge affichage
         
      -- Commande
         configuration_i      : in  std_logic;                       --! Configuration des drivers
         rafraichissement_i   : in  std_logic;                       --! Rafraichissement de l'affichage
         
      -- Status
         fifo_driver_full_i   : in  std_logic;                       --! La FIFO de pilotage des drivers est pleine
         fifo_driver_empty_i  : in  std_logic;                       --! La FIFO de pilotage des drivers est vide
         
      -- Interface m�moire
         lecture_image_en_o   : out std_logic;                       --! Enable lecture pixel
         num_chaine_driver_o  : out std_logic_vector( 1 downto 0);   --! Num�ro de la chaine de driver
         num_driver_o         : out std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
         num_sortie_driver_o  : out std_logic_vector( 3 downto 0)    --! Num�ro de la sortie du driver concern�
      );
   end component;
   
   component affichage_traitements is
      generic
      (
         GNR_AFFICHAGE_TRAITEMENTS_COEFFICIENT_ROUGE  : std_logic_vector( 7 downto 0) := X"B5";  --! Coefficient � appliquer � la couleur rouge
         GNR_AFFICHAGE_TRAITEMENTS_COEFFICIENT_VERT   : std_logic_vector( 7 downto 0) := X"FF";  --! Coefficient � appliquer � la couleur verte
         GNR_AFFICHAGE_TRAITEMENTS_COEFFICIENT_BLEU   : std_logic_vector( 7 downto 0) := X"6E"   --! Coefficient � appliquer � la couleur bleue
      );
      port
      (
      -- Signaux globaux
         rst_opt_i            : in  std_logic;                       --! Signal de reset vid�o
         clk_opt_i            : in  std_logic;                       --! Signal d'horloge vid�o
         
      -- Param�trage
         luminosite_i         : in  std_logic_vector( 7 downto 0);   --! R�glage de luminosit�
         
      -- Donn�es image entr�e
         lecture_enable_i     : in  std_logic;                       --! Enable donn�es image
         lecture_donnees_i    : in  std_logic_vector( 7 downto 0);   --! Donn�es image
         
      -- Infos donn�es image entr�e
         num_chaine_driver_i  : in  std_logic_vector( 1 downto 0);   --! Num�ro de la chaine de driver
         num_driver_i         : in  std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
         num_sortie_driver_i  : in  std_logic_vector( 3 downto 0);   --! Num�ro de la sortie du driver concern�
         couleur_pixel_i      : in  std_logic_vector( 1 downto 0);   --! Couleur du pixel
         
      -- Donn�es image sortie
         lecture_enable_o     : out std_logic;                       --! Enable donn�es image
         lecture_donnees_o    : out std_logic_vector( 7 downto 0);   --! Donn�es image
         
      -- Infos donn�es image sortie
         num_chaine_driver_o  : out std_logic_vector( 1 downto 0);   --! Num�ro de la chaine de driver
         num_driver_o         : out std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
         num_sortie_driver_o  : out std_logic_vector( 3 downto 0);   --! Num�ro de la sortie du driver concern�
         couleur_pixel_o      : out std_logic_vector( 1 downto 0)    --! Couleur du pixel
      );
   end component;

   component affichage_traitements_balance_couleurs_mult is
      port
      (
         a  : in  std_logic_vector( 7 downto 0);
         b  : in  std_logic_vector(15 downto 0);
         p  : out std_logic_vector(23 downto 0)
      );
   end component;
   
   component affichage_traitements_balance_couleurs is
      generic
      (
         GNR_AFFICHAGE_TRAITEMENTS_COEFFICIENT_ROUGE  : std_logic_vector( 7 downto 0) := X"B5";  --! Coefficient � appliquer � la couleur rouge
         GNR_AFFICHAGE_TRAITEMENTS_COEFFICIENT_VERT   : std_logic_vector( 7 downto 0) := X"FF";  --! Coefficient � appliquer � la couleur verte
         GNR_AFFICHAGE_TRAITEMENTS_COEFFICIENT_BLEU   : std_logic_vector( 7 downto 0) := X"6E"   --! Coefficient � appliquer � la couleur bleue
      );
      port
      (
      -- Signaux globaux
         rst_opt_i            : in  std_logic;                       --! Signal de reset vid�o
         clk_opt_i            : in  std_logic;                       --! Signal d'horloge vid�o
            
      -- Donn�es image entr�e
         lecture_enable_i     : in  std_logic;                       --! Enable donn�es image
         lecture_donnees_i    : in  std_logic_vector(15 downto 0);   --! Donn�es image
         
      -- Infos donn�es image entr�e
         num_chaine_driver_i  : in  std_logic_vector( 1 downto 0);   --! Num�ro de la chaine de driver
         num_driver_i         : in  std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
         num_sortie_driver_i  : in  std_logic_vector( 3 downto 0);   --! Num�ro de la sortie du driver concern�
         couleur_pixel_i      : in  std_logic_vector( 1 downto 0);   --! Couleur du pixel
         
      -- Donn�es image sortie
         lecture_enable_o     : out std_logic;                       --! Enable donn�es image
         lecture_donnees_o    : out std_logic_vector(15 downto 0);   --! Donn�es image
         
      -- Infos donn�es image sortie
         num_chaine_driver_o  : out std_logic_vector( 1 downto 0);   --! Num�ro de la chaine de driver
         num_driver_o         : out std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
         num_sortie_driver_o  : out std_logic_vector( 3 downto 0);   --! Num�ro de la sortie du driver concern�
         couleur_pixel_o      : out std_logic_vector( 1 downto 0)    --! Couleur du pixel
      );
   end component;
   
   component affichage_traitements_luminosite_mult is
      port
      (
         a  : in  std_logic_vector( 7 downto 0);
         b  : in  std_logic_vector(15 downto 0);
         p  : out std_logic_vector(23 downto 0)
      );
   end component;
   
   component affichage_traitements_luminosite is
      port
      (
      -- Signaux globaux
         rst_opt_i            : in  std_logic;                       --! Signal de reset vid�o
         clk_opt_i            : in  std_logic;                       --! Signal d'horloge vid�o
         
      -- Param�trage
         luminosite_i         : in  std_logic_vector( 7 downto 0);   --! R�glage de luminosit�
         
      -- Donn�es image entr�e
         lecture_enable_i     : in  std_logic;                       --! Enable donn�es image
         lecture_donnees_i    : in  std_logic_vector(15 downto 0);   --! Donn�es image
         
      -- Infos donn�es image entr�e
         num_chaine_driver_i  : in  std_logic_vector( 1 downto 0);   --! Num�ro de la chaine de driver
         num_driver_i         : in  std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
         num_sortie_driver_i  : in  std_logic_vector( 3 downto 0);   --! Num�ro de la sortie du driver concern�
         couleur_pixel_i      : in  std_logic_vector( 1 downto 0);   --! Couleur du pixel
         
      -- Donn�es image sortie
         lecture_enable_o     : out std_logic;                       --! Enable donn�es image
         lecture_donnees_o    : out std_logic_vector(15 downto 0);   --! Donn�es image
         
      -- Infos donn�es image sortie
         num_chaine_driver_o  : out std_logic_vector( 1 downto 0);   --! Num�ro de la chaine de driver
         num_driver_o         : out std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
         num_sortie_driver_o  : out std_logic_vector( 3 downto 0);   --! Num�ro de la sortie du driver concern�
         couleur_pixel_o      : out std_logic_vector( 1 downto 0)    --! Couleur du pixel
      );
   end component;
   
   component affichage_serialiseur is
      port
      (
      -- Signaux globaux
         rst_aff_i            : in  std_logic;                       --! Signal de reset affichage
         clk_aff_i            : in  std_logic;                       --! Signal d'horloge affichage
         driver_dclk_i        : in  std_logic;                       --! Horloge de donn�es du driver de LED (synchrone de clk_aff_i)
         
      -- Donn�es image entr�e
         lecture_enable_i     : in  std_logic;                       --! Enable donn�es image
         lecture_donnees_i    : in  std_logic_vector( 7 downto 0);   --! Donn�es image
         
      -- Infos donn�es image entr�e
         num_chaine_driver_i  : in  std_logic_vector( 1 downto 0);   --! Num�ro de la chaine de driver
         num_driver_i         : in  std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
         num_sortie_driver_i  : in  std_logic_vector( 3 downto 0);   --! Num�ro de la sortie du driver concern�
         
      -- Status FIFO
         fifo_driver_full_o   : out std_logic;                       --! La FIFO de pilotage des drivers est pleine
         fifo_driver_empty_o  : out std_logic;                       --! La FIFO de pilotage des drivers est vide
         
      -- Interface drivers
         io_driver_dclk_o     : out std_logic;                       --! Horloge de donn�es du driver de LED
         io_driver_latch_o    : out std_logic;                       --! Latch du driver de LED
         io_driver_sdi1_o     : out std_logic;                       --! Donn�e entrante du driver de LED n�1
         io_driver_sdi2_o     : out std_logic;                       --! Donn�e entrante du driver de LED n�2
         io_driver_sdi3_o     : out std_logic                        --! Donn�e entrante du driver de LED n�3
      );
   end component;
   
   component affichage_serialiseur_serialiseur is
      port
      (
      -- Signaux globaux
         rst_aff_i         : in  std_logic;                       --! Signal de reset affichage
         clk_aff_i         : in  std_logic;                       --! Signal d'horloge affichage
         driver_dclk_i     : in  std_logic;                       --! Horloge de donn�es du driver de LED (synchrone de clk_aff_i)
         
      -- Interface donn�es parall�les
         start_i           : in  std_logic;                       --! Demande de nouvelle transmission
         data_latch_i      : in  std_logic;                       --! Demande de latch des donn�es
         global_latch_i    : in  std_logic;                       --! Demande de latch global
         write_config_i    : in  std_logic;                       --! Demande de latch d'�criture de configuration
         data1_i           : in  std_logic_vector(15 downto 0);   --! Donn�es � s�rialiser sur la chaine de drivers n�1
         data2_i           : in  std_logic_vector(15 downto 0);   --! Donn�es � s�rialiser sur la chaine de drivers n�2
         data3_i           : in  std_logic_vector(15 downto 0);   --! Donn�es � s�rialiser sur la chaine de drivers n�3
         end_o             : out std_logic;                       --! Fin de transmission
         
      -- Interface drivers
         io_driver_dclk_o  : out std_logic;                       --! Horloge de donn�es du driver de LED
         io_driver_latch_o : out std_logic;                       --! Latch du driver de LED
         io_driver_sdi1_o  : out std_logic;                       --! Donn�e entrante du driver de LED n�1
         io_driver_sdi2_o  : out std_logic;                       --! Donn�e entrante du driver de LED n�2
         io_driver_sdi3_o  : out std_logic                        --! Donn�e entrante du driver de LED n�3
      );
   end component;
   
   component affichage_serialiseur_fifo is
      port
      (
      -- Signaux globaux
         rst_aff_i            : in  std_logic;                       --! Signal de reset affichage
         clk_aff_i            : in  std_logic;                       --! Signal d'horloge affichage
         
      -- Donn�es image entr�e
         lecture_enable_i     : in  std_logic;                       --! Enable donn�es image
         lecture_donnees_i    : in  std_logic_vector( 7 downto 0);   --! Donn�es image
         
      -- Infos donn�es image entr�e
         num_chaine_driver_i  : in  std_logic_vector( 1 downto 0);   --! Num�ro de la chaine de driver
         num_driver_i         : in  std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
         num_sortie_driver_i  : in  std_logic_vector( 3 downto 0);   --! Num�ro de la sortie du driver concern�
         
      -- Status FIFO
         fifo_driver_full_o   : out std_logic;                       --! La FIFO de pilotage des drivers est pleine
         fifo_driver_empty_o  : out std_logic;                       --! La FIFO de pilotage des drivers est vide
         
      -- Interface s�rialiseur
         ser_start_o          : out std_logic;                       --! Demande de nouvelle transmission
         ser_data_latch_o     : out std_logic;                       --! Demande de latch des donn�es
         ser_global_latch_o   : out std_logic;                       --! Demande de latch global
         ser_write_config_o   : out std_logic;                       --! Demande de latch d'�criture de configuration
         ser_data1_o          : out std_logic_vector(15 downto 0);   --! Donn�es � s�rialiser sur la chaine de drivers n�1
         ser_data2_o          : out std_logic_vector(15 downto 0);   --! Donn�es � s�rialiser sur la chaine de drivers n�2
         ser_data3_o          : out std_logic_vector(15 downto 0);   --! Donn�es � s�rialiser sur la chaine de drivers n�3
         ser_end_i            : in  std_logic                        --! Fin de transmission
      );
   end component;
   
   component affichage_serialiseur_fifo_image is
      port
      (
         clk         : in  std_logic;
         din         : in  std_logic_vector(25 downto 0);
         wr_en       : in  std_logic;
         rd_en       : in  std_logic;
         dout        : out std_logic_vector(25 downto 0);
         full        : out std_logic;
         empty       : out std_logic;
         prog_full   : out std_logic;
         prog_empty  : out std_logic
      );
   end component;
   
end package;
