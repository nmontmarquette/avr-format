%{
#include <iostream>
#include <cassert>

extern int yyinput();
extern int yylex();
extern void yyerror(const char *s);

int yywrap() {
    return 1;
}

#include "../asmline.h"

std::vector<AsmLine> asm_lines;

// forward declarations
extern int yylineno;
extern int yycolumn;
extern char *yytext;

void print_formatted_asm();
void process_eol();
void process_asm_line_comment(const char* text);
void process_cpp_line_comment(const char* text);

#if DEBUG
#   define LOG_DEBUG(format, ...) printf("DEBUG: " format "\n", ##__VA_ARGS__)
//#   define DEBUG_ASM_LINES() LOG_DEBUG("asm_lines.size()=%d, addr:%0x16x\n",asm_lines.size(), &asm_lines)
#   define DEBUG_ASM_LINES()
#   define ASSERT(condition) assert(condition)
#else
#   define LOG_DEBUG(format, ...)
#   define DEBUG_ASM_LINES()
#   define ASSERT(condition)
#endif

%}

%union {
    int ival; // Add this line
    char *sval;
    //AsmLine alval;
}

%token <sval> LABEL
%token <sval> INSTRUCTION
%token COMMA PLUS MINUS MULT DIV
%token <sval> ASM_LINE_COMMENT
%token <sval> CPP_LINE_COMMENT
%token <sval> IDENTIFIER
%token <sval> INCLUDE
%token LINE_COMMENT
%token MULTI_LINE_COMMENT MULTI_LINE_COMMENT_END
%token <sval> NUMBER
%token LPAREN RPAREN
%token EOL
%token <sval> ASM_DIRECTIVE
%token <sval> C_DIRECTIVE
%token SEMICOLON
%token <sval> STRING
%token <sval> WHITESPACE

%type <sval> comment
%type <sval> directive
%type <sval> label
%type <sval> argument

%%

program:
        line { print_formatted_asm(); }
        | program line { print_formatted_asm(); }
        ;

line:
          EOL                     { process_eol(); }
        | label EOL               { asm_lines.push_back({$1, ""}); printf("Parsed label: '%s'\n", $1); free($1); DEBUG_ASM_LINES();}
        | comment EOL             { free($1); }
        | directive EOL           { asm_lines.push_back({"", $1}); free($1); DEBUG_ASM_LINES();}
        | directive comment EOL   { asm_lines.push_back({"", $1}); free($1); DEBUG_ASM_LINES();}
        | label comment           { asm_lines.push_back({$1, $2}); free($1); free($2); DEBUG_ASM_LINES();}
        ;
directive:
          C_DIRECTIVE argument     { printf("Parsed C/C++ directive: '%s', parameter: '%s'\n", $1, $2); }
        | ASM_DIRECTIVE      { printf("Parsed simple assembler directive: '%s'\n", $1); }
        | ASM_DIRECTIVE  { printf("Parsed simple assembler directive: '%s'\n", $1); }
        | ASM_DIRECTIVE argument     { printf("Parsed simple assembler directive: '%s', parameter: '%s'\n", $1, $2); }
        ;

argument: IDENTIFIER                        { $$ = $1; }
        | STRING                        { $$ = $1; }
        ;

label:
        LABEL                        { $$ = $1; }
        ;

comment:
          ASM_LINE_COMMENT { $$ = $1; process_asm_line_comment($1); }
        | CPP_LINE_COMMENT { $$ = $1; process_cpp_line_comment($1); }
        ;


%%

std::string trim(const std::string& str) {
    std::string result = str;

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

void process_eol(){
    LOG_DEBUG("Parsed empty line.");
    asm_lines.push_back({"", "", ""});
    DEBUG_ASM_LINES();
}

void print_formatted_asm() {
    return;
    LOG_DEBUG("calling print_formatted_asm()");
    for (const AsmLine &line : asm_lines) {
        if (!line.label.empty()) {
            std::cout << line.label << " ";
        }
        if (!line.instruction.empty()) {
            std::cout << "\t" << line.instruction << " ";
        }
        std::cout << std::endl;
    }
    asm_lines.clear();
}

void process_line_comment(const std::string& comment) {
    LOG_DEBUG("Parsed comment: '%s'", comment.c_str());
    asm_lines.push_back({"", "", comment.c_str()});
    DEBUG_ASM_LINES();
}

void process_asm_line_comment(const char* text) {
    ASSERT(text);
    ASSERT(text[0]==';');
    process_line_comment(trim(std::string(&text[1])));
}

void process_cpp_line_comment(const char* text) {
    ASSERT(text);
    ASSERT((text[0]=='/') && (text[1]=='/'));
    process_line_comment(trim(std::string(&text[2])));
}

void yyerror(const char *error_message) {
    std::cerr << "Error: " << error_message << " at line " << yylineno << ", column " << yycolumn << ", near '" << yytext << "'" << std::endl;
}

