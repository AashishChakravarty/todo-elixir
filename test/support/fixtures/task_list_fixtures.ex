defmodule Todo.TaskListFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.TaskList` context.
  """

  @doc """
  Generate a group.
  """
  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Todo.TaskList.create_group()

    group
  end

  @doc """
  Generate a group_task.
  """
  def group_task_fixture(attrs \\ %{}) do
    {:ok, group_task} =
      attrs
      |> Enum.into(%{
        dependent_group_task_id: nil,
        description: "some description",
        group_id: 1,
        is_completed: false,
        name: "some name"
      })
      |> Todo.TaskList.create_group_task()

    group_task
  end
end
