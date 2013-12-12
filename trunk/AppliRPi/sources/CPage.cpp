#include "../includes/CPage.h"

CPage::CPage() :
m_fTempo(1.0)
{
}

CPage::CPage(std::string sTempo)
{
   std::stringstream ssTempo(sTempo);
   ssTempo >> m_fTempo;
}

CPage::CPage(const CPage& Page) :
m_fTempo(Page.m_fTempo)
{
}

float CPage::GetTempo()
{
   return m_fTempo;
}
