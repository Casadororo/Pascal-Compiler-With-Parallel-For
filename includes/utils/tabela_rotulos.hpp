#ifndef __TABELA_ROTULOS_H__
#define __TABELA_ROTULOS_H__

#include <deque>
#include <string>

class Rotulo {
public:
  Rotulo();

  std::string identificador;
private:
  static int index;
};

class TabelaRotulos {
public:
  TabelaRotulos() : rotulos{std::deque<Rotulo *>()} {};

  void push(Rotulo *rotulo);
  void pop();
  Rotulo *busca_rotulo(const std::string &simb);
  Rotulo *busca_rotulo(int offset);

  void print_tabela();

private:
  std::deque<Rotulo *> rotulos;
};

#endif