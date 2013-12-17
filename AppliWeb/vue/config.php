<div id ="header">
<div id ="logo">
<h1>  Configuration des pages de l'écran à LED</h1>
</div>
</div>

<body>
<div id="main">
<form method="post" action="index.php">

   
   <div id="content">
   <p class="btn-more box noprint">
   
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
            
			echo '<p class="btn-more box noprint">';
			echo '<b/><a href="index.php?modifpage=' . $i . '">Modifier la page</a></b>';   // Lien pour modifier la page
            //echo '<br>';
			echo '<b/><a href="index.php?supprpage=' . $i . '">Supprimer la page</a></b>';   // Lien pour supprimer la page
			echo '</p>';
            if ($i != 0)   // On ne peut pas monter la première page
            {
			
              // echo '<br>';
               echo '<b/><a href="index.php?monterpage=' . $i . '"><img src="design/fleches_haut.png" width=25 border=0 alt="monter"></a></b>';   // Lien pour monter la page
            }
            if ($i != ($Config->NbrDePages()-1))   // On ne peut pas descendre la dernière page
            {
               //echo '<br>';
               echo '<b/><a href="index.php?descendrepage=' . $i . '"><img src="design/fleches_bas.png" width=25 border=0 alt="descendre"></a></b>';   // Lien pour descendre la page
			   
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
    </div>
</form>
</div>
</body>