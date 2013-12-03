<?php
class CPageTemp extends CPage
{
   public function __construct()    // Surcharge constructeur
   {
      $this->_TypePage = "Temperature";
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
            default :
               break;
         }
      }
      while (strlen($Ligne) > 2);
   }
   
   public function Sauvegarder($File)  // Ecriture du fichier
   {
      parent::Sauvegarder($File);
      
      fputs($File, "\n");
   }
}
?>