<p>
   Format d'affichage de l'heure :
   <select name="Format">
      <option value="12H"
      <?php if (!array_key_exists('Format', $Page->Parametres()) or $Page->Parametres()['Format']=="12H")
            {?> selected="selected" <?php } ?>
      >12H</option>
      <option value="24H"
      <?php if (array_key_exists('Format', $Page->Parametres()) and $Page->Parametres()['Format']=="24H")
            {?> selected="selected" <?php } ?>
      >24H</option>
   </select>
</p>