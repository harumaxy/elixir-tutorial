defprotocol Size do
  @doc """
  # Protocol
  ポリモーフィズムを実現するメカニズム

  OOP でいう Interface
  FP でいう TypeClass
  Rust でいう Trait
  """
  @spec size(t()) :: integer()
  def size(data)
end

# Struct、または Elixir のデータ型(Integer, List, Atom, String, Map, Tuple, PID, Port, Reference, Function,...)　全てに対して実装できる

defimpl Size, for: List do
  def size(data), do: Enum.count(data)
end

defimpl Size, for: Atom do
  def size(data), do: Atom.to_string(data) |> String.length()
end

defimpl Size, for: Integer do
  def size(data), do: data
end

defimpl Size, for: Tuple do
  def size(data), do: tuple_size(data)
end

# Utility.type を実装

defprotocol Utility do
  # t, t() はモジュール内では自身の型を示す
  @spec type(t) :: String.t()
  def type(value)
end

defimpl Utility, for: BitString do
  def type(_value), do: "string"
end

defimpl Utility, for: Integer do
  def type(_value), do: "integer"
end

# impl {Protocol} for: Any
# デフォルトの実装を提供する
# ただし、 @derive [{Protocol}]  を実装するモジュールに明示的に書かないとデフォルト実装されない

defimpl Size, for: Any do
  def size(_), do: 0
end

defmodule OtherUser do
  @derive [Size]

  defstruct [:name, :age]
end

# @fallback_to_any true
# Protocol が実装されていないモジュールに対して実行する場合、Any のデフォルト実装を使う
# これは、 @derive しなくても全てのモジュールがデフォルト実装を使うようになる

# Built-in Protocol
## Enumerable (map, filter, reduce ...)
## String.Chars (to_string, template_string``)
## Inspect (inspect)
#  Function など、 Inspect protocol が実装されてない型もある
