#include <string>
#include <vector>

class MyString: public std::string {

public:
    MyString()
        : std::string()
    {}

    MyString(const char* text)
        : std::string(text)
    {}

    MyString(int value)
        : std::string(std::to_string(value))
    {}

    MyString lower() const {
        MyString result = *this;
        std::transform(result.begin(), result.end(), result.begin(),
                   [](unsigned char c){ return std::tolower(c); });
        return result;
    }

    std::vector<MyString> split() const {
        std::vector<MyString> result;
        bool inQuotes = false;
        MyString token;
        for(char c : *this){
            if (c == '\"') {
                inQuotes = !inQuotes;
            }
            if (c == ' ' && !inQuotes) {
                result.push_back(token);
                token.clear();
            } else {
                token += c;
            }
        }
        result.push_back(token);
        return result;
    }

    int toInt() const {
        //std::size_t pos{};
        return std::strtol(c_str(), nullptr, 0);
    }

    MyString trim() const {
        MyString result = *this;

        // Remove leading spaces
        result.erase(result.begin(), std::find_if(result.begin(), result.end(), [](int ch) {
            return !std::isspace(ch);
        }));

        // Remove trailing spaces
        result.erase(std::find_if(result.rbegin(), result.rend(), [](int ch) {
            return !std::isspace(ch);
        }).base(), result.end());

        return result;
    }

    MyString upper() const {
        MyString result = *this;
        std::transform(result.begin(), result.end(), result.begin(),
                   [](unsigned char c){ return std::toupper(c); });
        return result;
    }
};