#ifndef CPAGETEXTE_H
#define CPAGETEXTE_H

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include <Magick++.h>

#include "CPage.h"

#define CPAGE_RESOLUTION_US   40000   // 25 images par seconde

class CPageTexte : public CPage
{
   protected :
   float m_fCoefRouge;  // Entre 0.0 et 255.0
   float m_fCoefVert;   // Entre 0.0 et 255.0
   float m_fCoefBleu;   // Entre 0.0 et 255.0   
   
   void EnvoiImage();                        // Envoi de l'image sur le lien SPI
   virtual void UpdateImage() = 0;           // Mise à jour de l'image de la page
   
   public :
   CPageTexte();
   virtual ~CPageTexte();
   CPageTexte(std::string sTempo, float fCoefRouge, float fCoefVert, float fCoefBleu);
   CPageTexte(const CPageTexte& PageTexte);

   virtual void PreloadImage() = 0;          // Pré-chargement de l'image de la page
};

#endif //CPAGETEXTE_H
