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
         trigger_error("Err : Imposible d'ouvrir le fichier en lecture", E_USER_ERROR);
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
         trigger_error("Err : Imposible d'ouvrir le fichier pour écriture", E_USER_ERROR);
         fclose($File);
         return false;
      }
      
      // Vidage du fichier
      ftruncate($File,0);
      
      // Ecriture de l'entête
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
   
   public function NbrDePages()
   {
      return $this->_NbrDePages;
   }
   
   public function ListePages()
   {
      return $this->_ListePages;
   }
}
?>