defmodule ProxyEx.IP do
  @moduledoc """
  TODO: Documentation
  """

  @doc """
  Transforms a string of characters representing a list of IP:PORT into a list of tuples.

  ## Examples

    iex> ProxyEx.IP.cast("")
    {:ok, []}

    iex> ProxyEx.IP.cast("10.0.0.1:4002")
    {:ok, [{'10.0.0.1', 4002}]}

    iex> ProxyEx.IP.cast("10.0.0.1:4002,10.0.0.2:4002,10.0.0.3:4002")
    {:ok, [{'10.0.0.1', 4002}, {'10.0.0.2', 4002}, {'10.0.0.3', 4002}]}
  """
  @spec cast(String.t()) :: [{String.t(), non_neg_integer()}, ...]
  def cast(value) do
    res =
      value
      |> String.split(",")
      |> Stream.map(&String.split(&1, ":"))
      |> Enum.reduce([], fn
        [ip, port], acc -> [{to_charlist(ip), String.to_integer(port)} | acc]
        [""], acc -> acc
        x, _acc -> throw("invalid host found: #{inspect(x)}")
      end)
      |> Enum.reverse()

    {:ok, res}
  end
end
