<p>
   Texte à afficher :
   <input type="text" name="Texte" size="10" maxlength="7"
   <?php
   if (array_key_exists('Texte', $Page->Parametres()))
   {
      echo 'value="' . $Page->Parametres()['Texte'] . '"';
   }
   ?>
   >
</p>