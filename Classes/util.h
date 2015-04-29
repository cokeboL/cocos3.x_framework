#ifndef _Util_H_
#define _Util_H_

namespace util{
	long long stoll(const std::string &s);
	template<typename T> std::string to_string(T v)
    {
        std::stringstream conv;
        conv << v;
        std::string s;
        conv >> s;
        return s;
    }
}



#endif // _Util_H_