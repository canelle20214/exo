defmodule Exo do

  def test do
    receive do
      {:ok, msg} -> msg
      {:error, desc} -> "ERROR : " <> desc
      #_ -> "no case"
    end

    test()
  end
  
end
