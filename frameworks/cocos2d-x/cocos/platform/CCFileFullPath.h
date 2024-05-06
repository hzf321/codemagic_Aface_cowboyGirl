
#include <string>
#include <vector>
#include <unordered_map>

#include "platform/CCPlatformMacros.h"
#include "base/ccTypes.h"
#include "base/CCValue.h"
#include "base/CCData.h"

NS_CC_BEGIN

class CC_DLL FileFullPath
{
public:
    static FileFullPath* getInstance();
    static void destroyInstance();

    std::string getRealPath(const std::string &filename, const std::string &searchIt, const std::string &resolutionIt);
	unsigned char* decodeData(unsigned char* buf, unsigned long size, ssize_t* pSize);

    static FileFullPath* s_shared;
    mutable ValueMap _file_map;
};

NS_CC_END

