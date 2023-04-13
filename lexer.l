%{
#include <iostream>
#include "parser.tab.hpp"
extern int yyparse();
void yyerror(const char *s);
%}

%option noyywrap

%%

[ \t]+                  /* Ignore whitespace */

[A-Za-z_][A-Za-z0-9_]*:  { yylval.sval = strdup(yytext); return LABEL; }
[A-Za-z_][A-Za-z0-9_]*   { yylval.sval = strdup(yytext); return INSTRUCTION; }

[\n]                     { return EOL; }

.                        { /* Ignore other characters */ }

%%
