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

void CPageTexte::EnvoiImage(unsigned char ucLuminosite,
                       unsigned char ucRouge1, unsigned char ucVert1, unsigned char ucBleu1,
                       unsigned char ucRouge2, unsigned char ucVert2, unsigned char ucBleu2,
                       unsigned char ucRouge3, unsigned char ucVert3, unsigned char ucBleu3,
                       unsigned char ucRouge4, unsigned char ucVert4, unsigned char ucBleu4,
                       unsigned char ucRouge5, unsigned char ucVert5, unsigned char ucBleu5,
                       unsigned char ucRouge6, unsigned char ucVert6, unsigned char ucBleu6)
{
   unsigned char tx[1024];
   unsigned int idx(0);

// Ligne d'entête
   tx[idx++] = 0xA2; // Header
   tx[idx++] = 0x00; // Ligne 0
   tx[idx++] = ucLuminosite; // Luminosité

   tx[idx++] = ucRouge1; // Coefficient rouge Ecran 1
   tx[idx++] = ucVert1; // Coefficient vert Ecran 1
   tx[idx++] = ucBleu1; // Coefficient bleu Ecran 1

   tx[idx++] = ucRouge2; // Coefficient rouge Ecran 2
   tx[idx++] = ucVert2; // Coefficient vert Ecran 2
   tx[idx++] = ucBleu2; // Coefficient bleu Ecran 2

   tx[idx++] = ucRouge3; // Coefficient rouge Ecran 3
   tx[idx++] = ucVert3; // Coefficient vert Ecran 3
   tx[idx++] = ucBleu3; // Coefficient bleu Ecran 3

   tx[idx++] = ucRouge4; // Coefficient rouge Ecran 4
   tx[idx++] = ucVert4; // Coefficient vert Ecran 4
   tx[idx++] = ucBleu4; // Coefficient bleu Ecran 4

   tx[idx++] = ucRouge5; // Coefficient rouge Ecran 5
   tx[idx++] = ucVert5; // Coefficient vert Ecran 5
   tx[idx++] = ucBleu5; // Coefficient bleu Ecran 5

   tx[idx++] = ucRouge6; // Coefficient rouge Ecran 6
   tx[idx++] = ucVert6; // Coefficient vert Ecran 6
   tx[idx++] = ucBleu6; // Coefficient bleu Ecran 6
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

