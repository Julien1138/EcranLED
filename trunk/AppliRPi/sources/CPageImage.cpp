#include "../includes/CPageImage.h"

CPageImage::CPageImage() :
CPage()
{
   m_sSource = "";
}

CPageImage::CPageImage(std::string sTempo, std::string sSource) :
CPage(sTempo)
{
   m_sSource = sSource;
}

CPageImage::CPageImage(const CPageImage& PageImage) :
CPage((CPage&) PageImage)
{
}

void CPageImage::PreloadImage()
{
   Magick::Image Image;
   Image.read(("/var/www/images/" + m_sSource).c_str());
   Image.resize(Magick::Geometry(192, 56));
   m_Image.draw(Magick::DrawableCompositeImage(0, 0, Image));
}

void CPageImage::UpdateImage()
{
   // Rien à faire
}

