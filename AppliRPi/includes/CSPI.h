#ifndef CSPI_H
#define CSPI_H

#include <stdint.h>
#include <iostream>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/types.h>
#include <linux/spi/spidev.h>

static const char* device = "/dev/spidev0.0";
static uint8_t mode = SPI_MODE_0;
static uint8_t bits = 8;
static uint32_t speed = 2000000; // 2MHz

class CSPI
{
   protected :
   int m_fd;   // File descriptor du lien SPI
   
   public :
   CSPI();
   ~CSPI();
   CSPI(const CSPI& Page);

   void Envoi(unsigned char* data, int length);
};

#endif //CSPI_H
