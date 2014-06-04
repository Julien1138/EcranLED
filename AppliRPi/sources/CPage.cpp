#include "../includes/CPage.h"

#include <sys/time.h>
#include <unistd.h>

CPage::CPage() :
m_fTempo(1.0),
m_Image(Magick::Geometry(192, 56), Magick::Color("black"))
{
   m_Image.backgroundColor(Magick::Color("black"));
   m_pSPI = new CSPI;
}

CPage::CPage(std::string sTempo) :
m_Image(Magick::Geometry(192, 56), Magick::Color("black"))
{
   m_Image.backgroundColor(Magick::Color("black"));
   std::stringstream ssTempo(sTempo);
   ssTempo >> m_fTempo;
   m_pSPI = new CSPI;
}

CPage::CPage(const CPage& Page) :
m_fTempo(Page.m_fTempo),
m_Image(Magick::Geometry(192, 56), Magick::Color("black"))
{
   m_Image.backgroundColor(Magick::Color("black"));
   m_pSPI = new CSPI;
}

CPage::~CPage()
{
   delete m_pSPI;
}

void CPage::EnvoiImage(unsigned char ucLuminosite,
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
         Magick::ColorRGB Color(*m_pPixels++);
         tx[idx++] = (unsigned char) (Color.red()*255.0);
         tx[idx++] = (unsigned char) (Color.green()*255.0);
         tx[idx++] = (unsigned char) (Color.blue()*255.0);
      }
      m_pSPI->Envoi((unsigned char*) &tx, 2+3*192);
   }
}

void CPage::Afficher(unsigned char ucLuminosite,
                       unsigned char ucRouge1, unsigned char ucVert1, unsigned char ucBleu1,
                       unsigned char ucRouge2, unsigned char ucVert2, unsigned char ucBleu2,
                       unsigned char ucRouge3, unsigned char ucVert3, unsigned char ucBleu3,
                       unsigned char ucRouge4, unsigned char ucVert4, unsigned char ucBleu4,
                       unsigned char ucRouge5, unsigned char ucVert5, unsigned char ucBleu5,
                       unsigned char ucRouge6, unsigned char ucVert6, unsigned char ucBleu6)
{
   struct timeval StopTime, CurTime;
   unsigned int PrevSchedule, NextSchedule;
   
   gettimeofday(&StopTime, NULL);
   StopTime.tv_usec += ((unsigned int) (m_fTempo*1000000.0)) % 1000000;
   StopTime.tv_sec += (unsigned int) (m_fTempo);
   if (StopTime.tv_usec > 1000000)
   {
      StopTime.tv_sec += 1;
   }
   StopTime.tv_usec = StopTime.tv_usec % 1000000;

   gettimeofday(&CurTime, NULL);
   PrevSchedule = CurTime.tv_usec;
   NextSchedule = (CurTime.tv_usec + CPAGE_RESOLUTION_US) % 1000000;
   
   while (!(CurTime.tv_sec >= StopTime.tv_sec and CurTime.tv_usec >= StopTime.tv_usec))
   {
      gettimeofday(&CurTime, NULL);
      if (NextSchedule > PrevSchedule)
      {
         if (((unsigned int)(CurTime.tv_usec) > PrevSchedule) && 
         ((unsigned int)(CurTime.tv_usec) < NextSchedule))
         {
            this->UpdateImage();
            this->EnvoiImage(ucLuminosite,
                             ucRouge1, ucVert1, ucBleu1,
                             ucRouge2, ucVert2, ucBleu2,
                             ucRouge3, ucVert3, ucBleu3,
                             ucRouge4, ucVert4, ucBleu4,
                             ucRouge5, ucVert5, ucBleu5,
                             ucRouge6, ucVert6, ucBleu6);
            PrevSchedule = (PrevSchedule + CPAGE_RESOLUTION_US) % 1000000;
            NextSchedule = (NextSchedule + CPAGE_RESOLUTION_US) % 1000000;
         }
      }
      else
      {
         if (((unsigned int)(CurTime.tv_usec) > PrevSchedule) || 
         ((unsigned int)(CurTime.tv_usec) < NextSchedule))
         {
            this->UpdateImage();
            this->EnvoiImage(ucLuminosite,
                             ucRouge1, ucVert1, ucBleu1,
                             ucRouge2, ucVert2, ucBleu2,
                             ucRouge3, ucVert3, ucBleu3,
                             ucRouge4, ucVert4, ucBleu4,
                             ucRouge5, ucVert5, ucBleu5,
                             ucRouge6, ucVert6, ucBleu6);
            PrevSchedule = (PrevSchedule + CPAGE_RESOLUTION_US) % 1000000;
            NextSchedule = (NextSchedule + CPAGE_RESOLUTION_US) % 1000000;
         }
      }
      usleep(CPAGE_RESOLUTION_US/10);
   }
}

float CPage::GetTempo()
{
   return m_fTempo;
}

Magick::Image* CPage::GetpImage()
{
   return &m_Image;
}

