defmodule EtheroscopeEcto.Parity.Contract do
  use Ecto.Schema
  use Etheroscope.Util, :parity
  import Ecto.Changeset
  alias EtheroscopeEcto.Repo
  alias EtheroscopeEcto.Parity.{Contract, VariableState}

  schema "contracts" do
    field :address,   :string
    field :abi,       {:array, :map}
    field :most_recent_block, :integer, default: -1
    field :variables, {:array, :string}, default: []
    field :blocks,    {:array, :integer}, default: []

    has_many :variable_states, VariableState

    timestamps()
  end

  @doc false
  def changeset(%Contract{} = contract, attrs) do
    contract
    |> cast(attrs, [:address, :abi, :variables, :blocks])
    |> validate_required([:address, :abi])
  end

  @spec create_contract(map()) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def create_contract(attrs \\ %{}) do
    %Contract{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @spec update_contract(struct(), map()) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def update_contract(contract, attrs \\ %{}) do
    contract
    |> Contract.changeset(attrs)
    |> Repo.update()
  end

  defp get_contract(addr), do: Repo.get_by(Contract, address: addr)

  @doc """
    fetch_contract(addr) attempts to get the entire contract schema from the database.
  If that fails, it calls the parity wrapper to retrieve the basic information needed to
  store the contract (i.e. contractABI).
  """
  @spec fetch_contract(String.t()) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def fetch_contract(addr) do
    with nil          <- get_contract(addr),
         {:ok, attrs} <- EtheroscopeEth.Parity.Contract.fetch(addr)
    do
      create_contract(attrs)
    else
      {:error, err} -> Error.build_error_db(err, "Not Fetched: Contract #{addr}.")
      contract      -> {:ok, contract}
    end
  end

  @spec fetch_contract_block_numbers(String.t()) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def fetch_contract_block_numbers(addr) do
    with {:ok, contract} <- fetch_contract(addr),
         blocks           = contract.blocks
    do
      fetch_contract_block_numbers_h(contract, blocks)
    else
      error = {:error, _err} -> error
    end
  end

  defp fetch_contract_block_numbers_h(contract, blocks) do
    with {:ok, block_list = [_ | _]} <- update_block_numbers(contract.address, contract.most_recent_block),
         {:ok, new_contract}         <- update_contract(contract, %{blocks: blocks ++ block_list, most_recent_block: Enum.max(block_list)})
    do
      {:ok, new_contract.blocks}
    else
      {:ok, []}     -> {:ok, blocks}
      {:error, err, block_list} ->
        # block update interrupted
        update_contract(contract, %{blocks: blocks ++ block_list, most_recent_block: Enum.max(block_list)})
        Error.build_error_db(err, "Not Fetch: Contract Block Numbers fetching interrupted.")
      {:error, err} ->
        Error.build_error_db(err, "Not Updated: can't update contract in DB.")
    end
  end

  @spec update_block_numbers(String.t(), integer()) :: {:ok, MapSet.t()} | Error.with_arg()
  defp update_block_numbers(address, most_recent_block) do
    block_result = case most_recent_block do
      -1 -> EtheroscopeEth.Parity.Contract.fetch_early_blocks(address)
      x  -> EtheroscopeEth.Parity.Contract.fetch_latest_blocks(address, x)
    end

    case block_result do
      {:ok, blocks} ->
        {:ok, MapSet.to_list(block_numbers(blocks))}
      err = {:error, _blocks, _error} -> err
    end
  end

  @spec fetch_contract_abi(String.t()) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def fetch_contract_abi(addr) do
    case fetch_contract(addr) do
      {:error, chgset} -> Error.build_error_db(chgset.errors, "Not Fetched: contractABI for #{addr}.")
      {:ok, contract}  -> {:ok, contract.abi}
    end
  end

  @spec fetch_contract_variables(String.t()) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def fetch_contract_variables(addr) do
    with {:ok, contract}     <- fetch_contract(addr),
         []                  <- contract.variables,
         vars                 = abi_variables(contract.abi),
         {:ok, new_contract} <- update_contract(contract, %{variables: vars})
    do
      {:ok, new_contract.variables}
    else
      {:error, err}   -> Error.build_error_db(err, "Failed: contract variables for #{addr}.")
      vars = [_v|_vs] -> {:ok, vars}
    end
  end

end
