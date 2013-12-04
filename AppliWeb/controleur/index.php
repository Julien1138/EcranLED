<?php
include_once('modele/CConfig.class.php');
         
$Config = new CConfig();
$Config->Charger("config\\config.txt");

include('vue/index.php');

?>