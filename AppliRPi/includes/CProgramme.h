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
   std::vector<CPage*>   m_vectPages;   // Tableau de pages
   void Vider();
   
   public :
   ~CProgramme();
   void Charger(std::string sFichier);  // Chargement des paramètres de la page depuis un fichier
   void Afficher();
};

#endif //CPROGRAMME_H
