<section>
   <?php
   foreach($Page->Parametres() as $nom => $valeur)
   {
      if ($nom == "Type")
      {
         // On n'affiche pas le type, il est d�j� dans le titre.
      }
      else if ($nom == "Tempo")
      {
         echo sprintf("Dur�e d'affichage de la page : %s secondes.", $valeur) . '</br>';
      }
      else if ($nom == "Format") // Page d'heure
      {
         echo sprintf("Format d'affichage de l'heure : %s.", $valeur) . '</br>';
      }
      else if ($nom == "Source") // Page d'image
      {
         echo sprintf("Nom de l'image affich�e : %s", $valeur) . '</br>';
      }
      else if ($nom == "Texte") // Page de texte sur une ligne
      {
         echo sprintf("Texte affich� : %s", $valeur) . '</br>';
      }
      else if ($nom == "Texte1") // Page de texte sur deux lignes
      {
         echo sprintf("Texte affich� sur la premi�re ligne : %s", $valeur) . '</br>';
      }
      else if ($nom == "Texte2") // Page de texte sur deux lignes
      {
         echo sprintf("Texte affich� sur la deuxi�me ligne : %s", $valeur) . '</br>';
      }
      else if ($nom == "Defilement") // Page de texte sur deux lignes
      {
         if ($valeur == "oui")
         {
            echo "Le texte de la deuxi�me ligne est d�filant</br>";
         }
         else
         {
            echo "Le texte de la deuxi�me ligne n'est pas d�filant</br>";
         }
      }
      else
      {
         echo sprintf("%s = %s", $nom, $valeur) . '</br>';
      }
   }
   ?>
</section>