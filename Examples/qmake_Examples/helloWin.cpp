#include "hello.h"

Hello::Hello()
{
    
}

std::string Hello::operator()(const std::string& _who)
{
    return std::string(_who) + " Hello";
}
