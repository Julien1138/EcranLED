#include "../includes/CPageMeteo.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

CPageMeteo::CPageMeteo() :
CPage(),
m_iDateModifFichier(0)
{
   m_sFilePath = FICHIER_METEO;
}

CPageMeteo::CPageMeteo(std::string sTempo) :
CPage(sTempo),
m_iDateModifFichier(0)
{
   m_sFilePath = FICHIER_METEO;
}

CPageMeteo::CPageMeteo(const CPageMeteo& PageMeteo) :
CPage((CPage&) PageMeteo)
{
}

void CPageMeteo::PreloadImage()
{
}

void CPageMeteo::UpdateImage()
{
   if (this->VerifNouveauFichier())
   {
      std::ifstream ifsFichier(m_sFilePath.c_str(), std::ios::in);   // on ouvre en lecture
      std::string sLigne;
      int iTemperature;
      int iHumidite;
      int iVitesseVent;
      
      if (ifsFichier)
      {
         while(std::getline(ifsFichier, sLigne))
         {
            if (sLigne.substr(0,12) == "Temperature=")
            {
               char buffer[6];
               sprintf(buffer, "%s", (sLigne.substr(12, sLigne.length()-12)).c_str());
               std::stringstream ssTemperature(buffer);
               ssTemperature >> iTemperature;
            }
            else if (sLigne.substr(0,9) == "Humidite=")
            {
               char buffer[6];
               sprintf(buffer, "%s", (sLigne.substr(9, sLigne.length()-9)).c_str());
               std::stringstream ssHumidite(buffer);
               ssHumidite >> iHumidite;
            }
            else if (sLigne.substr(0,12) == "VitesseVent=")
            {
               char buffer[6];
               sprintf(buffer, "%s", (sLigne.substr(12, sLigne.length()-12)).c_str());
               std::stringstream ssVitesseVent(buffer);
               ssVitesseVent >> iVitesseVent;
            }
         }
         ifsFichier.close();
      }
      else
      {
         std::cerr << "Impossible d'ouvrir le fichier !" << std::endl;
      }

      m_Image.erase();

      // Incrustation de l'icone météo
      Magick::Image IconMeteo;
      IconMeteo.read(FICHIER_ICON_METEO);
      IconMeteo.resize(Magick::Geometry(192, 56));
      m_Image.draw(Magick::DrawableCompositeImage(0, 0, IconMeteo));
      
      // Récupération de la couleur de fond de l'icone météo
      Magick::PixelPacket *pixel = m_Image.getPixels(0, 0, 1, 1);
      Magick::Color Color = pixel[0];
      
      // Coloration du fond de l'image complète avec cette couleur
      m_Image.backgroundColor(Color);

      // Configuration de la font
      m_Image.font("Helvetica");
      m_Image.strokeColor("green");
      m_Image.fillColor("green");
      m_Image.fontPointsize(20);

      // Effacement de l'image
      m_Image.erase();

      // Incrustation de l'icone météo
      m_Image.draw(Magick::DrawableCompositeImage(0, 0, IconMeteo));

      // Incrustation de l'icone de vitesse du vent
      
      // Vitesse du vent
      char bufferVitesseVent[256];
      sprintf(bufferVitesseVent, "Vent : %iKm/h", iVitesseVent);
      m_Image.draw(Magick::DrawableText(50, 20, bufferVitesseVent));

      // Incrustation de l'icone d'humidité
      
      // Humidité
      char bufferHumidite[256];
      sprintf(bufferHumidite, "Humidité : %i%%", iVitesseVent);
      m_Image.draw(Magick::DrawableText(50, 48, bufferHumidite));
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

