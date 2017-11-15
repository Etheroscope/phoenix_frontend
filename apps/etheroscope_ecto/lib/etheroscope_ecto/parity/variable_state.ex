defmodule EtheroscopeEcto.Parity.VariableState do
  use Ecto.Schema
  import Ecto.Changeset
  alias EtheroscopeEcto.Parity.VariableState

  schema "variable_states" do
    field :address, :string
    field :variable, :string
    field :time, :integer
    field :value, :integer

    timestamps()
  end

  @doc false
  def changeset(%VariableState{} = contract_abi, attrs) do
    contract_abi
    |> cast(attrs, [:address, :variable, :time, :value])
    |> validate_required([:address, :variable, :time, :value])
  end
end
