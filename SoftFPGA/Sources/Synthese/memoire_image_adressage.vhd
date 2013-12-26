----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         memoire_image_adressage.vhd
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
-- Description  : Conversion d'adresse des pixels
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

entity memoire_image_adressage is
   port
   (
   -- Signaux globaux
      rst_aff_i            : in  std_logic;                       --! Signal de reset affichage
      clk_aff_i            : in  std_logic;                       --! Signal d'horloge affichage
      
   -- Position pixel
      lecture_enable_i     : in  std_logic;                       --! Enable lecture pixel
      num_chaine_driver_i  : in  std_logic_vector( 1 downto 0);   --! Numéro de la chaine de driver
      num_driver_i         : in  std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
      num_sortie_driver_i  : in  std_logic_vector( 3 downto 0);   --! Numéro de la sortie du driver concerné
      
   -- Infos pixel de sortie
      num_chaine_driver_o  : out std_logic_vector( 1 downto 0);   --! Numéro de la chaine de driver
      num_driver_o         : out std_logic_vector( 7 downto 0);   --! Position du driver dans la chaine
      num_sortie_driver_o  : out std_logic_vector( 3 downto 0);   --! Numéro de la sortie du driver concerné
      couleur_pixel_o      : out std_logic_vector( 1 downto 0);   --! Couleur du pixel
      
   -- Interface mémoire image
      lecture_enable_o     : out std_logic;                       --! Enable lecture pixel
      adresse_o            : out std_logic_vector(12 downto 0)    --! Adresse d'écriture des données image
   );
end memoire_image_adressage;

-----------------------------------  Description du module  ---------------------------------------
--! Ce module est différent pour chaque configuration de mobilier.
---------------------------------------------------------------------------------------------------

architecture rtl_memoire_image_adressage of memoire_image_adressage is
   
   signal s_num_driver_mod21_int    : std_logic_vector( 7 downto 0); --! 
   signal s_num_driver_mod21        : std_logic_vector( 4 downto 0); --! 
   signal s_num_driver_mod3_int     : std_logic_vector( 4 downto 0); --! 
   signal s_num_driver_mod3         : std_logic_vector( 1 downto 0); --! 
   signal s_driver_chaine_monte_int : std_logic;                     --! Partie montante de la chaine de driver n°1
   signal s_driver_chaine_monte     : std_logic;                     --! Partie montante de la chaine de driver
   
   signal s_groupe_ligne_montant    : std_logic_vector( 2 downto 0); --! Groupe de 8 lignes auquel appartient le driver d'une colonne montant
   signal s_groupe_ligne_descendant : std_logic_vector( 2 downto 0); --! Groupe de 8 lignes auquel appartient le driver d'une colonne descendante
   signal s_groupe_ligne            : std_logic_vector( 2 downto 0); --! Groupe de 8 lignes auquel appartient le driver
   signal s_ligne_int               : std_logic_vector( 2 downto 0); --! Numéro de la ligne dans le groupe de 8
   
   signal s_colonne_int             : std_logic;                     --! 
   signal s_groupe_colonne          : std_logic_vector( 4 downto 0); --! 
   
   signal s_rouge                   : std_logic;                     --! Pixel de couleur rouge
   signal s_vert                    : std_logic;                     --! Pixel de couleur verte
   signal s_bleu                    : std_logic;                     --! Pixel de couleur bleue
   signal s_ligne                   : std_logic_vector( 5 downto 0); --! Position ligne du pixel
   signal s_colonne                 : std_logic_vector( 5 downto 0); --! Position colonne du pixel
   
   signal s_lecture_enable_d        : std_logic;                     --! Enable lecture pixel
   signal s_num_chaine_driver_d     : std_logic_vector( 1 downto 0); --! Numéro de la chaine de driver
   signal s_num_driver_d            : std_logic_vector( 7 downto 0); --! Position du driver dans la chaine
   signal s_num_sortie_driver_d     : std_logic_vector( 3 downto 0); --! Numéro de la sortie du driver concerné
   
begin
   
   s_num_driver_mod21_int <= num_driver_i       when num_driver_i <  21 else
                             num_driver_i -  21 when num_driver_i <  42 else
                             num_driver_i -  42 when num_driver_i <  63 else
                             num_driver_i -  63 when num_driver_i <  84 else
                             num_driver_i -  84 when num_driver_i < 105 else
                             num_driver_i - 105;
   s_num_driver_mod21 <= s_num_driver_mod21_int(s_num_driver_mod21'range);
   
   s_num_driver_mod3_int <= s_num_driver_mod21      when s_num_driver_mod21 <  3 else
                            s_num_driver_mod21 -  3 when s_num_driver_mod21 <  6 else
                            s_num_driver_mod21 -  6 when s_num_driver_mod21 <  9 else
                            s_num_driver_mod21 -  9 when s_num_driver_mod21 < 12 else
                            s_num_driver_mod21 - 12 when s_num_driver_mod21 < 15 else
                            s_num_driver_mod21 - 15 when s_num_driver_mod21 < 18 else
                            s_num_driver_mod21 - 18;
   s_num_driver_mod3 <= s_num_driver_mod3_int(s_num_driver_mod3'range);
   
   s_driver_chaine_monte <= '0' when num_driver_i <  21 else
                                '1' when num_driver_i <  42 else
                                '0' when num_driver_i <  63 else
                                '1' when num_driver_i <  84 else
                                '0' when num_driver_i < 105 else
                                '1';
   
   --s_driver_chaine_monte <= s_driver_chaine_monte_int      when num_chaine_driver_i = "00" else
                            --not s_driver_chaine_monte_int;
   
   s_groupe_ligne_descendant <= "000" when s_num_driver_mod21 <  3 else
                                "001" when s_num_driver_mod21 <  6 else
                                "010" when s_num_driver_mod21 <  9 else
                                "011" when s_num_driver_mod21 < 12 else
                                "100" when s_num_driver_mod21 < 15 else
                                "101" when s_num_driver_mod21 < 18 else
                                "110";
   
   s_groupe_ligne_montant <= "110" when s_num_driver_mod21 <  3 else
                             "101" when s_num_driver_mod21 <  6 else
                             "100" when s_num_driver_mod21 <  9 else
                             "011" when s_num_driver_mod21 < 12 else
                             "010" when s_num_driver_mod21 < 15 else
                             "001" when s_num_driver_mod21 < 18 else
                             "000";
   

---------------------------------------------------------------------------------------------------
-- Process : prc_ligne
-- Détail : Calcul de la ligne
---------------------------------------------------------------------------------------------------
   prc_ligne : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_ligne_int    <= (others => '0');
         s_groupe_ligne <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if s_driver_chaine_monte = '1' then
            case s_num_driver_mod3 is
               when "00" =>
                  if num_sortie_driver_i > 9 then
                     s_ligne_int <= conv_std_logic_vector(7, 3);
                  elsif num_sortie_driver_i > 3 then
                     s_ligne_int <= conv_std_logic_vector(6, 3);
                  else
                     s_ligne_int <= conv_std_logic_vector(5, 3);
                  end if;
                  
               when "01" =>
                  if num_sortie_driver_i > 13 then
                     s_ligne_int <= conv_std_logic_vector(5, 3);
                  elsif num_sortie_driver_i > 7 then
                     s_ligne_int <= conv_std_logic_vector(4, 3);
                  elsif num_sortie_driver_i > 1 then
                     s_ligne_int <= conv_std_logic_vector(3, 3);
                  else
                     s_ligne_int <= conv_std_logic_vector(2, 3);
                  end if;
                  
               when "10" =>
                  if num_sortie_driver_i > 11 then
                     s_ligne_int <= conv_std_logic_vector(2, 3);
                  elsif num_sortie_driver_i > 5 then
                     s_ligne_int <= conv_std_logic_vector(1, 3);
                  else
                     s_ligne_int <= conv_std_logic_vector(0, 3);
                  end if;
                  
               when others =>
                  s_ligne_int <= (others => '0');
            end case;
         else
            case s_num_driver_mod3 is
               when "00" =>
                  if num_sortie_driver_i > 9 then
                     s_ligne_int <= conv_std_logic_vector(0, 3);
                  elsif num_sortie_driver_i > 3 then
                     s_ligne_int <= conv_std_logic_vector(1, 3);
                  else
                     s_ligne_int <= conv_std_logic_vector(2, 3);
                  end if;
                  
               when "01" =>
                  if num_sortie_driver_i > 13 then
                     s_ligne_int <= conv_std_logic_vector(2, 3);
                  elsif num_sortie_driver_i > 7 then
                     s_ligne_int <= conv_std_logic_vector(3, 3);
                  elsif num_sortie_driver_i > 1 then
                     s_ligne_int <= conv_std_logic_vector(4, 3);
                  else
                     s_ligne_int <= conv_std_logic_vector(5, 3);
                  end if;
                  
               when "10" =>
                  if num_sortie_driver_i > 11 then
                     s_ligne_int <= conv_std_logic_vector(5, 3);
                  elsif num_sortie_driver_i > 5 then
                     s_ligne_int <= conv_std_logic_vector(6, 3);
                  else
                     s_ligne_int <= conv_std_logic_vector(7, 3);
                  end if;
                  
               when others =>
                  s_ligne_int <= (others => '0');
            end case;
         end if;
         
         if s_driver_chaine_monte = '1' then
            s_groupe_ligne <= s_groupe_ligne_montant;
         else
            s_groupe_ligne <= s_groupe_ligne_descendant;
         end if;
         
      end if;
   end process;
   s_ligne <= s_groupe_ligne & s_ligne_int;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_colonne
-- Détail : Calcul de la colonne
---------------------------------------------------------------------------------------------------
   prc_colonne : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_colonne_int     <= '0';
         s_groupe_colonne  <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if s_driver_chaine_monte = '1' then
            case s_num_driver_mod3 is
               when "00" =>
                  if num_sortie_driver_i > 12 then
                     s_colonne_int <= '0';
                  elsif num_sortie_driver_i > 9 then
                     s_colonne_int <= '1';
                  elsif num_sortie_driver_i > 6 then
                     s_colonne_int <= '0';
                  elsif num_sortie_driver_i > 3 then
                     s_colonne_int <= '1';
                  elsif num_sortie_driver_i > 0 then
                     s_colonne_int <= '0';
                  else
                     s_colonne_int <= '1';
                  end if;
                  
               when "01" =>
                  if num_sortie_driver_i > 13 then
                     s_colonne_int <= '1';
                  elsif num_sortie_driver_i > 10 then
                     s_colonne_int <= '0';
                  elsif num_sortie_driver_i > 7 then
                     s_colonne_int <= '1';
                  elsif num_sortie_driver_i > 4 then
                     s_colonne_int <= '0';
                  elsif num_sortie_driver_i > 1 then
                     s_colonne_int <= '1';
                  else
                     s_colonne_int <= '0';
                  end if;
                  
               when "10" =>
                  if num_sortie_driver_i > 14 then
                     s_colonne_int <= '0';
                  elsif num_sortie_driver_i > 11 then
                     s_colonne_int <= '1';
                  elsif num_sortie_driver_i > 8 then
                     s_colonne_int <= '0';
                  elsif num_sortie_driver_i > 5 then
                     s_colonne_int <= '1';
                  elsif num_sortie_driver_i > 2 then
                     s_colonne_int <= '0';
                  else
                     s_colonne_int <= '1';
                  end if;
                  
               when others =>
                  s_colonne_int <= '0';
            end case;
         else
            case s_num_driver_mod3 is
               when "00" =>
                  if num_sortie_driver_i > 12 then
                     s_colonne_int <= '1';
                  elsif num_sortie_driver_i > 9 then
                     s_colonne_int <= '0';
                  elsif num_sortie_driver_i > 6 then
                     s_colonne_int <= '1';
                  elsif num_sortie_driver_i > 3 then
                     s_colonne_int <= '0';
                  elsif num_sortie_driver_i > 0 then
                     s_colonne_int <= '1';
                  else
                     s_colonne_int <= '0';
                  end if;
                  
               when "01" =>
                  if num_sortie_driver_i > 13 then
                     s_colonne_int <= '0';
                  elsif num_sortie_driver_i > 10 then
                     s_colonne_int <= '1';
                  elsif num_sortie_driver_i > 7 then
                     s_colonne_int <= '0';
                  elsif num_sortie_driver_i > 4 then
                     s_colonne_int <= '1';
                  elsif num_sortie_driver_i > 1 then
                     s_colonne_int <= '0';
                  else
                     s_colonne_int <= '1';
                  end if;
                  
               when "10" =>
                  if num_sortie_driver_i > 14 then
                     s_colonne_int <= '1';
                  elsif num_sortie_driver_i > 11 then
                     s_colonne_int <= '0';
                  elsif num_sortie_driver_i > 8 then
                     s_colonne_int <= '1';
                  elsif num_sortie_driver_i > 5 then
                     s_colonne_int <= '0';
                  elsif num_sortie_driver_i > 2 then
                     s_colonne_int <= '1';
                  else
                     s_colonne_int <= '0';
                  end if;
                  
               when others =>
                  s_colonne_int <= '0';
            end case;
         end if;
         
         if num_chaine_driver_i = "00" then
            if num_driver_i < 21 then
               s_groupe_colonne  <= conv_std_logic_vector(0, 5);
            elsif num_driver_i < 42 then
               s_groupe_colonne  <= conv_std_logic_vector(1, 5);
            elsif num_driver_i < 63 then
               s_groupe_colonne  <= conv_std_logic_vector(2, 5);
            elsif num_driver_i < 84 then
               s_groupe_colonne  <= conv_std_logic_vector(3, 5);
            elsif num_driver_i < 105 then
               s_groupe_colonne  <= conv_std_logic_vector(4, 5);
            else
               s_groupe_colonne  <= conv_std_logic_vector(5, 5);
            end if;
         elsif num_chaine_driver_i = "01" then
            if num_driver_i < 42 then
               s_groupe_colonne  <= conv_std_logic_vector(6, 5);
            elsif num_driver_i < 63 then
               s_groupe_colonne  <= conv_std_logic_vector(7, 5);
            elsif num_driver_i < 84 then
               s_groupe_colonne  <= conv_std_logic_vector(8, 5);
            elsif num_driver_i < 105 then
               s_groupe_colonne  <= conv_std_logic_vector(9, 5);
            else
               s_groupe_colonne  <= conv_std_logic_vector(10, 5);
            end if;
         elsif num_chaine_driver_i = "10" then
            if num_driver_i < 42 then
               s_groupe_colonne  <= conv_std_logic_vector(11, 5);
            elsif num_driver_i < 63 then
               s_groupe_colonne  <= conv_std_logic_vector(12, 5);
            elsif num_driver_i < 84 then
               s_groupe_colonne  <= conv_std_logic_vector(13, 5);
            elsif num_driver_i < 105 then
               s_groupe_colonne  <= conv_std_logic_vector(14, 5);
            else
               s_groupe_colonne  <= conv_std_logic_vector(15, 5);
            end if;
         end if;
         
      end if;
   end process;
   s_colonne <= s_groupe_colonne & s_colonne_int;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_rouge
-- Détail : Couleur rouge
---------------------------------------------------------------------------------------------------
   prc_rouge : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_rouge <= '0';
      elsif rising_edge(clk_aff_i) then
         
         if num_driver_i > 125 then
            s_rouge <= '0';
         else
            if s_driver_chaine_monte = '1' then
               case s_num_driver_mod3 is
                  when "00" =>
                     if num_sortie_driver_i =  1 or
                        num_sortie_driver_i =  4 or
                        num_sortie_driver_i =  7 or
                        num_sortie_driver_i = 10 or
                        num_sortie_driver_i = 13 then
                        s_rouge <= '1';
                     else
                        s_rouge <= '0';
                     end if;
                     
                  when "01" =>
                     if num_sortie_driver_i =  2 or
                        num_sortie_driver_i =  5 or
                        num_sortie_driver_i =  8 or
                        num_sortie_driver_i = 11 or
                        num_sortie_driver_i = 14 then
                        s_rouge <= '1';
                     else
                        s_rouge <= '0';
                     end if;
                     
                  when "10" =>
                     if num_sortie_driver_i =  0 or
                        num_sortie_driver_i =  3 or
                        num_sortie_driver_i =  6 or
                        num_sortie_driver_i =  9 or
                        num_sortie_driver_i = 12 or
                        num_sortie_driver_i = 15 then
                        s_rouge <= '1';
                     else
                        s_rouge <= '0';
                     end if;
                  
                  when others =>
                     s_rouge <= '0';
               end case;
            else
               case s_num_driver_mod3 is
                  when "00" =>
                     if num_sortie_driver_i =  0 or
                        num_sortie_driver_i =  3 or
                        num_sortie_driver_i =  6 or
                        num_sortie_driver_i =  9 or
                        num_sortie_driver_i = 12 or
                        num_sortie_driver_i = 15 then
                        s_rouge <= '1';
                     else
                        s_rouge <= '0';
                     end if;
                     
                  when "01" =>
                     if num_sortie_driver_i =  1 or
                        num_sortie_driver_i =  4 or
                        num_sortie_driver_i =  7 or
                        num_sortie_driver_i = 10 or
                        num_sortie_driver_i = 13 then
                        s_rouge <= '1';
                     else
                        s_rouge <= '0';
                     end if;
                     
                  when "10" =>
                     if num_sortie_driver_i =  2 or
                        num_sortie_driver_i =  5 or
                        num_sortie_driver_i =  8 or
                        num_sortie_driver_i = 11 or
                        num_sortie_driver_i = 14 then
                        s_rouge <= '1';
                     else
                        s_rouge <= '0';
                     end if;
                  
                  when others =>
                     s_rouge <= '0';
               end case;
            end if;
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_vert
-- Détail : Couleur verte
---------------------------------------------------------------------------------------------------
   prc_vert : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_vert <= '0';
      elsif rising_edge(clk_aff_i) then
         
         if num_driver_i > 125 then
            s_vert <= '0';
         else
            if s_driver_chaine_monte = '1' then
               case s_num_driver_mod3 is
                  when "00" =>
                     if num_sortie_driver_i =  2 or
                        num_sortie_driver_i =  5 or
                        num_sortie_driver_i =  8 or
                        num_sortie_driver_i = 11 or
                        num_sortie_driver_i = 14 then
                        s_vert <= '1';
                     else
                        s_vert <= '0';
                     end if;
                     
                  when "01" =>
                     if num_sortie_driver_i =  0 or
                        num_sortie_driver_i =  3 or
                        num_sortie_driver_i =  6 or
                        num_sortie_driver_i =  9 or
                        num_sortie_driver_i = 12 or
                        num_sortie_driver_i = 15 then
                        s_vert <= '1';
                     else
                        s_vert <= '0';
                     end if;
                     
                  when "10" =>
                     if num_sortie_driver_i =  1 or
                        num_sortie_driver_i =  4 or
                        num_sortie_driver_i =  7 or
                        num_sortie_driver_i = 10 or
                        num_sortie_driver_i = 13 then
                        s_vert <= '1';
                     else
                        s_vert <= '0';
                     end if;
                  
                  when others =>
                     s_vert <= '0';
               end case;
            else
               case s_num_driver_mod3 is
                  when "00" =>
                     if num_sortie_driver_i =  2 or
                        num_sortie_driver_i =  5 or
                        num_sortie_driver_i =  8 or
                        num_sortie_driver_i = 11 or
                        num_sortie_driver_i = 14 then
                        s_vert <= '1';
                     else
                        s_vert <= '0';
                     end if;
                     
                  when "01" =>
                     if num_sortie_driver_i =  0 or
                        num_sortie_driver_i =  3 or
                        num_sortie_driver_i =  6 or
                        num_sortie_driver_i =  9 or
                        num_sortie_driver_i = 12 or
                        num_sortie_driver_i = 15 then
                        s_vert <= '1';
                     else
                        s_vert <= '0';
                     end if;
                     
                  when "10" =>
                     if num_sortie_driver_i =  1 or
                        num_sortie_driver_i =  4 or
                        num_sortie_driver_i =  7 or
                        num_sortie_driver_i = 10 or
                        num_sortie_driver_i = 13 then
                        s_vert <= '1';
                     else
                        s_vert <= '0';
                     end if;
                  
                  when others =>
                     s_vert <= '0';
               end case;
            end if;
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_bleu
-- Détail : Couleur bleue
---------------------------------------------------------------------------------------------------
   prc_bleu : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_bleu <= '0';
      elsif rising_edge(clk_aff_i) then
         
         if num_driver_i > 125 then
            s_bleu <= '0';
         else
            if s_driver_chaine_monte = '1' then
               case s_num_driver_mod3 is
                  when "00" =>
                     if num_sortie_driver_i =  0 or
                        num_sortie_driver_i =  3 or
                        num_sortie_driver_i =  6 or
                        num_sortie_driver_i =  9 or
                        num_sortie_driver_i = 12 or
                        num_sortie_driver_i = 15 then
                        s_bleu <= '1';
                     else
                        s_bleu <= '0';
                     end if;
                     
                  when "01" =>
                     if num_sortie_driver_i =  1 or
                        num_sortie_driver_i =  4 or
                        num_sortie_driver_i =  7 or
                        num_sortie_driver_i = 10 or
                        num_sortie_driver_i = 13 then
                        s_bleu <= '1';
                     else
                        s_bleu <= '0';
                     end if;
                     
                  when "10" =>
                     if num_sortie_driver_i =  2 or
                        num_sortie_driver_i =  5 or
                        num_sortie_driver_i =  8 or
                        num_sortie_driver_i = 11 or
                        num_sortie_driver_i = 14 then
                        s_bleu <= '1';
                     else
                        s_bleu <= '0';
                     end if;
                  
                  when others =>
                     s_bleu <= '0';
               end case;
            else
               case s_num_driver_mod3 is
                  when "00" =>
                     if num_sortie_driver_i =  1 or
                        num_sortie_driver_i =  4 or
                        num_sortie_driver_i =  7 or
                        num_sortie_driver_i = 10 or
                        num_sortie_driver_i = 13 then
                        s_bleu <= '1';
                     else
                        s_bleu <= '0';
                     end if;
                     
                  when "01" =>
                     if num_sortie_driver_i =  2 or
                        num_sortie_driver_i =  5 or
                        num_sortie_driver_i =  8 or
                        num_sortie_driver_i = 11 or
                        num_sortie_driver_i = 14 then
                        s_bleu <= '1';
                     else
                        s_bleu <= '0';
                     end if;
                     
                  when "10" =>
                     if num_sortie_driver_i =  0 or
                        num_sortie_driver_i =  3 or
                        num_sortie_driver_i =  6 or
                        num_sortie_driver_i =  9 or
                        num_sortie_driver_i = 12 or
                        num_sortie_driver_i = 15 then
                        s_bleu <= '1';
                     else
                        s_bleu <= '0';
                     end if;
                  
                  when others =>
                     s_bleu <= '0';
               end case;
            end if;
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_adressage
-- Détail : Calcul de l'adresse du pixel
---------------------------------------------------------------------------------------------------
   prc_adressage : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         adresse_o  <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if s_rouge = '1' then
            adresse_o <= conv_std_logic_vector(3*conv_integer(s_colonne) + 96*conv_integer(s_ligne) + 0, adresse_o'length);
         elsif s_vert = '1' then                                                                   
            adresse_o <= conv_std_logic_vector(3*conv_integer(s_colonne) + 96*conv_integer(s_ligne) + 1, adresse_o'length);
         elsif s_bleu = '1' then                                                                  
            adresse_o <= conv_std_logic_vector(3*conv_integer(s_colonne) + 96*conv_integer(s_ligne) + 2, adresse_o'length);
         else
            adresse_o <= (others => '1');
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_alignement
-- Détail : Alignement des infos pixel de sortie
---------------------------------------------------------------------------------------------------
   prc_alignement : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_lecture_enable_d      <= '0';
         lecture_enable_o        <= '0';
         s_num_chaine_driver_d   <= (others => '0');
         num_chaine_driver_o     <= (others => '0');
         s_num_driver_d          <= (others => '0');
         num_driver_o            <= (others => '0');
         s_num_sortie_driver_d   <= (others => '0');
         num_sortie_driver_o     <= (others => '0');
         couleur_pixel_o         <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         s_lecture_enable_d      <= lecture_enable_i;
         lecture_enable_o        <= s_lecture_enable_d;
         s_num_chaine_driver_d   <= num_chaine_driver_i;
         num_chaine_driver_o     <= s_num_chaine_driver_d;
         s_num_driver_d          <= num_driver_i;
         num_driver_o            <= s_num_driver_d;
         s_num_sortie_driver_d   <= num_sortie_driver_i;
         num_sortie_driver_o     <= s_num_sortie_driver_d;
         
         if s_bleu = '1' then
            couleur_pixel_o      <= CST_AFFICHAGE_TRAITEMENTS_BLEU;
         elsif s_vert = '1' then                                                                   
            couleur_pixel_o      <= CST_AFFICHAGE_TRAITEMENTS_VERT;
         elsif s_rouge = '1' then                                                                  
            couleur_pixel_o      <= CST_AFFICHAGE_TRAITEMENTS_ROUGE;
         else
            couleur_pixel_o      <= CST_AFFICHAGE_TRAITEMENTS_BLANC;
         end if;
         
      end if;
   end process;
   
end architecture rtl_memoire_image_adressage;
