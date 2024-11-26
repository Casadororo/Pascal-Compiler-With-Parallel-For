#include "../includes/compilador.hpp"
#include "../includes/utils/simbolos.hpp"
#include "../includes/utils/tabela_rotulos.hpp"
#include "../includes/utils/tabela_simbolos.hpp"
#include "../includes/utils/tabela_tipos.hpp"
#include "../includes/utils/tipo.hpp"

#include <iostream>
#include <string>

// External variables
std::string simbolo_flex;
Simbolo *simbolo_main;
Tipo *int_type;
int nl = 1, instruction_count = 0;

// Compiler variables
TabelaSimbolos *tabela_simb;
TabelaRotulos *tabela_rotulos;
TabelaTipos *tabela_tipos;

std::ofstream compiled_stream;

void geraCodigo(const std::string &comando, int arg1) {
  compiled_stream << "     " << comando << " " << arg1 << std::endl;

  instruction_count++;
  compiled_stream.flush();
}

void geraCodigo(const std::string &comando, int arg1, int arg2) {
  compiled_stream << "     " << comando << " " << arg1 << ", " << arg2
                  << std::endl;

  instruction_count++;
  compiled_stream.flush();
}

void geraCodigo(const std::string &comando, int arg1, int arg2,
                const std::string &rot) {
  compiled_stream << "     " << comando << " " << arg1 << ", " << arg2 << ", "
                  << rot << std::endl;

  instruction_count++;
  compiled_stream.flush();
}

void geraCodigo(const std::string &comando, const std::string &rot,
                const std::string &arg1, const std::string &arg2) {
  if (rot != "")
    compiled_stream << rot << ": ";
  else
    compiled_stream << "     ";

  if (arg1 == "")
    compiled_stream << comando;
  else {
    if (arg2 == "")
      compiled_stream << comando << " " << arg1;
    else
      compiled_stream << comando << " " << arg1 << ", " << arg2;
  }
  compiled_stream << std::endl;

  instruction_count++;

  compiled_stream.flush();
}

void insereTiposSimples(TabelaTipos *tabela) {
  int_type = new Tipo("integer", t_int);

  tabela->push(int_type);
  tabela->push(new Tipo("boolean", t_bool));
}

void iniciaCompilador() {
  compiled_stream.open("MEPA");

  tabela_simb = new TabelaSimbolos;
  tabela_rotulos = new TabelaRotulos;
  tabela_tipos = new TabelaTipos;
  insereTiposSimples(tabela_tipos);

  tabela_tipos->print_tabela();
}

void desligaCompilador() {
  compiled_stream.close();

  delete tabela_simb;
  delete tabela_rotulos;
  delete tabela_tipos;
}

Param aplicarOperacao(const std::string &op, Param var1, Param var2) {
  tipo_simples_variavel result_type;
  tipo_simples_variavel needed_type;

  if (op == "CMME") {
    result_type = t_bool;
    needed_type = t_int;
  } else if (op == "CMMA") {
    result_type = t_bool;
    needed_type = t_int;
  } else if (op == "CMIG") {
    result_type = t_bool;
    needed_type = t_int;
  } else if (op == "CMDG") {
    result_type = t_bool;
    needed_type = t_int;
  } else if (op == "CMAG") {
    result_type = t_bool;
    needed_type = t_int;
  } else if (op == "CMEG") {
    result_type = t_bool;
    needed_type = t_int;
  } else if (op == "SOMA") {
    result_type = t_int;
    needed_type = t_int;
  } else if (op == "SUBT") {
    result_type = t_int;
    needed_type = t_int;
  } else if (op == "DISJ") {
    result_type = t_bool;
    needed_type = t_bool;
  } else if (op == "MULT") {
    result_type = t_int;
    needed_type = t_int;
  } else if (op == "DIVI") {
    result_type = t_int;
    needed_type = t_int;
  } else if (op == "CONJ") {
    result_type = t_bool;
    needed_type = t_bool;
  } else {
    error("Operação desconhecida");
  }

  Tipo *tipo1 = var1.tipo_v;
  Tipo *tipo2 = var2.tipo_v;

  if (tipo1->primitive_type != needed_type)
    error("Tipos diferentes");
  if (tipo1->primitive_type != needed_type)
    error("Tipos incompatíveis com a operação");

  geraCodigo(op);

  tipo_parametro tipo_param = t_copy;
  if (var1.tipo_param == t_pointer || var2.tipo_param == t_pointer)
    tipo_param = t_pointer;

  Tipo *tipo_resultante = tabela_tipos->busca_tipo_primitivo(result_type);

  return Param(tipo_resultante, tipo_param);
}

void insereSimbolo(Simbolo *simb) { tabela_simb->push(simb); }

Simbolo *buscaSimbolo(const std::string &simb) {
  Simbolo *sim = tabela_simb->buscaSimbolo(simb);

  if (sim == nullptr)
    error("Variável não declarada: " + simbolo_flex);

  return sim;
}

Simbolo *buscaSimbolo(int top_offset) {
  Simbolo *sim = tabela_simb->buscaSimbolo(top_offset);

  if (sim == nullptr)
    error("Variável não declarada: " + simbolo_flex);

  return sim;
}

void removeSimbolos(int quant) {
  for (int i = 0; i < quant; i++) {
    tabela_simb->pop();
  }
}

void colocaTipoEmSimbolos(Tipo *tipo, int quantidade) {
  tabela_simb->coloca_tipo_em_simbolos(tipo, quantidade);
}

void colocaTipoEmSimbolos(tipo_parametro_variavel tipo, int quantidade) {
  tabela_simb->coloca_tipo_em_simbolos(tipo, quantidade);
}

void colocaTipoEmSimbolos(tipo_parametro tipo, int quantidade) {
  tabela_simb->coloca_tipo_em_simbolos(tipo, quantidade);
}

void colocaTipoEmSimbolos(Tipo *tipo, int vector_size, int quantidade) {
  tabela_simb->coloca_tipo_em_simbolos(tipo, vector_size, quantidade);
}

void colocaDeslocEmParams(int quantidade) {
  tabela_simb->coloca_desloc_em_params(quantidade);
}

void insereRotulo(Rotulo *rotulo) { tabela_rotulos->push(rotulo); }

void removeRotulos(int quantidade) {
  for (int i = 0; i < quantidade; i++)
    tabela_rotulos->pop();
}

Rotulo *buscaRotulo(int top_offset) {
  return tabela_rotulos->busca_rotulo(top_offset);
}

void visualizaTabelas() {
  tabela_simb->print_tabela();
  tabela_tipos->print_tabela();
}

void visualizaTabelaSimbolos() { tabela_simb->print_tabela(); }
void visualizaTabelaTipos() { tabela_tipos->print_tabela(); }

void start_while() {
  Rotulo *start_rot = new Rotulo();
  insereRotulo(start_rot);

  geraCodigo("NADA", start_rot->identificador);
  insereRotulo(new Rotulo());
}

void do_while() {
  Rotulo *end_rot = buscaRotulo(0);

  geraCodigo("DSVF", "", end_rot->identificador);
}

void end_while() {
  Rotulo *start_rot = buscaRotulo(1);
  Rotulo *end_rot = buscaRotulo(0);

  geraCodigo("DSVS", "", start_rot->identificador);
  geraCodigo("NADA", end_rot->identificador);

  removeRotulos(2);
}

void start_if() {
  Rotulo *end_if = new Rotulo();
  insereRotulo(end_if);

  geraCodigo("DSVF", "", end_if->identificador);
}

void end_if() {
  Rotulo *end_if = buscaRotulo(0);

  geraCodigo("NADA", end_if->identificador);

  removeRotulos(1);
}

void start_else() {
  Rotulo *start_else = buscaRotulo(0);

  Rotulo *end_if = new Rotulo();
  insereRotulo(end_if);

  geraCodigo("DSVS", "", end_if->identificador);
  geraCodigo("NADA", start_else->identificador);
}

void end_else() {
  Rotulo *end_if = buscaRotulo(0);

  geraCodigo("NADA", end_if->identificador);

  removeRotulos(2);
}

// espelho de bison::Parse::error
void error(const std::string &msg) {
  std::cerr << msg << " at line " << nl << '\n';
  exit(0);
}

void entraProce(Simbolo *simb) {
  geraCodigo("ENPR", simb->rotulo_enpr()->identificador,
             std::to_string(simb->nivel_lexico));
}

void aplicarArmazenaVector(Simbolo *simb) { geraCodigo("ARMM"); }

void aplicarArmazena(Simbolo *simb) {
  std::string comando;

  if (simb->is_vector())
    return aplicarArmazenaVector(simb);

  if (simb->tipo_param == t_copy)
    comando = "ARMZ";
  else if (simb->tipo_param == t_pointer)
    comando = "ARMI";
  else
    error("Tipo param de variável inexistente");

  geraCodigo(comando, simb->nivel_lexico, simb->deslocamento);
}

void aplicarCarrega(Simbolo *simb) {
  std::string comando;
  if (simb->tipo_param == t_copy)
    comando = "CRVL";
  else if (simb->tipo_param == t_pointer)
    comando = "CRVI";
  else
    error("Tipo param de variável inexistente");

  geraCodigo(comando, simb->nivel_lexico, simb->deslocamento);
}

void aplicarCarrega(Simbolo *simb, const Param &param) {
  std::string comando;
  if (param.tipo_param == t_copy) {
    if (simb->tipo_param == t_copy)
      comando = "CRVL";
    else if (simb->tipo_param == t_pointer)
      comando = "CRVI";
    else
      error("Tipo param de variável inexistente");
  } else if (param.tipo_param == t_pointer) {
    if (simb->tipo_param == t_copy)
      comando = "CREN";
    else if (simb->tipo_param == t_pointer)
      comando = "CRVL";
    else
      error("Tipo param de variável inexistente");
  } else {
    error("Tipo param de variável inexistente");
  }

  geraCodigo(comando, simb->nivel_lexico, simb->deslocamento);
}

void insereTipo(std::string identificador, Tipo *tipo_pai) {
  tabela_tipos->push(new Tipo(identificador, tipo_pai));
}

Tipo *buscaTipo(std::string identificador) {
  Tipo *tipo = tabela_tipos->busca_tipo(identificador);

  if (tipo == nullptr)
    error("Tipo não declarado: " + identificador);

  return tipo;
}

Tipo *buscaTipoPrimitivo(tipo_simples_variavel tipo_primitivo) {
  Tipo *tipo = tabela_tipos->busca_tipo_primitivo(tipo_primitivo);

  if (tipo == nullptr)
    error("Tipo primitivo não declarado");

  return tipo;
}

void removeTipos(int quantidade) {
  for (int i = 0; i < quantidade; i++) {
    tabela_tipos->pop();
  }
}