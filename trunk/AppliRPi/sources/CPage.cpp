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
   //delete m_pPixels;
   delete m_pSPI;
}

void CPage::EnvoiImage()
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
         tx[idx++] = (unsigned char) (RGB.red()*255.0);
         tx[idx++] = (unsigned char) (RGB.green()*255.0);
         tx[idx++] = (unsigned char) (RGB.blue()*255.0);
      }
      m_pSPI->Envoi((unsigned char*) &tx, 2+3*192);
   }
}

void CPage::Afficher()
{
   struct timeval StopTime;
   struct timeval CurTime;
   unsigned int PrevSchedule(0);
   unsigned int NextSchedule(CPAGE_RESOLUTION_US);
   
   gettimeofday(&StopTime, NULL);
   StopTime.tv_usec += ((unsigned int) (m_fTempo*1000000.0)) % 1000000;
   StopTime.tv_sec += (unsigned int) (m_fTempo);
   if (StopTime.tv_usec > 1000000)
   {
      StopTime.tv_sec += 1;
   }
   StopTime.tv_usec = StopTime.tv_usec % 1000000;
   gettimeofday(&CurTime, NULL);
   
   while (!(CurTime.tv_sec >= StopTime.tv_sec and CurTime.tv_usec >= StopTime.tv_usec))
   {
      gettimeofday(&CurTime, NULL);
      if (NextSchedule > PrevSchedule)
      {
         if (((unsigned int)(CurTime.tv_usec) > PrevSchedule) && 
         ((unsigned int)(CurTime.tv_usec) < NextSchedule))
         {
            this->UpdateImage();
            this->EnvoiImage();
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
            this->EnvoiImage();
            PrevSchedule = (PrevSchedule + CPAGE_RESOLUTION_US) % 1000000;
            NextSchedule = (NextSchedule + CPAGE_RESOLUTION_US) % 1000000;
         }
      }
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

