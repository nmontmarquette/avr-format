%{
#include <iostream>
#include <string>
#include <vector>

extern int yylex();
extern void yyerror(const char *s);

int yywrap() {
    return 1;
}

struct AsmLine {
    std::string label;
    std::string instruction;
};

std::vector<AsmLine> asm_lines;

void print_formatted_asm();

%}

%union {
    char *sval;
}

%token <sval> LABEL
%token <sval> INSTRUCTION
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

void yyerror(const char *s) {
    std::cerr << "Error: " << s << std::endl;
}
