#ifndef CPAGEHEURE_H
#define CPAGEHEURE_H

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include <time.h>
#include "../includes/CPage.h"

class CPageHeure : public CPage
{
   private :
   bool m_bFormat24H;
   int m_iDerniereSeconde;  // Dernière valeur des secondes de l'heure locale
   
   public :
   CPageHeure();                                         // Constructeur
   CPageHeure(std::string sTempo, std::string sFormat);  // Constructeur
   CPageHeure(const CPageHeure& PageHeure);              // Constructeur de copie

   void PreloadImage();                                  // Pré-chargement de l'image
   void UpdateImage();                                   // Mise à jour de l'image
};

#endif //CPAGEHEURE_H
