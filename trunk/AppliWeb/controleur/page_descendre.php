<?php
   $Config->DescendrePage($_GET['descendrepage']);
   $Config->Sauvegarder(sprintf("%s\\config.txt", $GLOBALS["DossierConfig"]));
?>