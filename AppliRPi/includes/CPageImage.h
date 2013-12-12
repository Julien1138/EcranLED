#ifndef CPAGEIMAGE_H
#define CPAGEIMAGE_H

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include "../includes/CPage.h"

class CPageImage : public CPage
{
   private :
   
   public :
   CPageImage();                                         // Constructeur
   CPageImage(std::string sTempo, std::string sSource);  // Constructeur
   CPageImage(const CPageImage& PageImage);              // Constructeur de copie
};

#endif //CPAGEIMAGE_H
