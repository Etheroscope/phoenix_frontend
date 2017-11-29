defmodule EtheroscopeEcto.Parity.Contract do
  use Ecto.Schema
  use Etheroscope.Util, :parity
  import Ecto.Changeset
  require EtheroscopeEcto
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
  defp changeset(%Contract{} = contract, attrs) do
    contract
    |> cast(attrs, [:address, :abi, :variables, :blocks, :most_recent_block])
    |> validate_required([:address, :abi])
  end

  @spec create_contract(map()) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  defp create_contract(attrs) do
    %Contract{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @spec update_contract(struct(), map()) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def update_contract(contract, attrs) do
    contract
    |> changeset(attrs)
    |> Repo.update()
  end

  def next_storage_module, do: EtheroscopeEth.Parity.Contract

  def get(address: address) do
    case load_contract(address) do
      resp = {:ok, _c}    -> resp
      {:not_found, _addr} ->
        abi_s = apply(next_storage_module(), :get, [[address: address]])
        store_contract(address, abi_s)
    end
  end
  def get(address) when is_binary(address), do: get(address: address)

  defp store_contract(_addr, resp = {:error, _err}), do: resp
  defp store_contract(addr, {:ok, abi}) do
    # Logger.info "Storing: contract #{addr}"
    case create_contract(%{address: addr, abi: abi, variables: parse_contract_abi(abi)}) do
      resp = {:ok, _c} -> resp
      {:error, chgset} ->
        Error.build_error_db(chgset.errors, "Store Failed: contract #{addr}.")
    end
  end

  defp load_contract(addr) do
    case Repo.get_by(Contract, address: addr) do
      nil      -> {:not_found, addr}
      contract -> {:ok, contract}
    end
  end

  ################################### BLOCKS ###################################

  def get_block_numbers(addr) do
    case load_block_numbers(addr) do
      resp = {:ok, _b}  -> resp
      {:stale, ctr}     -> update_block_numbers(ctr)
      {:not_found, ctr} -> get_full_block_history(ctr)
      {:error, err}     -> Error.build_error_db(err, "Not Loaded: unable to load blocks for #{addr}")
    end
  end

  defp load_block_numbers(addr) do
    case get(addr) do
      {:ok, contract = %Contract{blocks: []}} -> {:not_found, contract}
      {:ok, contract}                         -> {:stale, contract} # assume it's always stale for now
      resp = {:error, _err}                   -> resp
    end
  end

  defp update_block_numbers(contract) do
    handle_new_blocks(contract, :fetch_latest_blocks, [contract.address, contract.most_recent_block])
  end

  defp get_full_block_history(contract) do
    handle_new_blocks(contract, :fetch_early_blocks, [contract.address])
  end

  defp handle_new_blocks(contract, fun, args) do
    case apply(next_storage_module(), fun, args) do
      {:ok, blocks} ->
        new_blocks = MapSet.to_list(block_numbers(blocks))
        store_block_numbers(contract, new_blocks)
      {:error, err} ->
        Error.build_error(err)
      {:error, err, new_blocks} ->
        if new_blocks != [], do: store_block_numbers(contract, new_blocks)
        Error.build_error(err)
    end
  end

  defp store_block_numbers(contract, new_blocks) do
    case contract |> update_contract(%{blocks: contract.blocks ++ new_blocks, most_recent_block: Util.max(new_blocks)}) do
      {:ok, new_contract} -> {:ok, new_contract.blocks}
      {:error, err}       -> Error.build_error_db(err, "Not Stored: contract blocks for #{contract.address}")
    end
  end

  ################################### ABI ###################################

  @spec get_contract_abi(String.t()) :: EtheroscopeEcto.db_status()
  def get_contract_abi(addr) do
    case get(addr) do
      {:ok, contract}       -> {:ok, %{abi: contract.abi, variables: contract.variables}}
      resp = {:error, _err} -> resp
    end
  end
end
