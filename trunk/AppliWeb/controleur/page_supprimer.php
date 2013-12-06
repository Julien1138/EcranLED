<?php
   $Config->SupprimerPage($_GET['supprpage']);
   $Config->Sauvegarder(sprintf("%s\\config.txt", $GLOBALS["DossierConfig"]));
?>