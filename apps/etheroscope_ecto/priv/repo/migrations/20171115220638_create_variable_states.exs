defmodule EtheroscopeEcto.Repo.Migrations.CreateVariableStates do
  use Ecto.Migration

  def change do
    create table(:blocks) do
      add :address, :string
      add :variable, :string
      add :time, :integer
      add :value, :integer

      timestamps()
    end

  end
end
