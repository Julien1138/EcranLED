<?php
include_once('CPage.abstract.php');

class CPageImage extends CPage
{
   private $_Source;
   
   public function __construct()    // Surcharge constructeur
   {
      $this->_TypePage = "Image";
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
            case "Source" :
               $this->_Source = $Param[1];
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
      
      fputs($File, sprintf("Source=%s\n", $this->_Source));
      fputs($File, "\n");
   }
}
?>