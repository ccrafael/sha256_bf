#ifndef __UTILS_H__
#define __UTILS_H__

#include <string>
#include "sha256.h"

using namespace std;

BYTE char2byte(char input); 
void hexstr2byte(string str, BYTE * buffer); 
string byte2hexstr(BYTE *data, int lena);


#endif  

