%{
#include <iostream>
#include "parser.tab.hpp"
#include "../asmline.h"

int yycolumn = 1;
%}

%option noyywrap

%x COMMENT

%%

<INITIAL>{
    [ \t]         { yycolumn += yyleng; }
    \n            { ++yylineno; yycolumn = 1; }
    [a-zA-Z][a-zA-Z0-9]*       { yylval.sval = strdup(yytext); yycolumn += yyleng; return LABEL; }
    ,             { yycolumn += yyleng; return COMMA; }
    [0-9]+        { yylval.ival = atoi(yytext); yycolumn += yyleng; return NUMBER; }
    ;[^\n]*       { yycolumn += yyleng; }
    \/\*          { BEGIN(COMMENT); yycolumn += yyleng; }
    .             { std::cerr << "Unknown character: " << yytext[0] << " at line " << yylineno << ", column " << yycolumn << std::endl; exit(1); }
}

<COMMENT>{
    \/\*          { std::cerr << "Error: Nested /* */ comments are not allowed" << std::endl; exit(1); }
    \*\/          { BEGIN(INITIAL); yycolumn += yyleng; }
    \n            { ++yylineno; yycolumn = 1; }
    .             { yycolumn += yyleng; }
    [^\n\*\/]+    { yycolumn += yyleng; }
}

%%
