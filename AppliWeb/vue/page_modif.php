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
      case 'Texte2Lignes' :
         include("page_modif_texte2.php");
         break;
      default :
         break;
   }
   ?>
   <p>
      Tempo :
      <input type="text" name="Tempo" size="10"
      <?php
      if (array_key_exists('Tempo', $Page->Parametres()))
      {
         echo 'value="' . $Page->Parametres()['Tempo'] . '"';
      }
      ?>
      >
      secondes
   </p>
   <input type="hidden" name="numpage" value="<?php echo $_GET["modifpage"];?>" />
   <input type="submit" name="updatepage" value="Enregistrer" />
</form>