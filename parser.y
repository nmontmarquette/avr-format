%{
#include <iostream>

extern int yyinput();
extern int yylex();
extern void yyerror(const char *s);
extern void skip_to_eol();

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
void skip_to_eol();

%}

%union {
    int ival; // Add this line
    char *sval;
    //AsmLine alval;
}

%token <sval> LABEL
%token <sval> INSTRUCTION
%token COMMA PLUS MINUS MULT DIV
%token COMMENT
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

line: EOL                         { printf("Parsed empty line\n"); }
        | label EOL               { asm_lines.push_back({$1, ""}); printf("Parsed label: '%s'\n", $1); free($1); }
        | comment EOL             { printf("Parsed comment: '%s'\n", $1); }
        | directive EOL           { asm_lines.push_back({"", $1}); free($1); }
        | directive comment       { asm_lines.push_back({"", $1}); free($1); }
        | label comment { asm_lines.push_back({$1, $2}); free($1); free($2); }
        ;

directive:
          C_DIRECTIVE WHITESPACE argument     { printf("Parsed C/C++ directive: '%s', parameter: '%s'\n", $1, $3); }
        | ASM_DIRECTIVE      { printf("Parsed simple assembler directive: '%s'\n", $1); }
        | ASM_DIRECTIVE WHITESPACE argument     { printf("Parsed simple assembler directive: '%s', parameter: '%s'\n", $1, $3); }
        | ASM_DIRECTIVE      {  }
        ;

argument: IDENTIFIER                        { $$ = $1; }
        | STRING                        { $$ = $1; }
        ;

label:
        LABEL                        { $$ = $1; }
        ;

comment: SEMICOLON { skip_to_eol(); }
       ;


%%

void print_formatted_asm() {
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

void yyerror(const char *error_message) {
    std::cerr << "Error: " << error_message << " at line " << yylineno << ", column " << yycolumn << ", near '" << yytext << "'" << std::endl;
}

