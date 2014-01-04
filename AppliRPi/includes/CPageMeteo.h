#ifndef CPAGEMETEO_H
#define CPAGEMETEO_H

#define FICHIER_ICON_METEO          "data/meteo_icon.png"
//#define FICHIER_ICON_HUMIDITE       "data/meteo_icon_humidite.png"
//#define FICHIER_ICON_VITESSE_VENT   "data/meteo_icon_vent.png"

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include "../includes/CPage.h"

class CPageMeteo : public CPage
{
   private :
   std::string m_sFilePath;
   int         m_iDateModifFichier;

   void UpdateImage();                       // Mise à jour de l'image
   bool VerifNouveauFichier();
   
   public :
   CPageMeteo();                             // Constructeur
   CPageMeteo(std::string sTempo);           // Constructeur
   CPageMeteo(const CPageMeteo& PageMeteo);  // Constructeur de copie

   void PreloadImage();                      // Pré-chargement de l'image de la page
};

#endif //CPAGEMETEO_H
