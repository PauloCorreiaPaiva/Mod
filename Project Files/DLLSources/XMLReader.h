#pragma once

#include <boost/utility/enable_if.hpp>
#include <boost/type_traits/is_enum.hpp>

namespace tinyxml2
{
	class XMLElement;
}

class XMLTypeContainer;
class InfoArrayBase;

class XMLReader
{
public:
	XMLReader(const XMLTypeContainer& FileReader, const tinyxml2::XMLElement* Element);

	void nextSiblingSameName();
	XMLReader openFolder(const char* name) const;

	bool valid() const;
	bool isType(const char* szType) const;


	void Read(const char* szTag, CvString& szText) const;
	void ReadTextKey(const char* szTag, CvString& szText) const;
	
	void Read(const char* szTag, bool& bBool) const;
	void Read(const char* szTag, int& iValue) const;

	template<typename T>
	typename boost::enable_if<boost::is_enum<T>, void>::type
	Read(const char* szTag, T& type) const;

	template<typename T0, typename T1, typename T2, typename T3>
	void Read(const char* szTag, InfoArray<T0, T1, T2, T3>& infoArray);

private:
	template<typename T0>
	void ReadInfoArray(const char* szTag, InfoArray1Only<T0>& infoArray);
	template<typename T0, typename T1>
	void ReadInfoArray(const char* szTag, InfoArray2Only<T0, T1>& infoArray);
	template<typename T0, typename T1, typename T2>
	void ReadInfoArray(const char* szTag, InfoArray3Only<T0, T1, T2>& infoArray);
	template<typename T0, typename T1, typename T2, typename T3>
	void ReadInfoArray(const char* szTag, InfoArray4Only<T0, T1, T2, T3>& infoArray);

	// read a single element. Use this one as it aims to have full error detection and reporting
	template<typename T>
	void readElement(const char* szTag, T& var, const tinyxml2::XMLElement* pElement, const tinyxml2::XMLElement* pParent, bool bAllowNone) const;

	const char* _ReadString(const char* szTag) const;
	
	const tinyxml2::XMLElement* childElement(const char* szTag) const;
	
	const XMLTypeContainer& m_FileReader;
	const tinyxml2::XMLElement* m_Element;
};


template<typename T>
typename boost::enable_if<boost::is_enum<T>, void>::type
XMLReader::Read(const char* szTag, T& type) const
{
	readElement(szTag, type, childElement(szTag), m_Element, true);
}


template<typename T0, typename T1, typename T2, typename T3>
void XMLReader::Read(const char* szTag, InfoArray<T0, T1, T2, T3>& infoArray)
{
	XMLReader child = openFolder(szTag);
	if (!child.valid())
	{
		return;
	}

	child.ReadInfoArray(szTag, infoArray);
}