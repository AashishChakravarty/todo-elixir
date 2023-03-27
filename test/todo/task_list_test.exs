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

    test "list_group_tasks/0 returns all group_tasks" do
      group_task = group_task_fixture()
      assert TaskList.list_group_tasks() == [group_task]
    end

    test "get_group_task!/1 returns the group_task with given id" do
      group_task = group_task_fixture()
      assert TaskList.get_group_task!(group_task.id) == group_task
    end

    test "create_group_task/1 with valid data creates a group_task" do
      valid_attrs = %{
        dependent_group_task_id: 42,
        description: "some description",
        group_id: 42,
        is_completed: true,
        name: "some name"
      }

      assert {:ok, %GroupTask{} = group_task} = TaskList.create_group_task(valid_attrs)
      assert group_task.dependent_group_task_id == 42
      assert group_task.description == "some description"
      assert group_task.group_id == 42
      assert group_task.is_completed == true
      assert group_task.name == "some name"
    end

    test "create_group_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaskList.create_group_task(@invalid_attrs)
    end

    test "update_group_task/2 with valid data updates the group_task" do
      group_task = group_task_fixture()

      update_attrs = %{
        dependent_group_task_id: 43,
        description: "some updated description",
        group_id: 43,
        is_completed: false,
        name: "some updated name"
      }

      assert {:ok, %GroupTask{} = group_task} =
               TaskList.update_group_task(group_task, update_attrs)

      assert group_task.dependent_group_task_id == 43
      assert group_task.description == "some updated description"
      assert group_task.group_id == 43
      assert group_task.is_completed == false
      assert group_task.name == "some updated name"
    end

    test "update_group_task/2 with invalid data returns error changeset" do
      group_task = group_task_fixture()
      assert {:error, %Ecto.Changeset{}} = TaskList.update_group_task(group_task, @invalid_attrs)
      assert group_task == TaskList.get_group_task!(group_task.id)
    end

    test "delete_group_task/1 deletes the group_task" do
      group_task = group_task_fixture()
      assert {:ok, %GroupTask{}} = TaskList.delete_group_task(group_task)
      assert_raise Ecto.NoResultsError, fn -> TaskList.get_group_task!(group_task.id) end
    end

    test "change_group_task/1 returns a group_task changeset" do
      group_task = group_task_fixture()
      assert %Ecto.Changeset{} = TaskList.change_group_task(group_task)
    end
  end
end
