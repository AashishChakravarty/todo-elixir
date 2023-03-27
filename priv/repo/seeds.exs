# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Todo.Repo.insert!(%Todo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Todo.TaskList

groups = [
  %{
    name: "Task Group 1",
    description: "Task Group 1",
    group_tasks: [
      %{
        name: "Group 1 - Task 1",
        description: "Group 1 - Task 1"
      },
      %{
        name: "Group 1 - Task 2",
        description: "Group 1 - Task 2",
        dependent_task_name: "Group 1 - Task 1"
      },
      %{
        name: "Group 1 - Task 3",
        description: "Group 1 - Task 3"
      }
    ]
  },
  %{
    name: "Task Group 2",
    description: "Task Group 2",
    group_tasks: [
      %{
        name: "Group 2 - Task 1",
        description: "Group 2 - Task 1"
      },
      %{
        name: "Group 2 - Task 2",
        description: "Group 2 - Task 2",
        dependent_task_name: "Group 2 - Task 1"
      },
      %{
        name: "Group 2 - Task 3",
        description: "Group 2 - Task 3"
      },
      %{
        name: "Group 2 - Task 4",
        description: "Group 2 - Task 4",
        dependent_task_name: "Group 2 - Task 2"
      },
      %{
        name: "Group 2 - Task 5",
        description: "Group 2 - Task 5",
        dependent_task_name: "Group 2 - Task 2"
      }
    ]
  },
  %{
    name: "Task Group 3",
    description: "Task Group 3",
    group_tasks: [
      %{
        name: "Group 3 - Task 1",
        description: "Group 3 - Task 1"
      },
      %{
        name: "Group 3 - Task 2",
        description: "Group 3 - Task 2"
      }
    ]
  },
  %{
    name: "Task Group 4",
    description: "Task Group 4",
    group_tasks: [
      %{
        name: "Group 4 - Task 1",
        description: "Group 4 - Task 1"
      },
      %{
        name: "Group 4 - Task 2",
        description: "Group 4 - Task 2",
        dependent_task_name: "Group 4 - Task 1"
      },
      %{
        name: "Group 4 - Task 3",
        description: "Group 4 - Task 3",
        dependent_task_name: "Group 4 - Task 2"
      },
      %{
        name: "Group 4 - Task 4",
        description: "Group 4 - Task 4",
        dependent_task_name: "Group 4 - Task 3"
      },
      %{
        name: "Group 4 - Task 5",
        description: "Group 4 - Task 5",
        dependent_task_name: "Group 4 - Task 4"
      }
    ]
  },
  %{
    name: "Task Group 5",
    description: "Task Group 5",
    group_tasks: [
      %{
        name: "Group 5 - Task 1",
        description: "Group 5 - Task 1"
      },
      %{
        name: "Group 5 - Task 2",
        description: "Group 5 - Task 2",
        dependent_task_name: "Group 5 - Task 1"
      },
      %{
        name: "Group 5 - Task 3",
        description: "Group 5 - Task 3",
        dependent_task_name: "Group 5 - Task 1"
      }
    ]
  }
]

Enum.each(groups, fn group ->
  {:ok, group_result} = TaskList.create_group(group)

  Enum.each(group.group_tasks, fn group_task ->
    dependent_id =
      if Map.has_key?(group_task, :dependent_task_name) do
        TaskList.get_group_task_by_name(group_task.dependent_task_name).id
      end

    group_task
    |> Map.merge(%{
      group_id: group_result.id,
      dependent_group_task_id: dependent_id
    })
    |> TaskList.create_group_task()
  end)
end)
