#ifndef CPAGETEMPERATURE_H
#define CPAGETEMPERATURE_H

#define FICHIER_METEO "data/meteo.txt"

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include "../includes/CPageTexte1.h"

class CPageTemperature : public CPageTexte1
{
   private :
   std::string m_sFilePath;
   int         m_iDateModifFichier;

   void UpdateImage();                                   // Mise à jour de l'image
   bool VerifNouveauFichier();
   
   public :
   CPageTemperature();                                         // Constructeur
   CPageTemperature(std::string sTempo, float fCoefRouge, float fCoefVert, float fCoefBleu);                       // Constructeur
   CPageTemperature(const CPageTemperature& PageTemperature);  // Constructeur de copie
};

#endif //CPAGETEMPERATURE_H
