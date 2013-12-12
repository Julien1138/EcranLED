#ifndef CPAGE_H
#define CPAGE_H

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>

class CPage
{
   protected :
   float m_fTempo;   // Dur�e d'affichage de la page
   // Image
   
   public :
   CPage();
   CPage(std::string sTempo);
   CPage(const CPage& Page);
   void  Charger(std::ifstream* ifsFichier); // Chargement des param�tres de la page depuis un fichier
   void  UpdateImage();                      // Mise � jour de l'image de la page
   float GetTempo();                         // Acc�s au param�tre Tempo
};

#endif //CPAGE_H
