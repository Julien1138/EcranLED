----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         spi_receiver.vhd
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
-- Description  : Interprétation des données SPI reçues
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

entity spi_receiver is
   port
   (
   -- Signaux globaux
      rst_aff_i      : in  std_logic;                       --! Signal de reset affichage
      clk_aff_i      : in  std_logic;                       --! Signal d'horloge affichage
      
      io_sck_i       : in std_logic;         --! SPI SCK signal
      io_ss_i        : in std_logic;         --! SPI SS signal
      io_mosi_i      : in std_logic;         --! SPI MOSI signal
      
      nouv_donnee_o  : out std_logic;        --! Burst when new data avaliable
      donnee_o       : out std_logic_vector(7 downto 0)  --! Deserialized data
   );
end spi_receiver;

-----------------------------------  Description du module  ---------------------------------------
--! 
---------------------------------------------------------------------------------------------------

architecture rtl_spi_receiver of spi_receiver is
   
   signal s_sck_d          : std_logic;
   signal s_ss_d           : std_logic;
   signal s_mosi_d         : std_logic;
   signal s_sck_fm         : std_logic;
   signal s_sck_fd         : std_logic;
   signal s_compteur_bits  : std_logic_vector(2 downto 0);
   signal s_data           : std_logic_vector(7 downto 0);
   
begin
   
---------------------------------------------------------------------------------------------------
-- Process : prc_retard
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_retard : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_sck_d  <= '0';
         s_ss_d   <= '1';
         s_mosi_d <= '0';
      elsif rising_edge(clk_aff_i) then
         s_sck_d  <= io_sck_i;
         s_ss_d   <= io_ss_i;
         s_mosi_d <= io_mosi_i;
      end if;
   end process;
   s_sck_fm <= '1' when io_sck_i = '1' and s_sck_d = '0' else  -- Front montant
               '0';
   s_sck_fd <= '1' when io_sck_i = '0' and s_sck_d = '1' else  -- Front descendant
               '0';
   
---------------------------------------------------------------------------------------------------
-- Process : prc_compteur_bits
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_compteur_bits : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_compteur_bits <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if io_ss_i = '1' then
            s_compteur_bits <= (others => '0');
         elsif s_sck_fm = '1' then
            s_compteur_bits <= s_compteur_bits + 1;
         else
            s_compteur_bits <= s_compteur_bits;
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_data
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_data : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_data <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if s_sck_fm = '1' then
            s_data <= s_data(6 downto 0) & s_mosi_d;
         else
            s_data <= s_data;
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_nouv_donnee
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_nouv_donnee : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         nouv_donnee_o <= '0';
         donnee_o <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if s_sck_fd = '1' and s_compteur_bits = 0 then
            nouv_donnee_o <= '1';
            donnee_o <= s_data;
         else
            nouv_donnee_o <= '0';
         end if;
         
      end if;
   end process;
   
end architecture rtl_spi_receiver;
