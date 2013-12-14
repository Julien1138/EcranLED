----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         memoire_image.vhd
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
-- Description  : Double m�moire de stockage de l'image
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

entity memoire_image is
   port
   (
   -- Signaux globaux
      rst_aff_i            : in  std_logic;                       --! Signal de reset vid�o
      clk_aff_i            : in  std_logic;                       --! Signal d'horloge vid�o
      
   -- Interface d'�criture de l'image
      ecriture_en_i        : in  std_logic;                       --! Write enable de la m�moire image
      ecriture_adresse_i   : in  std_logic_vector(12 downto 0);   --! Adresse d'�criture des donn�es image
      ecriture_donnees_i   : in  std_logic_vector( 7 downto 0);   --! Donn�es image
      
   -- Interface de lecture
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
end memoire_image;

-----------------------------------  Description du module  ---------------------------------------
--! Double m�moire de stockage de l'image
---------------------------------------------------------------------------------------------------

architecture rtl_memoire_image of memoire_image is
   
   signal s_ecriture_en       : std_logic_vector(0 downto 0); --! Write enable de la m�moire image
      
   signal s_lecture_enable    : std_logic;                     --! Enable lecture pixel
   signal s_lecture_adresse   : std_logic_vector(12 downto 0); --! Adresse de lecture des donn�es image
   signal s_num_chaine_driver : std_logic_vector( 1 downto 0); --! Num�ro de la chaine de driver
   signal s_num_driver        : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_num_sortie_driver : std_logic_vector( 3 downto 0); --! Num�ro de la sortie du driver concern�
   signal s_couleur_pixel     : std_logic_vector( 1 downto 0); --! Couleur du pixel
   
begin
   
   memoire_image_memoire_inst : memoire_image_memoire
   port map
   (
      clka  => clk_aff_i,
      wea   => s_ecriture_en,
      addra => ecriture_adresse_i,
      dina  => ecriture_donnees_i,
      douta => open,
      clkb  => clk_aff_i,
      web   => "0",
      addrb => s_lecture_adresse,
      dinb  => X"00",
      doutb => lecture_donnees_o
   );
   s_ecriture_en(0) <= ecriture_en_i;
   
   memoire_image_adressage_inst : memoire_image_adressage
   port map
   (
   -- Signaux globaux
      rst_aff_i            => rst_aff_i,
      clk_aff_i            => clk_aff_i,
      
   -- Position pixel
      lecture_enable_i     => lecture_enable_i,
      num_chaine_driver_i  => num_chaine_driver_i,
      num_driver_i         => num_driver_i,
      num_sortie_driver_i  => num_sortie_driver_i,
      
   -- Infos pixel de sortie
      num_chaine_driver_o  => s_num_chaine_driver,
      num_driver_o         => s_num_driver,
      num_sortie_driver_o  => s_num_sortie_driver,
      couleur_pixel_o      => s_couleur_pixel,
      
   -- Interface m�moire image
      lecture_enable_o     => s_lecture_enable,
      adresse_o            => s_lecture_adresse
   );
   
---------------------------------------------------------------------------------------------------
-- Process : prc_alignement
-- D�tail : Alignement des donn�es image lues
---------------------------------------------------------------------------------------------------
   prc_alignement : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         lecture_enable_o     <= '0';
         num_chaine_driver_o  <= (others => '0');
         num_driver_o         <= (others => '0');
         num_sortie_driver_o  <= (others => '0');
         couleur_pixel_o      <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         lecture_enable_o     <= s_lecture_enable;
         num_chaine_driver_o  <= s_num_chaine_driver;
         num_driver_o         <= s_num_driver;
         num_sortie_driver_o  <= s_num_sortie_driver;
         couleur_pixel_o      <= s_couleur_pixel;
         
      end if;
   end process;
   
   
end architecture rtl_memoire_image;
