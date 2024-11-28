#ifndef __FOR_PARALLEL_H__
#define __FOR_PARALLEL_H__

#include "simbolos.hpp"
#include "tabela_rotulos.hpp"

class ForParallel : public Simbolo {
public:
  ForParallel(int nivel_lexico, int deslocamento, Simbolo *n_threads)
      : Simbolo(nivel_lexico, deslocamento), rotulo_entrada_for{},
        rotulo_saida_for{}, rotulo_entrada_thread{}, n_threads{n_threads} {
    number_vars = number_of_default_vars;
  }

  ~ForParallel() = default;

  Rotulo rotulo_entrada_thread;
  Rotulo rotulo_entrada_for;
  Rotulo rotulo_saida_for;
  Rotulo rotulo_saida_thread;

  Simbolo *thread_id;
  Simbolo *n_threads;
  Simbolo *index;
  Simbolo *index_upper_limit;
  Simbolo *step;

protected:
  const int number_of_default_vars = 5;
};

#endif
