#ifndef CPAGE_H
#define CPAGE_H

#define FICHIER_METEO "data/meteo.txt"

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include <Magick++.h>

#include "CSPI.h"

#define CPAGE_RESOLUTION_US   40000   // 25 images par seconde

class CPage
{
   protected :
   float m_fTempo;      // Durée d'affichage de la page
   Magick::Image m_Image; // Image de la page
   Magick::PixelPacket * m_pPixels; // Image bas niveau
   CSPI* m_pSPI;
   
   virtual void EnvoiImage(unsigned char ucLuminosite,
                       unsigned char ucRouge1, unsigned char ucVert1, unsigned char ucBleu1,
                       unsigned char ucRouge2, unsigned char ucVert2, unsigned char ucBleu2,
                       unsigned char ucRouge3, unsigned char ucVert3, unsigned char ucBleu3,
                       unsigned char ucRouge4, unsigned char ucVert4, unsigned char ucBleu4,
                       unsigned char ucRouge5, unsigned char ucVert5, unsigned char ucBleu5,
                       unsigned char ucRouge6, unsigned char ucVert6, unsigned char ucBleu6);                        // Envoi de l'image sur le lien SPI
   virtual void UpdateImage() = 0;           // Mise à jour de l'image de la page
   
   public :
   CPage();
   virtual ~CPage();
   CPage(std::string sTempo);
   CPage(const CPage& Page);

   virtual void PreloadImage() = 0;          // Pré-chargement de l'image de la page
   void Afficher(unsigned char ucLuminosite,
                       unsigned char ucRouge1, unsigned char ucVert1, unsigned char ucBleu1,
                       unsigned char ucRouge2, unsigned char ucVert2, unsigned char ucBleu2,
                       unsigned char ucRouge3, unsigned char ucVert3, unsigned char ucBleu3,
                       unsigned char ucRouge4, unsigned char ucVert4, unsigned char ucBleu4,
                       unsigned char ucRouge5, unsigned char ucVert5, unsigned char ucBleu5,
                       unsigned char ucRouge6, unsigned char ucVert6, unsigned char ucBleu6);                  // Affichage de la page

   float GetTempo();                         // Accès au paramètre Tempo
   Magick::Image* GetpImage();
};

#endif //CPAGE_H
