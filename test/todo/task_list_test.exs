defmodule Todo.TaskListTest do
  use Todo.DataCase

  alias Todo.TaskList

  describe "groups" do
    alias Todo.TaskList.Group

    import Todo.TaskListFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_groups/0 returns all groups" do
      group = group_fixture()
      assert TaskList.list_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert TaskList.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Group{} = group} = TaskList.create_group(valid_attrs)
      assert group.description == "some description"
      assert group.name == "some name"
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaskList.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()

      update_attrs = %{
        description: "some updated description",
        name: "some updated name"
      }

      assert {:ok, %Group{} = group} = TaskList.update_group(group, update_attrs)
      assert group.description == "some updated description"
      assert group.name == "some updated name"
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = TaskList.update_group(group, @invalid_attrs)
      assert group == TaskList.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = TaskList.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> TaskList.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = TaskList.change_group(group)
    end
  end

  describe "group_tasks" do
    alias Todo.TaskList.GroupTask

    import Todo.TaskListFixtures

    @invalid_attrs %{
      dependent_group_task_id: nil,
      description: nil,
      group_id: nil,
      is_completed: nil,
      name: nil
    }

    setup _ do
      group = group_fixture()
      %{group: group, group_task: group_task_fixture(%{group_id: group.id})}
    end

    test "list_group_tasks/0 returns all group_tasks", %{group_task: group_task} do
      assert TaskList.list_group_tasks() == [group_task]
    end

    test "get_group_task!/1 returns the group_task with given id", %{group_task: group_task} do
      assert TaskList.get_group_task!(group_task.id) == group_task
    end

    test "create_group_task/1 with valid data creates a group_task", %{
      group: group,
      group_task: group_task
    } do
      valid_attrs = %{
        dependent_group_task_id: group_task.id,
        description: "test some description",
        group_id: group.id,
        is_completed: false,
        name: "test some name"
      }

      assert {:ok, %GroupTask{} = created_group_task} = TaskList.create_group_task(valid_attrs)
      assert created_group_task.dependent_group_task_id == group_task.id
      assert created_group_task.description == "test some description"
      assert created_group_task.group_id == group.id
      assert created_group_task.is_completed == false
      assert created_group_task.name == "test some name"
    end

    test "create_group_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaskList.create_group_task(@invalid_attrs)
    end

    test "update_group_task/2 with valid data updates the group_task", %{group_task: group_task} do
      second_group = group_fixture()
      second_group_task = group_task_fixture(%{group_id: second_group.id})

      update_attrs = %{
        dependent_group_task_id: second_group_task.id,
        description: "some updated description",
        group_id: second_group.id,
        is_completed: true,
        name: "some updated name"
      }

      assert {:ok, %GroupTask{} = updated_group_task} =
               TaskList.update_group_task(group_task, update_attrs)

      assert updated_group_task.dependent_group_task_id == second_group_task.id
      assert updated_group_task.description == "some updated description"
      assert updated_group_task.group_id == second_group.id
      assert updated_group_task.is_completed == true
      assert updated_group_task.name == "some updated name"
    end

    test "update_group_task/2 with invalid data returns error changeset", %{
      group_task: group_task
    } do
      assert {:error, %Ecto.Changeset{}} = TaskList.update_group_task(group_task, @invalid_attrs)
      assert group_task == TaskList.get_group_task!(group_task.id)
    end

    test "delete_group_task/1 deletes the group_task", %{group_task: group_task} do
      assert {:ok, %GroupTask{}} = TaskList.delete_group_task(group_task)
      assert_raise Ecto.NoResultsError, fn -> TaskList.get_group_task!(group_task.id) end
    end

    test "change_group_task/1 returns a group_task changeset", %{group_task: group_task} do
      assert %Ecto.Changeset{} = TaskList.change_group_task(group_task)
    end
  end
end
