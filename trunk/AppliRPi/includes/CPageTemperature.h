#ifndef CPAGETEMPERATURE_H
#define CPAGETEMPERATURE_H

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include "../includes/CPage.h"

class CPageTemperature : public CPage
{
   private :
   
   public :
   CPageTemperature();                                         // Constructeur
   CPageTemperature(std::string sTempo);                       // Constructeur
   CPageTemperature(const CPageTemperature& PageTemperature);  // Constructeur de copie
};

#endif //CPAGETEMPERATURE_H
