#include "../includes/CProgramme.h"
#include "../includes/CPageHeure.h"
#include "../includes/CPageTemperature.h"
#include "../includes/CPageImage.h"
#include "../includes/CPageTexte1.h"
#include "../includes/CPageTexte2.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include <Magick++.h>

CProgramme::CProgramme(std::string sFichier)
{
   m_iDateModifFichier = 0;
   m_sFilePath = sFichier.c_str();
}

CProgramme::~CProgramme()
{
   this->Vider();
}

void CProgramme::Charger()
{
   std::ifstream ifsFichier(m_sFilePath.c_str(), std::ios::in);   // on ouvre en lecture
   std::map<std::string, std::string> mapParametres;          // Liste associative des paramètres de la page
   std::string sLigne;
   
   if (ifsFichier)
   {
      this->Vider();
      while(std::getline(ifsFichier, sLigne))
      {
         if (sLigne.substr(0,5) == "[Page")
         {
            while(std::getline(ifsFichier, sLigne) && (sLigne.size() != 0))
            {
               int iPosEgale = sLigne.find('=',0); // Cherche la position du signe égale
               mapParametres[sLigne.substr(0, iPosEgale)] = sLigne.substr(iPosEgale+1, sLigne.size() - iPosEgale+1); // Ajout d'un paramètre à la liste
            }
            
            // Choix de la classe en fonction du type
            if (mapParametres["Type"] == "Heure")
            {
               CPageHeure* Page = new CPageHeure(mapParametres["Tempo"], mapParametres["Format"]);
               m_vectPages.push_back(Page);
            }
            else if (mapParametres["Type"] == "Temperature")
            {
               CPageTemperature* Page = new CPageTemperature(mapParametres["Tempo"]);
               m_vectPages.push_back(Page);
            }
            else if (mapParametres["Type"] == "Image")
            {
               CPageImage* Page = new CPageImage(mapParametres["Tempo"], mapParametres["Source"]);
               m_vectPages.push_back(Page);
            }
            else if (mapParametres["Type"] == "Texte1Ligne")
            {
               CPageTexte1* Page = new CPageTexte1(mapParametres["Tempo"], mapParametres["Texte"]);
               m_vectPages.push_back(Page);
            }
            else if (mapParametres["Type"] == "Texte2Lignes")
            {
               CPageTexte2* Page = new CPageTexte2(mapParametres["Tempo"], mapParametres["Texte1"], mapParametres["Texte2"], mapParametres["Defilement"]);
               m_vectPages.push_back(Page);
            }
         }
      }
      
      ifsFichier.close();
   }
   else
   {
      std::cerr << "Impossible d'ouvrir le fichier !" << std::endl;
   }
   
   // Préchargement des images
   for (std::vector<CPage*>::iterator it = m_vectPages.begin(); it != m_vectPages.end(); it++)
   {
      (*it)->PreloadImage();
   }
}

void CProgramme::Vider()
{
   while (!m_vectPages.empty())
   {
      delete m_vectPages.back();
      m_vectPages.pop_back();
   }
}

bool CProgramme::VerifNouvelleConfig()
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

void CProgramme::Afficher()
{
   while(true)
   {
      if (this->VerifNouvelleConfig())
      {
         this->Charger();
      }
      
      for (std::vector<CPage*>::iterator it = m_vectPages.begin(); it != m_vectPages.end(); it++)
      {
         (*it)->Afficher();
      }
   }
}

