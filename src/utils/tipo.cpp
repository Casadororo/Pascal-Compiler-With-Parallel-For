#include "../../includes/utils/tipo.hpp"

bool operator==(const Tipo &tipo1, const Tipo &tipo2) {
  if ((&tipo1 == &tipo2) || (tipo1.is_primitive() || tipo2.is_primitive()))
    if (tipo1.primitive_type == tipo2.primitive_type)
      return true;

  return false;
}

bool operator!=(const Tipo &tipo1, const Tipo &tipo2) {
  return !(tipo1 == tipo2);
}