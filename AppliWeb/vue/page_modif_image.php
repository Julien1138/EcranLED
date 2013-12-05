<?php
if($dossier = opendir($GLOBALS["DossierImages"]))
{
?>
<p>
   Image à afficher :
   <select name="Source">
<?php
   while($fichier = readdir($dossier))
   {
      if ($fichier != '.' && $fichier != '..')
      {
         echo '<option value="' . $fichier . '"';
         if (array_key_exists('Source', $Page->Parametres()) and $Page->Parametres()['Source']==$fichier)
         {
             echo ' selected="selected"';
         }
         echo '>' . $fichier . '</option>';
      }
   }
   closedir($dossier);
?>
   </select>
   <a href="index.php?ajoutimage=1">Ajouter une image...</a>
<p>
<?php
}
?>