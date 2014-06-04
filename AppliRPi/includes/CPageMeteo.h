#ifndef CPAGEMETEO_H
#define CPAGEMETEO_H

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include "../includes/CPageTexte2.h"

class CPageMeteo : public CPageTexte2
{
   private :
   std::string m_sFilePath;
   int         m_iDateModifFichier;

   void UpdateImage();                                   // Mise à jour de l'image
   bool VerifNouveauFichier();
   
   public :
   CPageMeteo();                                         // Constructeur
   CPageMeteo(std::string sTempo, float fCoefRouge, float fCoefVert, float fCoefBleu);                       // Constructeur
   CPageMeteo(const CPageMeteo& PageMeteo);  // Constructeur de copie
};

#endif //CPAGEMETEO_H
