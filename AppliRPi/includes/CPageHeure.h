#ifndef CPAGEHEURE_H
#define CPAGEHEURE_H

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include <time.h>
#include "../includes/CPageTexte1.h"

class CPageHeure : public CPageTexte1
{
   private :
   bool m_bFormat24H;
   int m_iDerniereSeconde;  // Dernière valeur des secondes de l'heure locale

   void UpdateImage();                                   // Mise à jour de l'image
   
   public :
   CPageHeure();                                         // Constructeur
   CPageHeure(std::string sTempo, float fCoefRouge, float fCoefVert, float fCoefBleu, std::string sFormat);  // Constructeur
   CPageHeure(const CPageHeure& PageHeure);              // Constructeur de copie
};

#endif //CPAGEHEURE_H
