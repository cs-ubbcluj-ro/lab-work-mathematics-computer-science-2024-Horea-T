%{
#include <stdio.h>
#include "yacc.tab.h" // Include Yacc definitions
#define YYDEBUG 1
%}

%%

"THM Language"         { return THM_LANGUAGE; }
"int"                  { return INT; }
"char"                 { return CHAR; }
"typedef"              { return TYPEDEF; }
"input"                { return INPUT; }
"output"               { return OUTPUT; }
"if"                   { return IF; }
"else"                 { return ELSE; }
"while"                { return WHILE; }
"for"                  { return FOR; }
"="                    { return ASSIGNMENT; }
"=="                   { return EQUAL; }
"!="                   { return NOT_EQUAL; }
"<"                    { return LESS; }
"<="                   { return LESS_EQUAL; }
">"                    { return GREATER; }
">="                   { return GREATER_EQUAL; }
"+"                    { return PLUS; }
"-"                    { return MINUS; }
"*"                    { return TIMES; }
"/"                    { return DIVIDE; }
"%"                    { return MOD; }
";"                    { return SEMICOLON; }
","                    { return COMMA; }
"("                    { return LPAREN; }
")"                    { return RPAREN; }
"{"                    { return LBRACE; }
"}"                    { return RBRACE; }
"["                    { return LBRACKET; }
"]"                    { return RBRACKET; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return IDENTIFIER_NUMBER; }
[0-9]+                 { yylval.ival = atoi(yytext); return CONSTANT_NUMBER; }
\'[^\']\'              { yylval.cval = yytext[1]; return CHARACTER_LITERAL; }
\"[^\"]*\"             { yylval.sval = strdup(yytext); return STRING_LITERAL; }
"//".*                 { /* Ignore comments */ }
[ \t\r\n]+             { /* Skip whitespace */ }
.                      { printf("Unknown token: '%s'\n", yytext); }

%%

int yywrap() {
    return 1;
}
