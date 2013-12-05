<?php
   foreach($_POST as $nom => $valeur)
   {
      if ($nom != "updatepage" and $nom != "numpage")
      {
         $Page->SetParametre($nom, $valeur);
      }
   }
   $Config->Sauvegarder(sprintf("%s\\config.txt", $GLOBALS["DossierConfig"]));
?>