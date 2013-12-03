<?php
abstract class CPage
{
   protected $_TypePage;
   protected $_Tempo;
   
   abstract public function Charger($File);  // Lecture du fichier
   
   public function Sauvegarder($File)  // Ecriture du fichier
   {
      fputs($File, sprintf("Type=%s\n", $this->_TypePage));
      fputs($File, sprintf("Tempo=%f\n", $this->_Tempo));
   }
}
?>