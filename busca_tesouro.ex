defmodule BuscaTesouro do
  def iniciar(matriz, tesouro) do
    num_linhas = length(matriz)
    num_processos = num_linhas

    # Cria uma tarefa para cada linha da matriz
    tarefas = for i <- 0..(num_processos - 1) do
      linha = Enum.at(matriz, i)
      Task.async(fn -> buscar(linha, tesouro, i) end)
    end

    # Espera por uma das tarefas concluir
    case Enum.find_value(tarefas, fn tarefa ->
      case Task.await(tarefa, :infinity) do
        {:encontrado, posicao} -> {:encontrado, posicao}
        :nao_encontrado -> nil
      end
    end) do
      {:encontrado, posicao} -> IO.puts("Tesouro encontrado na posicao #{inspect(posicao)}")
      _ -> IO.puts("Tesouro nao encontrado")
    end
  end

  defp buscar(linha, tesouro, processo) do
    # Verifica se o tesouro está na linha
    case Enum.find_index(linha, &(&1 == tesouro)) do
      nil -> :nao_encontrado
      coluna -> {:encontrado, {processo, coluna}}
    end
  end
end

# Exemplo de uso:
matriz = [
  [1, 2, 3, 4],
  [5, 6, 7, 8],
  [9, 10, 11, 12],
  [13, 14, 15, 16]
]

BuscaTesouro.iniciar(matriz, 12)
BuscaTesouro.iniciar(matriz, -1)
BuscaTesouro.iniciar(matriz, 17)
BuscaTesouro.iniciar(matriz, 5)
