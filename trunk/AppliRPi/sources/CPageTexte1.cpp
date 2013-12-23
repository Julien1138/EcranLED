#include "../includes/CPageTexte1.h"

CPageTexte1::CPageTexte1() :
CPage(),
m_sTexte("Vide")
{
}

CPageTexte1::CPageTexte1(std::string sTempo, std::string sTexte) :
CPage(sTempo),
m_sTexte(sTexte)
{
}

CPageTexte1::CPageTexte1(const CPageTexte1& PageTexte1) :
CPage((CPage&) PageTexte1),
m_sTexte(PageTexte1.m_sTexte)
{
}

void CPageTexte1::PreloadImage()
{
   m_Image.font("Helvetica");
   m_Image.strokeColor("white");
   m_Image.fillColor("white");
   m_Image.fontPointsize(54);
   m_Image.annotate(m_sTexte.c_str(), Magick::CenterGravity);
}

void CPageTexte1::UpdateImage()
{
}

