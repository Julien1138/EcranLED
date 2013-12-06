<?php
   $Config->SuppressionPage($_GET['supprpage']);
   $Config->Sauvegarder(sprintf("%s\\config.txt", $GLOBALS["DossierConfig"]));
?>