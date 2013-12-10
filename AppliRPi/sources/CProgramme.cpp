#include "../includes/CProgramme.h"

void CProgramme::Charger(std::string sFichier)
{
   std::ifstream ifsFichier(sFichier.c_str(), std::ios::in);  // on ouvre en lecture
   
   if (ifsFichier)
   {
      std::string sLigne;
      
      while(std::getline(ifsFichier, sLigne))
      {
         if (sLigne.substr(0,5) == "[Page")
         {
            m_vectPages.push_back(CPage());
            m_vectPages.back().Charger(&ifsFichier);
         }
      }
      
      ifsFichier.close();
   }
   else
   {
      std::cerr << "Impossible d'ouvrir le fichier !" << std::endl;
   }
   return;
}
