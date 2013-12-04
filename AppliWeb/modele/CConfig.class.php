<?php
include_once('CPage.class.php');

class CConfig
{
   private $_NbrDePages;
   private $_ListePages;
   
   public function Charger($FileName)   // lecture du fichier
   {
      $this->_NbrDePages=0;
      if (!$File = fopen($FileName,"r"))
      {
         echo "Err : Imposible d'ouvrir le fichier en lecture <br />";
         fclose($File);
         return false;
      }
      else
      {
         while(!feof($File))
         {
            $Ligne = trim(fgets($File,511));
            if (!strncmp($Ligne,"[Page",5))
            {
               $this->_NbrDePages++;
               $NumPage = (int) substr($Ligne,5,2);
               
               $this->_ListePages[$NumPage] = new CPage();
               $this->_ListePages[$NumPage]->Charger($File);
            }
         }
         fclose($File);
         return true;
      }
   }
   
   public function Sauvegarder($FileName)  // Ecriture du fichier
   {
      if (!$File = fopen($FileName,"w"))
      {
         echo "Err : Imposible d'ouvrir le fichier pour �criture <br />";
         fclose($File);
         return false;
      }
      
      // Vidage du fichier
      ftruncate($File,0);
      
      // Ecriture de l'ent�te
      fputs($File, "[Configuration]\n");
      fputs($File, sprintf("NombreDePages=%u\n", $this->_NbrDePages));
      
      // Ecriture de chaque page
      for ($i = 0 ; $i < $this->_NbrDePages ; $i++)
      {
         fputs($File, "\n");
         if ($i < 10)
         {
            fputs($File, sprintf("[Page0%u]\n", $i));
         }
         else
         {
            fputs($File, sprintf("[Page%u]\n", $i));
         }
         $this->_ListePages[$i]->Sauvegarder($File);
      }
      
      fclose($File);
      return true;
   }
   
   public function Afficher()
   {
      ?>
      <h1>Liste des pages :</h1>
      <?php
      
      for ($i = 0 ; $i < $this->_NbrDePages ; $i++)
      {
         ?>
         <h2>
         <?php
         echo 'Page n�' . $i . ' :</ br>' ;
         ?>
         </h2>
         <?php
         //$this->_ListePages[$i]->Afficher();
      }
   }
}
?>