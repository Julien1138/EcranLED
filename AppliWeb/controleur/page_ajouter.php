<?php
   $Config->AjouterPage($_POST['Type']);
   $Config->Sauvegarder(sprintf("%s/%s", $GLOBALS["DossierConfig"], $GLOBALS["FichierConfigTemp"]));
?>