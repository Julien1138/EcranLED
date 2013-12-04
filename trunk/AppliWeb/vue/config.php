<section>
   <h1>Configuration des pages de l'écran à LED<h1/>
   <?php
   // Ecriture de chaque page
   for ($i = 0 ; $i < $Config->NbrDePages() ; $i++)
   {
      echo '<h2>Page n°' . $i . '</h2>';  // Titre de la page
      $Page=$Config->ListePages()[$i]; // Récupération de la page
      if (isset($_GET['modifpage']) and (int) $_GET['modifpage']==(int) $i)
      {
         $Config->SetPageEnCoursDeModif($i);
         include("page_modif.php"); // Affichage du formulaire de modification de la page
         echo '<a href="index.php">Annuler</a>';   // Lien pour annuler la modification de la page
      }
      else
      {
         if (isset($_POST['updatepage']) and $Config->PageEnCoursDeModif() == $i)
         {
            include("controleur\\page_modif.php"); // Modif de la page
         }
         echo '<a href="index.php?modifpage=' . $i . '">Modifier la page</a>';   // Lien pour modifier la page
         include("page.php"); // Affichage de la page
      }
   }
   ?>
</section>