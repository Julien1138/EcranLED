<?php
include_once('CPage.abstract.php');

class CPageTxt1 extends CPage
{
   private $_Texte;
   
   public function __construct()    // Surcharge constructeur
   {
      $this->_TypePage = "Texte1Ligne";
   }
   
   public function Charger($File)   // Lecture du fichier
   {
      do
      {
         $Ligne = trim(fgets($File,511));
         $Param = explode("=", $Ligne);
         switch ($Param[0])
         {
            case "Tempo" :
               $this->_Tempo = floatval($Param[1]);
               break;
            case "Texte" :
               $this->_Texte = $Param[1];
               break;
            default :
               break;
         }
      }
      while (strlen($Ligne) > 2);
   }
   
   public function Sauvegarder($File)  // Ecriture du fichier
   {
      parent::Sauvegarder($File);
      
      fputs($File, sprintf("Texte=%s\n", $this->_Texte));
      fputs($File, "\n");
   }
}
?>