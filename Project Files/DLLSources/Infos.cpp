#include "CvGameCoreDLL.h"
#include "Infos.h"
#include "XMLReader.h"

bool InfoBase::readType(XMLReader& reader)
{
	return false;
}

bool InfoBase::read(XMLReader& reader)
{
	return false;
}

bool InfoBase::postLoadSetup(XMLReader& reader)
{
	return false;
}

const char* InfoBaseTypeDesc::getType() const
{
	return m_szType;
}

CvWString InfoBaseTypeDesc::getTextKeyWide() const
{
	return m_szTextKey;
}

CvWString InfoBaseTypeDesc::getDescription(uint uiForm) const
{
	if (m_szTextKey.IsEmpty())
	{
		return L"";
	}

	return gDLL->getObjectText(m_szTextKey, uiForm);
}

bool InfoBaseTypeDesc::readType(XMLReader& reader)
{
	reader.Read("Type", m_szType);
	return true;
}

bool InfoBaseTypeDesc::read(XMLReader& reader)
{
	reader.ReadTextKey("Description", m_szTextKey);
	return true;
}

bool InfoBaseTypeDesc::postLoadSetup(XMLReader& reader)
{
	return false;
}



InfoBasePedia::InfoBasePedia()
	: m_szType(NULL)
	, m_szTextKey(NULL)
	, m_szCivilopedia(NULL)
	, m_szHelp(NULL)
	, m_szSttrategy(NULL)
{
}

InfoBasePedia::~InfoBasePedia()
{
	SAFE_DELETE(m_szType);
	SAFE_DELETE(m_szTextKey);
	SAFE_DELETE(m_szCivilopedia);
	SAFE_DELETE(m_szHelp);
	SAFE_DELETE(m_szSttrategy);
}

bool InfoBasePedia::readType(XMLReader& reader)
{
	return true;
}

bool InfoBasePedia::read(XMLReader& reader)
{
	return false;
}

bool InfoBasePedia::postLoadSetup(XMLReader& reader)
{
	return false;
}

const char* InfoBasePedia::getType() const
{
	return m_szType;
}

const wchar* InfoBasePedia::getTextKeyWide() const
{
	return m_szTextKey;
}

CvWString InfoBasePedia::getDescription(uint uiForm) const
{
	if (m_szTextKey == NULL)
	{
		return L"";
	}

	return gDLL->getObjectText(m_szTextKey, uiForm);
}

CvWString InfoBasePedia::getCivilopedia() const
{
	if (m_szCivilopedia == NULL)
	{
		return L"";
	}
	return gDLL->getText(m_szCivilopedia);
}

CvWString InfoBasePedia::getHelp() const
{
	if (m_szHelp == NULL)
	{
		return L"";
	}
	return gDLL->getText(m_szHelp);
}

CvWString InfoBasePedia::getStrategy() const
{
	if (m_szSttrategy == NULL)
	{
		return L"";
	}
	return gDLL->getText(m_szSttrategy);
}


CivCategoryInfo::CivCategoryInfo()
	: m_eCivEffect(NO_CIV_EFFECT)
{}

const char* CivCategoryInfo::getType() const
{
	return m_szType;
}

CivEffectTypes CivCategoryInfo::getCivEffect() const
{
	return m_eCivEffect;
};

bool CivCategoryInfo::readType(XMLReader& reader)
{
	reader.Read("Type", m_szType);
	return true;
}

bool CivCategoryInfo::read(XMLReader& reader)
{
	reader.Read("eCivEffect", m_eCivEffect);
	return true;
}

CivilizationInfo::CivilizationInfo()
	: m_bPlayable(false)
	, m_iAreaMultiplier(0)
{
}

bool CivilizationInfo::readType(XMLReader& reader)
{
	reader.Read("Type", m_szType);
	return true;
}

bool CivilizationInfo::read(XMLReader& reader)
{
	reader.Read("bPlayable", m_bPlayable);
	reader.Read("iAreaMultiplier", m_iAreaMultiplier);
	reader.Read("Units", m_Units);
	reader.Read("Leaders", m_Leaders);

	return true;
}