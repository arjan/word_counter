defmodule WordCounter do
  def eager() do
    File.read!("priv/small.txt")
    |> String.split("\n")
    |> Enum.flat_map(&String.split/1)
    |> Enum.reduce(%{}, fn word, map ->
      Map.update(map, word, 1, &(&1 + 1))
    end)
  end

  def lazy() do
    File.stream!("priv/small.txt")
    |> Stream.flat_map(&String.split/1)
    |> Enum.reduce(%{}, fn word, map ->
      Map.update(map, word, 1, &(&1 + 1))
    end)
  end

  def flow() do
    File.stream!("priv/small.txt")
    |> Flow.from_enumerable()
    |> Flow.flat_map(&String.split(&1, " "))
    |> Flow.partition()
    |> Flow.reduce(fn -> %{} end, fn word, acc ->
      Map.update(acc, word, 1, &(&1 + 1))
    end)
    |> Enum.to_list()
  end
end
