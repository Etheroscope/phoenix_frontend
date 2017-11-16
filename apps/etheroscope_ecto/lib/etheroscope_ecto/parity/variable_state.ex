defmodule EtheroscopeEcto.Parity.VariableState do
  use Ecto.Schema
  import Ecto.Changeset
  alias EtheroscopeEcto.Repo
  alias EtheroscopeEcto.Parity.{Contract, VariableState}

  schema "variable_states" do
    field :variable, :string
    field :block_number, :integer
    field :value, :integer

    belongs_to :contract, Contract

    timestamps()
  end

  @doc false
  def changeset(%VariableState{} = contract_abi, attrs) do
    contract_abi
    |> cast(attrs, [:address, :variable, :block_number, :value])
    |> validate_required([:address, :variable, :block_number, :value])
  end

  @spec create_variable_state(map()) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def create_variable_state(attrs \\ %{}) do
    %VariableState{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @spec update_variable_state(struct(), map()) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def update_variable_state(variable_state, attrs \\ %{}) do
    variable_state
    |> VariableState.changeset(attrs)
    |> Repo.update()
  end

  def fetch_variable_state(address, variable, block_number) do
    with nil          <- Repo.get_by(VariableState, address: address, variable: variable, block_number: block_number),
         {:ok, value} <- EtheroscopeEth.Parity.VariableState.fetch_value(address, variable, block_number)
    do
      create_variable_state(%{
        value: value,
        block_number: block_number,
        variable: variable,
        address: address
      })
    end
  end

end
