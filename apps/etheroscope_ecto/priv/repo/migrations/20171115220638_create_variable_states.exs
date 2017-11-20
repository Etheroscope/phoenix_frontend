defmodule EtheroscopeEcto.Repo.Migrations.CreateVariableStates do
  use Ecto.Migration

  def change do
    create table(:variable_states) do
      add :variable, :string
      add :block_number, :integer
      add :value, :string

      add :contract_id, references(:contracts)

      timestamps()
    end

  end
end
