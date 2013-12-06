<?php
include_once('controleur/globals.php');
include_once('modele/CConfig.class.php');
         
$Config = new CConfig();
$Config->Charger(sprintf("%s\\config.txt", $GLOBALS["DossierConfig"]));

if (isset($_POST['updatepage']) and isset($_POST['numpage']))  // Mise � jour d'une page
{
   $Page=$Config->ListePages()[(int) $_POST['numpage']]; // R�cup�ration de la page
   include("controleur\\page_modif.php"); // Modification de la page
}

if (isset($_POST['ajoutpage']))  // Ajout d'une page
{
   include("controleur\\page_ajouter.php"); // Ajout de la page
}

if (isset($_GET['supprpage']))  // Suppression d'une page
{
   include("controleur\\page_supprimer.php"); // Suppression de la page
}

if (isset($_GET['monterpage']))  // Mont�e d'une page
{
   include("controleur\\page_monter.php"); // Mont�e de la page
}

if (isset($_GET['descendrepage']))  // Descente d'une page
{
   include("controleur\\page_descendre.php"); // Descente de la page
}

include('vue/index.php');

?>