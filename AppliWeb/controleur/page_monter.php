<?php
   $Config->MonterPage($_GET['monterpage']);
   $Config->Sauvegarder(sprintf("%s/config.txt", $GLOBALS["DossierConfig"]));
?>