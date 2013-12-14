----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         affichage_serialiseur_serialiseur.vhd
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

entity affichage_serialiseur_serialiseur is
   port
   (
   -- Signaux globaux
      rst_aff_i         : in  std_logic;                       --! Signal de reset affichage
      clk_aff_i         : in  std_logic;                       --! Signal d'horloge affichage
      driver_dclk_i     : in  std_logic;                       --! Horloge de données du driver de LED (synchrone de clk_aff_i)
      
   -- Interface données parallèles
      start_i           : in  std_logic;                       --! Demande de nouvelle transmission
      data_latch_i      : in  std_logic;                       --! Demande de latch des données
      global_latch_i    : in  std_logic;                       --! Demande de latch global
      write_config_i    : in  std_logic;                       --! Demande de latch d'écriture de configuration
      data1_i           : in  std_logic_vector(15 downto 0);   --! Données à sérialiser sur la chaine de drivers n°1
      data2_i           : in  std_logic_vector(15 downto 0);   --! Données à sérialiser sur la chaine de drivers n°2
      data3_i           : in  std_logic_vector(15 downto 0);   --! Données à sérialiser sur la chaine de drivers n°3
      end_o             : out std_logic;                       --! Fin de transmission
      
   -- Interface drivers
      io_driver_dclk_o  : out std_logic;                       --! Horloge de données du driver de LED
      io_driver_latch_o : out std_logic;                       --! Latch du driver de LED
      io_driver_sdi1_o  : out std_logic;                       --! Donnée entrante du driver de LED n°1
      io_driver_sdi2_o  : out std_logic;                       --! Donnée entrante du driver de LED n°2
      io_driver_sdi3_o  : out std_logic                        --! Donnée entrante du driver de LED n°3
   );
end affichage_serialiseur_serialiseur;

-----------------------------------  Description du module  ---------------------------------------
--! Le module affichage_serialiseur_serialiseur sérialise sur les signaux io_driver_sdiX_o les données
--! présentes sur les entrées dataX_i dès que le signal start_i est actif. A cet instant, la valeur
--! des entrées de demande de latch est également examinée afin de générer le créneau correspondant
--! sur le signal io_driver_latch_o.
---------------------------------------------------------------------------------------------------

architecture rtl_affichage_serialiseur_serialiseur of affichage_serialiseur_serialiseur is
   
   signal s_driver_dclk_d           : std_logic;                     --! Signal driver_dclk_i retardé
   signal s_driver_dclk_fd          : std_logic;                     --! Front descendant du signal driver_dclk_i
   signal s_attente_synchro_start   : std_logic;                     --! Attente d'un front descendant de l'horloge driver_dclk_i pour synchroniser le démarrage
   signal s_compteur                : std_logic_vector( 3 downto 0); --! Compteur de bits
   signal s_latch_length            : std_logic_vector( 3 downto 0); --! Durée du latch sur cette transmission
   signal s_buffer1_new             : std_logic_vector(15 downto 0); --! Nouveaux contenu des regitre à décalage utilisé pour la sérialisation de la chaine n°1
   signal s_buffer2_new             : std_logic_vector(15 downto 0); --! Nouveaux contenu des regitre à décalage utilisé pour la sérialisation de la chaine n°2
   signal s_buffer3_new             : std_logic_vector(15 downto 0); --! Nouveaux contenu des regitre à décalage utilisé pour la sérialisation de la chaine n°3
   signal s_buffer1                 : std_logic_vector(15 downto 0); --! Regitre à décalage utilisé pour la sérialisation de la chaine n°1
   signal s_buffer2                 : std_logic_vector(15 downto 0); --! Regitre à décalage utilisé pour la sérialisation de la chaine n°2
   signal s_buffer3                 : std_logic_vector(15 downto 0); --! Regitre à décalage utilisé pour la sérialisation de la chaine n°3
   signal s_driver_latch            : std_logic;                     --! Latch du driver de LED
   
begin
   
---------------------------------------------------------------------------------------------------
-- Process : prc_attente_synchro_start
-- Détail : Attente d'un front descendant de l'horloge driver_dclk_i pour synchroniser le démarrage
---------------------------------------------------------------------------------------------------
   prc_attente_synchro_start : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_attente_synchro_start <= '0';
      elsif rising_edge(clk_aff_i) then
         
         if s_driver_dclk_fd = '1' then
            s_attente_synchro_start <= '0';
         elsif start_i = '1' then
            s_attente_synchro_start <= '1';
         else
            s_attente_synchro_start <= s_attente_synchro_start;
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_compteur
-- Détail : Compteur de bits envoyés
---------------------------------------------------------------------------------------------------
   prc_compteur : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_compteur  <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if s_driver_dclk_fd = '1' then
            if (start_i = '1' or s_attente_synchro_start = '1') then
               s_compteur <= (others => '1');
            else
               if s_compteur /= 0 then
                  s_compteur <= s_compteur - 1;
               else
                  s_compteur <= s_compteur;
               end if;
            end if;
         else
            s_compteur <= s_compteur;
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_buffers_new
-- Détail : Latch du nouveau contenu des registes à décalage
---------------------------------------------------------------------------------------------------
   prc_buffers_new : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_buffer1_new <= (others => '0');
         s_buffer2_new <= (others => '0');
         s_buffer3_new <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if start_i = '1' then
            s_buffer1_new <= data1_i;
            s_buffer2_new <= data2_i;
            s_buffer3_new <= data3_i;
         else
            s_buffer1_new <= s_buffer1_new;
            s_buffer2_new <= s_buffer2_new;
            s_buffer3_new <= s_buffer3_new;
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_buffers
-- Détail : Registres à décalage
---------------------------------------------------------------------------------------------------
   prc_buffers : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_buffer1 <= (others => '0');
         s_buffer2 <= (others => '0');
         s_buffer3 <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if s_driver_dclk_fd = '1' then
            if start_i = '1' then
               s_buffer1 <= data1_i;
               s_buffer2 <= data2_i;
               s_buffer3 <= data3_i;
            elsif s_attente_synchro_start = '1' then
               s_buffer1 <= s_buffer1_new;
               s_buffer2 <= s_buffer2_new;
               s_buffer3 <= s_buffer3_new;
            else
               s_buffer1 <= s_buffer1(14 downto 0) & '0';
               s_buffer2 <= s_buffer2(14 downto 0) & '0';
               s_buffer3 <= s_buffer3(14 downto 0) & '0';
            end if;
         else
            s_buffer1 <= s_buffer1;
            s_buffer2 <= s_buffer2;
            s_buffer3 <= s_buffer3;
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_latch_length
-- Détail : Durée du latch sur cette transmission
---------------------------------------------------------------------------------------------------
   prc_latch_length : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_latch_length <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if start_i = '1' then
            if global_latch_i = '1' then
               s_latch_length <= CST_AFFICHAGE_SERIALISEUR_GLOBAL_LATCH_LENGTH;
            elsif data_latch_i = '1' then
               s_latch_length <= CST_AFFICHAGE_SERIALISEUR_DATA_LATCH_LENGTH;
            elsif write_config_i = '1' then
               s_latch_length <= CST_AFFICHAGE_SERIALISEUR_WRITE_CONFIG_LATCH_LENGTH;
            else
               s_latch_length <= (others => '0');
            end if;
         elsif s_attente_synchro_start = '0' and s_compteur = 0 then
            s_latch_length <= (others => '0');
         else
            s_latch_length <= s_latch_length;
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_end
-- Détail : Indicateur de fin de transmission
---------------------------------------------------------------------------------------------------
   end_o <= '1' when s_compteur = 0 and s_attente_synchro_start = '0' and start_i = '0' else
            '0';
   
---------------------------------------------------------------------------------------------------
-- Process : prc_driver_dclk
-- Détail : Horloge de données du driver de LED
---------------------------------------------------------------------------------------------------
   prc_driver_dclk : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_driver_dclk_d   <= '0';
         io_driver_dclk_o  <= '0';
      elsif rising_edge(clk_aff_i) then
         
         s_driver_dclk_d  <= driver_dclk_i;
         io_driver_dclk_o <= s_driver_dclk_d;   -- Alignement sur les données
         
      end if;
   end process;
   s_driver_dclk_fd <= '1' when s_driver_dclk_d = '1' and driver_dclk_i = '0' else
                       '0';
   
---------------------------------------------------------------------------------------------------
-- Process : prc_driver_latch
-- Détail : Latch du driver de LED
---------------------------------------------------------------------------------------------------
   prc_driver_latch : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_driver_latch    <= '0';
         io_driver_latch_o <= '0';
      elsif rising_edge(clk_aff_i) then
         
         if s_driver_dclk_fd = '1' then
            if s_compteur = 0 then
               s_driver_latch <= '0';
            elsif s_compteur <= s_latch_length then
               s_driver_latch <= '1';
            else
               s_driver_latch <= '0';
            end if;
         else
            s_driver_latch <= s_driver_latch;
         end if;
         
         io_driver_latch_o <= s_driver_latch;   -- Alignement sur les données
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_driver_sdi
-- Détail : Données entrantes des drivers de LED
---------------------------------------------------------------------------------------------------
   prc_driver_sdi : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         io_driver_sdi1_o <= '0';
         io_driver_sdi2_o <= '0';
         io_driver_sdi3_o <= '0';
      elsif rising_edge(clk_aff_i) then
         io_driver_sdi1_o <= s_buffer1(15);
         io_driver_sdi2_o <= s_buffer2(15);
         io_driver_sdi3_o <= s_buffer3(15);
      end if;
   end process;
   
end architecture rtl_affichage_serialiseur_serialiseur;
