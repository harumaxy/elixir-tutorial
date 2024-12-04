defmodule Sigils do
  def sigil_types do
    _regex = ~r/^[a-zA-Z0-9]+$/
    _date = ~D[2024-01-01]
    _time = ~T[12:00:00]
    # Native datetime = タイムゾーンを含まない
    _native_date_time = ~N[2024-01-01 12:00:00]
    # UTC datetime = タイムゾーンを含む
    _utc_date_time = ~U[2024-01-01 12:00:00Z]
    # ISO 文字列は sigil がない？関数でパース
    _japan_time = DateTime.from_iso8601("2024-01-01T12:00:00+09:00")
  end
end

defmodule MySigils do
  @moduledoc """
  # Custom Sigil
  sigil の実態は `sigil_*/2` 関数

  以下のように定義して、 import すれば sigil が使えるようになる
  """
  def sigil_i(string, []), do: String.to_integer(string)
  def sigil_i(string, [?n]), do: -String.to_integer(string)

  @doc """
  macro も sigil にできる
  コンパイル時に展開されるので便利
  """
  defmacro sigil_m(string, []) do
    quote do
      String.to_integer(unquote(string))
    end
  end

  def use_my_sigil do
    _comp_time = ~m(100) |> IO.inspect()
    _hundred = ~i(100) |> IO.inspect()
  end
end
