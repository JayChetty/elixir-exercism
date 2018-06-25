defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t], pos_integer) :: map
  def frequency(text, workers) do
    text
    |> combine
    |> clean
    |> count_parallel(workers)
  end

  @spec chunks([String], pos_integer) :: [[]]
  def chunks(character_list, 0) do
    [character_list]
  end

  def chunks(character_list, size_of_chunk) do
    Enum.chunk_every( character_list, size_of_chunk )
  end

  @spec count_parallel([String.t], pos_integer) :: map
  def count_parallel(text, num_workers) do
    size_of_chunk = length(text)/num_workers |> round
    chunks = chunks( text, size_of_chunk )
    worker_ids = Enum.map(chunks, fn(chunk)->
      Task.async(__MODULE__, :count, [chunk])
    end)
    Enum.reduce(worker_ids, %{}, fn(worker_id, count_map)->
      result = Task.await( worker_id )
      Map.merge(count_map, result, fn(_k, v1, v2)->  v1 + v2 end)
    end)
  end

  @spec count([String.t]) :: map
  def count(text) do
    Enum.reduce( text, %{}, fn(letter,letter_count) ->
      update_count(letter_count, letter)
    end)
  end


  @spec combine([String]) :: [String]
  def combine(text_list) do
    text_list
    |> Enum.map( fn(text) ->
      text
        |> String.downcase
        |> String.graphemes
    end )
    |> Enum.concat()
  end

  @spec clean([String]) :: [String]
  def clean(text_list) do
    Enum.filter(text_list, fn(character) ->
      String.match?(character, ~r/\p{L}/)
    end)
  end


  @spec update_count(map, String) :: map
  defp update_count(count, letter) do
    {_, updated_count} = Map.get_and_update(count, letter, fn(current_value) ->
      case current_value do
        nil -> {current_value, 1}
        _ -> {current_value, current_value + 1}
      end
    end)
    updated_count
  end
end
