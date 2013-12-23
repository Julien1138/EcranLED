#include "../includes/CPageTexte2.h"

CPageTexte2::CPageTexte2() :
CPage(),
m_sTexte1("Vide"),
m_sTexte2("Vide"),
m_bDefilement(false),
m_iLargeurLigne2(0)
{
}

CPageTexte2::CPageTexte2(std::string sTempo, std::string sTexte1, std::string sTexte2, std::string sDefilement) :
CPage(sTempo),
m_sTexte1(sTexte1),
m_sTexte2(sTexte2),
m_bDefilement(sDefilement == "oui"),
m_iLargeurLigne2(0)
{
}

CPageTexte2::CPageTexte2(const CPageTexte2& PageTexte2) :
CPage((CPage&) PageTexte2),
m_sTexte1(PageTexte2.m_sTexte1),
m_sTexte2(PageTexte2.m_sTexte2),
m_bDefilement(PageTexte2.m_bDefilement),
m_iLargeurLigne2(PageTexte2.m_iLargeurLigne2)
{
}

void CPageTexte2::PreloadImage()
{
   int iDummy;
   //Calcul de la largeur de chaque ligne
   /*MagickCore::MagickWand *mv = MagickCore::NewMagickWand();
   MagickCore::MagickSetSize(mv, 0, 56);
   MagickCore::MagickSetPointsize(mv, 26);
   MagickCore::MagickSetFont(mv, "Helvetica");
      MagickCore::MagickSetOption(mv, "fill", "white");
      MagickCore::MagickSetOption(mv, "background", "black");
      MagickCore::MagickSetGravity(mv, Magick::CenterGravity);
   char buffer[1024];
   sprintf(buffer, "caption:%s", m_sTexte2.c_str());
   MagickCore::MagickReadImage(mv, buffer);
      MagickCore::MagickWriteImage(mv, "2Lignes.bmp");
   MagickCore::MagickGetSize(mv,(size_t*) &m_iLargeurLigne2,(size_t*) &iDummy);

std::cout << "largeur : " << m_iLargeurLigne2 << "x" << iDummy << std::endl;*/

   m_Image.font("Helvetica");
   m_Image.strokeColor("white");
   m_Image.fillColor("white");
   m_Image.fontPointsize(26);
   m_Image.draw(Magick::DrawableText(0,20,m_sTexte1.c_str()));
   if (m_bDefilement)
   {
      m_Image.draw(Magick::DrawableText(0,48,m_sTexte2.c_str()));
   }
   else
   {
      m_Image.draw(Magick::DrawableText(0,48,m_sTexte2.c_str()));
   }
}

void CPageTexte2::UpdateImage()
{
}

