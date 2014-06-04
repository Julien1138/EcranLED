<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">
   <head>
      <?php
      if (isset($_GET['ajoutimage']))
      {
         echo"<title>Ajout d'une image</title>";
      }
      else
      {
         echo "<title>Configuration de l'écran à LED</title>";
      }
      ?>
      <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
   </head>
   <body>
      <?php
      if (isset($_GET['ajoutimage']))
      {
         include("ajout_image.php");
      }
      else
      {
         include("config.php");
      }
      ?>
   </body>
</html>