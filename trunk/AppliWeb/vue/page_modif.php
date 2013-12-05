<form method="post" action="index.php">
   <?php
   switch ($Page->Parametres()['Type'])
   {
      case 'Heure' :
         include("page_modif_heure.php");
         break;
      case 'Image' :
         include("page_modif_image.php");
         break;
      case 'Texte1Ligne' :
         include("page_modif_texte1.php");
         break;
      default :
         break;
   }
   echo '<input type="hidden" name="numpage" value="' . $_GET["modifpage"] . '" />';
   ?>
   <input type="submit" name="updatepage" value="Enregistrer" />
</form>