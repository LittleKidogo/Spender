defmodule Spender.Planning.IncomeType do
  @moduledoc """
    This module holds changesets used to work with the income_type
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Spender.{
    MoneyLogs.Budget,
    Planning.IncomeType
  }

  @type t :: %__MODULE__{}

  schema "incometypes" do
    field(:name, :string)
    field(:balance, :float)
    belongs_to(:budget, Budget)
  end

  @doc """
    This changeset takes in a struct and a map containig parameters
    and proceeds to match the parameters in the map to the schema above
  """
  @spec changeset(IncomeType.t(), map()) :: Ecto.Changeset.t()
  def changeset(incometype, attrs \\ %{}) do
    incometype
    |> cast(attrs, [:name, :balance])
    |> validate_required([:name, :balance])
  end

  @doc """
    This create changeset takes in a budget struct and map and proceeds to
    match it to the budget parameter in the schema
  """
  @spec create_changeset(Budget.t(), map()) :: Ecto.Changeset.t()
  def create_changeset(%Budget{} = budget, attrs) do
    %IncomeType{}
    |> IncomeType.changeset(attrs)
    |> put_assoc(:budget, budget)
  end
end
