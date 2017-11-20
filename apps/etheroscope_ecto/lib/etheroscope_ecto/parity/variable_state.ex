defmodule EtheroscopeEcto.Parity.VariableState do
  use Ecto.Schema
  use Etheroscope.Util
  import Ecto.Changeset
  alias EtheroscopeEcto.Repo
  alias EtheroscopeEcto.Parity.{Contract, VariableState}

  schema "variable_states" do
    field :variable, :string
    field :block_number, :integer
    field :value, :string

    belongs_to :contract, Contract

    timestamps()
  end

  @doc false
  def changeset(%VariableState{} = variable_state, attrs) do
    variable_state
    |> cast(attrs, [:address, :variable, :block_number, :value])
    |> validate_required([:address, :variable, :block_number, :value])
  end

  @spec create_variable_state(map()) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def create_variable_state(attrs \\ %{}) do
    %VariableState{}
    |> changeset(attrs)
    |> Repo.insert()
  end


  @spec fetch_variable_state(String.t(), String.t(), integer()) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def fetch_variable_state(address, variable, block_number) do
    with {:ok, contract} <- Contract.fetch_contract(address),
         nil             <- get_variable_state(contract, variable, block_number),
         {:ok, value}    <- EtheroscopeEth.Parity.VariableState.fetch_value(address, variable, block_number)
    do
      contract
      |> Ecto.build_assoc(:variable_states, %{ value: Integer.to_string(value), block_number: block_number, variable: variable })
      |> Repo.insert
    else
      {:error, errs = [_e | _es]} -> Error.build_error(errs, "[DB] Fetch variable state for #{variable} failed.")
      {:error, chgset}            -> Error.build_error(chgset.errors, "[DB] Fetch variable state for #{variable} failed.")
      var                         -> {:ok, var}
    end
  end

  defp get_variable_state(contract, variable, block_number) do
    contract
    |> Ecto.assoc(:variable_states)
    |> Repo.get_by(variable: variable, block_number: block_number)
  end

end
