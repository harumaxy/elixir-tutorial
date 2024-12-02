defmodule IoDemo do
  def put_get do
    IO.puts("Hello, world!")
    IO.gets(":stdin から 改行文字 までを読み込む: ") |> IO.inspect()

    IO.puts(:stderr, "エラー出力")
  end

  @doc """
  # IO device
  https://hexdocs.pm/elixir/1.17.3/IO.html#module-io-devices

  IO デバイスは pid | atom
  代表的なもの、事前定義されたものは atom で、動的に生成されたものは pid
  - :stdin, :stdout, :stderr

  File.open の戻り値は、 {:ok, pid}
  つまり、Elixir における File Descriptor はプロセスを立ち上げられていて、プロセスが状態を管理し、pid をデバイスとして扱う

  ## File が Process であることのメリット
  Process は別プロセスと通信ができる
  Erlang VM はクラスタリングができ、別のノードに配置された Process とも通信ができるので、ノードを超えてファイルを読み書きすることができる

  """
  def file_as_io_device do
    # io_device() 型を返す
    # 絶対にファイルがあることを期待している場合、この書き方をするより File.read! を使ったほうがいい。raise され、明確なエラーメッセージが出る
    {:ok, file} = File.open("hello.txt", [:write])
    # io_device() を扱う
    IO.binwrite(file, "Hello, world!")
    File.close(file)

    # 内容をそのまま全部 binary として読み込む
    {:ok, _content} = File.read("hello.txt")
  end

  @doc """
  # iodata (chardata)
  iodata = binary | iolist
  iolist = maybe_improper_list(byte() | binary() | iolist(), binary() | [])

  iodata / iolist は、built-in type である。

  IO.puts 関数など、io_deviceに書き込む関数は binary だけでなく、iolist も受け付ける
  なぜ使うかというと、パフォーマンスのためである

  string を join や format string で埋め込み して出力したい場合と、binary の領域確保などでコストがかかる
  binary list を使うことで、コピーや再割り当てをせずそれぞれを順番に参照して出力するだけでいいのでコストが安い
  """
  def iodata_aka_chardata do
    # efficient
    name = "Mary"
    IO.puts(["Hello, ", name, "!"])
    Enum.intersperse(["banana", "apple", "lemon"], ", ") |> IO.puts()

    # inefficient
    IO.puts("Hello, #{name}!")
    IO.puts("Hello " <> name <> "!")
    Enum.join(["banana", "apple", "lemon"], ", ") |> IO.puts()

    [?,, ?a, ?p, ?p, ?l, ?e] |> IO.puts()
  end
end
