defmodule EtheroscopeEcto.Repo.Migrations.CreateContracts do
  use Ecto.Migration

  def change do
    create table(:contracts) do
      add :address, :string
      add :abi, {:array, :map}
      add :variables, {:array, :string}, default: []
      add :blocks, {:array, :integer}, default: []
      add :most_recent_block, :integer, default: -1

      timestamps()
    end
  end
end
