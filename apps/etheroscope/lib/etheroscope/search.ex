defmodule Etheroscope.Search do

  def search(query) do
    {
      :ok,
      [
        %{
          :name => "Org 1",
          :description => "[Mock description 1]",
          :url => "http://fakeurl1.com",
          :contracts => [
            "0x1234567890A",
            "0x0987654321A",
            "0x4297833385A"
          ]
        },
        %{
          :name => "Org 2",
          :description => "[Mock description 2]",
          :url => "http://fakeurl2.com",
          :contracts => [
            "0x1234567890B",
            "0x0987654321B",
            "0x4297833385B"
          ]
        }
      ]
    }
  end
end
