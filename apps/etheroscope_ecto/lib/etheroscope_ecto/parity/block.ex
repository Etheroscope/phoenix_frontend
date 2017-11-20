defmodule EtheroscopeEcto.Parity.Block do
  use Ecto.Schema
  use Etheroscope.Util
  import Ecto.Changeset
  alias EtheroscopeEcto.Parity.Block
  alias EtheroscopeEcto.Repo

  schema "blocks" do
    field :number, :integer
    field :time, :string

    timestamps()
  end

  @doc false
  def changeset(%Block{} = block, attrs) do
    block
    |> cast(attrs, [:number, :time])
    |> validate_required([:number, :time])
  end

  @spec create_block(map()) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def create_block(attrs \\ %{}) do
    %Block{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def fetch_block_time(block_number) do
    Logger.info "[DB] Fetching: block #{block_number}"
    with nil           <- Repo.get_by(Block, number: block_number),
         {:ok, time}   <- EtheroscopeEth.Parity.Block.fetch_time(block_number),
         {:ok, _block} <- create_block(%{number: block_number, time: time})
    do
      {:ok, time}
    else
      {:error, err} -> Error.build_error(err, "[DB] Unable to fetch block time.")
      block         -> {:ok, block.time}
    end
  end
end
