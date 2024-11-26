#include "../../includes/utils/simbolos.hpp"

int Simbolo::is_main() { return this->tipo_simbo == main_process; }

int Simbolo::is_proc() { return this->tipo_simbo == process; }

int Simbolo::is_func() { return this->tipo_simbo == function; }

int Simbolo::is_proc_or_func() { return this->is_proc() || this->is_func(); }

int Simbolo::is_vector() { return this->vector_size > 0; }

Rotulo *Simbolo::rotulo_enpr() {
  if (this->rotulo_entrada_proce == nullptr) {
    this->rotulo_entrada_proce = new Rotulo();
  }

  return this->rotulo_entrada_proce;
}

Rotulo *Simbolo::rotulo_begin() {
  if (this->rotulo_entrada_begin == nullptr) {
    this->rotulo_entrada_begin = new Rotulo();
  }

  return this->rotulo_entrada_begin;
}