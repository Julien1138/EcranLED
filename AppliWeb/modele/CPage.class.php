<?php
class CPage
{
   protected $_Parametres;
   
   public function Charger($File)  // Lecture du fichier
   {
      $Ligne = trim(fgets($File,511));
      while (strlen($Ligne) != 0)
      {
         $Param = explode("=", $Ligne);
         $this->_Parametres[$Param[0]] = $Param[1];
         $Ligne = trim(fgets($File,511));
      }
   }
   
   public function Sauvegarder($File)  // Ecriture du fichier
   {
      foreach($this->_Parametres as $cle => $element)
      {
         fputs($File, sprintf("%s=%s\n", $cle, $element));
      }
   }
   
   public function Parametres()
   {
      return $this->_Parametres;
   }
}
?>