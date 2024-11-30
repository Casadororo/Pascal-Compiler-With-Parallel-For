import matplotlib.pyplot as plt

# Arquivo de resumo com as médias
summary_file = "results/summary.txt"

# Listas para armazenar os dados
inputs = ["1 thread", "2 threads", "4 threads", "8 threads", "16 threads"]
averages = []

# Ler os dados do arquivo
with open(summary_file, "r") as file:
    for line in file:
        parts = line.split()
        if len(parts) >= 2:
            averages.append(float(parts[2]))  # Média

# Criar o gráfico de linhas
plt.figure(figsize=(10, 6))
plt.plot(inputs, averages, marker="o", linestyle="-", linewidth=2)

# Configurações do gráfico
plt.xlabel("Quantidade de Threads")
plt.ylabel("Tempo Médio (segundos)")
plt.title("Tempos Médios de Execução para Diferentes Niveis de Paralelismo ")
plt.grid(True, linestyle="--", alpha=0.7)

# Salvar o gráfico como imagem
plt.tight_layout()
plt.savefig("results/average_times_line.png")
print("Gráfico salvo em 'results/average_times_line.png'.")

# Exibir o gráfico
plt.show()
