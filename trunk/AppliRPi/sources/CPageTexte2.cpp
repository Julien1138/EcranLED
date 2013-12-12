#include "../includes/CPageTexte2.h"

CPageTexte2::CPageTexte2() :
CPage(),
m_sTexte1("Vide"),
m_sTexte2("Vide"),
m_bDefilement(false)
{
}

CPageTexte2::CPageTexte2(std::string sTempo, std::string sTexte1, std::string sTexte2, std::string sDefilement) :
CPage(sTempo),
m_sTexte1(sTexte1),
m_sTexte2(sTexte2),
m_bDefilement(sDefilement == "oui")
{
}

CPageTexte2::CPageTexte2(const CPageTexte2& PageTexte2) :
CPage((CPage&) PageTexte2),
m_sTexte1(PageTexte2.m_sTexte1),
m_sTexte2(PageTexte2.m_sTexte2),
m_bDefilement(PageTexte2.m_bDefilement)
{
}
