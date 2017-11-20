defmodule EtheroscopeEcto.Repo.Migrations.MakeContractAddressesUnique do
  use Ecto.Migration

  def change do
    create unique_index(:contracts, [:address])
  end
end
