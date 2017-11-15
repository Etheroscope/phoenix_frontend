defmodule EtheroscopeEcto.Parity.ContractABI do
  use Ecto.Schema
  import Ecto.Changeset
  alias EtheroscopeEcto.Parity.ContractABI


  schema "contract_abis" do
    field :abi, :map
    field :address, :string

    timestamps()
  end

  @doc false
  def changeset(%ContractABI{} = contract_abi, attrs) do
    contract_abi
    |> cast(attrs, [:address, :abi])
    |> validate_required([:address, :abi])
  end
end
