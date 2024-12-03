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
end
