<?php
include_once('modele/CConfig.class.php');
         
$Config = new CConfig();
if (!$Config->Charger("config\\config.txt"))
{
   ?>
   <p>"Echec de chargement du fichier"<p/>
   <?php
}

if (!$Config->Sauvegarder("config\\config_out.txt"))
{
   ?>
   <p>"Echec de l'écriture du fichier"<p/>
   <?php
}

include_once('vue/index.php');

?>