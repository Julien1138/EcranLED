<section>
   <?php
   foreach($Page->Parametres() as $nom => $valeur)
   {
      echo sprintf("%s=%s", $nom, $valeur) . '</br>';
   }
   ?>
</section>