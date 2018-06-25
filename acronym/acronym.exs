require Logger
defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
    |> String.split()
    |> Enum.map(&word_as_letters/1)
    |> Enum.join()
  end

  defp word_as_letters(word) do
    letter_array = String.split(word, "")
    first_letter = hd( letter_array )
    remaining_letters = tl( letter_array )

    upcased_letters = remaining_letters
    |> Enum.filter( fn(letter) ->
      letter == String.upcase( letter ) && letter
    end )
    |> Enum.join()

    String.upcase( first_letter <> upcased_letters )
  end
end

# String.upcase(letter) == letter
