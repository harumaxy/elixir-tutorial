defmodule EnumerableStream do
  @doc """
  # Enumerate

  処理は全て eager
  = strict (正格評価)
  すぐに実行される
  """
  def enum_functions do
    import Enum

    map(1..4, &(&1 * 2))
    reduce(1..3, 0, &+/2)
    filter(4..6, &(&1 > 4))
  end

  @doc """
  # Stream
  だいたい Enum と同じ
  関数は lazy 遅延評価
  """
  def stream_functions do
    import Stream

    map(1..4, &(&1 * 2))
    # reduce([1, 2, 3], 0, &+/2)
    filter(4..6, &(&1 > 4))

    1..1000 |> Stream.map(&(&1 * 2)) |> Stream.filter(&EnumerableStream.odd?/1) |> Enum.to_list()
  end

  @doc """
  # Stream の作成
  作成方法は色々あり、 List から作る、 Bitstring や binary から作る、File から作るなど
  """
  def make_stream do
    # 1,2,3... の無限配列から10個取り出す
    Stream.cycle([1, 2, 3]) |> Enum.take(10)

    # 無限ループになるので無限listに対してmapを呼び出さないように
    # Stream.cycle([1, 2, 3]) |> Enum.map()

    # unfold: fold, reduce の逆。 acc -> {elem, acc} を返してリストやバイナリを Stream に分解する
    Stream.unfold("hello, world", &String.next_codepoint/1)

    # File オープン
    File.stream!("hello.txt")

    # 他にも、HTTP Request のストリームなど、でかいデータを小さく受け渡しして効率的に処理する事ができる
  end

  def odd?(num) do
    Integer.mod(num, 2) != 0
  end
end
