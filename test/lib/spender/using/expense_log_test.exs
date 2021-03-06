defmodule Spender.Using.ExpenseLogTest do
  @moduledoc """
  This module contains tests for the expense log
  changeset
  """
  use Spender.DataCase
  alias Spender.Using.ExpenseLog

  @no_name_attrs %{amount: 45.67}
  @no_amount_attrs %{name: "Zucchini"}
  @valid_expense %{name: "Zucchini", amount: 20.89}
  describe "ExpenseLog changeset" do
    test "is valid when provided correct attributes" do
      changeset = ExpenseLog.changeset(%ExpenseLog{}, @valid_expense)
      assert changeset.valid?
    end

    test "is invalid when not provided with a name" do
      changeset = ExpenseLog.changeset(%ExpenseLog{}, @no_name_attrs)
      refute changeset.valid?
    end

    test "is invalid when not provided with an amount" do
      changeset = ExpenseLog.changeset(%ExpenseLog{}, @no_amount_attrs)
      refute changeset.valid?
    end

    test "create_changeset will associate the payment method to the moneylog id" do
      moneylog = insert(:moneylog)
      changeset = ExpenseLog.create_changeset(moneylog, @valid_expense)
      assert changeset.valid?
      assert changeset.changes.moneylog
    end

    test "log_changeset will associate the paymnet method to the moneylog id" do
      logcategories = insert(:logcategory)
      changeset = ExpenseLog.log_changeset(logcategories, @valid_expense)
      assert changeset.valid?
      assert changeset.changes.logcategory
    end
  end
end
