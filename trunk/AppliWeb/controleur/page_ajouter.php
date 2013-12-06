<?php
   $Config->AjouterPage($_POST['Type']);
   $Config->Sauvegarder(sprintf("%s\\config.txt", $GLOBALS["DossierConfig"]));
?>