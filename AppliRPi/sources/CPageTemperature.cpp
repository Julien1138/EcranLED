#include "../includes/CPageTemperature.h"

CPageTemperature::CPageTemperature() :
CPage()
{
}

CPageTemperature::CPageTemperature(std::string sTempo) :
CPage(sTempo)
{
}

CPageTemperature::CPageTemperature(const CPageTemperature& PageTemperature) :
CPage((CPage&) PageTemperature)
{
}
