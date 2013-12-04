<form method="post" action="index.php">
   <?php
   switch ($Page->Parametres()['Type'])
   {
      case 'Heure' :
         include("page_modif_heure.php");
         break;
      default :
         break;
   }
   ?>
   </ br>
   <input type="submit" name="updatepage" value="Enregistrer" />
</form>