#ifndef CPROGRAMME_H
#define CPROGRAMME_H

#include <string>
#include <vector>
#include <fstream>
#include <iostream>
#include "../includes/CPage.h"

class CProgramme
{
   private :
   std::string          m_sFilePath;
   std::vector<CPage*>  m_vectPages;   // Tableau de pages
   int                  m_iDateModifFichier;
   
   void Charger();   // Chargement des paramètres de la page depuis le fichier
   void Vider();
   bool VerifNouvelleConfig();
   
   public :
   CProgramme(std::string sFichier);
   ~CProgramme();
   void Afficher();
};

#endif //CPROGRAMME_H
