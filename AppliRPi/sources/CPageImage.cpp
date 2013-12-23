#include "../includes/CPageImage.h"

CPageImage::CPageImage() :
CPage()
{
}

CPageImage::CPageImage(std::string sTempo, std::string sSource) :
CPage(sTempo)
{
}

CPageImage::CPageImage(const CPageImage& PageImage) :
CPage((CPage&) PageImage)
{
}

void CPageImage::PreloadImage()
{
}

void CPageImage::UpdateImage()
{
   // Rien à faire
}

