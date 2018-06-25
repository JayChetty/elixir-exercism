defmodule BankAccount do
  require Logger
  # use Agent
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, pid} = Agent.start_link(fn -> %{balance: 0, closed: false} end)
    pid
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    Agent.update(account, fn state ->  %{state | closed: true} end)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    Agent.get(account,  fn state ->
      case state.closed do
        true -> {:error, :account_closed}
        _ -> state.balance
      end
    end)
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    Agent.get_and_update(account,  fn state ->
      case state.closed do
        true -> { {:error, :account_closed}, state }
        _ -> { :ok, %{state | balance: state.balance + amount} }
      end
    end)
    # Agent.update(account, fn state ->  %{state | balance: state.balance + amount} end)
  end
end
