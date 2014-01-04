#include "../includes/CPageTexte.h"

#include <sys/time.h>
#include <unistd.h>

CPageTexte::CPageTexte() :
CPage(),
m_fCoefRouge(255.0),
m_fCoefVert(255.0),
m_fCoefBleu(255.0)
{
}

CPageTexte::CPageTexte(std::string sTempo, float fCoefRouge, float fCoefVert, float fCoefBleu) :
CPage(sTempo),
m_fCoefRouge(fCoefRouge),
m_fCoefVert(fCoefVert),
m_fCoefBleu(fCoefBleu)
{
}

CPageTexte::CPageTexte(const CPageTexte& PageTexte) :
CPage((CPage&) PageTexte),
m_fCoefRouge(255.0),
m_fCoefVert(255.0),
m_fCoefBleu(255.0)
{
}

CPageTexte::~CPageTexte()
{
}

void CPageTexte::EnvoiImage()
{
   unsigned char tx[1024];
   unsigned int idx(0);

// Ligne d'entête
   tx[idx++] = 0xA2; // Header
   tx[idx++] = 0x00; // Ligne 0
   tx[idx++] = 0xFF; // Luminosité

   tx[idx++] = 0xFF; // Coefficient rouge Ecran 1
   tx[idx++] = 0x80; // Coefficient vert Ecran 1
   tx[idx++] = 0x60; // Coefficient bleu Ecran 1

   tx[idx++] = 0x2A; // Coefficient rouge Ecran 2
   tx[idx++] = 0x28; // Coefficient vert Ecran 2
   tx[idx++] = 0x17; // Coefficient bleu Ecran 2

   tx[idx++] = 0x2A; // Coefficient rouge Ecran 3
   tx[idx++] = 0x28; // Coefficient vert Ecran 3
   tx[idx++] = 0x17; // Coefficient bleu Ecran 3

   tx[idx++] = 0x2A; // Coefficient rouge Ecran 4
   tx[idx++] = 0x28; // Coefficient vert Ecran 4
   tx[idx++] = 0x17; // Coefficient bleu Ecran 4

   tx[idx++] = 0x2A; // Coefficient rouge Ecran 5
   tx[idx++] = 0x28; // Coefficient vert Ecran 5
   tx[idx++] = 0x17; // Coefficient bleu Ecran 5

   tx[idx++] = 0x2A; // Coefficient rouge Ecran 6
   tx[idx++] = 0x28; // Coefficient vert Ecran 6
   tx[idx++] = 0x17; // Coefficient bleu Ecran 6
   m_pSPI->Envoi((unsigned char*) &tx, 2+3*192);

// Image
   m_pPixels = m_Image.getPixels(0, 0, 192, 56);
   for ( ssize_t row = 1; row < 57 ; row++ )
   {
      idx = 0;
      tx[idx++] = 0xA2; // Header
      tx[idx++] = (unsigned char) row;
      for ( ssize_t column = 0; column < 192 ; column++ )
      {
         Magick::ColorRGB RGB(*m_pPixels++);
         tx[idx++] = (unsigned char) (RGB.red()*m_fCoefRouge); // Rouge
         tx[idx++] = (unsigned char) (RGB.red()*m_fCoefVert); // Vert
         tx[idx++] = (unsigned char) (RGB.red()*m_fCoefBleu); // Bleu
      }
      m_pSPI->Envoi((unsigned char*) &tx, 2+3*192);
   }
}

