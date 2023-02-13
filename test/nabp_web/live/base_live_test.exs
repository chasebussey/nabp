defmodule NabpWeb.BaseLiveTest do
  use NabpWeb.ConnCase

  import Phoenix.LiveViewTest
  import Nabp.BasesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_base(_) do
    base = base_fixture()
    %{base: base}
  end

  describe "Index" do
    setup [:create_base]

    test "lists all bases", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/bases")

      assert html =~ "Listing Bases"
    end

    test "saves new base", %{conn: conn} do
      true
    end

    test "deletes base in listing", %{conn: conn, base: base} do
      {:ok, index_live, _html} = live(conn, ~p"/bases")

      assert index_live |> element("#bases-#{base.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#base-#{base.id}")
    end
  end

  describe "Show" do
    setup [:create_base]

    test "displays base", %{conn: conn, base: base} do
      {:ok, _show_live, html} = live(conn, ~p"/bases/#{base}")

      assert html =~ "Show Base"
    end
  end
end
