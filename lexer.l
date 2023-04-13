%{
#include <iostream>
#include "parser.tab.hpp"
#include "../asmline.h"

int yycolumn = 1;

const char* token_type_to_str(const int token_type){
    switch(token_type){
        case COMMA: return "COMMA";
        case LINE_COMMENT: return "LINE_COMMENT";
        case MULTI_LINE_COMMENT: return "MULTI_LINE_COMMENT";
        case LABEL: return "LABEL";
        case NEWLINE: return "NEWLINE";
        case NUMBER: return "NUMBER";
        default: return "UNKNOWN";
    }
}

void debug_print(const int token_type){
    printf("Line:%d column:%d, token: %s, text:'%s'\n", yylineno, yycolumn, token_type_to_str(token_type), yytext);
}

%}

%option noyywrap

%x COMMENT

%%

<INITIAL>{
    [ \t]         { debug_print(TAB); yycolumn += yyleng; }
    \n            { debug_print(NEWLINE); ++yylineno; yycolumn = 1; }
    [a-zA-Z][a-zA-Z0-9]*       { debug_print(LABEL); yylval.sval = strdup(yytext); yycolumn += yyleng; return LABEL; }
    ,             { debug_print(COMMA); yycolumn += yyleng; return COMMA; }
    [0-9]+        { debug_print(NUMBER); yylval.ival = atoi(yytext); yycolumn += yyleng; return NUMBER; }
    ;[^\n]*       { debug_print(LINE_COMMENT); yycolumn += yyleng; return LINE_COMMENT; }
    \/\*          { debug_print(MULTI_LINE_COMMENT); BEGIN(COMMENT); yycolumn += yyleng; }
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
