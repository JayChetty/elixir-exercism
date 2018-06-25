defmodule Change do
  require Logger
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t}
  def generate(coins, target) do
    coin_ranges = ranges(coins, target)
    winner = check_combinations(coin_ranges, [], nil, coins, target)
    cond do
      winner == nil || target < 0 ->
        {:error, "cannot change"}
      true ->
        {:ok, list_form(winner.combination, coins)}
    end

  end

  def list_form(combination,coins) do
    joined = Enum.zip(combination, coins)

    Enum.flat_map(joined, fn({number_of_coins, coin_value}) ->
      List.duplicate(coin_value, number_of_coins)
    end)
  end


  def score([number_of_coins | combinations], [ coin_value | coins ], total_number_of_coins, total) do
    score(combinations, coins, total_number_of_coins + number_of_coins, total + (number_of_coins * coin_value) )
  end

  def score([], [], total_number_of_coins, total) do
    {total, total_number_of_coins}
  end

  def total_number_of_coins(combination) do
    Enum.reduce(combination, fn(number_of_coin, acc) -> acc + number_of_coin end)
  end

  def check_combinations([main | rest], current_combination, current_winner, coins, target ) do
    Enum.reduce(main, current_winner, fn(value, acc) ->
      check_combinations(rest, [ value | current_combination ], acc, coins, target)
    end)
  end

  def check_combinations([], combination, current_winner, coins, target) do
    combination = Enum.reverse(combination)
    {total, total_number_of_coins} = score(combination, coins, 0, 0)

    cond do
      total == target && (current_winner == nil || total_number_of_coins < current_winner.number_of_coins) ->
        %{number_of_coins: total_number_of_coins, combination: combination }
      true ->
        current_winner
    end
  end

  def ranges(coins, target) do
    Enum.map(coins, fn(coin) ->
      Enum.to_list(0..Integer.floor_div(target, coin))
    end)
  end
end
