%{
#include<stdio.h>
#include<stdlib.h>
struct symbol {
    char *name;
    double value;
}
symbol symbols[100];
symbol* symbolfind(char*);
char idStr[50];
int yylex();
extern int yyparse();
FILE *yyin;
void yyerror(const char* s);
%}

%union {
        double  dval;
        symbol* sym;
}

%token <sym> ID
%token <dval> NUMBER
%token <dval> expr
%token ADD
%token SUB
%token MUL
%token DIV
%token leftPar
%token rightPar
%token assign
%left ADD SUB
%left MUL DIV
%right UMINUS

%%
lines   :   stmt ';'
        |   lines stmt ';' 
        ;
        
stmt    :   ID assign expr {$1->value=$3;}
        |   expr   { printf("%g\n",$1); }
        ;
    
expr    :   expr ADD expr  {$$=$1+$3;}
        |   expr SUB expr  {$$=$1-$3;}
        |   expr MUL expr  {$$=$1*$3;}
        |   expr DIV expr  {$$=$1/$3;}
        |   leftPar expr rightPar {$$=$2;}
        |   SUB expr %prec UMINUS {$$=-$2;}
        |   NUMBER {$$=$1;}
        |   ID {$$=$1->value;} 
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
            yylval.dval=0;
            while(isdigit(t))
            {
                yylval.dval=yylval.dval*10+t-'0';
                t=getchar();
            }
            ungetc(t,stdin);
            return NUMBER;
        }
        else if (( t >= 'a' && t <= 'z') || ( t >= 'A' && t <= 'Z') || ( t == '_'))
        {
            int ti = 0;
            while (( t >= 'a' && t <= 'z') || ( t >= 'A' && t <= 'Z') || ( t == '_')
            || (t >= '0' && t <='9'))
             {
                 idStr[ti] = t;
                 ti++;
                 t = getchar();
             }
             idStr[ti] = '\0';
             yylval.sym = symbolfind(idStr);
             ungetc(t, stdin);
             return ID;
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
        else if(t=='=')
        {
            return assign;
        }
        else
        {
            return t;
        }
    }
}
struct symbol* symbolfind(char* s){
        char *p;
        struct symbol *sp;
        for(sp=symbols;sp<&symbols[100];sp++){
                if(sp->name && !strcmp(sp->name,s))
                        return sp;
        if(!sp->name){
                sp->name=strdup(s);
                return sp;
                }
        }
        yyerror("Too many symbols.");
        exit(1);
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
