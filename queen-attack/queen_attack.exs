defmodule Queens do
  @type t :: %Queens{ black: {integer, integer}, white: {integer, integer} }
  defstruct black: nil, white: nil

  @doc """
  Creates a new set of Queens
  """
  @spec new() :: Queens.t()
  @spec new({integer, integer}, {integer, integer}) :: Queens.t()
  def new(white \\ {0,3}, black \\ {7,3}) do
    case same_position?(white,black) do
      true ->
        raise ArgumentError
      _ ->
        %Queens{ white: white, black: black }
    end
  end

  @doc """
  Gives a string reprentation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    0..7
    |> Enum.map(fn(num)-> add_line(num, queens) end)
    |> Enum.join("\n")
  end

  defp add_line(row, %{white: {white_row, white_col}, black: {black_row, black_col}}) do
    cond do
      row == white_row ->
        create_queen_line("W", white_col)
      row == black_row ->
        create_queen_line("B", black_col)
      true ->
        "_ _ _ _ _ _ _ _"
    end
  end

  defp create_queen_line(letter, position) do
    0..7
    |> Enum.map(fn(num) ->
      case num == position do
        true ->
          letter
        _ ->
          "_"
      end
    end)
    |> Enum.join(" ")
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(queens) do
    same_row?(queens) || same_col?(queens) || on_diag?(queens)
  end

  def same_row?(%{white: {white_row, white_col}, black: {black_row, black_col}}) do
    white_row == black_row
  end

  def same_col?(%{white: {white_row, white_col}, black: {black_row, black_col}}) do
    white_col == black_col
  end

  def on_diag?(%{white: {white_row, white_col}, black: {black_row, black_col}}) do
    abs(white_row - white_col) == abs(black_row - black_col)
  end

  defp same_position?({white_x, white_y}, {black_x, black_y}) do
    white_x == black_x && white_y == black_y
  end


end
