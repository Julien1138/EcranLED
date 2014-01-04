#ifndef CPAGETEXTE2_H
#define CPAGETEXTE2_H

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include "../includes/CPageTexte.h"

class CPageTexte2 : public CPageTexte
{
   private :
   std::string m_sTexte1;
   std::string m_sTexte2;
   bool        m_bDefilement;
   int         m_iLargeurLigne1;
   int         m_iLargeurLigne2;

   void UpdateImage();                                   // Mise à jour de l'image
   
   public :
   CPageTexte2();                                        // Constructeur
   CPageTexte2(std::string sTempo, float fCoefRouge, float fCoefVert, float fCoefBleu, std::string sTexte1, std::string sTexte2, std::string sDefilement);  // Constructeur
   CPageTexte2(const CPageTexte2& PageTexte2);           // Constructeur de copie

   void PreloadImage();                                  // Pré-chargement de l'image
};

#endif //CPAGETEXTE2_H
