defmodule EtheroscopeEcto.Parity.Block do
  use Ecto.Schema
  import Ecto.Changeset
  alias EtheroscopeEcto.Parity.Block

  schema "blocks" do
    field :number, :integer
    field :time, :integer

    timestamps()
  end

  @doc false
  def changeset(%Block{} = block, attrs) do
    block
    |> cast(attrs, [:number, :time])
    |> validate_required([:number, :time])
  end
end
