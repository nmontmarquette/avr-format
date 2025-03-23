#ifndef LINE_H_INCLUDED
#define LINE_H_INCLUDED

#include <vector>
#include "debug.h"
#include "mystring.h"

template<typename T>
std::vector<T> slice(std::vector<T> const& v, int start, int end) {
    auto first = v.begin() + start;
    auto last = v.begin() + end;
    return std::vector<T>(first, last);
}

enum TextCasing {
    AS_IS,
    UPPER,
    LOWER,
    //CAMEL,  // not quite implemented
};

class Base {
protected:
    MyString mText;
    bool mLeadingSpaces;
    bool mUseTabs;
    TextCasing mTextCasing;

public:
    Base(const char *text, bool leadingSpaces=false, TextCasing textCasing=TextCasing::AS_IS)
        : mText(text)
        , mLeadingSpaces(leadingSpaces)
        , mUseTabs(false)
        , mTextCasing(textCasing)
    {};

    Base(const MyString text, bool leadingSpaces=false, TextCasing textCasing=TextCasing::AS_IS)
        : mText(text)
        , mLeadingSpaces(leadingSpaces)
        , mUseTabs(false)
        , mTextCasing(textCasing)
    {};

    MyString format() const {
        return MyString("");
    };

    MyString text() const {
        return mText;
    }

    TextCasing textCasing() const {
        return mTextCasing;
    }
};

class Element: public Base {
protected:
    std::vector<Element> mElements;

public:
    Element()
        : Base("")
    {
        //mElements.push_back(*this);
    };

    Element(const char *text, bool leadingSpaces=false, TextCasing textCasing=TextCasing::AS_IS)
        : Base(text, leadingSpaces, textCasing)
    {
        //mElements.push_back(*this);
    };

    Element(const MyString text, bool leadingSpaces=false, TextCasing textCasing=TextCasing::AS_IS)
        : Base(text, leadingSpaces, textCasing)
    {
        //mElements.push_back(*this);
    };

    const std::vector<Element>& elements() const {
        return mElements;
    }

    MyString format() const {
        return mText;
    };
};

class Directive: public Element {
public:
    Directive(const char* directive)
        : Element(false, TextCasing::LOWER)
    {
        auto sub_strings = MyString(directive).split();
        if(sub_strings.size()>=1){
            mElements.push_back(Element(sub_strings[0]));
        } else {
            mElements.push_back(Element(directive));
        }
        for(size_t i=1;i<sub_strings.size();i++){
            mElements.push_back(sub_strings[i]);
        }
    };

    Directive(const char* directive, const char* text)
        : Directive(directive)
    {
        mElements.push_back(Element(text));
    };

    Directive(const char* directive, int param1, int param2)
        : Directive(directive)
    {
        mElements.push_back(Element(param1));
        mElements.push_back(Element(param2));
    };

    Element directive() const {
        return mElements[0];
    }

    Element parameter(const int index) const {
        return mElements[1+index];
    }

    std::vector<Element> parameters() const {
        return slice(mElements, 1, mElements.size());
    }
};

class Instruction: public Element {
public:
    Instruction()
        : Element()
    {

    }
    MyString format() const {
        MyString output;
    #if 0
        for(const Element &element: mElements){
            if(textCasing() == TextCasing::UPPER){
                output += element.text().upper();
            } else if(textCasing() == TextCasing::LOWER){
                output += element.text().lower();
            } else if(textCasing() == TextCasing::AS_IS){
                output += element.text();
            }
        }
    #endif
        return output;
    }

    Element instruction() const {
        return mElements[0];
    }

    Element operand(const int index) const {
        return mElements[1+index];
    }
};

class Comment: public Element {
private:
    bool mMultiLine;

public:
    Comment(bool multiLine, const char* marker, const char* comment)
        : Comment(multiLine, MyString(marker), MyString(comment))
    {
    }

    Comment(bool multiLine, const MyString marker, MyString comment)
        : Element()
        , mMultiLine(multiLine)
    {
        mElements.push_back(Element(marker));
        mElements.push_back(Element(comment));
    }

    MyString format() const {
        if(mMultiLine){
            throw "Multi-line comments not yet supported";
        } else {
            MyString output;
            for(const Element &element: mElements){
                output += element.text();
            }
            return output;
        }
    }
};

/**
 * Wraps a line comment (a comment that is not spanning multiple lines)
 */
class LineComment: public Comment {
public:
    /**
     * Computes the sum of two integers.
     *
     * This method takes two integers and returns their sum.
     *
     * @param comment The comment marker, typically ";" or "//"
     * @param comment The comment text
     * @param startOfLine Whether this line comment starts at the beginning of the line or after leading spaces or other elements.
     */
    LineComment(const char* marker, const char* comment, bool /* startOfLine */)
        : Comment(false, marker, MyString(comment).trim())
    {
    }

    MyString text() const {
        MyString output;
        output += mElements[0].text();
        output += " ";
        output += mElements[1].text();
        return output;
    }
};

/**
 * Wraps an assembler-type line comment (a comment that is not spanning multiple lines)
 */
class AssemblerLineComment: public LineComment {
public:
    /**
     * Computes the sum of two integers.
     *
     * This method takes two integers and returns their sum.
     *
     * @param comment The comment marker, typically ";" or "//"
     * @param comment The comment text
     * @param startOfLine Whether this line comment starts at the beginning of the line or after leading spaces or other elements.
     */
    AssemblerLineComment(const char* comment, bool startOfLine=false)
        : LineComment(";", comment, startOfLine)
    {
        ASSERT(comment);
        //ASSERT(comment[0]==';');
    }
};

/**
 * Wraps a C++-type line comment (a comment that is not spanning multiple lines)
 */
class CppLineComment: public LineComment {
public:
    /**
     * Computes the sum of two integers.
     *
     * This method takes two integers and returns their sum.
     *
     * @param comment The comment marker, typically ";" or "//"
     * @param comment The comment text
     * @param startOfLine Whether this line comment starts at the beginning of the line or after leading spaces or other elements.
     */
    CppLineComment(const char* comment, bool startOfLine=false)
        : LineComment("//", comment, startOfLine)
    {
        //ASSERT(comment);
       // ASSERT((comment[0]=='/') && (comment[1]=='/'));
    }
};

/**
 * @brief A line is a collection discrete text elements, each having their own formatting.
 *
 */
class Line {

private:
    std::vector<Base> mElements;

public:

    void add(const Base& element){
        mElements.push_back(element);
    }

    /**
     * @brief Formats a single line of source code.
     *
     * This method processes individual elements of the line and formats them according to
     * the specified configuration, including capitalization, spaces vs. tabs, column alignment, etc.
     *
     * @return MyString The formatted line as a string.
     */
    MyString format() const {
        MyString line;

        for (auto &element : mElements) {
            line += element.format();
        }
        line += "\n";
        return line;
    }
};

/**
 * Manages a list of lines for an AVR assembly source file.
 */
class Lines {
private:
    std::vector<Line> mLines;
    Line mCurrentLine;

    void addLineComment(LineComment &lineComment) {
        LOG_DEBUG("Parsed comment: '%s'", lineComment.text().c_str());
        add(lineComment);
        mLines.push_back(mCurrentLine);
    }

#if 0
    template <typename T, typename... Args>
    void process_asm_directive(const T& directive, const Args&... args) {
        MyString localDirective(directive);
        ASSERT(!localDirective.empty());
        LOG_DEBUG("Parsed assembler '%s' directive\n", directive);

        // Create a local lowercase copy
        std::transform(localDirective.begin(), localDirective.end(), localDirective.begin(), [](unsigned char c){
            return std::tolower(c);
        });

        if(0==localDirective.compare(MyString(".include"))){
            // The include directive has 1 parameter
            if(sizeof...(args)==1){
                const int size = sizeof...(args);
                const char* params[size] = {args...};
                MyString localFilename(params[0]);
                ASSERT(!localFilename.empty());
                gLines.push_back({"", localDirective.c_str(), ""});
                LOG_DEBUG("Parsed simple assembler '%s' directive, filename: '%s'\n", localDirective.c_str(), localFilename.c_str());
            } else {
                std::cerr << "ERROR: Was expecting 1 parameter with the '.include' directive at line " << yylineno << ", column " << yycolumn << std::endl;
            }
        } else {
            std::cerr << "ERROR: Unsupported (yet) assembler directive: " << localDirective << " at line " << yylineno << ", column " << yycolumn << std::endl;
        }
    }
#endif

public:

    const Line operator[](int index) {
        return mLines[index];
    }

    void add(const Base& element){
        mCurrentLine.add(element);
    }

    void addAssemblerDirective(const char* /*directive*/){
    }

    void addAssemblerDirective(const char* /*directive*/, const char* /*param1*/){
    }

    void addAssemblerLineComment(const char* text){
        // starting at index 1 to remove the ';' bit
        // what about any possible space ?
        AssemblerLineComment comment(&text[1]);
        addLineComment(comment);
    }

    void addCppDirective(const char* directive, const char* param1){
        printf("Parsed C/C++ directive: '%s', parameter: '%s'\n", directive, param1);
    }

    void addCppLineComment(const char* text){
        CppLineComment comment(&text[2]);
        //addLineComment(comment);
        //printf("Parsed C/C++ directive: '%s', parameter: '%s'\n", directive, param1);
    }

    void addEOL(){
        mLines.push_back(mCurrentLine);
        //mCurrentLine = Base();  // reset current line to an empty line
    }

    void addLabel(const char* identifier){
        //gLines.push_back({$1, ""});
        printf("Parsed label: '%s'\n", identifier);
    }

    std::vector<Line>::iterator begin() {
        return mLines.begin();
    }

    /**
     * Clears all contents.
     */
    int clear() {
        mLines.clear();
        return 0;
    }

    std::vector<Line>::iterator end() {
        return mLines.end();
    }

    void format() const {
    #if 0
        void print_formatted_asm() {
        LOG_DEBUG("calling print_formatted_asm()");
        for (const Line &line : gLines) {
            std::cout << line.format();
        }
        gLines.clear();
        }
    #endif
    }


    /**
     * Returns number of lines.
     */
    int size() const {
        return mLines.size();
    }
};

extern Lines gLines;

#endif // LINE_H_INCLUDEDs
