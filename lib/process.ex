defmodule ProcessTutorial do
  def process_demo do
    pid = spawn(fn -> 1 + 2 end)
    Process.alive?(pid)

    _self_pid = self()
  end

  @doc """
  # メッセージング
  ## send/2(pid, msg) 関数
  指定したプロセスidのプロセスにメッセージを送る
  Erlang/Elixir の処理系では超軽量なプロセスが複数存在でき、それぞれがメッセージキューやガベージコレクタ機能を持っている

  並列処理はプロセスを spawn することで開始され、 send でプロセス間通信を行う

  ## receive/1 マクロ
  メッセージキューから1つ取り出してパターンマッチングする

  do .. after .. end
  after に数値を置くことで、タイムアウトを設定できる(右の項の値を返す)
  """
  def process_messaging do
    send(self(), {:hello, "world"})

    receive do
      {:hello, value} ->
        value

      {:world, _value} ->
        "won't match"
    after
      1_000 -> "nothing after 1s"
    end
  end

  @doc """
  flush/0 関数
  Process の queue に溜まったメッセージをすべて出力する
  iex でしか使えない
  """
  def flush_msgs do
    # flush :
  end

  @doc """
  # Links
  実際の開発では、Link されたプロセスとして生成することが多い

  ## 何に使える？
  fault tolerance に使える
  Elixir のプロセスは分離されていて、普通は障害が起こっても伝搬せずエラー情報も共有されない。
  クラッシュしても他のプロセスに影響を与えないのは良い側面も有るが、死なせてやり直したいこともある。

  多言語では catch して処理することが多いが、Elixir/Erlang では Supervisor に Process をリンクしてプロセスの停止を検出し、新しいプロセスを生成するスタイル
  早く失敗させる、クラッシュさせることが Elixir の哲学
  """
  def linked_process do
    # 同じ
    self_id = self()
    spawn(fn -> raise "oops" end)
    ^self_id = self()

    # iex でやると、リンクされた Process が死んだとき、親プロセスも一緒に死ぬ
    self_id = self()
    spawn_link(fn -> raise "oops" end)
    ^self_id = self()

    # 手動でリンクも可能
    pid = spawn(fn -> nil end)
    Process.link(pid)
  end

  @doc """
  # Task
  Process を強化したもので、Supervision tree での監視、分散の用意さ、async/await などのユーティリティーを提供する

  生成
  - Task.start/1(fn) : 分離された Process を生成
  - Task.start_link/1(fn) : リンクされた Process を生成

  - Task.async/1(fn) : Task を生成する
  - Task.await/1(task) : Task の結果を待つ

  Task 構造体
  mfa, owner, pid, ref のフィールドを持つ
  """
  def task do
    Task.start(fn -> raise "oops" end)
  end
end

defmodule StateIsProcess do
  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  @doc """
  # Elixir における State
  State = 状態
  他のプログラミング言語だと可変性の変数を Mutex/Semaphore アクセス管理して複数プロセスからアクセスできるようにしたりする。

  Elixir で状態を表現する一般的な答えはプロセスである。

  ## Process を State にする
  関数型プログラミング言語では、変数は不変性を持つので再代入で更新はできない。
  なので、stateを引数とする関数を再帰呼び出しで無限ループさせ、ある実行サイクルの戻り値をその時点の状態として扱う


  下の例では、無限再帰関数 (receive で一時停止する) を Task Process として生成、
  pid に {:get, ...} メッセージを送って状態を取得、 {:put, ...} メッセージを送って状態を更新する

  ## 不完全な例
  以下の map を状態として保持する Task は、呼び出し元との値の受け渡しに send/receive を使う
  これはかなり低レベルで記述が多くなるので、 Agent を使ったほうがいい
  """
  def loop(map) do
    receive do
      {:get, key, caller} ->
        send(caller, Map.get(map, key))

      {:put, key, value} ->
        loop(Map.put(map, key, value))
    end
  end
end

defmodule AgentIsBetterForState do
  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Agent.start_link/1(fn)
  Agent.start_link/3(agent_module, fn, options)

  前者は動的に Agent を生成するのに使える。 pid はどこか別のデータストアに保存する必要がある？(関数のスコープを抜けると使えなくなるため)
  後者は、グローバル変数やシングルトン的な使い方をするのに使えるが、引数に渡す module に Agent behaviour を実装している必要がある

  """
  def operations() do
    pid = Agent.start_link(fn -> %{} end)
    Agent.update(pid, fn map -> Map.put(map, :hello, "world") end)
    Agent.get(pid, fn map -> map end) |> IO.inspect()
  end
end

# State を Process で表現できるのは上記の通り
# ただ、値の取得・更新が messaging を利用したものになるため、そのままだと利用しづらい
# Agent としてモジュールを通してやるのも一般的
# また、データの取得・更新のための通信モデルというのは Client/Server の方式に似ている
# このことから、Erlang は GenServer という Process の種類を用意している (Generic Server)
