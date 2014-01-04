#include "../includes/CPageTexte1.h"

CPageTexte1::CPageTexte1() :
CPageTexte(),
m_sTexte("Vide")
{
}

CPageTexte1::CPageTexte1(std::string sTempo, float fCoefRouge, float fCoefVert, float fCoefBleu, std::string sTexte) :
CPageTexte(sTempo, fCoefRouge, fCoefVert, fCoefBleu),
m_sTexte(sTexte)
{
}

CPageTexte1::CPageTexte1(const CPageTexte1& PageTexte1) :
CPageTexte((CPageTexte&) PageTexte1),
m_sTexte(PageTexte1.m_sTexte)
{
}

void CPageTexte1::PreloadImage()
{
   m_Image.font("Helvetica");
   m_Image.strokeColor("red");   // On utilise le rouge en niveau de gris
   m_Image.fillColor("red");   // On utilise le rouge en niveau de gris
   m_Image.fontPointsize(54);
   m_Image.annotate(m_sTexte.c_str(), Magick::CenterGravity);
}

void CPageTexte1::UpdateImage()
{
}

