defmodule EtheroscopeEcto.Parity.VariableState do
  use Ecto.Schema
  use Etheroscope.Util

  @behaviour Etheroscope.Resource

  import Ecto.Query, only: [from: 2]

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
  def get(opts = [address: _address, variable: variable, block_number: block_number]) do
    with {:ok, val}  <- apply(next_storage_module(), :get, [opts]),
         {:ok, time} <- Block.get_time(block_number)
    do
      format_variable_state(variable, val, block_number, time)
    else
      resp = {:error, _errs} -> resp
    end
  end

  def store_all(var_states, address) do
    case Contract.get(address) do
      {:ok, contract} ->
        Enum.map(var_states, &create_variable_state(contract, &1))
      resp = {:error, _err} ->
        resp
    end
  end

  def fetch_all_variable_states(address, variable) do
    Repo.all(from c in Contract,
                where: c.address == ^address,
                join: v in assoc(c, :variable_states),
                where: v.variable == ^variable,
                select: %{time: v.time, value: v.value})
  end

  defp create_variable_state(contract, args) do
    contract
      |> Ecto.build_assoc(:variable_states, args)
      |> Repo.insert
  end

  defp format_variable_state(variable, value, block_number, time) do
    %{
      value: Integer.to_string(value),
      block_number: block_number,
      time: time,
      variable: variable
    }
  end

end
