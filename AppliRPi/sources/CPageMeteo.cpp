#include "../includes/CPageMeteo.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

CPageMeteo::CPageMeteo() :
CPageTexte2(),
m_iDateModifFichier(0)
{
   m_sFilePath = FICHIER_METEO;
}

CPageMeteo::CPageMeteo(std::string sTempo, float fCoefRouge, float fCoefVert, float fCoefBleu) :
CPageTexte2(sTempo, fCoefRouge, fCoefVert, fCoefBleu, "", "", "non"),
m_iDateModifFichier(0)
{
   m_sFilePath = FICHIER_METEO;
}

CPageMeteo::CPageMeteo(const CPageMeteo& PageMeteo) :
CPageTexte2((CPageTexte2&) PageMeteo)
{
}

void CPageMeteo::UpdateImage()
{
   if (this->VerifNouveauFichier())
   {
      std::ifstream ifsFichier(m_sFilePath.c_str(), std::ios::in);   // on ouvre en lecture
      std::string sLigne;
      int iHumidite;
      int iVitesseVent;
      char buffer1[256], buffer2[256], buffer[512];
      Magick::Image Image;
      
      if (ifsFichier)
      {
         while(std::getline(ifsFichier, sLigne))
         {
            if (sLigne.substr(0,9) == "Humidite=")
            {
               char bufferx[6];
               sprintf(bufferx, "%s", (sLigne.substr(9, sLigne.length()-9)).c_str());
               std::stringstream ssHumidite(bufferx);
               ssHumidite >> iHumidite;
            }
            else if (sLigne.substr(0,12) == "VitesseVent=")
            {
               char bufferx[6];
               sprintf(bufferx, "%s", (sLigne.substr(12, sLigne.length()-12)).c_str());
               std::stringstream ssVitesseVent(bufferx);
               ssVitesseVent >> iVitesseVent;
            }
         }
         ifsFichier.close();
      }
      else
      {
         std::cerr << "Impossible d'ouvrir le fichier !" << std::endl;
      }
      
      // Vitesse du vent
      sprintf(buffer1, "Vent : %i Km/h", iVitesseVent);
      
      // Humidité
      sprintf(buffer2, "Humidité : %i%%", iHumidite);
      
      

      //Calcul de la largeur de la ligne 1
      MagickCore::MagickWand *mv1 = MagickCore::NewMagickWand();
      MagickCore::MagickSetSize(mv1, 0, 56);
      MagickCore::MagickSetPointsize(mv1, 26);
      MagickCore::MagickSetFont(mv1, "Helvetica");
      MagickCore::MagickSetOption(mv1, "fill", "white");
      MagickCore::MagickSetOption(mv1, "background", "black");
      MagickCore::MagickSetGravity(mv1, Magick::CenterGravity);
      sprintf(buffer, "caption:%s", buffer1);
      for (int i(0) ; i < 512 ; i++)
      {
         if (buffer[i] == ' ')
         {
            buffer[i] = '-';
         }
      }
      MagickCore::MagickReadImage(mv1, buffer);
      MagickCore::MagickWriteImage(mv1, "tmp.bmp");
      MagickCore::DestroyMagickWand(mv1);

      Image.read("tmp.bmp");
      m_iLargeurLigne1 = Image.baseColumns();

      //Calcul de la largeur de la ligne 2
      MagickCore::MagickWand *mv2 = MagickCore::NewMagickWand();
      MagickCore::MagickSetSize(mv2, 0, 56);
      MagickCore::MagickSetPointsize(mv2, 26);
      MagickCore::MagickSetFont(mv2, "Helvetica");
      MagickCore::MagickSetOption(mv2, "fill", "white");
      MagickCore::MagickSetOption(mv2, "background", "black");
      MagickCore::MagickSetGravity(mv2, Magick::CenterGravity);
      sprintf(buffer, "caption:%s", buffer2);
      for (int i(0) ; i < 512 ; i++)
      {
         if (buffer[i] == ' ')
         {
            buffer[i] = '-';
         }
      }
      MagickCore::MagickReadImage(mv2, buffer);
      MagickCore::MagickWriteImage(mv2, "tmp.bmp");
      MagickCore::DestroyMagickWand(mv2);

      Image.read("tmp.bmp");
      m_iLargeurLigne2 = Image.baseColumns();

      // Ecriture du texte
      m_Image.erase();
      m_Image.font("Helvetica");
      m_Image.strokeColor("red");   // On utilise le rouge en niveau de gris
      m_Image.fillColor("red");     // On utilise le rouge en niveau de gris
      m_Image.fontPointsize(26);
      m_Image.draw(Magick::DrawableText(96-(m_iLargeurLigne1/2), 20, buffer1));
      m_Image.draw(Magick::DrawableText(96-(m_iLargeurLigne2/2), 48, buffer2));
   }
}

bool CPageMeteo::VerifNouveauFichier()
{
   struct stat sb;
   stat(m_sFilePath.c_str(), &sb);
   if (m_iDateModifFichier != sb.st_mtim.tv_sec)
   {
      m_iDateModifFichier = sb.st_mtim.tv_sec;
      return true;
   }
   else
   {
      return false;
   }
}

