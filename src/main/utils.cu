#include "utils.h"
#include <sstream>
#include <iomanip>
#include <bitset>


using namespace std;

 BYTE char2byte(char input) {
   if(input >= '0' && input <= '9') {
     return input - '0';
   } else if(input >= 'A' && input <= 'F') {
     return input - 'A' + 10;
   } else if(input >= 'a' && input <= 'f') {
         return input - 'a' + 10;
   }
   throw std::invalid_argument("Invalid input string");
 }
 
 // buffer need to have size at least ceil(str.len/2)
 void hexstr2byte(string str, BYTE * buffer) { 
         for (int i = 0; i < str.size(); i = i + 2) { 
                 *(buffer++) = char2byte(str[i])*16 + char2byte(str[i+1]);
         }
 }
 
 string byte2hexstr(BYTE *data, int len) {
      stringstream ss;
      ss << hex;
      
      for (int i = 0; i < len; ++i) {
          ss << setw(2) << setfill('0') << (int)data[i];
      }
      
      return ss.str();
 }


 

