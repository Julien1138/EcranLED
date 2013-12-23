#include "../includes/CPage.h"

#include <sys/time.h>
#include <unistd.h>

CPage::CPage() :
m_fTempo(1.0),
m_Image(Magick::Geometry(192, 56), Magick::Color("black"))
{
   m_Image.backgroundColor(Magick::Color("black"));
}

CPage::CPage(std::string sTempo) :
m_Image(Magick::Geometry(192, 56), Magick::Color("black"))
{
   m_Image.backgroundColor(Magick::Color("black"));
   std::stringstream ssTempo(sTempo);
   ssTempo >> m_fTempo;
}

CPage::CPage(const CPage& Page) :
m_fTempo(Page.m_fTempo),
m_Image(Magick::Geometry(192, 56), Magick::Color("black"))
{
   m_Image.backgroundColor(Magick::Color("black"));
}

CPage::~CPage()
{
}

void CPage::EnvoiImage()
{
   m_pPixels = m_Image.getPixels(0, 0, 192, 56);
   for ( ssize_t row = 0; row < 192 ; row++ )
   {
      for ( ssize_t column = 0; column < 56 ; column++ )
      {
         Magick::ColorRGB RGB(*m_pPixels++);
         // std::cout << RGB.red() << " / "; double entre 0 et 1
         // ((int) RGB.green);
         // ((int) RGB.blue);
      }
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

