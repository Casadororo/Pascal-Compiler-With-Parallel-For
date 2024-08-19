#include "../../includes/utils/tabela_rotulos.hpp"

int Rotulo::index = 0;

Rotulo::Rotulo() {
  if (index < 10)
    this->identificador = "R0" + std::to_string(index++);
  else
    this->identificador = "R" + std::to_string(index++);
}

void TabelaRotulos::push(Rotulo *simbolo) { this->rotulos.push_back(simbolo); }

Rotulo *TabelaRotulos::busca_rotulo(const std::string &simb) {
  for (auto deque = rotulos.rbegin(); deque != rotulos.rend(); ++deque) {
    if ((*deque)->identificador == simb) {
      return *deque;
    }
  }

  return nullptr;
}

Rotulo *TabelaRotulos::busca_rotulo(int top_offset) {
  for (auto deque = rotulos.rbegin(); deque != rotulos.rend();
       ++deque, --top_offset) {
    if (top_offset == 0) {
      return *deque;
    }
  }

  return nullptr;
}

void TabelaRotulos::pop() {
  if (rotulos.empty())
    return;

  Rotulo *rotulo = rotulos.back();
  
  rotulos.pop_back();
  delete rotulo;
}

void TabelaRotulos::print_tabela() {
  if (rotulos.empty()) {
    printf("┌─────────────────┐\n");
    printf("│  Tabela Vazia!  │\n");
    printf("└─────────────────┘\n");
    return;
  }

  printf("┌───────────────────────────┐\n");
  printf("│     Tabela de Rotulos     │\n");
  printf("├───────────────────────────┤\n");
  printf("│         Rotulo            │\n");

  for (auto deque = rotulos.rbegin(); deque != rotulos.rend(); ++deque) {
    printf("├─────────────┼─────────────┤\n");
    printf("│ %-25s │\n", (*deque)->identificador.c_str());
  }

  printf("└───────────────────────────┘\n");
}
