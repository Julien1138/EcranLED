----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         affichage_serialiseur.vhd
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
-- Description  : Sérialisation des données pour les drivers de LED
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

entity affichage_serialiseur is
   port
   (
   -- Signaux globaux
      rst_aff_i            : in  std_logic;                       --! Signal de reset affichage
      clk_aff_i            : in  std_logic;                       --! Signal d'horloge affichage
      driver_dclk_i        : in  std_logic;                       --! Horloge de données du driver de LED (synchrone de clk_aff_i)
      
   -- Données image entrée
      lecture_enable_i     : in  std_logic;                       --! Enable données image
      lecture_donnees_i    : in  std_logic_vector( 7 downto 0);   --! Données image
      
   -- Infos données image entrée
      num_chaine_driver_i  : in  std_logic_vector( 1 downto 0);   --! Numéro de la chaine de driver
      num_driver_i         : in  std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
      num_sortie_driver_i  : in  std_logic_vector( 3 downto 0);   --! Numéro de la sortie du driver concerné
      
   -- Status FIFO
      fifo_driver_full_o   : out std_logic;                       --! La FIFO de pilotage des drivers est pleine
      fifo_driver_empty_o  : out std_logic;                       --! La FIFO de pilotage des drivers est vide
      
   -- Interface drivers
      io_driver_dclk_o     : out std_logic;                       --! Horloge de données du driver de LED
      io_driver_latch_o    : out std_logic;                       --! Latch du driver de LED
      io_driver_sdi1_o     : out std_logic;                       --! Donnée entrante du driver de LED n°1
      io_driver_sdi2_o     : out std_logic;                       --! Donnée entrante du driver de LED n°2
      io_driver_sdi3_o     : out std_logic                        --! Donnée entrante du driver de LED n°3
   );
end affichage_serialiseur;

-----------------------------------  Description du module  ---------------------------------------
--! Sérialisation des données pour les drivers de LED
---------------------------------------------------------------------------------------------------

architecture rtl_affichage_serialiseur of affichage_serialiseur is
   
   signal s_ser_start         : std_logic;                     --! Demande de nouvelle transmission
   signal s_ser_data_latch    : std_logic;                     --! Demande de latch des données
   signal s_ser_global_latch  : std_logic;                     --! Demande de latch global
   signal s_ser_write_config  : std_logic;                     --! Demande de latch d'écriture de configuration
   signal s_ser_data1         : std_logic_vector(15 downto 0); --! Données à sérialiser sur la chaine de drivers n°1
   signal s_ser_data2         : std_logic_vector(15 downto 0); --! Données à sérialiser sur la chaine de drivers n°2
   signal s_ser_data3         : std_logic_vector(15 downto 0); --! Données à sérialiser sur la chaine de drivers n°3
   signal s_ser_end           : std_logic;                     --! Fin de transmission
      
begin
   
   affichage_serialiseur_fifo_inst : affichage_serialiseur_fifo
   port map
   (
   -- Signaux globaux
      rst_aff_i            => rst_aff_i,
      clk_aff_i            => clk_aff_i,
      
   -- Données image entrée
      lecture_enable_i     => lecture_enable_i,
      lecture_donnees_i    => lecture_donnees_i,
      
   -- Infos données image entrée
      num_chaine_driver_i  => num_chaine_driver_i,
      num_driver_i         => num_driver_i,
      num_sortie_driver_i  => num_sortie_driver_i,
      
   -- Status FIFO
      fifo_driver_full_o   => fifo_driver_full_o,
      fifo_driver_empty_o  => fifo_driver_empty_o,
      
   -- Interface sérialiseur
      ser_start_o          => s_ser_start,
      ser_data_latch_o     => s_ser_data_latch,
      ser_global_latch_o   => s_ser_global_latch,
      ser_write_config_o   => s_ser_write_config,
      ser_data1_o          => s_ser_data1,
      ser_data2_o          => s_ser_data2,
      ser_data3_o          => s_ser_data3,
      ser_end_i            => s_ser_end
   );
   
   affichage_serialiseur_serialiseur_inst : affichage_serialiseur_serialiseur
   port map
   (
   -- Signaux globaux
      rst_aff_i         => rst_aff_i,
      clk_aff_i         => clk_aff_i,
      driver_dclk_i     => driver_dclk_i,
      
   -- Interface données parallèles
      start_i           => s_ser_start,
      data_latch_i      => s_ser_data_latch,
      global_latch_i    => s_ser_global_latch,
      write_config_i    => s_ser_write_config,
      data1_i           => s_ser_data1,
      data2_i           => s_ser_data2,
      data3_i           => s_ser_data3,
      end_o             => s_ser_end,
      
   -- Interface drivers
      io_driver_dclk_o  => io_driver_dclk_o,
      io_driver_latch_o => io_driver_latch_o,
      io_driver_sdi1_o  => io_driver_sdi1_o,
      io_driver_sdi2_o  => io_driver_sdi2_o,
      io_driver_sdi3_o  => io_driver_sdi3_o
   );
   
end architecture rtl_affichage_serialiseur;
