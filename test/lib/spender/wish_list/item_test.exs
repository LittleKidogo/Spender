defmodule Spender.WishList.ItemTest do
  use Spender.DataCase
  alias Spender.WishList.Item

  @valid_attrs %{name: "Soap", price: 10.3}
  @invalid_attrs %{name: "Soap", }

  describe "item changesets" do
    test "should be valid with correct input" do
      changeset = Item.changeset(%Item{}, @valid_attrs)
      assert changeset.valid?
    end

    test " should fail with invalid inputs" do
      changeset = Item.changeset(%Item{}, @invalid_attrs)
      refute changeset.valid?
    end
  end
end