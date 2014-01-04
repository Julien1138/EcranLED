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
   <?php
   if ($Page->Parametres()['Type'] == 'Date' ||
       $Page->Parametres()['Type'] == 'Heure' ||
       $Page->Parametres()['Type'] == 'Temperature' ||
       $Page->Parametres()['Type'] == 'Texte1Ligne' ||
       $Page->Parametres()['Type'] == 'Texte2Lignes')
   {
   ?>
      <p>
         Couleur du texte :
         <select name="Couleur">
            <option value="#FFFFFF">Blanc</option>
            <option value="#FF0000">Rouge</option>
            <option value="#00FF00">Vert</option>
            <option value="#0000FF">Bleu</option>
            <option value="#FFFF00">Jaune</option>
            <option value="#00FFFF">Turquoise</option>
            <option value="#FF00FF">Violet</option>
            <option value="#FF7F00">Orange</option>
         </select>
      </p>
   <?php
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