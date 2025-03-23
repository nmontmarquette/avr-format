#include <iostream>
#include <fstream>
#include <string>
#include <map>

std::map<std::string, std::string> readConfigFile(const std::string& filePath) {
    std::map<std::string, std::string> config;
    std::ifstream file(filePath);
    std::string line;

    if (file.is_open()) {
        while (getline(file, line)) {
            size_t delimiterPos = line.find('=');
            if (delimiterPos != std::string::npos) {
                std::string key = line.substr(0, delimiterPos);
                std::string value = line.substr(delimiterPos + 1);
                config[key] = value;
            }
        }
        file.close();
    } else {
        std::cerr << "Unable to open the configuration file: " << filePath << std::endl;
    }

    return config;
}