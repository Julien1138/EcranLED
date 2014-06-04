#include "../includes/CProgramme.h"
#include "../includes/CPageHeure.h"
#include "../includes/CPageTemperature.h"
#include "../includes/CPageImage.h"
#include "../includes/CPageTexte1.h"
#include "../includes/CPageTexte2.h"
#include "../includes/CPageMeteo.h"
#include "../includes/CPageDate.h"

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
         if (sLigne.substr(0,14) == "[Configuration")
         {
            while(std::getline(ifsFichier, sLigne) && (sLigne.size() != 0))
            {
               int iPosEgale = sLigne.find('=',0); // Cherche la position du signe égale
               mapParametres[sLigne.substr(0, iPosEgale)] = sLigne.substr(iPosEgale+1, sLigne.size() - iPosEgale+1); // Ajout d'un paramètre à la liste
            }
            
            m_ucLuminosite = strtol(mapParametres["Luminosite"].c_str(), NULL, 10);
            m_ucRouge1 = strtol(mapParametres["Rouge1"].c_str(), NULL, 10);
            m_ucVert1 = strtol(mapParametres["Vert1"].c_str(), NULL, 10);
            m_ucBleu1 = strtol(mapParametres["Bleu1"].c_str(), NULL, 10);
            m_ucRouge2 = strtol(mapParametres["Rouge2"].c_str(), NULL, 10);
            m_ucVert2 = strtol(mapParametres["Vert2"].c_str(), NULL, 10);
            m_ucBleu2 = strtol(mapParametres["Bleu2"].c_str(), NULL, 10);
            m_ucRouge3 = strtol(mapParametres["Rouge3"].c_str(), NULL, 10);
            m_ucVert3 = strtol(mapParametres["Vert3"].c_str(), NULL, 10);
            m_ucBleu3 = strtol(mapParametres["Bleu3"].c_str(), NULL, 10);
            m_ucRouge4 = strtol(mapParametres["Rouge4"].c_str(), NULL, 10);
            m_ucVert4 = strtol(mapParametres["Vert4"].c_str(), NULL, 10);
            m_ucBleu4 = strtol(mapParametres["Bleu4"].c_str(), NULL, 10);
            m_ucRouge5 = strtol(mapParametres["Rouge5"].c_str(), NULL, 10);
            m_ucVert5 = strtol(mapParametres["Vert5"].c_str(), NULL, 10);
            m_ucBleu5 = strtol(mapParametres["Bleu5"].c_str(), NULL, 10);
            m_ucRouge6 = strtol(mapParametres["Rouge6"].c_str(), NULL, 10);
            m_ucVert6 = strtol(mapParametres["Vert6"].c_str(), NULL, 10);
            m_ucBleu6 = strtol(mapParametres["Bleu6"].c_str(), NULL, 10);
         }
         else if (sLigne.substr(0,5) == "[Page")
         {
            while(std::getline(ifsFichier, sLigne) && (sLigne.size() != 0))
            {
               int iPosEgale = sLigne.find('=',0); // Cherche la position du signe égale
               mapParametres[sLigne.substr(0, iPosEgale)] = sLigne.substr(iPosEgale+1, sLigne.size() - iPosEgale+1); // Ajout d'un paramètre à la liste
            }
            
            // Choix de la classe en fonction du type
            if (mapParametres["Type"] == "Heure")
            {
               
               CPageHeure* Page = new CPageHeure(mapParametres["Tempo"],
                                                 strtol(mapParametres["Couleur"].substr(1,2).c_str(), NULL, 16),
                                                 strtol(mapParametres["Couleur"].substr(3,2).c_str(), NULL, 16),
                                                 strtol(mapParametres["Couleur"].substr(5,2).c_str(), NULL, 16),
                                                 mapParametres["Format"]);
               m_vectPages.push_back(Page);
            }
            else if (mapParametres["Type"] == "Temperature")
            {
               CPageTemperature* Page = new CPageTemperature(mapParametres["Tempo"],
                                                             strtol(mapParametres["Couleur"].substr(1,2).c_str(), NULL, 16),
                                                             strtol(mapParametres["Couleur"].substr(3,2).c_str(), NULL, 16),
                                                             strtol(mapParametres["Couleur"].substr(5,2).c_str(), NULL, 16));
               m_vectPages.push_back(Page);
            }
            else if (mapParametres["Type"] == "Image")
            {
               CPageImage* Page = new CPageImage(mapParametres["Tempo"],
                                                 mapParametres["Source"]);
               m_vectPages.push_back(Page);
            }
            else if (mapParametres["Type"] == "Texte1Ligne")
            {
               CPageTexte1* Page = new CPageTexte1(mapParametres["Tempo"],
                                                   strtol(mapParametres["Couleur"].substr(1,2).c_str(), NULL, 16),
                                                   strtol(mapParametres["Couleur"].substr(3,2).c_str(), NULL, 16),
                                                   strtol(mapParametres["Couleur"].substr(5,2).c_str(), NULL, 16),
                                                   mapParametres["Texte"]);
               m_vectPages.push_back(Page);
            }
            else if (mapParametres["Type"] == "Texte2Lignes")
            {
               CPageTexte2* Page = new CPageTexte2(mapParametres["Tempo"],
                                                   strtol(mapParametres["Couleur"].substr(1,2).c_str(), NULL, 16),
                                                   strtol(mapParametres["Couleur"].substr(3,2).c_str(), NULL, 16),
                                                   strtol(mapParametres["Couleur"].substr(5,2).c_str(), NULL, 16),
                                                   mapParametres["Texte1"],
                                                   mapParametres["Texte2"],
                                                   mapParametres["Defilement"]);
               m_vectPages.push_back(Page);
            }
            else if (mapParametres["Type"] == "Meteo")
            {
               CPageMeteo* Page = new CPageMeteo(mapParametres["Tempo"],
                                                 strtol(mapParametres["Couleur"].substr(1,2).c_str(), NULL, 16),
                                                 strtol(mapParametres["Couleur"].substr(3,2).c_str(), NULL, 16),
                                                 strtol(mapParametres["Couleur"].substr(5,2).c_str(), NULL, 16));
               m_vectPages.push_back(Page);
            }
            else if (mapParametres["Type"] == "Date")
            {
               CPageDate* Page = new CPageDate(mapParametres["Tempo"],
                                               strtol(mapParametres["Couleur"].substr(1,2).c_str(), NULL, 16),
                                               strtol(mapParametres["Couleur"].substr(3,2).c_str(), NULL, 16),
                                               strtol(mapParametres["Couleur"].substr(5,2).c_str(), NULL, 16));
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
         (*it)->Afficher(m_ucLuminosite,
                         m_ucRouge1, m_ucVert1, m_ucBleu1,
                         m_ucRouge2, m_ucVert2, m_ucBleu2,
                         m_ucRouge3, m_ucVert3, m_ucBleu3,
                         m_ucRouge4, m_ucVert4, m_ucBleu4,
                         m_ucRouge5, m_ucVert5, m_ucBleu5,
                         m_ucRouge6, m_ucVert6, m_ucBleu6);
      }
   }
}

