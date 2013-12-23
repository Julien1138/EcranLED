#ifndef CPAGE_H
#define CPAGE_H

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>
#include <Magick++.h>

#define CPAGE_RESOLUTION_US   100000   // 10 images par seconde

class CPage
{
   protected :
   float m_fTempo;      // Dur�e d'affichage de la page
   Magick::Image m_Image; // Image de la page
   Magick::PixelPacket * m_pPixels; // Image bas niveau
   
   void EnvoiImage();                        // Envoi de l'image sur le lien SPI
   virtual void UpdateImage() = 0;           // Mise � jour de l'image de la page
   
   public :
   CPage();
   ~CPage();
   CPage(std::string sTempo);
   CPage(const CPage& Page);

   virtual void PreloadImage() = 0;          // Pr�-chargement de l'image de la page
   void Afficher();                          // Affichage de la page

   float GetTempo();                         // Acc�s au param�tre Tempo
   Magick::Image* GetpImage();
};

#endif //CPAGE_H
