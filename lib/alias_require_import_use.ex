defmodule AliasRequireImportUse do
  @moduledoc """
  # alias, import, require
  レキシカルスコープを持つディレクティブ(Elixir syntax の一部)
  alias : モジュールを呼び出しやすい別名にする
  import : モジュール名を省略する
  require : マクロを使用するためにモジュールを読み込む (上2はユーティリティであり必須ではないが、require はマクロ機能を利用するためには必須)
  マクロは強力だが require を書いて明示的に opt-in (使用許可)をする必要がある


  # macro
  モジュールがコードを挿入するための拡張ポイント
  use はマクロである
  use : require + __using__/1 macro extension
  指定した {Module} を require する + {Module}.__using__/1 macro コールバックを展開して、現在のモジュールコンテキストにコードを挿入する
  """

  require Integer

  @doc """
  Integer.is_odd は macro なのでガードで使える。使う前に require Integer が必要
  Integer モジュールは普通に呼び出せる関数が多いため、マクロが含まれているのを見落としやすい罠
  """
  def doit_if_odd(n) when Integer.is_odd(n) do
    IO.puts("odd")
  end

  @doc """
  # import vs alias
  import は only [] が使える、完全にモジュール修飾子を省略できる(別名すらなく)
  便利だが、自作のコードベースでは alias を多用したほうがいい？完全にモジュール修飾子なしにすると、モジュール内で定義した関数やグローバルにある関数と名前衝突の可能性がある
  """
  def import_alias do
  end

  @doc """
  # use/2(mod, opts) = require + macro extension
  GenServer, SuperVisor, ExUnit.Case, Mix.Task ... などはこの use マクロ、 __using__/1 コールバックマクロを実装している

  ## attribute about use macro
  @behaviour: {ModuleName} を指定しておくと、 use で使える behaviour としてマークされる
  @callback: behaviour が動作するのに実装が必要なコールバックを列挙しておく
    - GenServer.init/1
  @optional_callbacks : ↑の、任意版 (実装しなくても、一応起動はする)
    - GenServer.handle_call/3, ...

  実装例
  https://github.com/elixir-lang/elixir/blob/eadbd8bdf3375e6e02f02d78b4c6c998c54b1b64/lib/elixir/lib/gen_server.ex#L844

  macro は、関数の定義など Elixir のコードでできることがすべてできる。
  require -> マクロ呼び出し(展開) することで共通の関数定義を挿入できるが、ひと手間多いのを use でひとまとめにしている、というところか
  他の言語で言うところの継承に近い
  """
  def use_behaviour do
  end

  use ExUnit.Case
end
