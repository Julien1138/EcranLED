#include "../includes/CSPI.h"

#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))

CSPI::CSPI()
{
   m_fd = open(device, O_RDWR);
   if (m_fd < 0)
      std::cout << "Can't open device" << std::endl;

   if (ioctl(m_fd, SPI_IOC_WR_MODE, &mode) < 0)
      std::cout << "Cant set spi mode" << std::endl;

   if (ioctl(m_fd, SPI_IOC_WR_BITS_PER_WORD, &bits) < 0)
      std::cout << "Cant set bits per word" << std::endl;

   if (ioctl(m_fd, SPI_IOC_WR_MAX_SPEED_HZ, &speed) < 0)
      std::cout << "Cant set max speed hz" << std::endl;
}

CSPI::CSPI(const CSPI& SPI) :
m_fd(SPI.m_fd)
{
   if (ioctl(m_fd, SPI_IOC_WR_MODE, &mode) < 0)
      std::cout << "Cant set spi mode" << std::endl;

   if (ioctl(m_fd, SPI_IOC_WR_BITS_PER_WORD, &bits) < 0)
      std::cout << "Cant set bits per word" << std::endl;

   if (ioctl(m_fd, SPI_IOC_WR_MAX_SPEED_HZ, &speed) < 0)
      std::cout << "Cant set max speed hz" << std::endl;
}

CSPI::~CSPI()
{
   close(m_fd);
}

void CSPI::Envoi(unsigned char* data, int length)
{
   //unsigned char rx[256];
   struct spi_ioc_transfer spi;
   spi.tx_buf = (unsigned long) data;
   spi.rx_buf = (unsigned long) data;
   spi.len = length;
   spi.delay_usecs = 0;
   spi.speed_hz = speed;
   spi.bits_per_word = bits;
   spi.cs_change = 0;

   if (ioctl(m_fd, SPI_IOC_MESSAGE(1), &spi) < 0)
      std::cout << "Can't send spi message" << std::endl;
}

