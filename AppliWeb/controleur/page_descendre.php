<?php
   $Config->DescendrePage($_GET['descendrepage']);
   $Config->Sauvegarder(sprintf("%s/%s", $GLOBALS["DossierConfig"], $GLOBALS["FichierConfigTemp"]));
?>