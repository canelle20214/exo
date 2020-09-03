defmodule Exo do

  def test() do
    receive do
      {:ok, msg} -> IO.puts(msg)
      {:error, desc} -> IO.puts("ERROR : " <> desc)
    end

    test()
  end

end
