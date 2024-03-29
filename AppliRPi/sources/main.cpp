#include <string>
#include <Magick++.h>

#include "../includes/CProgramme.h"
#include "../includes/CSPI.h"

#define MAGICKCORE_QUANTUM_DEPTH 8

int main(int argc,char **argv) 
{
   //CSPI* SPI = new CSPI;
   
   //unsigned char tx[2] = {0xA2, 0xA4};
   //SPI->Envoi((unsigned char*) &tx, 2);
   
   CProgramme* Programme = new CProgramme("/var/www/config/config.txt");
   Programme->Afficher();
   
   /*
   // Create base image (black image of 192 by 56 pixels)
   // Magick::Image image( Magick::Geometry(192, 56), Magick::Color("black") );
   
   // Write the result
   // image.write("x.png");
   
   // Example:
   Magick::Image my_image( Magick::Geometry(192, 56), Magick::Color("black"));
   
   // set the text rendering font (the color is determined by the "current" image setting)

   my_image.font("Helvetica");
   // my_image.boxColor("red");
   my_image.strokeColor("white");
   my_image.fillColor("white");
   my_image.fontPointsize(28);
   
   // draw text with different gravity position
   my_image.annotate("Hello !", Magick::NorthGravity);
   // my_image.annotate("Super !", Magick::SouthGravity);

   my_image.draw(Magick::DrawableFont("Helvetica"));

   my_image.draw(Magick::DrawableStrokeColor("white"));
   // my_image.draw(Magick::DrawableFillColor(Magick::Color(0, 0, 0, MaxRGB)));
   my_image.draw(Magick::DrawableTextUnderColor("red"));
   my_image.draw(Magick::DrawableText(-20,27,"Text Sample with draw"));
   
   my_image.write("x.png");
   my_image.write("x.jpg");
   */
   
   return 0;
}
