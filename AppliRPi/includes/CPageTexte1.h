#ifndef CPAGETEXTE1_H
#define CPAGETEXTE1_H

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include "../includes/CPageTexte.h"

class CPageTexte1 : public CPageTexte
{
   protected :
   std::string m_sTexte;

   virtual void UpdateImage();                                   // Mise à jour de l'image
   
   public :
   CPageTexte1();                                        // Constructeur
   CPageTexte1(std::string sTempo, float fCoefRouge, float fCoefVert, float fCoefBleu, std::string sTexte);  // Constructeur
   CPageTexte1(const CPageTexte1& PageTexte1);           // Constructeur de copie

   virtual void PreloadImage();                                  // Pré-chargement de l'image
};

#endif //CPAGETEXTE1_H
