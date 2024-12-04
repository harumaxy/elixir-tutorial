defmodule AntiPattens do
  def overuse_comments do
    # 現在の時刻
    now = DateTime.utc_now()
  end

  def complex_else_clauses_in_with do
    # 左の項を関数などに切り分けて、エラー構造を統一しよう
    with {:ok, value} <- {:ok, 1},
         {:ok, value} <- {:ok, 2},
         {:ok, value} <- {:ok, 3} do
      value
    else
      {:error, _} = error -> error
      :error -> :error
    end
  end

  # 関数で使ってる値と、ガードで使ってる値が混在して読みづらい(この程度まではアンチパターンじゃないが...)
  def drive(%User{age: age, name: name}) when age >= 18, do: name

  # この書き方なら、引数からガードに使う部分だけマッチできるし、user引数(構造体の全体)を関数内で使える
  def drive(%User{age: age} = user) when age < 18, do: user.name

  # 動的 atom 生成  => atom の数はシステムにより制限があるため、 String.to_atom/1 は外部からのリクエストで使わないほうがいい
  def parse(%{"status" => status, "message" => message} = _payload) do
    %{status: String.to_atom(status), message: message}
  end

  # convert_status/1(string) で、静的に変換する(想定してない文字列が来たらエラーにする)
  def convert_status("ok"), do: :ok
  def convert_status("error"), do: :error
  def convert_status("redirect"), do: :redirect

  # もしくは、 String.to_existing_atom/1 を使うと、システムに存在する atom にしか変換できないためメモリ不足を防げる
  # モジュール内で使われているatomならOK, 明示的に示すことも可能
  def valid_statuses do
    # String.to_existing_atom/1 のためのアトム事前定義
    [:ok, :error, :redirect]
  end

  # 位置パラメータの数を多くするのは良くない
  # インターフェースが分かりづらく、runtime error が増える
  @doc """
  load/6
  """
  def load(_name, _email, _pssword, _user_alias, _book_title, _book_ed) do
  end

  @doc """
  引数を Keyword List、Map, Struct にする
  パターンマッチもできるし、開発中の静的解析で引数エラーに気づきやすい

  構造体ごとに分けることもできる
  load/2
  """
  def load(
        %{
          name: _name,
          email: _email,
          password: _password
        } = user,
        %{user_alias: _user_alias, book_title: _book_title, book_ed: _book_ed} = book
      ) do
  end

  # Non-assertive map access
  # map の要素取得には map[:key] と map.key がある
  # 前者はキーが存在しない場合に nil を返すが、後者はエラーを返す

  # この関数の例でいうと、 2d と 3d の点があり、 z だけが optional
  # 以下のコードだと、 x, y が nil でもエラーにならない
  def bad_plot(point) do
    {point[:x], point[:y], point[:z]}
  end

  # 不正なデータが返されると、他の関数でエラーが発生してどこが原因かわかりにくい
  # さっさと死んでエラーを伝搬したほうがいいので、 x, y は assertive access で z だけ optional にする
  def plot(point) do
    {point.x, point.y, point[:z]}
  end

  # Non-assertive truthiness
  # ||, &&, ! の演算子は、項が bool でなくてもエラーを吐かないので予想外の結果になりやすい
  # or, and, not を使うべき
end
