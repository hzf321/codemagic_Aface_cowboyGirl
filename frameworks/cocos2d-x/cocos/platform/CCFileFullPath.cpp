
#include "platform/CCFileUtils.h"
#include "platform/CCFileFullPath.h"
#include "base/CCData.h"
#include "base/ccMacros.h"

NS_CC_BEGIN

FileFullPath* FileFullPath::s_shared = nullptr;

FileFullPath* FileFullPath::getInstance()
{
    if (s_shared == nullptr)
    {
        s_shared = new FileFullPath();
    }
    return s_shared;
}

void FileFullPath::destroyInstance()
{
    CC_SAFE_DELETE(s_shared);
}

unsigned char* FileFullPath::decodeData(unsigned char* buf, unsigned long size, ssize_t *pSize)
{
	unsigned char* buffer = NULL;
	bool isEncrypt = true;

	unsigned char key = 58;
	const char* sign = "FPX-a46fv";
	int signLen = strlen(sign);

	for (unsigned int i = 0; isEncrypt && i < signLen && i < size; ++i)
	{
		isEncrypt = buf[i] == sign[i];
	}

	if (isEncrypt)
	{
		unsigned char* resultPtr = buf + signLen;
		for (size_t i = 0; i < size - signLen; i++)
		{
			resultPtr[i] = resultPtr[i] ^ key;
		}
		size = size - signLen;
		buffer = new unsigned char[size];
		std::copy(resultPtr, resultPtr + size, buffer);
	}
	else
	{
		buffer = buf;
	}

	if (pSize)
	{
		*pSize = size;
	}
	return buffer;
}

std::string FileFullPath::getRealPath(const std::string &filename, const std::string &searchIt, const std::string &resolutionIt)
{
    if (filename.empty())
    {
        return "";
    }

    if((searchIt.length() >= 4 && searchIt.substr(searchIt.length() - 4, 4) == "res/") ||
       (searchIt.length() > 15 && searchIt.substr(searchIt.length() - 15, 15) == "theme_resource/") ||
       (searchIt.length() > 14 && searchIt.substr(searchIt.length() - 14, 14) == "theme_desktop/")) {
        if (_file_map.empty()) {
                   auto fullpath1 = FileUtils::getInstance()->getPathForFilename("gghghgddhf/fdgjyjg",resolutionIt, searchIt);
                   if (!fullpath1.empty()) {
                       _file_map = FileUtils::getInstance()->getValueMapFromFile("gghghgddhf/fdgjyjg");
                   }
               }
        std::string search = FileUtils::getInstance()->getNewFilename(searchIt);
        std::string key = FileUtils::getInstance()->getNewFilename(filename);
        if (key.substr(key.length() - 4, 4) == ".lua" && key.substr(0, 2) == ".\\") {
            key = key.substr(2, key.length());
        }
        if (search.length() > 14 && search.substr(search.length() - 14, 14) == "theme_desktop/") {
            if (key.length() > 9 && (key.substr(0, 9) == "theme138/")) {
                key = key.substr(9, key.length());
            }
            search = search.substr(0, search.length() - 14);
        }
        else if (search.length() > 15 && search.substr(search.length() - 15, 15) == "theme_resource/") {
            if (key.length() > 15 && key.substr(0, 15) == "theme_resource/") {
                key = key.substr(15, key.length());
            }
            search = search.substr(0, search.length() - 15);
        }

        if (key.length() > 23 && (key.substr(0, 23) == "theme_desktop/theme138/")) {
            key = key.substr(23, key.length());
        }

        if (!_file_map.empty() && !_file_map[key].isNull()) {
            auto name = _file_map[key].asString();
            auto fullpath = FileUtils::getInstance()->getPathForFilename(name, resolutionIt, search);
            if (!fullpath.empty()) {
                return fullpath;
            }
        }
    }

    return "";
}

NS_CC_END
