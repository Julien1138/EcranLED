<?php
   $Config->AjoutPage($_POST['Type']);
   $Config->Sauvegarder(sprintf("%s\\config.txt", $GLOBALS["DossierConfig"]));
?>