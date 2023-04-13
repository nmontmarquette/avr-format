%{
#include <iostream>
#include "parser.tab.hpp"
#include "../asmline.h"

int yycolumn = 1;

const char* token_type_to_str(const int token_type){
    switch(token_type){
        case ASM_DIRECTIVE: return "ASM_DIRECTIVE";
        case ASM_LINE_COMMENT: return "ASM_LINE_COMMENT";
        case COMMA: return "COMMA";
        case C_DIRECTIVE: return "C_DIRECTIVE";
        case CPP_LINE_COMMENT: return "CPP_LINE_COMMENT";
        case EOL: return "EOL";
        case LINE_COMMENT: return "LINE_COMMENT";
        case MULTI_LINE_COMMENT: return "MULTI_LINE_COMMENT";
        case MULTI_LINE_COMMENT_END: return "MULTI_LINE_COMMENT_END";
        case IDENTIFIER: return "IDENTIFIER";
        case INCLUDE: return "INCLUDE";
        case LABEL: return "LABEL";
        case NUMBER: return "NUMBER";
        case SEMICOLON: return "SEMICOLON";
        case STRING: return "STRING";
        //case WHITESPACE: return "WHITESPACE";
        default: return "UNKNOWN";
    }
}

static int yyinput();
static void yyunput (int c, char *buf_ptr);


void debug_print(const int token_type){
    // Prevent debug-printing an actual '\n' character
    if(EOL==token_type){
        printf("Found token: '%s' at line:%d column:%d\n", token_type_to_str(token_type), yylineno, yycolumn);
    } else {
        printf("Found token: '%s' at line:%d column:%d, text:'%s'\n", token_type_to_str(token_type), yylineno, yycolumn, yytext);
    }
}

%}

%option noyywrap

%x MULTI_LINE_COMMENT

%%

<INITIAL>{
    \"([^\\\"]|\\.)*\" { debug_print(STRING); yylval.sval = strdup(yytext); yycolumn += yyleng; return STRING; }
    [\ \t]+        { yycolumn += yyleng; }
    \n            { debug_print(EOL); ++yylineno; yycolumn = 1; return EOL;}
    [a-zA-Z][a-zA-Z0-9_]*:       { debug_print(LABEL); yylval.sval = strdup(yytext); yycolumn += yyleng; return LABEL; }
    [a-zA-Z][a-zA-Z0-9_]*       { debug_print(IDENTIFIER); yylval.sval = strdup(yytext); yycolumn += yyleng; return IDENTIFIER; }
    ,             { debug_print(COMMA); yycolumn += yyleng; return COMMA; }
    [0-9]+        { debug_print(NUMBER); yylval.ival = atoi(yytext); yycolumn += yyleng; return NUMBER; }
    ";".*         { debug_print(ASM_LINE_COMMENT); yylval.sval = strdup(yytext); yycolumn += yyleng; return ASM_LINE_COMMENT; }
    "//".*        { debug_print(CPP_LINE_COMMENT); yylval.sval = strdup(yytext); yycolumn += yyleng; return CPP_LINE_COMMENT; }
    \.[a-z]+      { debug_print(ASM_DIRECTIVE); yylval.sval = strdup(yytext); yycolumn += yyleng; return ASM_DIRECTIVE; }
    \#[a-z]+      { debug_print(C_DIRECTIVE); yylval.sval = strdup(yytext); yycolumn += yyleng; return C_DIRECTIVE; }
    \/\*          { debug_print(MULTI_LINE_COMMENT); BEGIN(MULTI_LINE_COMMENT); yycolumn += yyleng; }
    .             { yycolumn += yyleng; return yytext[0]; }
}

<MULTI_LINE_COMMENT>{
    \/\*          { std::cerr << "Error: Nested /* */ comments are not allowed" << std::endl; exit(1); }
    \*\/          { BEGIN(INITIAL); yycolumn += yyleng; }
    \n            { ++yylineno; yycolumn = 1; }
    .             { yycolumn += yyleng; }
    [^\n\*\/]+    { yycolumn += yyleng; }
    \/\*.*\*\/    { yycolumn += yyleng; }
}

%%
