#ifndef CPAGEDATE_H
#define CPAGEDATE_H

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include <time.h>
#include "../includes/CPageTexte2.h"

class CPageDate : public CPageTexte2
{
   private :
   int m_iDerniereHeure;                                 // Dernière valeur des heures de l'heure locale

   void UpdateImage();                                   // Mise à jour de l'image
   
   public :
   CPageDate();                                         // Constructeur
   CPageDate(std::string sTempo, float fCoefRouge, float fCoefVert, float fCoefBleu);  // Constructeur
   CPageDate(const CPageDate& PageDate);              // Constructeur de copie
};

#endif //CPAGEDATE_H
