<?php
   $Config->SupprimerPage($_GET['supprpage']);
   $Config->Sauvegarder(sprintf("%s/%s", $GLOBALS["DossierConfig"], $GLOBALS["FichierConfigTemp"]));
?>