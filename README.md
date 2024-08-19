# Trabalho de Construção de Compiladores

## Introdução

Bem-vindos ao nosso projeto de Construção de Compiladores! Este repositório contém todos os recursos e códigos necessários para o desenvolvimento de um compilador utilizando as ferramentas MEPA, Bison e Flex. Nosso objetivo é criar um compilador que possa analisar, interpretar e devolver como saída o seu equivalente em MEPA.

### O que é MEPA?

MEPA (Máquina de Execução Pseudo-Assembler) é uma ferramenta educativa usada para simular um ambiente de execução de código intermediário, comumente utilizado em disciplinas acadêmicas de compiladores (como essa que estamos cursando). Ela permite aos estudantes visualizarem a execução de código intermediário gerado por compiladores.

### O que são Bison e Flex?

Bison e Flex são ferramentas de geração automática de analisadores sintáticos e léxicos. Flex é usado para construir o analisador léxico, que identifica os tokens da linguagem de programação. Bison é utilizado para desenvolver o analisador sintático, transformando a sequência de tokens em uma estrutura gramatical que representa o programa fonte.

### Estrutura do Repositório

O repositório está organizado da seguinte maneira:

- `Source/`: Contém os arquivos fonte do compilador, incluindo os scripts Bison e Flex.
- `Docs/`: Documentação do projeto, incluindo especificações da linguagem e do projeto.
- `Tests/`: Testes automatizados para garantir a qualidade e a corretude do compilador.

### Como Usar

Instruções detalhadas sobre como compilar e executar o compilador podem ser encontradas na seção de documentação (`docs/`). Certifique-se de seguir todas as instruções para garantir a execução adequada do projeto.

## Agradecimentos

Obrigado pai e mãe por me criarem para este momento único onde eu posso desenvolver um compilador irado.

## USAGE

1. Só para gerar código MEPA:
> make

2. Executar o programa
> ./compilador teste1.pas

3. Ver código MEPA
> cat MEPA


Para aqueles mais curiosos, verifiquem o arquivo lex.yy.c . Este
arquivo é a implementação em "C" da autômato gerado pelo analisador
léxico ao ler o arquivo "compilador.l". De forma análoga,
"compilador.tab.c" é o autômato a pilha gerado pelo bison ao ler o
arquivo "compilador.y".

Na segunda parte da disciplina, será mostrado como gerar um autômato a
pilha (tabela de ações e de desvios) para uma classe de gramáticas
mais restritas do que esta, porém que segue o mesmo "esquema".
