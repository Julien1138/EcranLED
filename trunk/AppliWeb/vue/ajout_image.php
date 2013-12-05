<?php
if (isset($_FILES['monfichier']) and $_FILES['monfichier']['error'] == 0)
{
   $infosfichier = pathinfo($_FILES['monfichier']['name']);
   $extension_upload = strtolower($infosfichier['extension']);
   $extensions_autorisees = array('jpg', 'jpeg', 'gif', 'png', 'bmp');
   if (in_array($extension_upload, $extensions_autorisees))
   {
      move_uploaded_file($_FILES['monfichier']['tmp_name'], $GLOBALS['DossierImages'] . '/' . basename($_FILES['monfichier']['name']));
      echo '<p>Chargement du fichier' . $_FILES["monfichier"]["name"] . ': OK</p>';
   }
   else
   {
      echo '<p>Chargement du fichier' . $_FILES["monfichier"]["name"] . ': NOK</p>';
   }
}
else
{
?>
   <form action="index.php?ajoutimage=1" method="post" enctype="multipart/form-data">
      <p>
         Formulaire d'envoi de fichier :<br />
         <input type="file" name="monfichier" /><br />
         <input type="submit" value="Envoyer le fichier" />
      </p>
   </form>
<?php
}
?>
<a href="index.php">Retour</a>