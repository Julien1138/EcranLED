<?php
   foreach($_POST as $nom => $valeur)
   {
      if ($nom != "updatepage")
      {
         $Page->SetParametre($nom, $valeur);
      }
   }
   $Config->Sauvegarder("config\\config.txt");
?>