defmodule EtheroscopeEcto.Parity.VariableState do
  use Ecto.Schema
  use Etheroscope.Util

  @behaviour Etheroscope.Resource

  require EtheroscopeEcto
  alias EtheroscopeEcto.Repo
  alias Etheroscope.Cache.Block
  alias EtheroscopeEcto.Parity.Contract

  schema "variable_states" do
    field :variable, :string
    field :block_number, :integer
    field :time,  :integer
    field :value, :string

    belongs_to :contract, Contract

    timestamps()
  end

  def next_storage_module, do: EtheroscopeEth.Parity.VariableState

  @doc """
    Wrapper for get.
  """
  def get_variable_state(address, variable, block_number) do
    get([address: address, variable: variable, block_number: block_number])
  end

  @doc """
    Returns the variable state from the DB or runs the necessary operations to fetch
  it from the blockchain.
  """
  def get(opts = [address: address, variable: variable, block_number: block_number]) do
    case load_variable_state(address, variable, block_number) do
      hit = {:ok, _val} ->
        hit
      {:error, chgset} ->
        Error.build_error(chgset.errors, "[DB] Fetch Failed: Variable State for #{variable} at block #{block_number}.")
      {:not_found, contract} ->
        value_s = apply(next_storage_module(), :get, [opts])
        create_variable_state(contract, variable, block_number, value_s)
    end
  end

  def store_all(var_states) do
    Repo.insert_all(EtheroscopeEcto.Parity.VariableState, var_states)
  end

  defp create_variable_state(_contract, variable, block_number, {:error, err}) do
    Error.build_error_db(err, "Fetch Failed: Variable State for #{variable} at block #{block_number}.")
  end
  defp create_variable_state(contract, variable, block_number, {:ok, value}) do
    contract
    |> Ecto.build_assoc(:variable_states, %{
      value: Integer.to_string(value),
      block_number: block_number,
      time: Block.get_time(block_number),
      variable: variable
    })
  end

  defp load_variable_state(address, variable, block_number) do
    case Contract.get(address) do
      {:ok, contract}       -> get_variable_state_from_contract(contract, variable, block_number)
      resp = {:error, _err} -> resp
    end
  end

  defp get_variable_state_from_contract(contract, variable, block_number) do
    case contract |> Ecto.assoc(:variable_states) |> Repo.get_by(variable: variable, block_number: block_number) do
      nil -> {:not_found, contract}
      var -> {:ok, var}
    end
  end

end
