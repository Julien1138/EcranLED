#include "../includes/CPageTemperature.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

CPageTemperature::CPageTemperature() :
CPage(),
m_iDateModifFichier(0)
{
   m_sFilePath = FICHIER_METEO;
}

CPageTemperature::CPageTemperature(std::string sTempo) :
CPage(sTempo),
m_iDateModifFichier(0)
{
   m_sFilePath = FICHIER_METEO;
}

CPageTemperature::CPageTemperature(const CPageTemperature& PageTemperature) :
CPage((CPage&) PageTemperature)
{
}

void CPageTemperature::PreloadImage()
{
   m_Image.font("Helvetica");
   m_Image.strokeColor("white");
   m_Image.fillColor("white");
   m_Image.fontPointsize(70);
}

void CPageTemperature::UpdateImage()
{
   if (this->VerifNouveauFichier())
   {
      std::ifstream ifsFichier(m_sFilePath.c_str(), std::ios::in);   // on ouvre en lecture
      std::string sLigne;
      
      if (ifsFichier)
      {
         while(std::getline(ifsFichier, sLigne))
         {
            if (sLigne.substr(0,12) == "Temperature=")
            {
               char buffer[6];
               sprintf(buffer, "%s°C", (sLigne.substr(12, sLigne.length()-12)).c_str());

               m_Image.erase();
               m_Image.annotate(buffer, Magick::NorthGravity);
            }
         }
         ifsFichier.close();
      }
      else
      {
         std::cerr << "Impossible d'ouvrir le fichier !" << std::endl;
      }
   }
}

bool CPageTemperature::VerifNouveauFichier()
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

