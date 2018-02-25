#pragma once
#include <string>

struct Hello
{
    Hello();
    std::string operator()(const std::string& _who);
};


