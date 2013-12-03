<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<?php
   // Inclusion de toutes les classes
   $_CLASSES = array_merge(glob ("classes/*.abstract.php"),
                           glob ("classes/*.class.php"));
   foreach ($_CLASSES AS $_CLASS)
   {
      require ($_CLASS);
   }
?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">
   <head>
      <title>Configuration de l'écran à LED</title>
      <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
   </head>
   <body>
      <?php
         
         $Config = new CConfig();
         if (!$Config->Charger("config.txt"))
         {
            ?>
            <p>"Echec de chargement du fichier"<p/>
            <?php
         }
         
         $Config->Afficher();
         
         /*if (!$Config->Sauvegarder("config_out.txt"))
         {
            ?>
            <p>"Echec de l'écriture du fichier"<p/>
            <?php
         }*/
      ?>
      
      
      
   </body>
</html>