#!/bin/bash

# Entradas de teste
# "MEPA1" "MEPA4" "MEPA8" "MEPA16"
inputs=("MEPA2")

# Arquivo do interpretador
interpreter="./INTER"

# Número de execuções
num_runs=50

# Diretório para armazenar os resultados
output_dir="results"
mkdir -p $output_dir

# Loop por cada entrada
for input in "${inputs[@]}"; do
    echo "Executando testes para $input..."
    
    # Arquivo para armazenar os tempos
    time_file="$output_dir/${input}_times.txt"
    > $time_file

    # Executa o programa 100 vezes e guarda os tempos
    for ((i = 1; i <= num_runs; i++)); do
        echo "Execução $i para $input"
        # Extrai o tempo real da execução
        real_time=$( { /usr/bin/time -f "%e" $interpreter -ri $input > /dev/null; } 2>&1 )
        echo $real_time >> $time_file
    done

    # Calcula a média dos tempos
    avg_time=$(awk '{sum+=$1} END {print sum/NR}' $time_file)

    echo "Média para $input: $avg_time segundos"
    echo "$input Média: $avg_time segundos" >> "$output_dir/summary.txt"
done

echo "Teste concluído. Resultados em $output_dir."
