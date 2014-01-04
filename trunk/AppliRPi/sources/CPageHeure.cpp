#include "../includes/CPageHeure.h"

CPageHeure::CPageHeure() :
CPageTexte1(),
m_bFormat24H(true),
m_iDerniereSeconde(61)
{
}

CPageHeure::CPageHeure(std::string sTempo, float fCoefRouge, float fCoefVert, float fCoefBleu, std::string sFormat) :
CPageTexte1(sTempo, fCoefRouge, fCoefVert, fCoefBleu, ""),
m_bFormat24H(sFormat == "24H"),
m_iDerniereSeconde(61)
{
}

CPageHeure::CPageHeure(const CPageHeure& PageHeure) :
CPageTexte1((CPageTexte1&) PageHeure),
m_bFormat24H(PageHeure.m_bFormat24H),
m_iDerniereSeconde(PageHeure.m_iDerniereSeconde)
{
}

void CPageHeure::UpdateImage()
{
   time_t tHeure = time(NULL); // tHeure contient maintenant la date et l'heure courante

   if (localtime(&tHeure)->tm_sec < m_iDerniereSeconde) // Changement de minute
   {
      char buffer[6];
      if (m_bFormat24H)
      {
         strftime(buffer, sizeof(buffer), "%H:%M", localtime(&tHeure));
      }
      else
      {
         strftime(buffer, sizeof(buffer), "%I:%M", localtime(&tHeure));
      }

      m_Image.erase();
      m_Image.annotate(buffer, Magick::CenterGravity);
   }

   m_iDerniereSeconde = localtime(&tHeure)->tm_sec;
}
