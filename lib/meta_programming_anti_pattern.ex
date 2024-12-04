defmodule MetaProgrammingAntiPattern do
  # Module 内部の do end ブロックでも、変数を定義したり control flow を書くことができる
  # ただ、関数定義の内部では参照できないので、メタプログラミング用
  # hello = "world"
  # if hello !== "world!!" do
  #   raise "hello is not world!!"
  # end

  def doit do
  end
end

# マクロアンチパターン改善 : 展開されたコードが大きくなりすぎるのを防ぐ
# 実質、コードのASTを展開していることになるので処理が多すぎるとコンパイルが遅くなる
# マクロを実装するモジュールの関数を呼び出したり、展開先のコードが少なくなる工夫をすべし
defmodule Route do
  defmacro get(route, handler) do
    quote do
      # マクロ内の処理を Route.__define__ 関数に共通化することで、コードが増えるのを防ぐ
      __define__(__MODULE__, unquote(route), unquote(handler))
    end
  end

  def __define__(module, route, handler) do
    if not is_binary(route) do
      raise "route must be a binary"
    end

    if not is_function(handler) do
      raise "handler must be a function"
    end

    Module.put_attribute(module, :get_route_store_for_compilation, {route, handler})
  end
end

# behaviour を実装する moduledoc に書くこと
# use した場合に、呼び出し元の module のパブリックインターフェースへの影響を書く (栄養成分表示のようなもの)
