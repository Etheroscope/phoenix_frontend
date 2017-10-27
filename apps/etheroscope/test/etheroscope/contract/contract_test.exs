defmodule Etheroscope.ContractTest do
  use Etheroscope.DataCase

  alias Etheroscope.Contract

  describe "histories" do
    alias Etheroscope.Contract.History

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def history_fixture(attrs \\ %{}) do
      {:ok, history} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contract.create_history()

      history
    end

    test "list_histories/0 returns all histories" do
      history = history_fixture()
      assert Contract.list_histories() == [history]
    end

    test "get_history!/1 returns the history with given id" do
      history = history_fixture()
      assert Contract.get_history!(history.id) == history
    end

    test "create_history/1 with valid data creates a history" do
      assert {:ok, %History{} = history} = Contract.create_history(@valid_attrs)
    end

    test "create_history/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contract.create_history(@invalid_attrs)
    end

    test "update_history/2 with valid data updates the history" do
      history = history_fixture()
      assert {:ok, history} = Contract.update_history(history, @update_attrs)
      assert %History{} = history
    end

    test "update_history/2 with invalid data returns error changeset" do
      history = history_fixture()
      assert {:error, %Ecto.Changeset{}} = Contract.update_history(history, @invalid_attrs)
      assert history == Contract.get_history!(history.id)
    end

    test "delete_history/1 deletes the history" do
      history = history_fixture()
      assert {:ok, %History{}} = Contract.delete_history(history)
      assert_raise Ecto.NoResultsError, fn -> Contract.get_history!(history.id) end
    end

    test "change_history/1 returns a history changeset" do
      history = history_fixture()
      assert %Ecto.Changeset{} = Contract.change_history(history)
    end
  end
end
