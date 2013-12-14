<?php
   $Config->MonterPage($_GET['monterpage']);
   $Config->Sauvegarder(sprintf("%s/%s", $GLOBALS["DossierConfig"], $GLOBALS["FichierConfigTemp"]));
?>