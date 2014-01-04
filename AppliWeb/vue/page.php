<section>
   <?php
   foreach($Page->Parametres() as $nom => $valeur)
   {
      if ($nom == "Type")
      {
         // On n'affiche pas le type, il est déjà dans le titre.
      }
      else if ($nom == "Tempo")
      {
         echo sprintf("Durée d'affichage de la page : %s secondes.", $valeur) . '</br>';
      }
      else if ($nom == "Format") // Page d'heure
      {
         echo sprintf("Format d'affichage de l'heure : %s.", $valeur) . '</br>';
      }
      else if ($nom == "Source") // Page d'image
      {
         echo sprintf("Nom de l'image affichée : %s", $valeur) . '</br>';
      }
      else if ($nom == "Texte") // Page de texte sur une ligne
      {
         echo sprintf("Texte affiché : %s", $valeur) . '</br>';
      }
      else if ($nom == "Texte1") // Page de texte sur deux lignes
      {
         echo sprintf("Texte affiché sur la première ligne : %s", $valeur) . '</br>';
      }
      else if ($nom == "Texte2") // Page de texte sur deux lignes
      {
         echo sprintf("Texte affiché sur la deuxième ligne : %s", $valeur) . '</br>';
      }
      else if ($nom == "Defilement") // Page de texte sur deux lignes
      {
         if ($valeur == "oui")
         {
            echo "Le texte de la deuxième ligne est défilant</br>";
         }
         else
         {
            echo "Le texte de la deuxième ligne n'est pas défilant</br>";
         }
      }
      else
      {
         echo sprintf("%s = %s", $nom, $valeur) . '</br>';
      }
   }
   ?>
</section>