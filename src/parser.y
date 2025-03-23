%{
#include <iostream>

extern int yyinput();
extern int yylex();
extern void yyerror(const char *s);

int yywrap() {
    return 1;
}

#include "lines.h"

Lines gLines;

// forward declarations
extern int yylineno;
extern int yycolumn;
extern char *yytext;

void print_formatted_asm(){
    printf("Calling print_formatted_asm()\n");
}

void print_formatted_asm1(){
    printf("Calling print_formatted_asm1()\n");
}

void print_formatted_asm2(){
    printf("Calling print_formatted_asm2()\n");
}

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
%token <sval> AVR_INSTRUCTION
%token LINE_COMMENT
%token <sval> NUMBER
%token LPAREN RPAREN
%token EOL
%token <sval> ASM_DIRECTIVE
%token <sval> C_DIRECTIVE
%token SEMICOLON
%token <sval> STRING

%type <sval> comment
%type <sval> directive
%type <sval> label
%type <sval> argument

%%

program:
        | line { print_formatted_asm1(); }
        | program line { print_formatted_asm2(); }
        ;

line:
          EOL                     { gLines.addEOL(); }
        | comment EOL             { printf("parser: comment\n"); gLines.addAssemblerLineComment($1); free($1); }
        | label EOL               { printf("parser: label\n"); gLines.addLabel($1); free($1); }
        | directive EOL           { printf("parser: directive\n"); free($1); }
        | directive comment EOL   { printf("parser: directive comment\n");free($1); free($2); }
        | label comment           { printf("parser: label comment\n");free($1); free($2); }
        ;
//instruction:
//          INSTRUCTION  OPERAND
directive:
          C_DIRECTIVE argument    { gLines.addCppDirective($1, $2); }
        | ASM_DIRECTIVE           { gLines.addAssemblerDirective($1);}
        | ASM_DIRECTIVE argument  { gLines.addAssemblerDirective($1, $2); }
        ;

argument: IDENTIFIER              { $$ = $1; }
        | STRING                  { $$ = $1; }
        ;

label:
        LABEL                     { $$ = $1; }
        ;

comment:
          ASM_LINE_COMMENT { $$ = $1; gLines.addAssemblerLineComment($1); }
        | CPP_LINE_COMMENT { $$ = $1; gLines.addCppLineComment($1); }
        ;


%%

void yyerror(const char *error_message) {
    std::cerr << "Error: " << error_message << " at line " << yylineno << ", column " << yycolumn << ", near '" << yytext << "'" << std::endl;
}

