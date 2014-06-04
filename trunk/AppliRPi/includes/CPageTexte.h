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
   
   void EnvoiImage(unsigned char ucLuminosite,
                       unsigned char ucRouge1, unsigned char ucVert1, unsigned char ucBleu1,
                       unsigned char ucRouge2, unsigned char ucVert2, unsigned char ucBleu2,
                       unsigned char ucRouge3, unsigned char ucVert3, unsigned char ucBleu3,
                       unsigned char ucRouge4, unsigned char ucVert4, unsigned char ucBleu4,
                       unsigned char ucRouge5, unsigned char ucVert5, unsigned char ucBleu5,
                       unsigned char ucRouge6, unsigned char ucVert6, unsigned char ucBleu6);                        // Envoi de l'image sur le lien SPI
   virtual void UpdateImage() = 0;           // Mise à jour de l'image de la page
   
   public :
   CPageTexte();
   virtual ~CPageTexte();
   CPageTexte(std::string sTempo, float fCoefRouge, float fCoefVert, float fCoefBleu);
   CPageTexte(const CPageTexte& PageTexte);

   virtual void PreloadImage() = 0;          // Pré-chargement de l'image de la page
};

#endif //CPAGETEXTE_H
