#include "../../includes/utils/tabela_tipos.hpp"
#include <iostream>

void TabelaTipos::push(Tipo *tipo) { tipos.push_back(tipo); }

TabelaTipos::~TabelaTipos() {
  while (!tipos.empty()) {
    Tipo *back = tipos.back();
    tipos.pop_back();
    delete back;
  }
}

void TabelaTipos::pop() {
  if (!tipos.empty()) {
    Tipo *back = tipos.back();
    tipos.pop_back();
    delete back;
  } else {
    std::cerr << "Error: Trying to pop from an empty TabelaTipos." << std::endl;
  }
}

Tipo *TabelaTipos::busca_tipo(const std::string &simb) {
  for (Tipo *tipo : tipos) {
    if (tipo->identificador == simb) {
      return tipo;
    }
  }
  return nullptr;
}

Tipo *TabelaTipos::busca_tipo(int offset) {
  if (offset >= 0 && offset < tipos.size()) {
    return tipos[offset];
  }
  return nullptr;
}

Tipo *TabelaTipos::busca_tipo_primitivo(tipo_simples_variavel tipo) {
  for (auto it = tipos.begin(); it != tipos.end(); ++it) {
    if ((*it)->is_primitive() && (*it)->primitive_type == tipo) {
      return *it;
    }
  }
  return nullptr;
}

void TabelaTipos::print_tabela() {
  if (tipos.empty()) {
    printf("┌─────────────────┐\n");
    printf("│  Tabela Vazia!  │\n");
    printf("└─────────────────┘\n");
    return;
  }

  printf("┌──────────────────────────────────────────────────────┐\n");
  printf("│                   Tabela de Tipos                    │\n");
  printf("├───────────────┬───────────────┬──────────────────────┤\n");
  printf("│ Identificador │ Tipo Simples  │ Tipo Pai             │\n");

  for (const auto &tipo : tipos) {
    printf("├───────────────┼───────────────┼──────────────────────┤\n");
    const char *tipo_simples_str;
    switch (tipo->primitive_type) {
    case t_int:
      tipo_simples_str = "t_int";
      break;
    case t_bool:
      tipo_simples_str = "t_bool";
      break;
    case t_undefined:
      tipo_simples_str = "t_undefined";
      break;
    default:
      tipo_simples_str = "unknown";
      break;
    }

    printf("│ %-13s │ %-13s │ %-20s │\n", tipo->identificador.c_str(),
           tipo_simples_str,
           (tipo->father_type == nullptr
                ? "Primitive Type"
                : tipo->father_type->identificador.c_str()));
  }

  printf("└───────────────┴───────────────┴──────────────────────┘\n");
}