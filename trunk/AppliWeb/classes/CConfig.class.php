<?php
class CConfig
{
   private $_NbrDePages;
   private $_ListePages;
   
   public function Charger($FileName)   // lecture du fichier
   {
      $this->_NbrDePages=0;
      if (!$File = fopen($FileName,"r"))
      {
         echo "Err : Imposible d'ouvrir le fichier en lecture <br />";
         fclose($File);
         return false;
      }
      else
      {
         while(!feof($File))
         {
            $Ligne = trim(fgets($File,511));
            if (!strncmp($Ligne,"[Page",5))
            {
               $this->_NbrDePages++;
               $NumPage = (int) substr($Ligne,5,2);
               
               $Ligne = trim(fgets($File,511)); // Ligne suivante
               $Type = explode("=", $Ligne);
               if ($Type[0] != "Type")
               {
                  echo 'Err : La description doit toujours commencer par le type de page <br />';
                  fclose($File);
                  return false;  // La description doit toujours commencer par le type de page
               }
               else
               {
                  switch ($Type[1])
                  {
                     case "Heure" :
                        $this->_ListePages[$NumPage] = new CPageHeure();
                        break;
                     case "Temperature" :
                        $this->_ListePages[$NumPage] = new CPageTemp();
                        break;
                     case "Image" :
                        $this->_ListePages[$NumPage] = new CPageImage();
                        break;
                     case "Texte1Ligne" :
                        $this->_ListePages[$NumPage] = new CPageTxt1();
                        break;
                     case "Texte2Lignes" :
                        $this->_ListePages[$NumPage] = new CPageTxt2();
                        break;
                     default :
                        echo 'Err : Type inconnu <br />';
                        fclose($File);
                        return false;
                        break;
                  }
                  $this->_ListePages[$NumPage]->Charger($File);
               }
            }
         }
         fclose($File);
         return true;
      }
   }
   
   public function Sauvegarder($FileName)  // Ecriture du fichier
   {
      if (!$File = fopen($FileName,"w"))
      {
         echo "Err : Imposible d'ouvrir le fichier pour écriture <br />";
         fclose($File);
         return false;
      }
      
      // Vidage du fichier
      ftruncate($File,0);
      
      // Ecriture de l'entête
      fputs($File, "[Configuration]\n");
      fputs($File, sprintf("NombreDePages=%u\n", $this->_NbrDePages));
      fputs($File, "\n");
      
      // Ecriture de chaque page
      for ($i = 0 ; $i < $this->_NbrDePages ; $i++)
      {
         if ($i < 10)
         {
            fputs($File, sprintf("[Page0%u]\n", $i));
         }
         else
         {
            fputs($File, sprintf("[Page%u]\n", $i));
         }
         $this->_ListePages[$i]->Sauvegarder($File);
      }
      
      fclose($File);
      return true;
   }
   
   public function Afficher()
   {
      ?>
      <h1>Liste des pages :</h1>
      <?php
      
      for ($i = 0 ; $i < $this->_NbrDePages ; $i++)
      {
         ?>
         <h2>
         <?php
         echo 'Page n°' . $i . ' :</ br>' ;
         ?>
         </h2>
         <?php
         $this->_ListePages[$i]->Afficher();
      }
   }
}
?>