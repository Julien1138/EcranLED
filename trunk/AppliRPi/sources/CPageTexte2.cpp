#include "../includes/CPageTexte2.h"

CPageTexte2::CPageTexte2() :
CPageTexte(),
m_sTexte1("Vide"),
m_sTexte2("Vide"),
m_bDefilement(false),
m_iLargeurLigne1(0),
m_iLargeurLigne2(0)
{
}

CPageTexte2::CPageTexte2(std::string sTempo, float fCoefRouge, float fCoefVert, float fCoefBleu, std::string sTexte1, std::string sTexte2, std::string sDefilement) :
CPageTexte(sTempo, fCoefRouge, fCoefVert, fCoefBleu),
m_sTexte1(sTexte1),
m_sTexte2(sTexte2),
m_bDefilement(sDefilement == "oui"),
m_iLargeurLigne1(0),
m_iLargeurLigne2(0)
{
}

CPageTexte2::CPageTexte2(const CPageTexte2& PageTexte2) :
CPageTexte((CPageTexte&) PageTexte2),
m_sTexte1(PageTexte2.m_sTexte1),
m_sTexte2(PageTexte2.m_sTexte2),
m_bDefilement(PageTexte2.m_bDefilement),
m_iLargeurLigne1(PageTexte2.m_iLargeurLigne1),
m_iLargeurLigne2(PageTexte2.m_iLargeurLigne2)
{
}

void CPageTexte2::PreloadImage()
{
   char buffer[1024];
   Magick::Image Image;

   //Calcul de la largeur de la ligne 1
   MagickCore::MagickWand *mv1 = MagickCore::NewMagickWand();
   MagickCore::MagickSetSize(mv1, 0, 56);
   MagickCore::MagickSetPointsize(mv1, 26);
   MagickCore::MagickSetFont(mv1, "Helvetica");
   MagickCore::MagickSetOption(mv1, "fill", "white");
   MagickCore::MagickSetOption(mv1, "background", "black");
   MagickCore::MagickSetGravity(mv1, Magick::CenterGravity);
   sprintf(buffer, "caption:%s", m_sTexte1.c_str());
   for (int i(0) ; i < 1024 ; i++)
   {
      if (buffer[i] == ' ')
      {
         buffer[i] = '-';
      }
   }
   MagickCore::MagickReadImage(mv1, buffer);
   MagickCore::MagickWriteImage(mv1, "tmp.bmp");
   MagickCore::DestroyMagickWand(mv1);

   Image.read("tmp.bmp");
   m_iLargeurLigne1 = Image.baseColumns();

   //Calcul de la largeur de la ligne 2
   MagickCore::MagickWand *mv2 = MagickCore::NewMagickWand();
   MagickCore::MagickSetSize(mv2, 0, 56);
   MagickCore::MagickSetPointsize(mv2, 26);
   MagickCore::MagickSetFont(mv2, "Helvetica");
   MagickCore::MagickSetOption(mv2, "fill", "white");
   MagickCore::MagickSetOption(mv2, "background", "black");
   MagickCore::MagickSetGravity(mv2, Magick::CenterGravity);
   sprintf(buffer, "caption:%s", m_sTexte2.c_str());
   for (int i(0) ; i < 1024 ; i++)
   {
      if (buffer[i] == ' ')
      {
         buffer[i] = '-';
      }
   }
   MagickCore::MagickReadImage(mv2, buffer);
   MagickCore::MagickWriteImage(mv2, "tmp.bmp");
   MagickCore::DestroyMagickWand(mv2);

   Image.read("tmp.bmp");
   m_iLargeurLigne2 = Image.baseColumns();

   // Ecriture du texte
   m_Image.font("Helvetica");
   m_Image.strokeColor("red");   // On utilise le rouge en niveau de gris
   m_Image.fillColor("red");     // On utilise le rouge en niveau de gris
   m_Image.fontPointsize(26);
   m_Image.draw(Magick::DrawableText(96-(m_iLargeurLigne1/2), 20, m_sTexte1.c_str()));
   if (m_bDefilement)
   {
      // Aligné à gauche
      m_Image.draw(Magick::DrawableText(0,48,m_sTexte2.c_str()));
   }
   else
   {
      // Centré
      m_Image.draw(Magick::DrawableText(96-(m_iLargeurLigne2/2), 48, m_sTexte2.c_str()));
   }
}

void CPageTexte2::UpdateImage()
{
}

