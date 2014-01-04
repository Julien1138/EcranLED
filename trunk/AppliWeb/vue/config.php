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
      
      // Séparateur à remplacer par une image
      echo "==================================================================================</br>";
      
      // Titre de la page
      echo "<h2>Page d'affichage ";
      switch ($Page->Parametres()['Type'])
      {
         case 'Heure' :
            echo "de l'horloge";
            break;
         case 'Temperature' :
            echo "de la température extérieure";
            break;
         case 'Meteo' :
            echo "de la météo";
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
      echo ' :</h2>';
      
      if (isset($_GET['modifpage']) and (int) $_GET['modifpage']==(int) $i)
      {
         echo '<p>';
         include("page_modif.php"); // Affichage du formulaire de modification de la page
         echo '<b><a href="index.php"><img src="design/annuler.png" width = 15>Annuler </a></b>';   // Lien pour annuler la modification de la page
         echo '</p>';
      }
      else
      {
         include("page.php"); // Affichage de la page
         echo '<p class="btn-more box noprint">';
         echo '<b/><a href="index.php?modifpage=' . $i . '">Modifier la page<img src="design/modifier.png" width = 25></a></b>';   // Lien pour modifier la page
         echo '<b/><a href="index.php?supprpage=' . $i . '">Supprimer la page<img src="design/supprimer.png" width = 25></a></b>';   // Lien pour supprimer la page
         
         if ($i != 0)   // On ne peut pas monter la première page
         {
            echo '<b/><a href="index.php?monterpage=' . $i . '">Monter <img src="design/fleches_haut.png" width=25 border=0></a></b>';   // Lien pour monter la page
         }
         if ($i != ($Config->NbrDePages()-1))   // On ne peut pas descendre la dernière page
         {
            echo '<b/><a href="index.php?descendrepage=' . $i . '">Descendre <img src="design/fleches_bas.png" width=25 border=0></a></b>';   // Lien pour descendre la page
         }
         echo '</p>';
      }
      
      // Séparateur à remplacer par une image
      echo "==================================================================================</br>";
   }
   ?>
   <h2>Ajouter une page</h2>
   <p>
      Ajouter une page de type
      <select name="Type">
         <option value="Heure">Heure</option>
         <option value="Temperature">Température</option>
         <option value="Meteo">Météo</option>
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