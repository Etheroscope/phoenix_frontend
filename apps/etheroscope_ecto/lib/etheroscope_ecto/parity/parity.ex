defmodule EtheroscopeEcto.Parity do
  @moduledoc """
  The Parity context.
  """

  import Ecto.Query, warn: false
  alias EtheroscopeEcto.Repo

  alias EtheroscopeEcto.Parity.ContractABI

  @doc """
  Returns the list of contract_abis.

  ## Examples

      iex> list_contract_abis()
      [%ContractABI{}, ...]

  """
  def list_contract_abis do
    Repo.all(ContractABI)
  end

  @doc """
  Gets a single contract_abi.

  Raises `Ecto.NoResultsError` if the Contract abi does not exist.

  ## Examples

      iex> get_contract_abi!(123)
      %ContractABI{}

      iex> get_contract_abi!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contract_abi!(id), do: Repo.get!(ContractABI, id)

  @doc """
  Creates a contract_abi.

  ## Examples

      iex> create_contract_abi(%{field: value})
      {:ok, %ContractABI{}}

      iex> create_contract_abi(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contract_abi(attrs \\ %{}) do
    %ContractABI{}
    |> ContractABI.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a contract_abi.

  ## Examples

      iex> update_contract_abi(contract_abi, %{field: new_value})
      {:ok, %ContractABI{}}

      iex> update_contract_abi(contract_abi, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_contract_abi(%ContractABI{} = contract_abi, attrs) do
    contract_abi
    |> ContractABI.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ContractABI.

  ## Examples

      iex> delete_contract_abi(contract_abi)
      {:ok, %ContractABI{}}

      iex> delete_contract_abi(contract_abi)
      {:error, %Ecto.Changeset{}}

  """
  def delete_contract_abi(%ContractABI{} = contract_abi) do
    Repo.delete(contract_abi)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contract_abi changes.

  ## Examples

      iex> change_contract_abi(contract_abi)
      %Ecto.Changeset{source: %ContractABI{}}

  """
  def change_contract_abi(%ContractABI{} = contract_abi) do
    ContractABI.changeset(contract_abi, %{})
  end
end
