#ifndef CPAGETEXTE1_H
#define CPAGETEXTE1_H

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include "../includes/CPage.h"

class CPageTexte1 : public CPage
{
   private :
   std::string m_sTexte;
   
   public :
   CPageTexte1();                                        // Constructeur
   CPageTexte1(std::string sTempo, std::string sTexte);  // Constructeur
   CPageTexte1(const CPageTexte1& PageTexte1);           // Constructeur de copie

   void PreloadImage();                                  // Pré-chargement de l'image
   void UpdateImage();                                   // Mise à jour de l'image
};

#endif //CPAGETEXTE1_H
