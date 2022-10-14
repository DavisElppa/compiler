%{
#include<stdio.h>
#include<stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
extern int yyparse();
FILE *yyin;
void yyerror(const char* s);
int decimal=0;
%}

%token NUMBER
%token ADD
%token SUB
%token MUL
%token DIV
%token leftPar
%token rightPar
%left ADD SUB
%left MUL DIV
%right UMINUS

%%
lines   :   lines expr ';' {printf("%f\n",$2);}
        |   lines ';'
        |   
        ;
    
expr    :   expr ADD expr  {$$=$1+$3;}
        |   expr SUB expr  {$$=$1-$3;}
        |   expr MUL expr  {$$=$1*$3;}
        |   expr DIV expr  {$$=$1/$3;}
        |   leftPar expr rightPar {$$=$2;}
        |   SUB expr %prec UMINUS {$$=-$2;}
        |   NUMBER {$$=$1;}
        ;
%%

int yylex()
{
    int t;
    while(1)
    {
        t=getchar();
        if(t==' '|| t=='\t' || t=='\n')
        {

        }
        else if(isdigit(t))
        {
            yylval=0;
            double cnt=10;
            while(isdigit(t))
            {
                if(decimal)
                {
                    yylval=yylval+(t-'0')/cnt;
                    cnt*=10;

                }
                else
                {
                    yylval=yylval*10+t-'0';
                }
                t=getchar();
                if(t=='.')
                {
                    decimal=1;
                    t=getchar();
                }
            }
            /* 跳出循环，是否是小数仍然要赋值为否*/
            decimal=0;
            ungetc(t,stdin);
            return NUMBER;
        }
        else if(t=='+')
        {
            return ADD;
        }
        else if(t=='-')
        {
            return SUB;
        }
        else if(t=='*')
        {
            return MUL;
        }
        else if(t=='/')
        {
            return DIV;
        }
        else if(t=='(')
        {
            return leftPar;
        }
        else if(t==')')
        {
            return rightPar;
        }
        else
        {
            return t;
        }
    }
}
void yyerror(const char* s){
	fprintf(stderr, "Parse error:%s\n", s);
	exit(1);
}
int main(void)
{
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
