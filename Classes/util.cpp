#include <string>       // std::string
#include <iostream>     // std::cout
#include <sstream>      // std::stringstream
#include "util.h"
#include "cocos2d.h"

namespace util{

long long stoll(const std::string &s)
{
	std::stringstream conv;
	conv << s;
	long long ll;
	conv >> ll; 
	return ll;
}

std::string to_string(int v)
{
	std::stringstream conv;
	conv << v;
	std::string s;
	conv >> s; 
	return s;
}
    
}