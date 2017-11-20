defmodule Etheroscope.Repo.Migrations.CreateBlocks do
  use Ecto.Migration

  def change do
    create table(:blocks) do
      add :number, :integer
      add :time, :string

      timestamps()
    end

  end
end
