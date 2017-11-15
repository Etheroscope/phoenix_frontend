defmodule EtheroscopeEcto.Repo.Migrations.CreateVariableStates do
  use Ecto.Migration

  def change do
    create table(:variable_states) do
      add :address, :string
      add :variable, :string
      add :time, :integer
      add :value, :integer

      timestamps()
    end

  end
end
