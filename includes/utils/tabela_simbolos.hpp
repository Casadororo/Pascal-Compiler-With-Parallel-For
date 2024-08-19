#ifndef __STACK_H__
#define __STACK_H__

#include "simbolos.hpp"

class t_node {
public:
  ~t_node() {
    delete simbolo;
  }

  t_node *next;
  t_node *prev;

  Simbolo *simbolo;
};

class TabelaSimbolos {
public:
  TabelaSimbolos() : top(nullptr), bottom(nullptr){};

  ~TabelaSimbolos();

  void push(Simbolo *simbolo);
  void pop();
  Simbolo *buscaSimbolo(const std::string &simb);
  Simbolo *buscaSimbolo(int top_offset);

  void coloca_tipo_em_simbolos(Tipo *tipo, int quantidade);
  void coloca_tipo_em_simbolos(tipo_parametro_variavel tipo, int quantidade);
  void coloca_tipo_em_simbolos(tipo_parametro tipo, int quantidade);
  void coloca_desloc_em_params(int quantidade);

  void print_var_simbolo(Simbolo *simbolo);
  void print_process_simbolo(Simbolo *simbolo);
  void print_tabela();
  void print_parametros(Simbolo *simbolo);

protected:
  int is_stack_empty();

private:
  t_node *top;
  t_node *bottom;
};

void print_simbolo(Simbolo *s);

#endif