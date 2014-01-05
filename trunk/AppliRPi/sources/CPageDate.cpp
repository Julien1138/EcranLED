#include "../includes/CPageDate.h"

CPageDate::CPageDate() :
CPageTexte2(),
m_iDerniereHeure(24)
{
}

CPageDate::CPageDate(std::string sTempo, float fCoefRouge, float fCoefVert, float fCoefBleu) :
CPageTexte2(sTempo, fCoefRouge, fCoefVert, fCoefBleu, "", "", "non"),
m_iDerniereHeure(24)
{
}

CPageDate::CPageDate(const CPageDate& PageDate) :
CPageTexte2((CPageTexte2&) PageDate),
m_iDerniereHeure(PageDate.m_iDerniereHeure)
{
}

void CPageDate::UpdateImage()
{
   time_t tHeure = time(NULL); // tHeure contient maintenant la date et l'heure courante

   if (localtime(&tHeure)->tm_hour < m_iDerniereHeure) // Changement de jour
   {
      char buffer1[256], buffer2[256], buffer[512];
      Magick::Image Image;

      // ligne 1
      switch (localtime(&tHeure)->tm_wday)
      {
         case 0:
            sprintf(buffer1, "Dimanche %i", localtime(&tHeure)->tm_mday);
            break;
         case 1:
            sprintf(buffer1, "Lundi %i", localtime(&tHeure)->tm_mday);
            break;
         case 2:
            sprintf(buffer1, "Mardi %i", localtime(&tHeure)->tm_mday);
            break;
         case 3:
            sprintf(buffer1, "Mercredi %i", localtime(&tHeure)->tm_mday);
            break;
         case 4:
            sprintf(buffer1, "Jeudi %i", localtime(&tHeure)->tm_mday);
            break;
         case 5:
            sprintf(buffer1, "Vendredi %i", localtime(&tHeure)->tm_mday);
            break;
         case 6:
            sprintf(buffer1, "Samedi %i", localtime(&tHeure)->tm_mday);
            break;
         default:
            break;
      }
      // ligne 2
      switch (localtime(&tHeure)->tm_mon)
      {
         case 0:
            sprintf(buffer2, "Janvier %i", localtime(&tHeure)->tm_year + 1900);
            break;
         case 1:
            sprintf(buffer2, "Février %i", localtime(&tHeure)->tm_year + 1900);
            break;
         case 2:
            sprintf(buffer2, "Mars %i", localtime(&tHeure)->tm_year + 1900);
            break;
         case 3:
            sprintf(buffer2, "Avril %i", localtime(&tHeure)->tm_year + 1900);
            break;
         case 4:
            sprintf(buffer2, "Mai %i", localtime(&tHeure)->tm_year + 1900);
            break;
         case 5:
            sprintf(buffer2, "Juin %i", localtime(&tHeure)->tm_year + 1900);
            break;
         case 6:
            sprintf(buffer2, "Juillet %i", localtime(&tHeure)->tm_year + 1900);
            break;
         case 7:
            sprintf(buffer2, "Août %i", localtime(&tHeure)->tm_year + 1900);
            break;
         case 8:
            sprintf(buffer2, "Septembre %i", localtime(&tHeure)->tm_year + 1900);
            break;
         case 9:
            sprintf(buffer2, "Octobre %i", localtime(&tHeure)->tm_year + 1900);
            break;
         case 10:
            sprintf(buffer2, "Novembre %i", localtime(&tHeure)->tm_year + 1900);
            break;
         case 11:
            sprintf(buffer2, "Décembre %i", localtime(&tHeure)->tm_year + 1900);
            break;
         default:
            break;
      }

      //Calcul de la largeur de la ligne 1
      MagickCore::MagickWand *mv1 = MagickCore::NewMagickWand();
      MagickCore::MagickSetSize(mv1, 0, 56);
      MagickCore::MagickSetPointsize(mv1, 26);
      MagickCore::MagickSetFont(mv1, "Helvetica");
      MagickCore::MagickSetOption(mv1, "fill", "white");
      MagickCore::MagickSetOption(mv1, "background", "black");
      MagickCore::MagickSetGravity(mv1, Magick::CenterGravity);
      sprintf(buffer, "caption:%s", buffer1);
      for (int i(0) ; i < 512 ; i++)
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
      sprintf(buffer, "caption:%s", buffer2);
      for (int i(0) ; i < 512 ; i++)
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
      m_Image.erase();
      m_Image.font("Helvetica");
      m_Image.strokeColor("red");   // On utilise le rouge en niveau de gris
      m_Image.fillColor("red");     // On utilise le rouge en niveau de gris
      m_Image.fontPointsize(26);
      m_Image.draw(Magick::DrawableText(96-(m_iLargeurLigne1/2), 20, buffer1));
      m_Image.draw(Magick::DrawableText(96-(m_iLargeurLigne2/2), 48, buffer2));
   }

   m_iDerniereHeure = localtime(&tHeure)->tm_hour;
}
