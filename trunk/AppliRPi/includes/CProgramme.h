#ifndef CPROGRAMME_H
#define CPROGRAMME_H

#include <string>
#include <vector>
#include <fstream>
#include <iostream>
#include "../includes/CPage.h"

class CProgramme
{
   private :
   std::string          m_sFilePath;
   std::vector<CPage*>  m_vectPages;   // Tableau de pages
   int                  m_iDateModifFichier;
   unsigned char        m_ucLuminosite;
   unsigned char        m_ucRouge1;
   unsigned char        m_ucVert1;
   unsigned char        m_ucBleu1;
   unsigned char        m_ucRouge2;
   unsigned char        m_ucVert2;
   unsigned char        m_ucBleu2;
   unsigned char        m_ucRouge3;
   unsigned char        m_ucVert3;
   unsigned char        m_ucBleu3;
   unsigned char        m_ucRouge4;
   unsigned char        m_ucVert4;
   unsigned char        m_ucBleu4;
   unsigned char        m_ucRouge5;
   unsigned char        m_ucVert5;
   unsigned char        m_ucBleu5;
   unsigned char        m_ucRouge6;
   unsigned char        m_ucVert6;
   unsigned char        m_ucBleu6;
   
   void Charger();   // Chargement des paramètres de la page depuis le fichier
   void Vider();
   bool VerifNouvelleConfig();
   
   public :
   CProgramme(std::string sFichier);
   ~CProgramme();
   void Afficher();
};

#endif //CPROGRAMME_H
