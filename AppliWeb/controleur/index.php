<?php
include_once('controleur/globals.php');
include_once('modele/CConfig.class.php');

if (isset($_GET['ignorer']))  // Ignorer les changements
{
   include("controleur/restauration.php"); // Restauration de la congiguration
}

if (isset($_GET['enregistrer']))  // Enregistrer les changement
{
   include("controleur/sauvegarde.php"); // Sauvegarde de la configuration
}

$Config = new CConfig();
$Config->Charger(sprintf("%s/%s", $GLOBALS["DossierConfig"], $GLOBALS["FichierConfigTemp"]));

if (isset($_POST['parametrage']))  // Paramétrage
{
   $Param=$Config->Parametres();
   include("controleur/parametrage.php"); // Parametrage
}

if (isset($_POST['updatepage']) and isset($_POST['numpage']))  // Mise à jour d'une page
{
   $Page=$Config->ListePages()[(int) $_POST['numpage']]; // Récupération de la page
   include("controleur/page_modif.php"); // Modification de la page
}

if (isset($_POST['ajoutpage']))  // Ajout d'une page
{
   include("controleur/page_ajouter.php"); // Ajout de la page
}

if (isset($_GET['supprpage']))  // Suppression d'une page
{
   include("controleur/page_supprimer.php"); // Suppression de la page
}

if (isset($_GET['monterpage']))  // Montée d'une page
{
   include("controleur/page_monter.php"); // Montée de la page
}

if (isset($_GET['descendrepage']))  // Descente d'une page
{
   include("controleur/page_descendre.php"); // Descente de la page
}

include('vue/index.php');

?>