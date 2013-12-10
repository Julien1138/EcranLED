#ifndef CPAGE_H
#define CPAGE_H

#include <string>
#include <map>
#include <sstream>
#include <iostream>
#include <fstream>

class CPage
{
   private :
                                                         // Image
   std::map<std::string, std::string>  m_mapParametres;  // Liste associative des paramètres de la page
   
   void  UpdateImageHeure();   // Mise à jour de l'image de la page de type Heure
   void  UpdateImageTemp();    // Mise à jour de l'image de la page de type Temperature
   void  UpdateImageImage();   // Mise à jour de l'image de la page de type Image
   void  UpdateImageTexte1();  // Mise à jour de l'image de la page de type Texte1Ligne
   void  UpdateImageTexte2();  // Mise à jour de l'image de la page de type Texte2Lignes
   
   public :
   void  Charger(std::ifstream* ifsFichier);  // Chargement des paramètres de la page depuis un fichier
   void  UpdateImage();                      // Mise à jour de l'image de la page
   float GetTempo();                         // Accès au paramètre Tempo
};

#endif //CPAGE_H
