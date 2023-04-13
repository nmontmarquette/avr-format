%{
#include <iostream>
#include "parser.tab.hpp"
extern int yyparse();
void yyerror(const char *s);

int yycolumn = 1;
%}

%option noyywrap

%%

[ \t]         { yycolumn += yyleng; }
\n            { ++yylineno; yycolumn = 1; }
[a-zA-Z][a-zA-Z0-9]*       { yylval.sval = strdup(yytext); yycolumn += yyleng; return LABEL; }
,             { yycolumn += yyleng; return COMMA; }
[0-9]+        { yylval.ival = atoi(yytext); yycolumn += yyleng; return NUMBER; }
\+            { yycolumn += yyleng; return PLUS; }
\-            { yycolumn += yyleng; return MINUS; }
\*            { yycolumn += yyleng; return MULT; }
\/            { yycolumn += yyleng; return DIV; }
\(            { yycolumn += yyleng; return LPAREN; }
\)            { yycolumn += yyleng; return RPAREN; }
;[^\n]*       { yycolumn += yyleng; }
.             { std::cerr << "Unknown character: " << yytext[0] << " at line " << yylineno << ", column " << yycolumn << std::endl; exit(1); }

%%
