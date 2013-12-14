<?php
   foreach($_POST as $nom => $valeur)
   {
      if ($nom != "updatepage" and $nom != "numpage")
      {
         if ($nom == "Tempo") // Forcer une valeur flottante pour la tempo
         {
            $Page->SetParametre($nom, (float) $valeur);
         }
         else
         {
            $Page->SetParametre($nom, $valeur);
         }
      }
   }
   $Config->Sauvegarder(sprintf("%s/%s", $GLOBALS["DossierConfig"], $GLOBALS["FichierConfigTemp"]));
?>