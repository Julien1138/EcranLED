<section>
   <?php
   foreach($Page->Parametres() as $nom => $valeur)
   {
      if ($nom != "Type")
      {
         echo sprintf("%s = %s", $nom, $valeur) . '</br>';
      }
   }
   ?>
</section>