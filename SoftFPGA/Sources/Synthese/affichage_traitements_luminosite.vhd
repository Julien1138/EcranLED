----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         affichage_traitements_luminosite.vhd
--              . 
-- Type           Synth�tisable
--              . 
--! @author       J. AUPART
--              . 
--! @version      1.0
--              . 
--! @date         14/11/2013
--              . 
----------------|-------------------------------------------------------------
-- Description  : Traitement de luminosite sur l'image
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

library work;
use work.pkg_driver.all;

entity affichage_traitements_luminosite is
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
end affichage_traitements_luminosite;

-----------------------------------  Description du module  ---------------------------------------
--! Traitement de luminosite sur l'image
---------------------------------------------------------------------------------------------------

architecture rtl_affichage_traitements_luminosite of affichage_traitements_luminosite is
   
   signal s_mult_result : std_logic_vector(23 downto 0); --! R�sultat de la multiplication
   
begin
   
---------------------------------------------------------------------------------------------------
-- Process : prc_luminosite
-- D�tail : Traitement de luminosit�
---------------------------------------------------------------------------------------------------
   prc_luminosite : process(rst_opt_i, clk_opt_i)
   begin
      if rst_opt_i = '1' then
         lecture_enable_o     <= '0';
         lecture_donnees_o    <= (others => '0');
         num_chaine_driver_o  <= (others => '0');
         num_driver_o         <= (others => '0');
         num_sortie_driver_o  <= (others => '0');
         couleur_pixel_o      <= (others => '0');
      elsif rising_edge(clk_opt_i) then
         lecture_enable_o     <= lecture_enable_i;
         lecture_donnees_o    <= s_mult_result(23 downto 8);
         num_chaine_driver_o  <= num_chaine_driver_i;
         num_driver_o         <= num_driver_i;
         num_sortie_driver_o  <= num_sortie_driver_i;
         couleur_pixel_o      <= couleur_pixel_i;
      end if;
   end process;
   
   affichage_traitements_luminosite_mult_inst : affichage_traitements_luminosite_mult
   port map
   (
      a  => luminosite_i,
      b  => lecture_donnees_i,
      p  => s_mult_result
   );
   
end architecture rtl_affichage_traitements_luminosite;
