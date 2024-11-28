%{
#include <iostream>
#include <string>
#include <cmath>
#include "flex.hpp"
#include "../includes/compilador.hpp"
#include "../includes/utils/for_parallel.hpp"

#define flags(STR) std::cerr << "\033[1;31m" << STR << "\033[0m\n"
#define flag std::cerr << "\033[1;31mFLAG\033[0m\n"

int lexic_level = 0;
int num_total_vars = 0;
int num_total_params = 0;
int num_same_type_vars = 0;
int num_type_declared = 0;
int top_desloc = 0;

std::list<Param> *params;
std::stack<std::list<Param>> expression_list_types = {};
std::stack<std::stack<Param>> calling_proc_params = {};
std::stack<int*> num_proc_declared = {};

bool inside_for_parallel = false;
%}

%require "3.7.4"
%language "C++"
%defines "bison.hpp"
%output "bison.cpp"

%define api.parser.class {Parser}
%define api.namespace {bison}
%define api.value.type variant
%param {yyscan_t scanner}

%code requires {
#include "../includes/utils/simbolos.hpp"
#include "../includes/utils/for_parallel.hpp"
#include <queue>
}

%code provides
{
    #define YY_DECL \
        int yylex(bison::Parser::semantic_type *yylval, yyscan_t yyscanner)
    YY_DECL;
}

%type <Param> variavel_func
%type <Param> fator
%type <Param> expressao_simples
%type <Param> expressao
%type <Param> termo

%type <Simbolo*> bloco
%type <Simbolo*> variavel
%type <Simbolo*> chamada_sem_pametro
%type <Simbolo*> declaracao_procedimento
%type <Simbolo*> declaracao_funcao
%type <Simbolo*> chamada_procedimento_parametros
%type <Simbolo*> chamada_funcao_sem_parametros
%type <std::string> ident

%type <int> parte_declara_vars
%type <int> parte_declara_tipo
%type <int> parte_declara_subrotinas_wrap

%type <tipo_parametro> tipo_parametro
%type <Tipo*> tipo

// Var define Stuff
%type <std::queue<Simbolo*>*> lista_var
%type <int> declara_var
%type <int> declara_vars

// Vector Stuff
%type <Simbolo*> variavel_with_vector
%type <int> vector_index_const

// Thread Stuff
%type <int> numero
%type <Simbolo*> for_parallel_attr
%type <Simbolo*> for_parallel_attr_const
%type <Simbolo*> for_parallel_to
%type <Simbolo*> for_parallel_step

%token PROGRAM VAR T_BEGIN T_END
%token LABEL TYPE ARRAY PROCEDURE
%token FUNCTION GOTO IF ELSE
%token THEN WHILE DO OR
%token DIV AND NOT READ
%token WRITE TRUE FALSE ATRIBUICAO
%token PONTO_E_VIRGULA DOIS_PONTOS VIRGULA PONTO
%token ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVE FECHA_CHAVE
%token ABRE_COLCHETE FECHA_COLCHETE IGUAL DIFERENTE
%token MENOR_QUE MENOR_OU_IGUAL MAIOR_OU_IGUAL MAIOR_QUE
%token MAIS MENOS MULTI NUMERO
%token IDENT

// Thread stuff
%token FOR_PARALLEL TO STEP CREATE_THREADS

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%%

// 1. programa -> PROGRAM IDENT '(' lista_idents ')' ';' bloco '.'
programa:  
   {
      iniciaCompilador();
      geraCodigo("INPP");
   }
   PROGRAM IDENT
   ABRE_PARENTESES lista_idents FECHA_PARENTESES PONTO_E_VIRGULA
   <Simbolo*>{
      simbolo_main = new Simbolo("main", lexic_level, new std::list<Param>(), main_process);

      $$ = simbolo_main;
   }
   bloco PONTO 
   {
      geraCodigo("PARA");
      desligaCompilador();
   }
;

bloco:
   <Simbolo*>{
      Simbolo* proce = $<Simbolo*>0;
      
      if (proce->is_proc_or_func()) {
         entraProce(proce);
      }else if (!proce->is_main()) {
         error("Suposto ser um simbolo de procedimento ou funcao, final do bloco de "
               "declaracoes de subrotinas");
      }

      top_desloc = 0;
      $<Simbolo*>$ = proce;
   }
   parte_declara_tipo 
   {
      $1->number_types = $2;
   }
   parte_declara_vars
   <Simbolo*>{
      $1->number_vars = $4;

      $$ = $1;
   }
   parte_declara_subrotinas_wrap
   {
      $1->number_procs = $6;

      if ($1->is_func())
         $1->allow_return = true;
   }
   comando_composto
   {
      Simbolo* proce = $1;

      removeSimbolos(proce->parametros->size() + proce->number_vars + proce->number_procs);

      removeTipos($1->number_types);
      geraCodigo("DMEM", proce->number_vars);
      visualizaTabelas();

      if (proce->is_proc_or_func())
         geraCodigo("RTPR", proce->nivel_lexico, proce->parametros->size());

      if (proce->is_func())
         $1->allow_return = false;
   }
;

for_parallel_bloco:
   <ForParallel*>{
      ForParallel *for_parallel = $<ForParallel*>0;

      // Entrada da thread
      geraCodigo("NADA", for_parallel->rotulo_entrada_thread.identificador);
      geraCodigo("AMEM", for_parallel->number_vars);

      geraCodigo("CRCT", for_parallel->n_threads->value);
      aplicarArmazena(for_parallel->n_threads);

      $<ForParallel*>$ = for_parallel;
   }
   parte_declara_vars
   FOR_PARALLEL for_parallel_attr TO for_parallel_to STEP for_parallel_step
   {
      ForParallel *for_parallel = $1;
      
      for_parallel->number_vars += $2;
      for_parallel->index = $4;
      for_parallel->index_upper_limit = $6;
      for_parallel->step = $8;

      visualizaTabelaSimbolos();

      geraCodigo("NADA", for_parallel->rotulo_entrada_for.identificador);

      aplicarCarrega(for_parallel->index);
      aplicarCarrega(for_parallel->index_upper_limit);
      geraCodigo("CMME");
      geraCodigo("DSVF", "", for_parallel->rotulo_saida_for.identificador);

   }
   comando_composto
   {
      ForParallel *for_parallel = $1;

      aplicarCarrega(for_parallel->index);
      aplicarCarrega(for_parallel->step);
      geraCodigo("SOMA");
      aplicarArmazena(for_parallel->index);

      geraCodigo("DSVS", "", for_parallel->rotulo_entrada_for.identificador);
      geraCodigo("NADA", for_parallel->rotulo_saida_for.identificador);
   }
;

for_parallel_attr:
   ident
   <Simbolo*>{
      Simbolo *index_var = new Simbolo($1, lexic_level, top_desloc, variavel_simples);
      top_desloc++;
      index_var->tipo_v = int_type;
      insereSimbolo(index_var);
      
      $$ = index_var;
   }
   ATRIBUICAO expressao
   {
      $$ = $2;

      if(*int_type != *($4.tipo_v))
         error("Tipos incompatíveis na atribuição");
      
      aplicarArmazena($$);
   }
;

for_parallel_attr_const:
   ident
   <Simbolo*>{
      Simbolo *index_var = new Simbolo($1, lexic_level, top_desloc, variavel_simples);
      top_desloc++;
      index_var->tipo_v = int_type;
      insereSimbolo(index_var);
      
      $$ = index_var;
   }
   ATRIBUICAO numero
   {
      $$ = $2;
      $$->value = $4;
   }
;

for_parallel_to:
   expressao
   {
      if(*int_type != *($1.tipo_v))
         error("Tipos incompatíveis na atribuição");

      Simbolo *to_var = new Simbolo("_to", lexic_level, top_desloc, variavel_simples);
      top_desloc++;
      to_var->tipo_v = int_type;
      insereSimbolo(to_var);
      
      aplicarArmazena(to_var);
      $$ = to_var;
   }
;

for_parallel_step:
   expressao
   {
      if(*int_type != *($1.tipo_v))
         error("Tipos incompatíveis na atribuição");

      Simbolo *to_var = new Simbolo("_step", lexic_level, top_desloc, variavel_simples);
      top_desloc++;
      to_var->tipo_v = int_type;
      insereSimbolo(to_var);
      
      aplicarArmazena(to_var);
      $$ = to_var;
   }
;

for_parallel:
   CREATE_THREADS
   <Simbolo*>{
      if (inside_for_parallel)
         error("For parallel dentro de outro for parallel");
   
      inside_for_parallel = true;
   
      lexic_level++;
      top_desloc = 0;

      Simbolo *thread_id = new Simbolo("threadId", lexic_level, top_desloc, variavel_simples);
      top_desloc++;
      thread_id->tipo_v = int_type;
      insereSimbolo(thread_id);

      $$ = thread_id;
   }
   for_parallel_attr_const DO
   <ForParallel*>{
      Simbolo *n_threads = $3;
      Simbolo *thread_id = $2;

      ForParallel *for_parallel = new ForParallel(lexic_level, 0, n_threads);
      for_parallel->thread_id = thread_id;

      visualizaTabelas();

      for (int id = 0;id < n_threads->value; id++) {
         geraCodigo("CTHR", id, lexic_level, for_parallel->rotulo_entrada_thread.identificador);
      }

      geraCodigo("DSVS", "", for_parallel->rotulo_saida_thread.identificador);
      
      $$ = for_parallel;
   }
   for_parallel_bloco
   {
      ForParallel* for_parallel = $5;
      
      removeSimbolos(for_parallel->number_vars);
      geraCodigo("DMEM", for_parallel->number_vars);
      geraCodigo("STHR");
      inside_for_parallel = false;
      lexic_level--;

      geraCodigo("NADA", for_parallel->rotulo_saida_thread.identificador);

      for (int i = 0;i < for_parallel->n_threads->value; i++) {
         geraCodigo("ETHR", i);
      }

      visualizaTabelas();
   }
;

parte_declara_tipo:
   TYPE define_tipos
   {
      $$ = num_type_declared;
      visualizaTabelaTipos();
   }
   | %empty 
   {
      $$ = 0;
   }
;

define_tipos:
   define_tipo define_tipo
   | define_tipo
;

define_tipo:
   ident IGUAL tipo PONTO_E_VIRGULA
   {
      insereTipo($1, $3);
      num_type_declared++;
   }
;

// 8. Parte de Declaracoes de variaveis
parte_declara_vars: 
   VAR declara_vars 
   {
      geraCodigo("AMEM", $2);
      $$ = $2;
      visualizaTabelaSimbolos();
   }
   | %empty
   {
      $$ = 0;
   }
;
 
// 9. Declaração de variáveis
declara_vars:
   declara_vars declara_var
   {
      $$ = $1 + $2;
   }
   | declara_var
   {
      $$ = $1;
   }
;

declara_var:
   lista_var DOIS_PONTOS tipo vector_index_const PONTO_E_VIRGULA
   {
      int amem = 0, var_size = 1, vector_size = $4;
      Tipo *tipo_v = $3;
      std::queue<Simbolo*> *lista_var = $1;

      if(vector_size != 0)
         var_size *= $4;

      while(!lista_var->empty()) {
         Simbolo *simbolo = lista_var->front();
         lista_var->pop();

         simbolo->tipo_v = tipo_v;
         simbolo->deslocamento = top_desloc;
         simbolo->vector_size = vector_size;

         insereSimbolo(simbolo);

         amem += var_size;
         top_desloc += var_size;
      }

      $$ = amem;
   }
;

lista_var:
   lista_var VIRGULA ident
   {
      $$ = $1;
      $$->push(new Simbolo($3, lexic_level, variavel_simples));
   }
   | ident 
   {
      $$ = new std::queue<Simbolo*>();
      $$->push(new Simbolo($1, lexic_level, variavel_simples));
   }
;

ident:
   IDENT
   {
      $$ = simbolo_flex;
   }
;

// 10. lista_idents -> lista_idents ',' IDENT | IDENT
lista_idents:
   lista_idents VIRGULA ident
   | ident
;

/* Regra 11 - Parte de Declarações de Sub-Rotinas */
parte_declara_subrotinas_wrap:
   {
      Simbolo *proc = $<Simbolo*>0;

      geraCodigo("DSVS", "", proc->rotulo_begin()->identificador);

      num_proc_declared.push(new int{0});
   }
   parte_declara_subrotinas
   {
      Simbolo *proc = $<Simbolo*>0;

      geraCodigo("NADA", proc->rotulo_begin()->identificador);

      int *procs_declared = num_proc_declared.top();
      num_proc_declared.pop();
      $$ = *procs_declared;
      delete procs_declared;
   }
   | %empty
   {
      $$ = 0;
   }
;

parte_declara_subrotinas:
   parte_declara_subrotinas parte_declara_subrotinas_two
   | parte_declara_subrotinas_two 
;

parte_declara_subrotinas_two:
   declaracao_procedimento bloco PONTO_E_VIRGULA
   {
      lexic_level--;

      ++*(num_proc_declared.top());
   }
   | declaracao_funcao
   bloco PONTO_E_VIRGULA
   {
      lexic_level--;

      ++*(num_proc_declared.top());
   }
;

/* Regra 12 - Declaração de Procedimento */
declaracao_procedimento:
   PROCEDURE ident
   <Simbolo*>{
      lexic_level++;
      num_total_vars = 0;
      num_total_params = 0;
      num_type_declared = 0;
      
      params = new std::list<Param>();
      Simbolo *proce = new Simbolo($2, lexic_level, params, process);
      insereSimbolo(proce);

      $$ = proce;
   }
   declaracao_params PONTO_E_VIRGULA
   {
      $$ = $3;
   }
;

/* Regra 13 - Declaração de Função */
declaracao_funcao:
   FUNCTION ident
   <Simbolo*>{
      lexic_level++;
      num_total_vars = 0;
      num_total_params = 0;
      
      params = new std::list<Param>();
      Simbolo *proce = new Simbolo($2, lexic_level, params, function);
      insereSimbolo(proce);
      
      $$ = proce;
   }
   declaracao_params DOIS_PONTOS tipo PONTO_E_VIRGULA
   {
      $$ = $3;
      $3->tipo_param = t_copy;
      $3->deslocamento = -(4 + num_total_params);
      $3->tipo_v = $6;
   }
;

declaracao_params:
   ABRE_PARENTESES parametros_formais
   {
      colocaDeslocEmParams(num_total_params);
      
      params = nullptr;
   }
   FECHA_PARENTESES
   | %empty
   {
      params = nullptr;
   }
;

/* Regra 14 - Parâmetros Formais */
parametros_formais:
   parametros_formais PONTO_E_VIRGULA secao_parametros_formais
   | secao_parametros_formais
;

/* Regra 15 - Secao Parâmetros Formais */
secao_parametros_formais:
   {
      num_same_type_vars = 0;
   }
   tipo_parametro lista_params DOIS_PONTOS tipo
   {
      Tipo *tipo_v = $5;
      tipo_parametro tipo_param = $2;

      for(int i = 0;i < num_same_type_vars;i++) {
         params->push_back(Param(tipo_v, tipo_param));
      }

      colocaTipoEmSimbolos(tipo_v, num_same_type_vars);
      colocaTipoEmSimbolos(tipo_param, num_same_type_vars);
   }
;

lista_params:
   lista_params VIRGULA ident 
   {
      insereSimbolo(new Simbolo($3, lexic_level, 0, parametros_formais));
      num_total_params++;
      num_same_type_vars++;
   }
   | ident
   {
      insereSimbolo(new Simbolo($1, lexic_level, 0, parametros_formais));
      num_total_params++;
      num_same_type_vars++;
   }
;

tipo_parametro:
   VAR
   {
      $$ = t_pointer;
   }
   | %empty
   {
      $$ = t_copy;
   }
;

/* Regra 16 - Comando Composto */
comando_composto:
   T_BEGIN lista_comandos T_END
;

lista_comandos:
   lista_comandos PONTO_E_VIRGULA comando
   | comando
;

/* Regra 17 - Comando */
comando:
   NUMERO DOIS_PONTOS comando_sem_rotulo
   | comando_sem_rotulo
   | %empty
;

/* Regra 18 - Comando sem Rotulo - FALTA READ E WRITE*/
comando_sem_rotulo:
   atribuicao
   | chamada_procedimento
   | comando_composto
   | comando_repetitivo
   | comando_condicional
   | for_parallel
   | WRITE ABRE_PARENTESES lista_write FECHA_PARENTESES
   | READ ABRE_PARENTESES lista_read FECHA_PARENTESES
;

lista_write:
   lista_write VIRGULA expressao
   {
      geraCodigo("IMPR");
   }
   | expressao
   {
      geraCodigo("IMPR");
   }
;

lista_read:
   lista_read VIRGULA variavel
   {
      geraCodigo("LEIT");
      aplicarArmazena($3);
   }
   | variavel
   {
      geraCodigo("LEIT");
      aplicarArmazena($1);
   }
;

/* Regra 19 - Atribuicao */
atribuicao:
   variavel_with_vector ATRIBUICAO expressao
   {
      if($1->is_func())
         if(!$1->allow_return)
            error("Função não pode ser usada como variável");

      if(*($1->tipo_v) != *($3.tipo_v))
         error("Tipos incompatíveis na atribuição");
      
      aplicarArmazena($1);
   }
;

variavel_with_vector:
   variavel ABRE_COLCHETE expressao FECHA_COLCHETE
   {
      if(!$1->is_vector())
         error("Variavel não é um vetor");

      if(*($3.tipo_v) != *int_type)
         error("Indice não é um inteiro");
      
      geraCodigo("CRCT", $1->deslocamento);
      geraCodigo("SOMA");

      $$ = $1;
   }
   | variavel
   {
      if($1->is_vector())
         error("Variável não é um vetor");

      $$ = $1;
   }
;

/* Regra 20 - Chamada de Procedimento */
chamada_procedimento:
   chamada_sem_pametro
   {
      if(!$1->is_proc_or_func())
         error("Chamada de procedimento inválida");
      if($1->parametros->size() != 0)
         error("Número de parâmetros inválido");
      if($1->is_func())
         geraCodigo("AMEM", 1);
      geraCodigo("CHPR", "", $1->rotulo_enpr()->identificador, std::to_string(lexic_level));
      if($1->is_func())
         geraCodigo("DMEM", 1);
   }
   | chamada_procedimento_parametros
   {
      if($1->is_func())
         geraCodigo("DMEM", 1);
   }
;

chamada_sem_pametro:
   variavel
   {
      $$ = $1;
   }
   | variavel ABRE_PARENTESES FECHA_PARENTESES
   {
      $$ = $1;
   }
;

chamada_procedimento_parametros:
   variavel ABRE_PARENTESES 
   {
      Simbolo *proc = $1;

      if(!proc->is_proc_or_func())
         error("Chamada de procedimento inválida");
      
      expression_list_types.push({});
      calling_proc_params.push({});

      if(proc->is_func())
         geraCodigo("AMEM", 1);

      for(auto it = proc->parametros->rbegin();it != proc->parametros->rend();++it) {
         calling_proc_params.top().push(*it);
      }
   }
   lista_de_expressoes FECHA_PARENTESES
   {
      Simbolo *proc = $1;
      if(proc->parametros->size() != expression_list_types.top().size())
         error("Número de parâmetros inválido");

      for (auto it = proc->parametros->begin(), it_list = expression_list_types.top().begin();it != proc->parametros->end();++it, ++it_list) {
         if ((*it).tipo_v != (*it_list).tipo_v)
            error("Tipos de parâmetros incompatíveis");
      }

      geraCodigo("CHPR", "", $1->rotulo_enpr()->identificador, std::to_string(lexic_level));
      
      expression_list_types.pop();
      calling_proc_params.pop();

      $$ = $1;
   }
;

chamada_funcao_sem_parametros:
   variavel ABRE_PARENTESES FECHA_PARENTESES
   {
      Simbolo *proc = $1;

      if(!proc->is_func())
         error("Chamada de função inválida");
      
      geraCodigo("AMEM", 1);
      geraCodigo("CHPR", "", $1->rotulo_enpr()->identificador, std::to_string(lexic_level));
      
      $$ = $1;
   }
;

variavel:
   IDENT
   {
      Simbolo* simbolo = buscaSimbolo(simbolo_flex);
      $$ = simbolo;
   }
;

/* Regra 22 - Comando Condicional */
comando_condicional:
   if_then cond_else
;

if_then:
   IF expressao_booleana 
   {
      start_if();
   }
   THEN comando_sem_rotulo
;

cond_else:
   ELSE 
   {
      start_else();
   }
   comando_sem_rotulo
   {
      end_else();
   }
   | %prec LOWER_THAN_ELSE %empty
   {
      end_if();
   }
;

/* Regra 23 - Comando Repetitivo */
comando_repetitivo:
   WHILE
   {
      start_while();
   }
   expressao_booleana DO 
   {
      do_while();
   }
   comando_sem_rotulo
   {
      end_while();
   }
;

expressao_booleana:
   expressao
   {
      if($1.tipo_v->primitive_type != t_bool)
         error("Expressão booleana inválida");
   }
;

// 24. 
lista_de_expressoes:
   lista_de_expressoes VIRGULA expressao
   {
      expression_list_types.top().push_back($3);
      if(calling_proc_params.top().empty())
         error("Número de parâmetros inválido");
      calling_proc_params.top().pop();
   }
   | expressao
   {
      expression_list_types.top().push_back($1);
      if(calling_proc_params.top().empty())
         error("Número de parâmetros inválido");
      calling_proc_params.top().pop();
   }
;

// 25 & 26..
expressao:
   expressao_simples MENOR_QUE expressao_simples
   {
      $$ = aplicarOperacao("CMME", $1, $3);
   }
   | expressao_simples MAIOR_QUE expressao_simples
   {
      $$ = aplicarOperacao("CMMA", $1, $3);
   }
   | expressao_simples IGUAL expressao_simples
   {
      $$ = aplicarOperacao("CMIG", $1, $3);
   }
   | expressao_simples DIFERENTE expressao_simples
   {
      $$ = aplicarOperacao("CMDG", $1, $3);
   }
   | expressao_simples MAIOR_OU_IGUAL expressao_simples
   {
      $$ = aplicarOperacao("CMAG", $1, $3);
   }
   | expressao_simples MENOR_OU_IGUAL expressao_simples
   {
      $$ = aplicarOperacao("CMEG", $1, $3);
   }
   | expressao_simples
;

// 27.
expressao_simples:
   expressao_simples MAIS termo  
   {
      $$ = aplicarOperacao("SOMA", $1, $3);
   }
   | expressao_simples MENOS termo 
   {
      $$ = aplicarOperacao("SUBT", $1, $3);
   }
   | expressao_simples OR termo 
   {
      $$ = aplicarOperacao("DISJ", $1, $3);
   }
   | termo
;

// 28.
termo:
   termo MULTI fator 
   {
      $$ = aplicarOperacao("MULT", $1, $3);
   }
   | termo DIV fator 
   {
      $$ = aplicarOperacao("DIVI", $1, $3);
   }
   | termo AND fator 
   {
      $$ = aplicarOperacao("CONJ", $1, $3);
   }
   | fator
;

// 29.
fator:
   NUMERO 
   {
      geraCodigo("CRCT", "", simbolo_flex);
      $$ = Param(buscaTipoPrimitivo(t_int), t_copy);
   }
   | TRUE 
   {
      geraCodigo("CRCT", 1);
      $$ = Param(buscaTipoPrimitivo(t_bool), t_copy);
   }
   | FALSE 
   {
      geraCodigo("CRCT", 0);
      $$ = Param(buscaTipoPrimitivo(t_bool), t_copy);
   }
   | ABRE_PARENTESES expressao FECHA_PARENTESES
   {
      $$ = $2;
   }
   | variavel_func
;

// 30.
variavel_func:
   variavel 
   {
      Simbolo* simbolo = $1;
      
      if(simbolo->is_proc_or_func())
         error("Variável não pode ser um procedimento");
      
      if(!calling_proc_params.empty()) {
         if(calling_proc_params.top().empty())
            error("Número de parâmetros inválido");
         
         Param param = calling_proc_params.top().top();

         aplicarCarrega(simbolo, param);
      } else {
         aplicarCarrega(simbolo);
      }
      
      $$ = Param(simbolo->tipo_v, simbolo->tipo_param);
   }
   | variavel vector_index
   {
      Simbolo* simbolo = $1;

      if(!simbolo->is_vector())
         error("Variável não é um vetor");

      geraCodigo("CRCT", simbolo->deslocamento);
      geraCodigo("SOMA");
      geraCodigo("CONT");

      $$ = Param(simbolo->tipo_v, simbolo->tipo_param);
   }
   | chamada_procedimento_parametros
   {
      Simbolo* proc = $1;
      if(!proc->is_func())
         error("Chamada de função inválida");

      $$ = Param(proc->tipo_v, proc->tipo_param);
   }
   | chamada_funcao_sem_parametros
   {
      Simbolo* proc = $1;
      if(!proc->is_func())
         error("Chamada de função inválida");

      $$ = Param(proc->tipo_v, proc->tipo_param);
   }
;

tipo:
   ident
   {
      $$ = buscaTipo($1);
   }
;

numero:
   NUMERO
   {
      $$ = std::stoi(simbolo_flex);
   }
;

vector_index:
   ABRE_COLCHETE expressao FECHA_COLCHETE
   {
      if (*($2.tipo_v) != *int_type)
         error("Index não é um inteiro");
   }
;

vector_index_const:
   ABRE_COLCHETE numero FECHA_COLCHETE
   {
      if ($2 < 1)
         error("Tamanho do vetor inválido");
      $$ = $2;
   }
   | %empty
   {
      $$ = 0;
   }
;

%%

void bison::Parser::error(const std::string& msg) {
    std::cerr << msg << " at line " << nl <<'\n';
    std::cerr << "with token " << simbolo_flex << '\n';
    exit(0);
}