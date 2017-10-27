defmodule Etheroscope.Repo.Migrations.CreateHistories do
  use Ecto.Migration

  def change do
    create table(:histories) do

      timestamps()
    end

  end
end
