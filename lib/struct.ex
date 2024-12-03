defmodule StructDemo do
  @moduledoc """
  # Struct とは
  Map の上に構築され、 compile-time check と default value を提供する

  要するに、型付き & デフォルト値付き Map
  """
end

defmodule User do
  @doc """
  %User{} を定義している
  """
  defstruct name: "John", age: 27

  def new_user do
    %User{name: "Alice", age: 30}

    # %User{name: "Alice", years: 30} : コンパイル時に、定義されたフィールドだけがStructに存在することを保証するのでこれはエラー
  end

  def get_name(%User{name: name}) do
    name
  end

  def is_user_map? do
    # => true
    is_map(%User{})

    # Map -> Struct へはパターンマッチ代入できない(マッチしない)。逆はできる。
    # 同じ構造体かどうかはパターンマッチで区別できるとも言える
    user = %User{}
    ^user = %{name: "John", age: 27}
    %{name: name} = %User{}
  end

  @doc """
  # Map と Struct の違い
  Struct は型付き & デフォルト値付き Map である
  最も簡単な区別は、　`__struct__` :: ModuleName フィールドを持ってるかどうか

  あと、Mapが継承する protocol を Struct は継承しない (Enum.each とかできない)
  """
  def __struct__field do
    # __struct__ は、構造体が定義されているモジュール名を返す
    :"Elixir.User" = %User{}.__struct__

    # 関数も呼び出せる(冗長なので意味ないが)
    %User{}.__struct__.is_user_map?
  end
end

defmodule MyStruct do
  @moduledoc """
  # nil default
  defstruct で、キーワードリストになってない部分は nil が暗黙的にデフォルトになる

  ちなみに、デフォルト値がセットされているからと言って、そのフィールドへの型が制限されるわけではない (string デフォルト値をもつ name: に 100 を入れてもエラーにならない)

  # @enforce_keys
  コンストラクタで必須にするフィールドを指定できる
  コンパイル時にチェックされ、欠落しているコードが有るとエラーになる
  """
  @enforce_keys [:email]
  defstruct [:email, name: "NoName", age: 0]
end
