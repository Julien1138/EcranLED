<p>
   Texte à afficher sur la ligne du haut :
   <input type="text" name="Texte1" size="30" maxlength="25"
   <?php
   if (array_key_exists('Texte1', $Page->Parametres()))
   {
      echo 'value="' . $Page->Parametres()['Texte1'] . '"';
   }
   ?>
   ><br>
   Texte à afficher sur la ligne du bas :
   <input type="text" name="Texte2" size="30"
   <?php
   if (array_key_exists('Texte2', $Page->Parametres()))
   {
      echo 'value="' . $Page->Parametres()['Texte2'] . '"';
   }
   ?>
   ><br>
   Défilement de la ligne du bas ?
   <input type="radio" name="Defilement" value="oui" id="oui"
   <?php
   if (array_key_exists('Defilement', $Page->Parametres()) and $Page->Parametres()['Defilement']=="oui")
   {
      echo ' checked="checked" ';
   }
   ?>
   /> <label for="oui">Oui</label>
   <input type="radio" name="Defilement" value="non" id="non"
   <?php
   if (!array_key_exists('Defilement', $Page->Parametres()) or $Page->Parametres()['Defilement']!="oui")
   {
      echo ' checked="checked" ';
   }
   ?>
   /> <label for="non">Non</label>
</p>