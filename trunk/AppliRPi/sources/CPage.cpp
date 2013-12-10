#include "../includes/CPage.h"

void CPage::Charger(std::ifstream* ifsFichier)
{
   std::string sLigne;
   
   while(std::getline(*ifsFichier, sLigne) && (sLigne.size() != 0))
   {
      int iPosEgale = sLigne.find('=',0); // Cherche la position du signe égale
      m_mapParametres[sLigne.substr(0, iPosEgale)] = sLigne.substr(iPosEgale+1, sLigne.size() - iPosEgale+1);  // Ajout d'un paramètre à la liste
   }
   
   UpdateImage();
   
   return;
}

void CPage::UpdateImage()
{
   if (m_mapParametres["Type"] == "Heure")
   {
         UpdateImageHeure();
   }
   else if (m_mapParametres["Type"] == "Temperature")
   {
         UpdateImageTemp();
   }
   else if (m_mapParametres["Type"] == "Image")
   {
         UpdateImageImage();
   }
   else if (m_mapParametres["Type"] == "Texte1Ligne")
   {
         UpdateImageTexte1();
   }
   else if (m_mapParametres["Type"] == "Texte2Lignes")
   {
         UpdateImageTexte2();
   }
   return;
}

void CPage::UpdateImageHeure()
{
   std::cout << "UpdateImageHeure();" << std::endl;
   std::cout << "Tempo = " << this->GetTempo() << " secondes" << std::endl;
}

void CPage::UpdateImageTemp()
{
   std::cout << "UpdateImageTemp();" << std::endl;
   std::cout << "Tempo = " << this->GetTempo() << " secondes" << std::endl;
}

void CPage::UpdateImageImage()
{
   std::cout << "UpdateImageImage();" << std::endl;
   std::cout << "Tempo = " << this->GetTempo() << " secondes" << std::endl;
}

void CPage::UpdateImageTexte1()
{
   std::cout << "UpdateImageTexte1();" << std::endl;
   std::cout << "Tempo = " << this->GetTempo() << " secondes" << std::endl;
}

void CPage::UpdateImageTexte2()
{
   std::cout << "UpdateImageTexte2();" << std::endl;
   std::cout << "Tempo = " << this->GetTempo() << " secondes" << std::endl;
}

float CPage::GetTempo()
{
   if (m_mapParametres.find("Tempo") == m_mapParametres.end())
   {
      return 0.0;
   }
   else
   {
      std::stringstream ssTempo(m_mapParametres["Tempo"]);
      float fTempo;
      
      ssTempo >> fTempo;
      
      return fTempo;
   }
}
