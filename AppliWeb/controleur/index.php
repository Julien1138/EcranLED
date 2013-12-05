<?php
include_once('controleur/globals.php');
include_once('modele/CConfig.class.php');
         
$Config = new CConfig();
$Config->Charger(sprintf("%s\\config.txt", $GLOBALS["DossierConfig"]));

include('vue/index.php');

?>