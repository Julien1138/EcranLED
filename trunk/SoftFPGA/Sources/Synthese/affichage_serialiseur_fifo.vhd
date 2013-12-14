----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         affichage_serialiseur_fifo.vhd
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
-- Description  : FIFO d'entrée du sérialiseur
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

entity affichage_serialiseur_fifo is
   port
   (
   -- Signaux globaux
      rst_aff_i            : in  std_logic;                       --! Signal de reset affichage
      clk_aff_i            : in  std_logic;                       --! Signal d'horloge affichage
      
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
      
   -- Interface sérialiseur
      ser_start_o          : out std_logic;                       --! Demande de nouvelle transmission
      ser_data_latch_o     : out std_logic;                       --! Demande de latch des données
      ser_global_latch_o   : out std_logic;                       --! Demande de latch global
      ser_write_config_o   : out std_logic;                       --! Demande de latch d'écriture de configuration
      ser_data1_o          : out std_logic_vector(15 downto 0);   --! Données à sérialiser sur la chaine de drivers n°1
      ser_data2_o          : out std_logic_vector(15 downto 0);   --! Données à sérialiser sur la chaine de drivers n°2
      ser_data3_o          : out std_logic_vector(15 downto 0);   --! Données à sérialiser sur la chaine de drivers n°3
      ser_end_i            : in  std_logic                        --! Fin de transmission
   );
end affichage_serialiseur_fifo;

-----------------------------------  Description du module  ---------------------------------------
--! La latence maximum entre l'ordre d'écriture de données image de l'ordonnanceur et l'entrée de
--! la FIFO doit être de moins de 32 cycles d'horloge.
---------------------------------------------------------------------------------------------------

architecture rtl_affichage_serialiseur_fifo of affichage_serialiseur_fifo is
   
   -- Machine d'état
   type t_etat_fifo is (IDLE,
                        LECTURE_IMAGE,
                        LECTURE_CONFIG);
   signal sm_etat_fifo_present   : t_etat_fifo := IDLE;
   signal sm_etat_fifo_futur     : t_etat_fifo := IDLE;
   
   signal s_fifo_image_read         : std_logic;
   signal s_fifo_image_write        : std_logic;
   signal s_fifo_image_data_in      : std_logic_vector(25 downto 0);
   signal s_fifo_image_data_out     : std_logic_vector(25 downto 0);
   signal s_fifo_image_almost_empty : std_logic;
   signal s_fifo_image_almost_full  : std_logic;
   signal s_fifo_image_empty        : std_logic;
   
begin
   
---------------------------------------------------------------------------------------------------
-- Process : prc_fifo_image_write
-- Détail : Ecriture dans la fifo image
---------------------------------------------------------------------------------------------------
   prc_fifo_image_write1 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_fifo_image_write <= '0';
      elsif rising_edge(clk_aff_i) then
         
         if lecture_enable_i = '1' and num_chaine_driver_i = "10" then
            s_fifo_image_write <= '1';
         else
            s_fifo_image_write <= '0';
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_fifo_image_data1
-- Détail : Ecriture des données dans la fifo données image
---------------------------------------------------------------------------------------------------
   prc_fifo_image_data1 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_fifo_image_data_in(7 downto 0) <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if lecture_enable_i = '1' and num_chaine_driver_i = "00" then
            s_fifo_image_data_in(7 downto 0) <= lecture_donnees_i;
         else
            s_fifo_image_data_in(7 downto 0) <= s_fifo_image_data_in(7 downto 0);
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_fifo_image_data2
-- Détail : Ecriture des données dans la fifo données image
---------------------------------------------------------------------------------------------------
   prc_fifo_image_data2 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_fifo_image_data_in(15 downto 8) <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if lecture_enable_i = '1' and num_chaine_driver_i = "01" then
            s_fifo_image_data_in(15 downto 8) <= lecture_donnees_i;
         else
            s_fifo_image_data_in(15 downto 8) <= s_fifo_image_data_in(15 downto 8);
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_fifo_image_data3
-- Détail : Ecriture des données dans la fifo données image
---------------------------------------------------------------------------------------------------
   prc_fifo_image_data3 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_fifo_image_data_in(23 downto 16) <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if lecture_enable_i = '1' and num_chaine_driver_i = "10" then
            s_fifo_image_data_in(23 downto 16) <= lecture_donnees_i;
         else
            s_fifo_image_data_in(23 downto 16) <= s_fifo_image_data_in(23 downto 16);
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_fifo_image_data_latch
-- Détail : Ecriture des data_latch dans la fifo données image
---------------------------------------------------------------------------------------------------
   prc_fifo_image_data_latch : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_fifo_image_data_in(24) <= '0';
      elsif rising_edge(clk_aff_i) then
         
         if lecture_enable_i = '1' and num_chaine_driver_i = "10" and
            num_driver_i = CST_AFFICHAGE_ORDONNANCEUR_IDX_DERNIER_DRIVER then
            s_fifo_image_data_in(24) <= '1';
         else
            s_fifo_image_data_in(24) <= '0';
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_fifo_image_global_latch
-- Détail : Ecriture des global_latch dans la fifo données image
---------------------------------------------------------------------------------------------------
   prc_fifo_image_global_latch : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_fifo_image_data_in(25) <= '0';
      elsif rising_edge(clk_aff_i) then
         
         if lecture_enable_i = '1' and num_chaine_driver_i = "10" and
            num_driver_i = CST_AFFICHAGE_ORDONNANCEUR_IDX_DERNIER_DRIVER and
            num_sortie_driver_i = X"0" then
            s_fifo_image_data_in(25) <= '1';
         else
            s_fifo_image_data_in(25) <= '0';
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_etat_fifo
-- Détail : Machine d'état sm_etat_fifo
---------------------------------------------------------------------------------------------------
   prc_etat_fifo : process(sm_etat_fifo_present, s_fifo_image_almost_empty, s_fifo_image_empty)
   begin
      case sm_etat_fifo_present is
         when IDLE =>
            if s_fifo_image_almost_empty = '0' then
               sm_etat_fifo_futur <= LECTURE_IMAGE;
            else
               sm_etat_fifo_futur <= IDLE;
            end if;
            
         when LECTURE_IMAGE =>
            if s_fifo_image_empty = '1' then
               sm_etat_fifo_futur <= IDLE;
            else
               sm_etat_fifo_futur <= LECTURE_IMAGE;
            end if;
            
         when LECTURE_CONFIG =>
            sm_etat_fifo_futur <= IDLE;
            
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
         sm_etat_fifo_present <= IDLE;
      elsif rising_edge(clk_aff_i) then
         sm_etat_fifo_present <= sm_etat_fifo_futur;
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_fifo_image_read
-- Détail : Lecture de la FIFO image
---------------------------------------------------------------------------------------------------
   prc_fifo_image_read : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_fifo_image_read <= '0';
      elsif rising_edge(clk_aff_i) then
         
         if sm_etat_fifo_present = LECTURE_IMAGE and ser_end_i = '1' then
            s_fifo_image_read <= '1';
         else
            s_fifo_image_read <= '0';
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_ser_start
-- Détail : Demande de nouvelle transmission
---------------------------------------------------------------------------------------------------
   prc_ser_start : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         ser_start_o <= '0';
      elsif rising_edge(clk_aff_i) then
         
         if sm_etat_fifo_present = LECTURE_IMAGE and ser_end_i = '1' then
            ser_start_o <= '1';
         else
            ser_start_o <= '0';
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_ser_data_latch
-- Détail : Demande de latch des données
---------------------------------------------------------------------------------------------------
   prc_ser_data_latch : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         ser_data_latch_o <= '0';
      elsif rising_edge(clk_aff_i) then
         
         if sm_etat_fifo_present = LECTURE_IMAGE then
            ser_data_latch_o <= s_fifo_image_data_out(24);
         else
            ser_data_latch_o <= '0';
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_ser_global_latch
-- Détail : Demande de latch global
---------------------------------------------------------------------------------------------------
   prc_ser_global_latch : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         ser_global_latch_o <= '0';
      elsif rising_edge(clk_aff_i) then
         
         if sm_etat_fifo_present = LECTURE_IMAGE then
            ser_global_latch_o <= s_fifo_image_data_out(25);
         else
            ser_global_latch_o <= '0';
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_ser_write_config
-- Détail : Demande de latch d'écriture de configuration
---------------------------------------------------------------------------------------------------
   prc_ser_write_config : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         ser_write_config_o <= '0';
      elsif rising_edge(clk_aff_i) then
         ser_write_config_o <= '0';
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_ser_data
-- Détail : Données à sérialiser sur les chaines de drivers
---------------------------------------------------------------------------------------------------
   prc_ser_data : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         ser_data1_o <= (others => '0');
         ser_data2_o <= (others => '0');
         ser_data3_o <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if sm_etat_fifo_present = LECTURE_IMAGE then
            ser_data1_o <= X"0" & s_fifo_image_data_out( 7 downto  0) & X"0";
            ser_data2_o <= X"0" & s_fifo_image_data_out(15 downto  8) & X"0";
            ser_data3_o <= X"0" & s_fifo_image_data_out(23 downto 16) & X"0";
         else
            ser_data1_o <= (others => '0');
            ser_data2_o <= (others => '0');
            ser_data3_o <= (others => '0');
         end if;
         
      end if;
   end process;
   
   affichage_serialiseur_fifo_image_inst : affichage_serialiseur_fifo_image
   port map
   (
      clk         => clk_aff_i,
      din         => s_fifo_image_data_in,
      wr_en       => s_fifo_image_write,
      rd_en       => s_fifo_image_read,
      dout        => s_fifo_image_data_out,
      full        => open,
      empty       => s_fifo_image_empty,
      prog_full   => s_fifo_image_almost_full,
      prog_empty  => s_fifo_image_almost_empty
   );
   fifo_driver_empty_o  <= s_fifo_image_empty;
   fifo_driver_full_o   <= s_fifo_image_almost_full;
   
end architecture rtl_affichage_serialiseur_fifo;
