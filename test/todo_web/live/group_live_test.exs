defmodule TodoWeb.PostLiveTest do
  use TodoWeb.ConnCase

  import Phoenix.LiveViewTest

  import Todo.TaskListFixtures

  defp create_group_and_tasks(_) do
    group = group_fixture()
    %{group: group, group_task: group_task_fixture(%{group_id: group.id})}
  end

  describe "Index" do
    setup [:create_group_and_tasks]

    test "lists all groups", %{conn: conn, group: group} do
      {:ok, _index_live, html} = live(conn, ~p"/")
      assert html =~ "Things To Do"
      assert html =~ group.name
    end
  end

  describe "Show" do
    setup [:create_group_and_tasks]

    test "displays group tasks", %{conn: conn, group: group} do
      {:ok, _show_live, html} = live(conn, ~p"/#{group}")

      assert html =~ "Task Group"
      assert html =~ group.name
    end
  end
end
