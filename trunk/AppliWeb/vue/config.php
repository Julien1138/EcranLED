<form method="post" action="index.php">
   <h1>Configuration des pages de l'�cran � LED<h1/>
   <?php
   // Ecriture de chaque page
   for ($i = 0 ; $i < $Config->NbrDePages() ; $i++)
   {
      $Page=$Config->ListePages()[$i]; // R�cup�ration de la page
      echo '<h2>Page n�' . $i . '</h2>';  // Titre de la page
      if (isset($_GET['modifpage']) and (int) $_GET['modifpage']==(int) $i)
      {
         include("page_modif.php"); // Affichage du formulaire de modification de la page
         echo '<a href="index.php">Annuler</a>';   // Lien pour annuler la modification de la page
      }
      else
      {
         if (!isset($_GET['modifpage']))  // A n'afficher que si aucune page n'est en cours de modification
         {
            echo '<a href="index.php?modifpage=' . $i . '">Modifier la page</a>';   // Lien pour modifier la page
            echo '<br>';
            echo '<a href="index.php?supprpage=' . $i . '">Supprimer la page</a>';   // Lien pour supprimer la page
         }
         include("page.php"); // Affichage de la page
      }
   }
   ?>
   <h2>Ajouter une page</h2>
   <p>
      Ajouter une page de type
      <select name="Type">
         <option value="Heure">Heure</option>
         <option value="Temperature">Temperature</option>
         <option value="Image">Image</option>
         <option value="Texte1Ligne">Texte sur 1 Ligne</option>
         <option value="Texte2Lignes">Texte sur 2 Lignes</option>
      </select>
      <input type="submit" name="ajoutpage" value="Ajouter" />
   </p>
</form>