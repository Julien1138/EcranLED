#include "../includes/CPageHeure.h"

CPageHeure::CPageHeure() :
CPage(),
m_bFormat24H(true),
m_iDerniereSeconde(61)
{
}

CPageHeure::CPageHeure(std::string sTempo, std::string sFormat) :
CPage(sTempo),
m_bFormat24H(sFormat == "24H"),
m_iDerniereSeconde(61)
{
}

CPageHeure::CPageHeure(const CPageHeure& PageHeure) :
CPage((CPage&) PageHeure),
m_bFormat24H(PageHeure.m_bFormat24H),
m_iDerniereSeconde(PageHeure.m_iDerniereSeconde)
{
}

void CPageHeure::PreloadImage()
{
   m_Image.font("Helvetica");
   m_Image.strokeColor("white");
   m_Image.fillColor("white");
   m_Image.fontPointsize(70);
}

void CPageHeure::UpdateImage()
{
   time_t tHeure = time(NULL); // tHeure contient maintenant la date et l'heure courante
   if (localtime(&tHeure)->tm_sec < m_iDerniereSeconde) // Changement de minute
   {
      char buffer[6];
      if (m_bFormat24H)
      {
         strftime(buffer, sizeof(buffer), "%H:%M", localtime(&tHeure));
      }
      else
      {
         strftime(buffer, sizeof(buffer), "%I:%M", localtime(&tHeure));
      }

/*
      MagickCore::MagickWand *mv;

      mv = MagickCore::NewMagickWand();

      MagickCore::MagickSetSize(mv, 0, 56);
      MagickCore::MagickSetPointsize(mv, 56);
      MagickCore::MagickSetFont(mv, "Helvetica");
      MagickCore::MagickSetOption(mv, "fill", "white");
      MagickCore::MagickSetOption(mv, "background", "black");
      MagickCore::MagickSetGravity(mv, Magick::CenterGravity);
      MagickCore::MagickReadImage(mv, "caption:15:1222fpfpfpfpjkjkjkjkybybybqtqtqtqtq");
      MagickCore::MagickWriteImage(mv, "Heure.png");
*/
      m_Image.erase();
      m_Image.annotate(buffer, Magick::NorthGravity);

      //m_Image.write("Heure.png");
      

/*
      Magick::Image Image( Magick::Geometry(12, 12), Magick::Color("black"));
      Image.draw(Magick::DrawableFont("Helvetica"));
      Image.draw(Magick::DrawableStrokeColor("white"));
      Image.draw(Magick::DrawableFillColor("white"));
      Image.draw(Magick::DrawablePointSize(56));
      Image.read("-caption:'Toto'");
      //Image.draw(Magick::DrawableText(0,0,buffer));
      std::cout << "Width : " << Image.size().width() << std::endl;
      std::cout << "Height : " << Image.size().height() << std::endl;
      
      Image.write("Heure.png");*/
   }
   m_iDerniereSeconde = localtime(&tHeure)->tm_sec;
}
