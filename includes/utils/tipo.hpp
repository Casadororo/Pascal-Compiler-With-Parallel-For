#ifndef __TIPO_H__
#define __TIPO_H__

#include <string>

typedef enum { t_int, t_bool, t_undefined } tipo_simples_variavel;

class Tipo {
public:
  Tipo(std::string identificador, Tipo *father_type)
      : identificador{identificador}, father_type{father_type}, primitive_type{father_type->primitive_type} {};
  Tipo(std::string identificador, tipo_simples_variavel primitive_type)
      : identificador{identificador}, primitive_type{primitive_type} {};

  int is_primitive() const { return father_type == nullptr; }

  std::string identificador;
  Tipo *father_type = nullptr;
  tipo_simples_variavel primitive_type;
};

bool operator!=(const Tipo &tipo1, const Tipo &tipo2);
bool operator==(const Tipo &tipo1, const Tipo &tipo2);

#endif