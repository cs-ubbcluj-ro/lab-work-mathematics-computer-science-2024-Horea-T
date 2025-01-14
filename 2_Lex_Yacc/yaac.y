%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Define YYSTYPE
typedef union {
    int ival;
    char *sval;
} YYSTYPE;

#define YYSTYPE YYSTYPE
extern FILE *yyin;

void yyerror(const char *s);
int yylex(void);
%}

%union {
    int ival;
    char *sval;
}

%token THM_LANGUAGE INT CHAR TYPEDEF INPUT OUTPUT IF ELSE WHILE FOR
%token IDENTIFIER_NUMBER CONSTANT_NUMBER ASSIGNMENT
%token PLUS MINUS TIMES DIVIDE MOD
%token LESS LESS_EQUAL EQUAL NOT_EQUAL GREATER_EQUAL GREATER
%token SEMICOLON COMMA LPAREN RPAREN LBRACE RBRACE

%left PLUS MINUS
%left TIMES DIVIDE MOD
%nonassoc LESS LESS_EQUAL EQUAL NOT_EQUAL GREATER_EQUAL GREATER

%%
thm_program:
    THM_LANGUAGE declaration_list statement_list
    {
        printf("Program syntactic correct\n");
    }
    ;

declaration_list:
    declaration SEMICOLON
    | declaration SEMICOLON declaration_list
    ;

declaration:
    INT id_list
    | CHAR id_list
    | TYPEDEF IDENTIFIER_NUMBER
    ;

id_list:
    IDENTIFIER_NUMBER
    | IDENTIFIER_NUMBER COMMA id_list
    ;

statement_list:
    statement SEMICOLON
    | statement SEMICOLON statement_list
    ;

statement:
    assignment_stmt
    | conditional_stmt
    | loop_stmt
    | io_stmt
    ;

assignment_stmt:
    IDENTIFIER_NUMBER ASSIGNMENT expression
    ;

conditional_stmt:
    IF LPAREN condition RPAREN LBRACE statement_list RBRACE
    | IF LPAREN condition RPAREN LBRACE statement_list RBRACE ELSE LBRACE statement_list RBRACE
    ;

loop_stmt:
    WHILE LPAREN condition RPAREN LBRACE statement_list RBRACE
    | FOR LPAREN assignment_stmt SEMICOLON condition SEMICOLON expression RPAREN LBRACE statement_list RBRACE
    ;

io_stmt:
    INPUT LPAREN IDENTIFIER_NUMBER RPAREN
    | OUTPUT LPAREN IDENTIFIER_NUMBER RPAREN
    ;

expression:
    term
    | expression PLUS term
    | expression MINUS term
    ;

term:
    factor
    | term TIMES factor
    | term DIVIDE factor
    | term MOD factor
    ;

factor:
    IDENTIFIER_NUMBER
    | CONSTANT_NUMBER
    | LPAREN expression RPAREN
    ;

condition:
    expression relational_operator expression
    ;

relational_operator:
    LESS
    | LESS_EQUAL
    | EQUAL
    | NOT_EQUAL
    | GREATER_EQUAL
    | GREATER
    ;

%%
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Error: Could not open file %s\n", argv[1]);
            return 1;
        }
        yyin = file; // Redirect input to the file
    }

    if (yyparse() == 0) {
        printf("Parsing completed successfully.\n");
    } else {
        printf("Parsing failed.\n");
    }

    return 0;
}
