----------------|-------------------------------------------------------------
--              . 
--                JCDecaux
--              . 
-- Projet         JEI_MESSAGE/FPGA_Driver
--              . 
--! @file         interpreteur.vhd
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

entity interpreteur is
   port
   (
   -- Signaux globaux
      rst_aff_i            : in  std_logic;                       --! Signal de reset affichage
      clk_aff_i            : in  std_logic;                       --! Signal d'horloge affichage
      
   -- Interface SPI
      NewData_i            : in  std_logic;
      Data_i               : in  std_logic_vector( 7 downto 0);
      
   -- Interface d'écriture de l'image
      ecriture_en1_o       : out std_logic;
      ecriture_en2_o       : out std_logic;
      ecriture_en3_o       : out std_logic;
      ecriture_en4_o       : out std_logic;
      ecriture_en5_o       : out std_logic;
      ecriture_en6_o       : out std_logic;
      ecriture_adresse_o   : out std_logic_vector(12 downto 0);
      ecriture_donnees_o   : out std_logic_vector( 7 downto 0);
      
   -- Mise à jour de l'affichage
      rafraichissement_o   : out std_logic;
      
   -- Paramètres
      luminosite_o         : out std_logic_vector( 7 downto 0);   --! Réglage de luminosité
      coefficient_rouge_1_o: out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
      coefficient_vert_1_o : out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
      coefficient_bleu_1_o : out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
      coefficient_rouge_2_o: out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
      coefficient_vert_2_o : out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
      coefficient_bleu_2_o : out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
      coefficient_rouge_3_o: out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
      coefficient_vert_3_o : out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
      coefficient_bleu_3_o : out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
      coefficient_rouge_4_o: out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
      coefficient_vert_4_o : out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
      coefficient_bleu_4_o : out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
      coefficient_rouge_5_o: out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
      coefficient_vert_5_o : out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
      coefficient_bleu_5_o : out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
      coefficient_rouge_6_o: out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
      coefficient_vert_6_o : out std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
      coefficient_bleu_6_o : out std_logic_vector( 7 downto 0)    --! Coefficient à appliquer à la couleur bleue
   );
end interpreteur;

-----------------------------------  Description du module  ---------------------------------------
--! 
---------------------------------------------------------------------------------------------------

architecture rtl_interpreteur of interpreteur is
   
   -- Machine d'état
   type t_etat_interpreteur is (ATTENTE_NOUVELLE_TRAME,
                                LECTURE_NUMERO_LIGNE,
                                LECTURE_LIGNE_INFO,
                                LECTURE_LIGNE_VIDEO,
                                ERREUR);
   signal sm_etat_interpreteur_present : t_etat_interpreteur := ATTENTE_NOUVELLE_TRAME;
   signal sm_etat_interpreteur_futur   : t_etat_interpreteur := ATTENTE_NOUVELLE_TRAME;
   
   signal s_compteur_couleurs : std_logic_vector( 1 downto 0);
   signal s_compteur_colonnes : std_logic_vector( 7 downto 0);
   signal s_compteur_lignes   : std_logic_vector( 7 downto 0);
   signal s_compteur_info     : std_logic_vector( 9 downto 0);
   
   signal s_compteur_adresse  : std_logic_vector(ecriture_adresse_o'range);
   signal s_ecriture_en1      : std_logic;
   signal s_ecriture_en2      : std_logic;
   signal s_ecriture_en3      : std_logic;
   signal s_ecriture_en4      : std_logic;
   signal s_ecriture_en5      : std_logic;
   signal s_ecriture_en6      : std_logic;
   
   signal s_luminosite           : std_logic_vector( 7 downto 0);   --! Réglage de luminosité
   signal s_coefficient_rouge_1  : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
   signal s_coefficient_vert_1   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
   signal s_coefficient_bleu_1   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
   signal s_coefficient_rouge_2  : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
   signal s_coefficient_vert_2   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
   signal s_coefficient_bleu_2   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
   signal s_coefficient_rouge_3  : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
   signal s_coefficient_vert_3   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
   signal s_coefficient_bleu_3   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
   signal s_coefficient_rouge_4  : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
   signal s_coefficient_vert_4   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
   signal s_coefficient_bleu_4   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
   signal s_coefficient_rouge_5  : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
   signal s_coefficient_vert_5   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
   signal s_coefficient_bleu_5   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
   signal s_coefficient_rouge_6  : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur rouge
   signal s_coefficient_vert_6   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur verte
   signal s_coefficient_bleu_6   : std_logic_vector( 7 downto 0);   --! Coefficient à appliquer à la couleur bleue
   
begin
   
---------------------------------------------------------------------------------------------------
-- Process : prc_etat_interperteur
-- Détail : Machine d'état sm_etat_interpreteur
---------------------------------------------------------------------------------------------------
   prc_etat_interperteur : process(sm_etat_interpreteur_present, NewData_i, Data_i, s_compteur_lignes,
                                   s_compteur_colonnes, s_compteur_couleurs)
   begin
      case sm_etat_interpreteur_present is
         when ATTENTE_NOUVELLE_TRAME =>
            if NewData_i = '1' then
               if Data_i = CST_INTERPRETEUR_HEADER then
                  sm_etat_interpreteur_futur <= LECTURE_NUMERO_LIGNE;
               elsif s_compteur_lignes = 0 then
                  sm_etat_interpreteur_futur <= ATTENTE_NOUVELLE_TRAME;
               else
                  sm_etat_interpreteur_futur <= ERREUR;
               end if;
            else
               sm_etat_interpreteur_futur <= ATTENTE_NOUVELLE_TRAME;
            end if;
            
         when LECTURE_NUMERO_LIGNE =>
            if NewData_i = '1' then
               if Data_i = s_compteur_lignes then
                  if s_compteur_lignes = 0 then
                     sm_etat_interpreteur_futur <= LECTURE_LIGNE_INFO;
                  else
                     sm_etat_interpreteur_futur <= LECTURE_LIGNE_VIDEO;
                  end if;
               else
                  sm_etat_interpreteur_futur <= ERREUR;
               end if;
            else
               sm_etat_interpreteur_futur <= LECTURE_NUMERO_LIGNE;
            end if;
            
         when LECTURE_LIGNE_INFO =>
            if NewData_i = '1' and s_compteur_colonnes = CST_INTERPRETEUR_DERNIERE_COLONNE and s_compteur_couleurs = "10" then
               sm_etat_interpreteur_futur <= ATTENTE_NOUVELLE_TRAME;
            else
               sm_etat_interpreteur_futur <= LECTURE_LIGNE_INFO;
            end if;
            
         when LECTURE_LIGNE_VIDEO =>
            if NewData_i = '1' and s_compteur_colonnes = CST_INTERPRETEUR_DERNIERE_COLONNE and s_compteur_couleurs = "10" then
               sm_etat_interpreteur_futur <= ATTENTE_NOUVELLE_TRAME;
            else
               sm_etat_interpreteur_futur <= LECTURE_LIGNE_VIDEO;
            end if;
            
         when ERREUR =>
            sm_etat_interpreteur_futur <= ATTENTE_NOUVELLE_TRAME;
            
         when others => NULL;
      end case;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_etat_interperteur_sync
-- Détail : Synchronisation de la machine d'état sm_etat_interpreteur
---------------------------------------------------------------------------------------------------
   prc_etat_interperteur_sync : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         sm_etat_interpreteur_present <= ATTENTE_NOUVELLE_TRAME;
      elsif rising_edge(clk_aff_i) then
         sm_etat_interpreteur_present <= sm_etat_interpreteur_futur;
      end if;
   end process;
   
   
---------------------------------------------------------------------------------------------------
-- Process : prc_compteur_couleurs
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_compteur_couleurs : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_compteur_couleurs <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if sm_etat_interpreteur_present = ATTENTE_NOUVELLE_TRAME then
            s_compteur_couleurs <= (others => '0');
         elsif NewData_i = '1' and
            (sm_etat_interpreteur_present = LECTURE_LIGNE_INFO or
             sm_etat_interpreteur_present = LECTURE_LIGNE_VIDEO) then
            if s_compteur_couleurs = "10" then
               s_compteur_couleurs <= (others => '0');
            else
               s_compteur_couleurs <= s_compteur_couleurs + 1;
            end if;
         else
            s_compteur_couleurs <= s_compteur_couleurs;
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_compteur_colonnes
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_compteur_colonnes : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_compteur_colonnes <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if sm_etat_interpreteur_present = ATTENTE_NOUVELLE_TRAME then
            s_compteur_colonnes <= (others => '0');
         elsif NewData_i = '1' and
            (sm_etat_interpreteur_present = LECTURE_LIGNE_INFO or
             sm_etat_interpreteur_present = LECTURE_LIGNE_VIDEO) and
            s_compteur_couleurs = "10" then
            if s_compteur_colonnes = CST_INTERPRETEUR_DERNIERE_COLONNE then
               s_compteur_colonnes <= (others => '0');
            else
               s_compteur_colonnes <= s_compteur_colonnes + 1;
            end if;
         else
            s_compteur_colonnes <= s_compteur_colonnes;
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_compteur_lignes
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_compteur_lignes : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_compteur_lignes <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if sm_etat_interpreteur_present = ERREUR then
            s_compteur_lignes <= (others => '0');
         elsif NewData_i = '1' and
            (sm_etat_interpreteur_present = LECTURE_LIGNE_INFO or
             sm_etat_interpreteur_present = LECTURE_LIGNE_VIDEO) and
            s_compteur_couleurs = "10" and
            s_compteur_colonnes = CST_INTERPRETEUR_DERNIERE_COLONNE then
            if s_compteur_lignes = CST_INTERPRETEUR_DERNIERE_LIGNE then
               s_compteur_lignes <= (others => '0');
            else
               s_compteur_lignes <= s_compteur_lignes + 1;
            end if;
         else
            s_compteur_lignes <= s_compteur_lignes;
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_compteur_info
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_compteur_info : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_compteur_info <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if sm_etat_interpreteur_present /= LECTURE_LIGNE_INFO then
            s_compteur_info <= (others => '0');
         elsif NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO then
            s_compteur_info <= s_compteur_info + 1;
         else
            s_compteur_info <= s_compteur_info;
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_compteur_adresse
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_compteur_adresse : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_compteur_adresse <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         s_compteur_adresse <= conv_std_logic_vector(conv_integer(s_compteur_couleurs) +
                                                     3*(conv_integer(s_compteur_colonnes) mod 32) +
                                                     96*(conv_integer(s_compteur_lignes) - 1), s_compteur_adresse'length);
         
      end if;
   end process;
   ecriture_adresse_o <= s_compteur_adresse;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_ecriture_en
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_ecriture_en : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_ecriture_en1 <= '0';
         s_ecriture_en2 <= '0';
         s_ecriture_en3 <= '0';
         s_ecriture_en4 <= '0';
         s_ecriture_en5 <= '0';
         s_ecriture_en6 <= '0';
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_VIDEO then
            if s_compteur_colonnes <= CST_INTERPRETEUR_DERNIERE_COLONNE_ECRAN1 then
               s_ecriture_en1 <= '1';
               s_ecriture_en2 <= '0';
               s_ecriture_en3 <= '0';
               s_ecriture_en4 <= '0';
               s_ecriture_en5 <= '0';
               s_ecriture_en6 <= '0';
            elsif s_compteur_colonnes <= CST_INTERPRETEUR_DERNIERE_COLONNE_ECRAN2 then
               s_ecriture_en1 <= '0';
               s_ecriture_en2 <= '1';
               s_ecriture_en3 <= '0';
               s_ecriture_en4 <= '0';
               s_ecriture_en5 <= '0';
               s_ecriture_en6 <= '0';
            elsif s_compteur_colonnes <= CST_INTERPRETEUR_DERNIERE_COLONNE_ECRAN3 then
               s_ecriture_en1 <= '0';
               s_ecriture_en2 <= '0';
               s_ecriture_en3 <= '1';
               s_ecriture_en4 <= '0';
               s_ecriture_en5 <= '0';
               s_ecriture_en6 <= '0';
            elsif s_compteur_colonnes <= CST_INTERPRETEUR_DERNIERE_COLONNE_ECRAN4 then
               s_ecriture_en1 <= '0';
               s_ecriture_en2 <= '0';
               s_ecriture_en3 <= '0';
               s_ecriture_en4 <= '1';
               s_ecriture_en5 <= '0';
               s_ecriture_en6 <= '0';
            elsif s_compteur_colonnes <= CST_INTERPRETEUR_DERNIERE_COLONNE_ECRAN5 then
               s_ecriture_en1 <= '0';
               s_ecriture_en2 <= '0';
               s_ecriture_en3 <= '0';
               s_ecriture_en4 <= '0';
               s_ecriture_en5 <= '1';
               s_ecriture_en6 <= '0';
            elsif s_compteur_colonnes <= CST_INTERPRETEUR_DERNIERE_COLONNE_ECRAN6 then
               s_ecriture_en1 <= '0';
               s_ecriture_en2 <= '0';
               s_ecriture_en3 <= '0';
               s_ecriture_en4 <= '0';
               s_ecriture_en5 <= '0';
               s_ecriture_en6 <= '1';
            else
               s_ecriture_en1 <= '0';
               s_ecriture_en2 <= '0';
               s_ecriture_en3 <= '0';
               s_ecriture_en4 <= '0';
               s_ecriture_en5 <= '0';
               s_ecriture_en6 <= '0';
            end if;
         else
            s_ecriture_en1 <= '0';
            s_ecriture_en2 <= '0';
            s_ecriture_en3 <= '0';
            s_ecriture_en4 <= '0';
            s_ecriture_en5 <= '0';
            s_ecriture_en6 <= '0';
         end if;
         
      end if;
   end process;
   ecriture_en1_o <= s_ecriture_en1;
   ecriture_en2_o <= s_ecriture_en2;
   ecriture_en3_o <= s_ecriture_en3;
   ecriture_en4_o <= s_ecriture_en4;
   ecriture_en5_o <= s_ecriture_en5;
   ecriture_en6_o <= s_ecriture_en6;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_ecriture_donnees
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_ecriture_donnees : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         ecriture_donnees_o <= (others => '0');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_VIDEO then
            ecriture_donnees_o <= Data_i;
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_rafraichissement
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_rafraichissement : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         rafraichissement_o <= '0';
      elsif rising_edge(clk_aff_i) then
         
         if sm_etat_interpreteur_futur = ATTENTE_NOUVELLE_TRAME and
            sm_etat_interpreteur_present /= ATTENTE_NOUVELLE_TRAME and
            sm_etat_interpreteur_present /= ERREUR and
            s_compteur_lignes = CST_INTERPRETEUR_DERNIERE_LIGNE then
            rafraichissement_o <= '1';
         else
            rafraichissement_o <= '0';
         end if;
         
      end if;
   end process;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_luminosite
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_luminosite : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_luminosite <= X"3F";
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 0 then
            s_luminosite <= Data_i;
         else
            s_luminosite <= s_luminosite;
         end if;
         
      end if;
   end process;
   luminosite_o <= s_luminosite;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_rouge_1
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_rouge_1 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_rouge_1 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 1 then
            s_coefficient_rouge_1 <= Data_i;
         else
            s_coefficient_rouge_1 <= s_coefficient_rouge_1;
         end if;
         
      end if;
   end process;
   coefficient_rouge_1_o <= s_coefficient_rouge_1;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_vert_1
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_vert_1 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_vert_1 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 2 then
            s_coefficient_vert_1 <= Data_i;
         else
            s_coefficient_vert_1 <= s_coefficient_vert_1;
         end if;
         
      end if;
   end process;
   coefficient_vert_1_o <= s_coefficient_vert_1;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_bleu_1
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_bleu_1 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_bleu_1 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 3 then
            s_coefficient_bleu_1 <= Data_i;
         else
            s_coefficient_bleu_1 <= s_coefficient_bleu_1;
         end if;
         
      end if;
   end process;
   coefficient_bleu_1_o <= s_coefficient_bleu_1;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_rouge_2
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_rouge_2 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_rouge_2 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 4 then
            s_coefficient_rouge_2 <= Data_i;
         else
            s_coefficient_rouge_2 <= s_coefficient_rouge_2;
         end if;
         
      end if;
   end process;
   coefficient_rouge_2_o <= s_coefficient_rouge_2;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_vert_2
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_vert_2 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_vert_2 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 5 then
            s_coefficient_vert_2 <= Data_i;
         else
            s_coefficient_vert_2 <= s_coefficient_vert_2;
         end if;
         
      end if;
   end process;
   coefficient_vert_2_o <= s_coefficient_vert_2;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_bleu_2
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_bleu_2 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_bleu_2 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 6 then
            s_coefficient_bleu_2 <= Data_i;
         else
            s_coefficient_bleu_2 <= s_coefficient_bleu_2;
         end if;
         
      end if;
   end process;
   coefficient_bleu_2_o <= s_coefficient_bleu_2;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_rouge_3
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_rouge_3 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_rouge_3 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 7 then
            s_coefficient_rouge_3 <= Data_i;
         else
            s_coefficient_rouge_3 <= s_coefficient_rouge_3;
         end if;
         
      end if;
   end process;
   coefficient_rouge_3_o <= s_coefficient_rouge_3;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_vert_3
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_vert_3 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_vert_3 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 8 then
            s_coefficient_vert_3 <= Data_i;
         else
            s_coefficient_vert_3 <= s_coefficient_vert_3;
         end if;
         
      end if;
   end process;
   coefficient_vert_3_o <= s_coefficient_vert_3;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_bleu_3
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_bleu_3 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_bleu_3 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 9 then
            s_coefficient_bleu_3 <= Data_i;
         else
            s_coefficient_bleu_3 <= s_coefficient_bleu_3;
         end if;
         
      end if;
   end process;
   coefficient_bleu_3_o <= s_coefficient_bleu_3;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_rouge_4
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_rouge_4 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_rouge_4 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 10 then
            s_coefficient_rouge_4 <= Data_i;
         else
            s_coefficient_rouge_4 <= s_coefficient_rouge_4;
         end if;
         
      end if;
   end process;
   coefficient_rouge_4_o <= s_coefficient_rouge_4;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_vert_4
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_vert_4 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_vert_4 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 11 then
            s_coefficient_vert_4 <= Data_i;
         else
            s_coefficient_vert_4 <= s_coefficient_vert_4;
         end if;
         
      end if;
   end process;
   coefficient_vert_4_o <= s_coefficient_vert_4;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_bleu_4
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_bleu_4 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_bleu_4 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 12 then
            s_coefficient_bleu_4 <= Data_i;
         else
            s_coefficient_bleu_4 <= s_coefficient_bleu_4;
         end if;
         
      end if;
   end process;
   coefficient_bleu_4_o <= s_coefficient_bleu_4;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_rouge_5
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_rouge_5 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_rouge_5 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 13 then
            s_coefficient_rouge_5 <= Data_i;
         else
            s_coefficient_rouge_5 <= s_coefficient_rouge_5;
         end if;
         
      end if;
   end process;
   coefficient_rouge_5_o <= s_coefficient_rouge_5;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_vert_5
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_vert_5 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_vert_5 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 14 then
            s_coefficient_vert_5 <= Data_i;
         else
            s_coefficient_vert_5 <= s_coefficient_vert_5;
         end if;
         
      end if;
   end process;
   coefficient_vert_5_o <= s_coefficient_vert_5;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_bleu_5
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_bleu_5 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_bleu_5 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 15 then
            s_coefficient_bleu_5 <= Data_i;
         else
            s_coefficient_bleu_5 <= s_coefficient_bleu_5;
         end if;
         
      end if;
   end process;
   coefficient_bleu_5_o <= s_coefficient_bleu_5;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_rouge_6
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_rouge_6 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_rouge_6 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 16 then
            s_coefficient_rouge_6 <= Data_i;
         else
            s_coefficient_rouge_6 <= s_coefficient_rouge_6;
         end if;
         
      end if;
   end process;
   coefficient_rouge_6_o <= s_coefficient_rouge_6;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_vert_6
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_vert_6 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_vert_6 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 17 then
            s_coefficient_vert_6 <= Data_i;
         else
            s_coefficient_vert_6 <= s_coefficient_vert_6;
         end if;
         
      end if;
   end process;
   coefficient_vert_6_o <= s_coefficient_vert_6;
   
---------------------------------------------------------------------------------------------------
-- Process : prc_coefficient_bleu_6
-- Détail : 
---------------------------------------------------------------------------------------------------
   prc_coefficient_bleu_6 : process(rst_aff_i, clk_aff_i)
   begin
      if rst_aff_i = '1' then
         s_coefficient_bleu_6 <= (others => '1');
      elsif rising_edge(clk_aff_i) then
         
         if NewData_i = '1' and sm_etat_interpreteur_present = LECTURE_LIGNE_INFO and s_compteur_info = 18 then
            s_coefficient_bleu_6 <= Data_i;
         else
            s_coefficient_bleu_6 <= s_coefficient_bleu_6;
         end if;
         
      end if;
   end process;
   coefficient_bleu_6_o <= s_coefficient_bleu_6;
   
end architecture rtl_interpreteur;
