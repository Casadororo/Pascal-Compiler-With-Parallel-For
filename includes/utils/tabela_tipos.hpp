#ifndef __TABELA_TIPOS_H__
#define __TABELA_TIPOS_H__

#include "tipo.hpp"
#include <deque>
#include <string>

class TabelaTipos {
public:
  TabelaTipos() : tipos{std::deque<Tipo *>()} {};
  ~TabelaTipos();

  void push(Tipo *rotulo);
  void pop();
  Tipo *busca_tipo(const std::string &simb);
  Tipo *busca_tipo(int offset);
  Tipo *busca_tipo_primitivo(tipo_simples_variavel tipo);

  void print_tabela();

private:
  std::deque<Tipo *> tipos;
};

#endif