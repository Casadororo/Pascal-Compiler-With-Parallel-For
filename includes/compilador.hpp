#include "utils/simbolos.hpp"
#include "utils/tabela_rotulos.hpp"
#include <fstream>
#include <stack>
#include <string>

/* -------------------------------------------------------------------
 * variáveis globais
 * ------------------------------------------------------------------- */

#define print

extern std::string simbolo_flex;
extern Simbolo *simbolo_main;
extern int nl, instruction_count;
extern std::ofstream compiled_stream;

/* -------------------------------------------------------------------
 * prototipos globais
 * ------------------------------------------------------------------- */

void geraCodigo(const std::string &comando, const std::string &rot = "",
                const std::string &arg1 = "", const std::string &arg2 = "");
void geraCodigo(const std::string &comando, int arg1);
void geraCodigo(const std::string &comando, int arg1, int arg2);

int yylex();
void yyerror(const std::string &s);

void iniciaCompilador();
void desligaCompilador();

void insereSimbolo(Simbolo *simb);
Simbolo *buscaSimbolo(const std::string &simb);
Simbolo *buscaSimbolo(int top_offset);
void removeSimbolos(int quant);
void removeSimbolos();

void insereTipo(std::string identificador, Tipo *tipo_pai);
Tipo *buscaTipo(std::string identificador);
Tipo *buscaTipoPrimitivo(tipo_simples_variavel tipo_primitivo);
void removeTipos(int quantidade);

void colocaTipoEmSimbolos(Tipo *tipo, int quantidade);
void colocaTipoEmSimbolos(tipo_parametro_variavel tipo, int quantidade);
void colocaTipoEmSimbolos(tipo_parametro tipo, int quantidade);
void colocaDeslocEmParams(int quantidade);

void aplicarArmazena(Simbolo* simb);
void aplicarCarrega(Simbolo* simb);
void aplicarCarrega(Simbolo* simb, const Param& param);

Param aplicarOperacao(const std::string &op, Param var1, Param var2);
void start_while();
void do_while();
void end_while();

void start_if();
void end_if();
void start_else();
void end_else();

void entraProce(Simbolo *simb);

void visualizaTabelas();
void visualizaTabelaSimbolos();
void visualizaTabelaTipos();
void error(const std::string &msg);