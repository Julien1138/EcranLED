<?php
class CPageTxt2 extends CPage
{
   private $_Texte1;
   private $_Texte2;
   private $_Defilement;
   
   public function __construct()    // Surcharge constructeur
   {
      $this->_TypePage = "Texte2Lignes";
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
            case "Texte1" :
               $this->_Texte1 = $Param[1];
               break;
            case "Texte2" :
               $this->_Texte2 = $Param[1];
               break;
            case "Defilement" :
               $this->_Defilement = $Param[1];
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
      
      fputs($File, sprintf("Texte1=%s\n", $this->_Texte1));
      fputs($File, sprintf("Texte2=%s\n", $this->_Texte2));
      fputs($File, sprintf("Defilement=%s\n", $this->_Defilement));
      fputs($File, "\n");
   }
}
?>