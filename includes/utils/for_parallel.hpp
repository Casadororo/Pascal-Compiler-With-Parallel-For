#ifndef __FOR_PARALLEL_H__
#define __FOR_PARALLEL_H__

#include "simbolos.hpp"
#include "tabela_rotulos.hpp"

class ForParallel : public Simbolo {
public:
  ForParallel(int nivel_lexico, int deslocamento, int thread_identifier_start,
              int n_threads)
      : Simbolo(nivel_lexico, deslocamento), rotulo_entrada_for{},
        rotulo_saida_for{}, rotulo_entrada_thread{},
        thread_identifier_start{thread_identifier_start}, n_threads{n_threads} {
  }

  ~ForParallel() = default;

  Rotulo rotulo_entrada_thread;
  Rotulo rotulo_entrada_for;
  Rotulo rotulo_saida_for;
  Rotulo rotulo_saida_thread;

  int thread_identifier_start;
  int n_threads;
  Simbolo *index;
  Simbolo *index_upper_limit;
};

#endif
