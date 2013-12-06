<?php
include_once('controleur/globals.php');
include_once('modele/CConfig.class.php');
         
$Config = new CConfig();
$Config->Charger(sprintf("%s\\config.txt", $GLOBALS["DossierConfig"]));

if (isset($_POST['updatepage']) and isset($_POST['numpage']))  // Mise à jour d'une page
{
   $Page=$Config->ListePages()[(int) $_POST['numpage']]; // Récupération de la page
   include("controleur\\page_modif.php"); // Modification de la page
}

if (isset($_POST['ajoutpage']))  // Ajout d'une page
{
   include("controleur\\page_ajout.php"); // Ajout de la page
}

if (isset($_GET['supprpage']))  // Suppression d'une page
{
   include("controleur\\page_suppression.php"); // Ajout de la page
}

include('vue/index.php');

?>