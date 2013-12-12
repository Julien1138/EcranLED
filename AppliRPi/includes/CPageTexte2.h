#ifndef CPAGETEXTE2_H
#define CPAGETEXTE2_H

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include "../includes/CPage.h"

class CPageTexte2 : public CPage
{
   private :
   std::string m_sTexte1;
   std::string m_sTexte2;
   bool        m_bDefilement;
   
   public :
   CPageTexte2();                                        // Constructeur
   CPageTexte2(std::string sTempo, std::string sTexte1, std::string sTexte2, std::string sDefilement);  // Constructeur
   CPageTexte2(const CPageTexte2& PageTexte2);           // Constructeur de copie
};

#endif //CPAGETEXTE2_H
