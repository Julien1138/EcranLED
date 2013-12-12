#include "../includes/CProgramme.h"
#include "../includes/CPageHeure.h"
#include "../includes/CPageTemperature.h"
#include "../includes/CPageImage.h"
#include "../includes/CPageTexte1.h"
#include "../includes/CPageTexte2.h"

CProgramme::~CProgramme()
{
   this->Vider();
}

void CProgramme::Charger(std::string sFichier)
{
   std::ifstream                       ifsFichier(sFichier.c_str(), std::ios::in);   // on ouvre en lecture
   std::map<std::string, std::string>  mapParametres;          // Liste associative des paramètres de la page
   std::string                         sLigne;
   
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
   return;
}

void CProgramme::Vider()
{
   while (!m_vectPages.empty())
   {
      delete m_vectPages.back();
      m_vectPages.pop_back();
   }
}

void CProgramme::Afficher()
{
   std::cout << "CProgramme::Afficher()" << std::endl;
   for (std::vector<CPage*>::iterator it = m_vectPages.begin(); it != m_vectPages.end(); it++)
   {
      std::cout << "Tempo : " << (*it)->GetTempo() << std::endl;
   }
}
