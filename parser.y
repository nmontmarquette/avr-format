%{
#include <iostream>

extern int yylex();
extern void yyerror(const char *s);

int yywrap() {
    return 1;
}

#include "../asmline.h"

std::vector<AsmLine> asm_lines;

void print_formatted_asm();

%}

%union {
    int ival; // Add this line
    char *sval;
    //AsmLine alval;
}

%token <sval> LABEL
%token <sval> INSTRUCTION
%token COMMA PLUS MINUS MULT DIV
%token NUMBER
%token LPAREN RPAREN
%token EOL

%type <sval> label
%type <sval> instruction

%%

program:
        line { print_formatted_asm(); }
        | program line { print_formatted_asm(); }
        ;

line:
        eol
        | label eol                  { asm_lines.push_back({$1, ""}); free($1); }
        | instruction eol            { asm_lines.push_back({"", $1}); free($1); }
        | label instruction eol      { asm_lines.push_back({$1, $2}); free($1); free($2); }
        ;

eol:
        EOL
        ;

label:
        LABEL                        { $$ = $1; }
        ;

instruction:
        INSTRUCTION                  { $$ = $1; }
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

extern int yylineno;
extern int yycolumn;
extern char *yytext;

void yyerror(const char *error_message) {
    std::cerr << "Error: " << error_message << " at line " << yylineno << ", column " << yycolumn << ", near '" << yytext << "'" << std::endl;
}

