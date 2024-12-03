# Elixir は heredoc ("""3つの引用符""") と Markdown でドキュメントを書くことを推奨している
# ExDoc というライブラリで、HTML/ePubドキュメントに変換できる

defmodule ModuleAttributes do
  @moduledoc """
  # Module Attributes
  @ で始まる、モジュールに書ける属性

  使い道
  - アノテーション、注意書き
  - コンパイル中に使える store
  - コンパイル時定数

  ## 主な属性
  - @moduledoc : モジュールのドキュメント。Markdown
  - @doc : 関数・マクロのドキュメント
  - @spec
  - @behaviour : OTP である、またはユーザー定義の behaviour であることを示す (British spelling であることに注意)

  ↓ doc test も書ける

  ## Examples
    iex> ModuleAttributes.hello()
    :hello
  """

  def hello do
    :hello
  end

  # 定義はモジュールスコープ、参照はモジュール/関数内でできる
  @hello :world

  @doc """
  # Attribute を値のストアとして使う
  - コンパイル時に、設定された値に置き換えられる
    - ある意味、C/C++ の #define 定数プリプロセッサに近い
  - 置き換えたあと、モジュール属性は破棄される
  - Attribute の値に関数を使うことはできない (未コンパイル = 関数がまだ存在していないため)

  消費税、円周率、1時間の秒数、1日の時間... などに便利?

  ただし、コンパイル時コストがかかるので何回も使わないほうがいい

  """
  def attr_as_temp_storage do
    IO.inspect(@hello)
  end

  # 実はモジュール内で副作用があるコードを書ける (コンパイル中に実行される)
  IO.inspect(@hello)

  # @ をストアとして参照する場合、現在の値をスナップショットとして取得する。何回も参照するとコンパイルが遅くなるので、値を取得する defp にすると良い
  @example :example
  def some_function, do: do_something_with(example())
  def another_function, do: do_something_else_with(example())
  defp example, do: @example
  defp do_something_with(v), do: IO.inspect(v)
  defp do_something_else_with(v), do: IO.inspect(v)

  @doc """
  # 定数のベストプラクティス
  @属性を定数として使うとコンパイルコストがかかる
  一般的に、アプリケーションの定数として使うなら arity 0 の関数でいい

  MyApp.Constants. モジュールのようなものを作るのは一般的
  """
  # @hours_in_a_day 24
  def hours_in_a_day, do: 24

  # じゃあ、モジュール属性を値のストアとして使う場合は？
  # -> 関数のパターンマッチ、ガードに使うと良い。 (使える式が限られている。コンパイル時定数は使えるものの一つ)
  # コンパイル時になにか計算して、それを使うのに向く

  # その他
  # モジュールのカスタム注釈など
end
