<form method="post" action="index.php">
   <h1>Configuration des pages de l'écran à LED</h1>
   <p>
      <a href="index.php?ignorer=oui">Ignorer les changements</a>
      <a href="index.php?enregistrer=oui">Enregistrer les changements</a>
   </p>
   <?php
   // Ecriture de chaque page
   for ($i = 0 ; $i < $Config->NbrDePages() ; $i++)
   {
      $Page=$Config->ListePages()[$i]; // Récupération de la page
      
      // Titre de la page
      echo '<h2>Page n°' . $i . ' : Affichage ';
      switch ($Page->Parametres()['Type'])
      {
         case 'Heure' :
            echo "de l'horloge";
            break;
         case 'Temperature' :
            echo "de la température extérieure";
            break;
         case 'Image' :
            echo "d'une image";
            break;
         case 'Texte1Ligne' :
            echo "d'un texte sur une ligne";
            break;
         case 'Texte2Lignes' :
            echo "d'un texte sur deux lignes";
            break;
         default :
            break;
      }
      echo '</h2>';
      
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
            if ($i != 0)   // On ne peut pas monter la première page
            {
               echo '<br>';
               echo '<a href="index.php?monterpage=' . $i . '">Monter la page</a>';   // Lien pour supprimer la page
            }
            if ($i != ($Config->NbrDePages()-1))   // On ne peut pas descendre la dernière page
            {
               echo '<br>';
               echo '<a href="index.php?descendrepage=' . $i . '">Descendre la page</a>';   // Lien pour supprimer la page
            }
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