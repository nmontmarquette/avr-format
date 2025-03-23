/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     LABEL = 258,
     INSTRUCTION = 259,
     COMMA = 260,
     PLUS = 261,
     MINUS = 262,
     MULT = 263,
     DIV = 264,
     ASM_LINE_COMMENT = 265,
     CPP_LINE_COMMENT = 266,
     IDENTIFIER = 267,
     INCLUDE = 268,
     AVR_INSTRUCTION = 269,
     LINE_COMMENT = 270,
     NUMBER = 271,
     LPAREN = 272,
     RPAREN = 273,
     EOL = 274,
     ASM_DIRECTIVE = 275,
     C_DIRECTIVE = 276,
     SEMICOLON = 277,
     STRING = 278
   };
#endif
/* Tokens.  */
#define LABEL 258
#define INSTRUCTION 259
#define COMMA 260
#define PLUS 261
#define MINUS 262
#define MULT 263
#define DIV 264
#define ASM_LINE_COMMENT 265
#define CPP_LINE_COMMENT 266
#define IDENTIFIER 267
#define INCLUDE 268
#define AVR_INSTRUCTION 269
#define LINE_COMMENT 270
#define NUMBER 271
#define LPAREN 272
#define RPAREN 273
#define EOL 274
#define ASM_DIRECTIVE 275
#define C_DIRECTIVE 276
#define SEMICOLON 277
#define STRING 278




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 35 "src/parser.y"
{
    int ival; // Add this line
    char *sval;
    //AsmLine alval;
}
/* Line 1529 of yacc.c.  */
#line 101 "src/parser.tab.hpp"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

