----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         affichage_ordonnanceur.vhd
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
-- Description  : Ordonnanceur de l'affichage
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

entity affichage_ordonnanceur is
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
      
   -- Interface mémoire
      lecture_image_en_o   : out std_logic;                       --! Enable lecture pixel
      num_chaine_driver_o  : out std_logic_vector( 1 downto 0);   --! Numéro de la chaine de driver
      num_driver_o         : out std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
      num_sortie_driver_o  : out std_logic_vector( 3 downto 0)    --! Numéro de la sortie du driver concerné
   );
end affichage_ordonnanceur;

-----------------------------------  Description du module  ---------------------------------------
--! Machine d'état et compteurs qui gèrent les différentes étapes de l'affichage
---------------------------------------------------------------------------------------------------

architecture rtl_affichage_ordonnanceur of affichage_ordonnanceur is
   
   -- Machine d'état
   type t_etat_ordonnanceur is (IDLE,
                                CONFIGURATION_BUFFERS,
                                CHARGEMENT_IMAGE);
   signal sm_etat_ordonnanceur_present : t_etat_ordonnanceur := IDLE;
   signal sm_etat_ordonnanceur_futur   : t_etat_ordonnanceur := IDLE;
   
   signal s_ser_start               : std_logic;                     --! Début de sérialisation
   signal s_lecture_image_en        : std_logic;                     --! Enable lecture pixel
   signal s_compteur_chaine_driver  : std_logic_vector( 1 downto 0); --! Compteur de la chaine de driver en cours de paramétrage
   signal s_compteur_sortie_driver  : std_logic_vector( 3 downto 0); --! Compteur de la sortie du driver en cours de paramétrage
   signal s_compteur_driver         : std_logic_vector( 7 downto 0); --! Compteur du driver en cours de paramétrage
   
begin
   
---------------------------------------------------------------------------------------------------
-- Process : prc_etat_ordonnanceur
-- Détail : Machine d'état sm_etat_ordonnanceur
---------------------------------------------------------------------------------------------------
   prc_etat_ordonnanceur : process(sm_etat_ordonnanceur_present, configuration_i, rafraichissement_i,
                                   fifo_driver_empty_i, s_ser_start, s_compteur_driver,
                                   s_compteur_sortie_driver)
   begin
      case sm_etat_ordonnanceur_present is
         when IDLE =>
            if configuration_i = '1' then
               sm_etat_ordonnanceur_futur <= CONFIGURATION_BUFFERS;
            elsif rafraichissement_i = '1' and fifo_driver_empty_i = '1' then
               sm_etat_ordonnanceur_futur <= CHARGEMENT_IMAGE;
            else
               sm_etat_ordonnanceur_futur <= IDLE;
            end if;
            
         when CONFIGURATION_BUFFERS =>
            sm_etat_ordonnanceur_futur <= IDLE;
            
         when CHARGEMENT_IMAGE =>
            if s_ser_start = '1' and s_compteur_driver = CST_AFFICHAGE_ORDONNANCEUR_IDX_DERNIER_DRIVER and s_compteur_sortie_driver = X"0" then
               sm_etat_ordonnanceur_futur <= IDLE;
            else
               sm_etat_ordonnanceur_futur <= CHARGEMENT_IMAGE;
            end if;
            
         when others => NULL;
      end case;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_etat_ordonnanceur_sync
-- Détail : Synchronisation de la machine d'état sm_etat_ordonnanceur
---------------------------------------------------------------------------------------------------
   prc_etat_ordonnanceur_sync : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         sm_etat_ordonnanceur_present <= IDLE;
      elsif rising_edge(clk_aff_i) then
         sm_etat_ordonnanceur_present <= sm_etat_ordonnanceur_futur;
      end if;
   end process;
   
   s_ser_start <= '1' when sm_etat_ordonnanceur_present = CHARGEMENT_IMAGE and s_compteur_chaine_driver = "10" and fifo_driver_full_i = '0' else
                  '0';
   
---------------------------------------------------------------------------------------------------
-- Process : prc_lecture_image_en
-- Détail : Numéro de la chaine de driver
---------------------------------------------------------------------------------------------------
   prc_lecture_image_en : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_lecture_image_en <= '0';
      elsif rising_edge(clk_aff_i) then
         
         if sm_etat_ordonnanceur_present = IDLE then
            if rafraichissement_i = '1' and fifo_driver_empty_i = '1' then
               s_lecture_image_en <= '1';
            else
               s_lecture_image_en <= '0';
            end if;
         elsif sm_etat_ordonnanceur_futur = CHARGEMENT_IMAGE then
            if s_ser_start = '1' then
               s_lecture_image_en <= '1';
            elsif s_compteur_chaine_driver = "10"  then
               s_lecture_image_en <= '0';
            else
               s_lecture_image_en <= s_lecture_image_en;
            end if;
         else
            s_lecture_image_en <= '0';
         end if;
         
      end if;
   end process;
   lecture_image_en_o <= s_lecture_image_en;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_num_chaine_driver
-- Détail : Numéro de la chaine de driver
---------------------------------------------------------------------------------------------------
   prc_num_chaine_driver : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_compteur_chaine_driver <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if sm_etat_ordonnanceur_present = IDLE then
            s_compteur_chaine_driver <= (others => '0');
         elsif sm_etat_ordonnanceur_present = CHARGEMENT_IMAGE then
            if s_ser_start = '1' then
               s_compteur_chaine_driver <= (others => '0');
            elsif s_compteur_chaine_driver = "10" then
               s_compteur_chaine_driver <= s_compteur_chaine_driver;
            else
               s_compteur_chaine_driver <= s_compteur_chaine_driver + 1;
            end if;
         else
            s_compteur_chaine_driver <= (others => '0');
         end if;
         
      end if;
   end process;
   num_chaine_driver_o <= s_compteur_chaine_driver;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_compteur_sortie_driver
-- Détail : Compteur de la sortie des drivers en cours de paramétrage
---------------------------------------------------------------------------------------------------
   prc_compteur_sortie_driver : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_compteur_sortie_driver <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if sm_etat_ordonnanceur_present = IDLE then
            s_compteur_sortie_driver <= (others => '1');
         elsif sm_etat_ordonnanceur_present = CHARGEMENT_IMAGE then
            if s_ser_start = '1' and s_compteur_driver = CST_AFFICHAGE_ORDONNANCEUR_IDX_DERNIER_DRIVER then
               s_compteur_sortie_driver <= s_compteur_sortie_driver - 1;
            else
               s_compteur_sortie_driver <= s_compteur_sortie_driver;
            end if;
         else
            s_compteur_sortie_driver <= (others => '1');
         end if;
         
      end if;
   end process;
   num_sortie_driver_o <= s_compteur_sortie_driver;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_compteur_driver
-- Détail : Compteur du drivers en cours de paramétrage
---------------------------------------------------------------------------------------------------
   prc_compteur_driver : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_compteur_driver <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if sm_etat_ordonnanceur_present = IDLE then
            s_compteur_driver <= (others => '0');
         elsif sm_etat_ordonnanceur_present = CHARGEMENT_IMAGE then
            if s_ser_start = '1' then
               if s_compteur_driver = CST_AFFICHAGE_ORDONNANCEUR_IDX_DERNIER_DRIVER then
                  s_compteur_driver <= (others => '0');
               else
                  s_compteur_driver <= s_compteur_driver + 1;
               end if;
            else
               s_compteur_driver <= s_compteur_driver;
            end if;
         else
            s_compteur_driver <= (others => '0');
         end if;
         
      end if;
   end process;
   num_driver_o <= s_compteur_driver;
   
end architecture rtl_affichage_ordonnanceur;
