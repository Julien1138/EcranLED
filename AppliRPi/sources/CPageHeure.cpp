#include "../includes/CPageHeure.h"
#include <time.h>

CPageHeure::CPageHeure() :
CPage(),
m_bFormat24H(true)
{
}

CPageHeure::CPageHeure(std::string sTempo, std::string sFormat) :
CPage(sTempo),
m_bFormat24H(sFormat == "24H")
{
}

CPageHeure::CPageHeure(const CPageHeure& PageHeure) :
CPage((CPage&) PageHeure),
m_bFormat24H(PageHeure.m_bFormat24H)
{
}

/*
void CPageHeure::UpdateImage()
{
   time_t tHeure = time(NULL); // t contient maintenant la date et l'heure courante
   char buffer[6];
   if (m_mapParametres["Format"] == "24H")
   {
      strftime(buffer, sizeof(buffer), "%H:%M", localtime(&tHeure));
      // strftime(buffer, sizeof(buffer), "%H:%M", gmtime(&tHeure));
   }
   else
   {
      strftime(buffer, sizeof(buffer), "%I:%M", localtime(&tHeure));
      // strftime(buffer, sizeof(buffer), "%I:%M", gmtime(&tHeure));
   }
   std::cout << "UpdateImageHeure();" << std::endl;
   std::cout << buffer << std::endl;
   std::cout << "Tempo = " << this->m_fTempo << " secondes" << std::endl;
}
*/
