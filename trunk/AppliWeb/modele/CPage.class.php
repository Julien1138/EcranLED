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
      foreach($this->_Parametres as $nom => $valeur)
      {
         fputs($File, sprintf("%s=%s\n", $nom, $valeur));
      }
   }
   
   public function Parametres()
   {
      return $this->_Parametres;
   }
   
   public function SetParametre($nom, $valeur)
   {
      $this->_Parametres[$nom] = $valeur;
   }
}
?>