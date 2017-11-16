defmodule Etheroscope.Organisation do

  def fetch_organisation(organisation_name) do
    {
      :ok,
      %{
        :name => organisation_name,
        :description => "[Mock description]",
        :url => "http://fakeurl.com",
        :contracts => [
          "0x1234567890",
          "0x0987654321",
          "0x4297833385"
        ]
      }
    }
  end

end
