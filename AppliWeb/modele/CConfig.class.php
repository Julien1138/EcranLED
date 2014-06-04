<?php
include_once('CParametres.class.php');
include_once('CPage.class.php');

class CConfig
{
   private $_NbrDePages;
   private $_Parametres;
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
            else if (!strncmp($Ligne,"[Configuration",14))
            {
               $this->_Parametres = new CParametres();
               $this->_Parametres->Charger($File);
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
      // fputs($File, sprintf("NombreDePages=%u\n", $this->_NbrDePages));
      $this->_Parametres->Sauvegarder($File);
      
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
   
   public function AjouterPage($Type)
   {
      $this->_ListePages[$this->_NbrDePages] = new CPage();
      $this->_ListePages[$this->_NbrDePages]->SetParametre('Type', $Type);
      $this->_NbrDePages++;
      return true;
   }
   
   public function SupprimerPage($NumPage)
   {
      if ($this->_NbrDePages > 0 )
      {
         array_splice($this->_ListePages, $NumPage, 1);
         $this->_NbrDePages--;
         return true;
      }
      else
      {
         trigger_error("Err : Pas de page à supprimer", E_USER_ERROR);
         return false;
      }
   }
   
   public function MonterPage($NumPage)
   {
      if ($this->_NbrDePages > 1 and $NumPage != 0)
      {
         $TempPage = new CPage();
         $TempPage = $this->_ListePages[$NumPage-1];
         $this->_ListePages[$NumPage-1] = $this->_ListePages[$NumPage];
         $this->_ListePages[$NumPage] = $TempPage;
         unset($TempPage);
         return true;
      }
      else
      {
         trigger_error("Err : Imposible de monter la première page", E_USER_ERROR);
         return false;
      }
   }
   
   public function DescendrePage($NumPage)
   {
      if ($this->_NbrDePages > 1 and $NumPage != ($this->_NbrDePages-1))
      {
         $TempPage = new CPage();
         $TempPage = $this->_ListePages[$NumPage+1];
         $this->_ListePages[$NumPage+1] = $this->_ListePages[$NumPage];
         $this->_ListePages[$NumPage] = $TempPage;
         unset($TempPage);
         return true;
      }
      else
      {
         trigger_error("Err : Imposible de descendre la dernière page", E_USER_ERROR);
         return false;
      }
   }
   
   public function Parametres()
   {
      return $this->_Parametres;
   }
}
?>