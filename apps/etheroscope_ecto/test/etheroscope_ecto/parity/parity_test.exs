defmodule EtheroscopeEcto.ParityTest do
  use EtheroscopeEcto.DataCase

  alias EtheroscopeEcto.Parity

  describe "contract_abis" do
    alias EtheroscopeEcto.Parity.ContractState

    @valid_attrs %{abi: %{}, address: "some address"}
    @update_attrs %{abi: %{}, address: "some updated address"}
    @invalid_attrs %{abi: nil, address: nil}

    def contract_abi_fixture(attrs \\ %{}) do
      {:ok, contract_abi} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Parity.create_contract_abi()

      contract_abi
    end

    test "list_contract_abis/0 returns all contract_abis" do
      contract_abi = contract_abi_fixture()
      assert Parity.list_contract_abis() == [contract_abi]
    end

    test "get_contract_abi!/1 returns the contract_abi with given id" do
      contract_abi = contract_abi_fixture()
      assert Parity.get_contract_abi!(contract_abi.id) == contract_abi
    end

    test "create_contract_abi/1 with valid data creates a contract_abi" do
      assert {:ok, %ContractState{} = contract_abi} = Parity.create_contract_abi(@valid_attrs)
      assert contract_abi.abi == %{}
      assert contract_abi.address == "some address"
    end

    test "create_contract_abi/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Parity.create_contract_abi(@invalid_attrs)
    end

    test "update_contract_abi/2 with valid data updates the contract_abi" do
      contract_abi = contract_abi_fixture()
      assert {:ok, contract_abi} = Parity.update_contract_abi(contract_abi, @update_attrs)
      assert %ContractState{} = contract_abi
      assert contract_abi.abi == %{}
      assert contract_abi.address == "some updated address"
    end

    test "update_contract_abi/2 with invalid data returns error changeset" do
      contract_abi = contract_abi_fixture()
      assert {:error, %Ecto.Changeset{}} = Parity.update_contract_abi(contract_abi, @invalid_attrs)
      assert contract_abi == Parity.get_contract_abi!(contract_abi.id)
    end

    test "delete_contract_abi/1 deletes the contract_abi" do
      contract_abi = contract_abi_fixture()
      assert {:ok, %ContractState{}} = Parity.delete_contract_abi(contract_abi)
      assert_raise Ecto.NoResultsError, fn -> Parity.get_contract_abi!(contract_abi.id) end
    end

    test "change_contract_abi/1 returns a contract_abi changeset" do
      contract_abi = contract_abi_fixture()
      assert %Ecto.Changeset{} = Parity.change_contract_abi(contract_abi)
    end
  end
end
