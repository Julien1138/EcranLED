#include "../includes/CPageTemperature.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

CPageTemperature::CPageTemperature() :
CPageTexte1(),
m_iDateModifFichier(0)
{
   m_sFilePath = FICHIER_METEO;
}

CPageTemperature::CPageTemperature(std::string sTempo, float fCoefRouge, float fCoefVert, float fCoefBleu) :
CPageTexte1(sTempo, fCoefRouge, fCoefVert, fCoefBleu, ""),
m_iDateModifFichier(0)
{
   m_sFilePath = FICHIER_METEO;
}

CPageTemperature::CPageTemperature(const CPageTemperature& PageTemperature) :
CPageTexte1((CPageTexte1&) PageTemperature)
{
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
               m_Image.annotate(buffer, Magick::CenterGravity);
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

