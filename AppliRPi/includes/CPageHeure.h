#ifndef CPAGEHEURE_H
#define CPAGEHEURE_H

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include "../includes/CPage.h"

class CPageHeure : public CPage
{
   private :
   bool m_bFormat24H;
   
   public :
   CPageHeure();                                         // Constructeur
   CPageHeure(std::string sTempo, std::string sFormat);  // Constructeur
   CPageHeure(const CPageHeure& PageHeure);              // Constructeur de copie
};

#endif //CPAGEHEURE_H
