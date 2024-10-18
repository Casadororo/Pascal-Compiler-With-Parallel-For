%{
#include <cstdlib>
#include "bison.hpp"
using namespace bison;

#include "../includes/compilador.hpp"

#include <cstdlib>
#include <iomanip>

#define PADD std::left << std::setw(16) << std::setfill(' ')
#define IMPRIME(STR) std::cerr << PADD << STR << "\t# " << PADD << simbolo_flex << nl << '\n' ;

%}

%option reentrant interactive noyywrap noyylineno nodefault outfile="flex.cpp" header="flex.hpp"

pulo_linha [\n]

descarte [\t ]+

ident [a-zA-Z][a-zA-Z0-9]*

numero [0-9]+

comentario "(*".*"*)"

comentario2 "//".*

%%

{pulo_linha} {nl++;}

{descarte}

{comentario}

{comentario2}

program {
  simbolo_flex = yytext;        
  IMPRIME("program");
  return Parser::token::yytokentype::PROGRAM;
}

var {
  simbolo_flex = yytext;
  IMPRIME("var");
  return Parser::token::VAR;
}

begin {
  simbolo_flex = yytext;
  IMPRIME("begin");
  return Parser::token::T_BEGIN;
}

end {
  simbolo_flex = yytext;
  IMPRIME("end");
  return Parser::token::T_END;
}

label {
  simbolo_flex = yytext;
  IMPRIME("label");
  return Parser::token::LABEL;
}

type {
  simbolo_flex = yytext;
  IMPRIME("type");
  return Parser::token::TYPE;
}

array {
  simbolo_flex = yytext;
  IMPRIME("array");
  return Parser::token::ARRAY;
}

procedure {
  simbolo_flex = yytext;
  IMPRIME("procedure");
  return Parser::token::PROCEDURE;
}

function {
  simbolo_flex = yytext;
  IMPRIME("function");
  return Parser::token::FUNCTION;
}

goto {
  simbolo_flex = yytext;
  IMPRIME("goto");
  return Parser::token::GOTO;
}

if {
  simbolo_flex = yytext;
  IMPRIME("if");
  return Parser::token::IF;
}

else {
  simbolo_flex = yytext;
  IMPRIME("else");
  return Parser::token::ELSE;
}

then {
  simbolo_flex = yytext;
  IMPRIME("then");
  return Parser::token::THEN;
}

while {
  simbolo_flex = yytext;
  IMPRIME("while");
  return Parser::token::WHILE;
}

for_parallel {
  simbolo_flex = yytext;
  IMPRIME("for_parallel");
  return Parser::token::FOR_PARALLEL;
}

to {
  simbolo_flex = yytext;
  IMPRIME("to");
  return Parser::token::TO;
}

into {
  simbolo_flex = yytext;
  IMPRIME("into");
  return Parser::token::INTO;
}

do {
  simbolo_flex = yytext;
  IMPRIME("do");
  return Parser::token::DO;
}

or {
  simbolo_flex = yytext;
  IMPRIME("or");
  return Parser::token::OR;
}

div {
  simbolo_flex = yytext;
  IMPRIME("div");
  return Parser::token::DIV;
}

and {
  simbolo_flex = yytext;
  IMPRIME("and");
  return Parser::token::AND;
}

not {
  simbolo_flex = yytext;
  IMPRIME("not");
  return Parser::token::NOT;
}

read {
  simbolo_flex = yytext;
  IMPRIME("read");
  return Parser::token::READ;
}

write {
  simbolo_flex = yytext;
  IMPRIME("write");
  return Parser::token::WRITE;
}

true {
  simbolo_flex = yytext;
  IMPRIME("true");
  return Parser::token::TRUE;
}

false {
  simbolo_flex = yytext;
  IMPRIME("false");
  return Parser::token::FALSE;
}

:= {
  simbolo_flex = yytext;
  IMPRIME("atribuicao");
  return Parser::token::ATRIBUICAO;
}

\; {
  simbolo_flex = yytext;
  IMPRIME("ponto_virgula");
  return Parser::token::PONTO_E_VIRGULA;
}

\: {
  simbolo_flex = yytext;
  IMPRIME("dois_pontos");
  return Parser::token::DOIS_PONTOS;
}

\, {
  simbolo_flex = yytext;
  IMPRIME("virgula");
  return Parser::token::VIRGULA;
}


\. {
  simbolo_flex = yytext;
  IMPRIME("ponto");
  return Parser::token::PONTO;
   }

\( {
  simbolo_flex = yytext;
  IMPRIME("abre_parenteses");
  return Parser::token::ABRE_PARENTESES;
   }

\) {
  simbolo_flex = yytext;
  IMPRIME("fecha_parenteses");
  return Parser::token::FECHA_PARENTESES;
}

\{ {
  simbolo_flex = yytext;
  IMPRIME("abre_chave");
  return Parser::token::ABRE_CHAVE;
}

\} {
  simbolo_flex = yytext;
  IMPRIME("fecha_chave");
  return Parser::token::FECHA_CHAVE;
}

\[ {
  simbolo_flex = yytext; 
  IMPRIME("abre_colchete");
  return Parser::token::ABRE_COLCHETE;
}

\] {
  simbolo_flex = yytext;
  IMPRIME("fech_colchete");
  return Parser::token::FECHA_COLCHETE;
}

\= {
  simbolo_flex = yytext;
  IMPRIME("igual");
  return Parser::token::IGUAL;
}

\<> {
  simbolo_flex = yytext;
  IMPRIME("diferente");
  return Parser::token::DIFERENTE;
}

\< {
  simbolo_flex = yytext;
  IMPRIME("menor_que");
  return Parser::token::MENOR_QUE;
}

\<= {
  simbolo_flex = yytext;
  IMPRIME("menor_ou_igual");
  return Parser::token::MENOR_OU_IGUAL;
}

\>= {
  simbolo_flex = yytext;
  IMPRIME("maior_ou_igual");
  return Parser::token::MAIOR_OU_IGUAL;
}

\> {
  simbolo_flex = yytext;
  IMPRIME("maior_que");
  return Parser::token::MAIOR_QUE;
}

\+ {
  simbolo_flex = yytext;
  IMPRIME("mais");
  return Parser::token::MAIS;
}

\- {
  simbolo_flex = yytext;
  IMPRIME("menos");
  return Parser::token::MENOS;
}

\* {
  simbolo_flex = yytext;
  IMPRIME("multiplica");
  return Parser::token::MULTI;
}

{numero} {
  simbolo_flex = yytext;
  IMPRIME("numero");
  return Parser::token::NUMERO;
}

{ident} {
  simbolo_flex = yytext;
  IMPRIME("ident");
  return Parser::token::IDENT;
}

.           /* no action on unmatched input */

%%

int main(int argc, char* argv[]) {  
  yyscan_t scanner;
  FILE *inputFile;

  if (argc<2 || argc>2) {
    printf("usage compilador <arq>a %d\n", argc);
    return(-1);
  }

  inputFile = fopen(argv[1], "r");
  if (inputFile == NULL) {
    printf("usage compilador <arq>b\n");
    return(-1);
  }

  yylex_init(&scanner);
  yyset_in(inputFile, scanner);
  bison::Parser parser{ scanner };
  std::cout.precision(10);
  parser.parse();
  yylex_destroy(scanner);
}