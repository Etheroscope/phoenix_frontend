defmodule EtheroscopeEcto.Repo.Migrations.CreateContractAbis do
  use Ecto.Migration

  def change do
    create table(:contract_abis) do
      add :address, :string
      add :abi, :map

      timestamps()
    end

  end
end
