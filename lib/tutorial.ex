defmodule Tutorial do
  @moduledoc """
  Documentation for `Tutorial`.
  """

  def myloop(msg, n) when n > 0 do
    IO.puts(msg)
    myloop(msg, n - 1)
  end

  def myloop(msg, 0), do: :ok

  def consume_list([head | tail]) do
    IO.puts("Head: #{head}")
    consume_list(tail)
  end

  def consume_list([]), do: :done

  def reference_op_as_func() do
    Enum.reduce([1, 2, 3, 4, 5, 6], 0, &+/2)
    Enum.reduce([1, 2, 3, 4, 5, 6], 1, &*/2)

    # これの場合、コールバックのアリティが 1 と 2 で違うのでエラーになる
    # Enum.map([1, 2, 3, 4, 5, 6], &+/2)

    # 短縮記法でアリティ1の無名関数にする
    Enum.map([1, 2, 3, 4, 5, 6], &(&1 + 1))
  end
end
