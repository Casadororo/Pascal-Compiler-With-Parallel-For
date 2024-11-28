#ifndef __SIMBOLOS_H__
#define __SIMBOLOS_H__

#include "tabela_rotulos.hpp"
#include "tipo.hpp"
#include <list>
#include <string>

typedef enum {
  simb_program,
  simb_var,
  simb_begin,
  simb_end,
  simb_label,
  simb_type,
  simb_array,
  simb_procedure,
  simb_function,
  simb_goto,
  simb_if,
  simb_else,
  simb_then,
  simb_while,
  simb_do,
  simb_or,
  simb_div,
  simb_and,
  simb_not,
  simb_read,
  simb_write,
  simb_true,
  simb_false,
  simb_atribuicao,
  simb_ponto_e_virgula,
  simb_dois_pontos,
  simb_virgula,
  simb_ponto,
  simb_abre_parenteses,
  simb_fecha_parenteses,
  simb_abre_chave,
  simb_fecha_chave,
  simb_abre_colchete,
  simb_fecha_colchete,
  simb_igual,
  simb_diferente,
  simb_menor_que,
  simb_menor_ou_igual,
  simb_maior_ou_igual,
  simb_maior_que,
  simb_mais,
  simb_menos,
  simb_multi,
  simb_identificador,
  simb_numero
} flex_simbolos;

typedef enum { variavel_simples, parametros_formais } tipo_parametro_variavel;
typedef enum { var, process, function, main_process } tipo_simbolo;
typedef enum { t_copy, t_pointer } tipo_parametro;

class Param {
public:
  Param() = default;
  Param(Tipo *tipo_v, tipo_parametro tipo_param)
      : tipo_v{tipo_v}, tipo_param{tipo_param} {}

  Tipo *tipo_v;
  tipo_parametro tipo_param;
};

class Simbolo {
protected:
  Simbolo(int nivel_lexico, int deslocamento)
      : nivel_lexico{nivel_lexico}, deslocamento{deslocamento} {}

public:
  Simbolo(const std::string &identificador, int nivel_lexico,
          tipo_parametro_variavel tipo_param_var)
      : identificador{identificador}, tipo_simbo{var},
        tipo_param_var{tipo_param_var}, nivel_lexico{nivel_lexico} {}

  Simbolo(const std::string &identificador, int nivel_lexico, int deslocamento,
          tipo_parametro_variavel tipo_param_var)
      : identificador{identificador}, tipo_simbo{var},
        tipo_param_var{tipo_param_var}, nivel_lexico{nivel_lexico},
        deslocamento{deslocamento} {}

  Simbolo(const std::string &identificador, int nivel_lexico,
          std::list<Param> *parametros, tipo_simbolo tipo_simbo)
      : identificador{identificador}, nivel_lexico{nivel_lexico},
        parametros{parametros}, tipo_simbo{tipo_simbo} {}

  ~Simbolo() {
    if (parametros != nullptr)
      delete parametros;

    if (rotulo_entrada_proce != nullptr)
      delete rotulo_entrada_proce;

    if (rotulo_entrada_begin != nullptr)
      delete rotulo_entrada_begin;
  }

  Rotulo *rotulo_enpr();
  Rotulo *rotulo_begin();

  int is_proc();
  int is_main();
  int is_func();
  int is_proc_or_func();
  int is_vector();

  std::string identificador;
  Tipo *tipo_v;
  tipo_parametro_variavel tipo_param_var;
  tipo_parametro tipo_param;

  int nivel_lexico;
  int deslocamento;

  std::list<Param> *parametros = nullptr;
  tipo_simbolo tipo_simbo;
  int number_vars = 0;
  int number_types = 0;
  int allow_return = 0;
  int number_procs = 0;
  int vector_size = 0;
  int value = 0;

protected:
  Rotulo *rotulo_entrada_proce = nullptr;
  Rotulo *rotulo_entrada_begin = nullptr;
};

#endif