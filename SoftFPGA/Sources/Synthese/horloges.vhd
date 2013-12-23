----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         horloges.vhd
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
-- Description  : Génération des signaux d'horloge et de reset utilisés dans
--                le design.
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

entity horloges is
   port
   (
   -- Signaux externes
      io_clk_i       : in  std_logic;  --! Horloge externe (50 MHz)
      
   -- Domaine d'horloge affichage
      rst_aff_o      : out std_logic;  --! Signal de reset affichage
      clk_aff_o      : out std_logic;  --! Signal d'horloge affichage
      driver_dclk_o  : out std_logic;  --! Horloge de données du driver de LED (synchrone de clk_aff_i)
      driver_gclk_o  : out std_logic   --! Horloge de PWM du driver de LED (synchrone de clk_aff_i)
   );
end horloges;

-----------------------------------  Description du module  ---------------------------------------
--! Génération des signaux d'horloge et de reset utilisés dans le design.
---------------------------------------------------------------------------------------------------

architecture rtl_horloges of horloges is
   
   signal s_rst_count            : std_logic_vector(7 downto 0) := X"FF";                          --! Compteur pour le reset
   signal s_rst_async            : std_logic := '1';                                               --! Reset asynchrone
   
   signal s_rst_aff_int          : std_logic;                                                      --! Reset synchrone du domaine d'horloge affichage (signal intermédiaire)
   signal s_rst_aff              : std_logic;                                                      --! Reset synchrone du domaine d'horloge affichage
   
   signal s_driver_dclk          : std_logic;                                                      --! Horloge de données du driver de LED (synchrone de clk_aff_i)
   signal s_driver_dclk_compteur : std_logic_vector(CST_HORLOGES_DEMI_PERIODE_DCLK_DRIVER'range);  --! Compteur pour la création de l'horloge s_driver_dclk
   signal s_driver_gclk          : std_logic;                                                      --! Horloge de PWM du driver de LED (synchrone de clk_aff_i)
   signal s_driver_gclk_compteur : std_logic_vector(CST_HORLOGES_DEMI_PERIODE_GCLK_DRIVER'range);  --! Compteur pour la création de l'horloge s_driver_gclk
   
begin
   
---------------------------------------------------------------------------------------------------
-- Process : prc_reset
-- Détail : Création d'un reset interne
---------------------------------------------------------------------------------------------------
   prc_reset : process(io_clk_i)
   begin
      if rising_edge(io_clk_i) then
      
         if s_rst_count /= 0 then
            s_rst_count <= s_rst_count - 1;
            s_rst_async <= '1';
         else
            s_rst_count <= s_rst_count;
            s_rst_async <= '0';
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_synchro_reset_affichage
-- Détail : Synchronisation du reset du domaine d'horloge affichage
---------------------------------------------------------------------------------------------------
   prc_synchro_reset_affichage : process(s_rst_async, io_clk_i)
   begin
      if s_rst_async = '1' then
         s_rst_aff_int  <= '1';
         s_rst_aff      <= '1';
      elsif rising_edge(io_clk_i) then
         s_rst_aff_int  <= '0';
         s_rst_aff      <= s_rst_aff_int;
      end if;
   end process;
   
   rst_aff_o <= s_rst_aff;
   clk_aff_o <= io_clk_i;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_driver_dclk
-- Détail : Horloge de données du driver de LED
---------------------------------------------------------------------------------------------------
   prc_driver_dclk : process(s_rst_aff, io_clk_i)
   begin
      if s_rst_aff = '1' then
         s_driver_dclk           <= '0';
         s_driver_dclk_compteur  <= (others => '0');
      elsif rising_edge(io_clk_i) then
         
         if s_driver_dclk_compteur = CST_HORLOGES_DEMI_PERIODE_DCLK_DRIVER-1 then
            s_driver_dclk           <= not s_driver_dclk;
            s_driver_dclk_compteur  <= (others => '0');
         else
            s_driver_dclk           <= s_driver_dclk;
            s_driver_dclk_compteur  <= s_driver_dclk_compteur + 1;
         end if;
         
      end if;
   end process;
   driver_dclk_o <= s_driver_dclk;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_driver_gclk
-- Détail : Horloge de PWM du driver de LED
---------------------------------------------------------------------------------------------------
   prc_driver_gclk : process(s_rst_aff, io_clk_i)
   begin
      if s_rst_aff = '1' then
         s_driver_gclk           <= '0';
         s_driver_gclk_compteur  <= (others => '0');
      elsif rising_edge(io_clk_i) then
         
         if s_driver_gclk_compteur = CST_HORLOGES_DEMI_PERIODE_GCLK_DRIVER-1 then
            s_driver_gclk           <= not s_driver_gclk;
            s_driver_gclk_compteur  <= (others => '0');
         else
            s_driver_gclk           <= s_driver_gclk;
            s_driver_gclk_compteur  <= s_driver_gclk_compteur + 1;
         end if;
         
      end if;
   end process;
   driver_gclk_o <= s_driver_gclk;
   
end architecture rtl_horloges;
