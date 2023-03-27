defmodule Todo.TaskList.GroupTask do
  @moduledoc """
  GroupTask Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required ~W(name group_id)a
  @optional ~W(description is_completed dependent_group_task_id)a
  @attrs @required ++ @optional

  schema "group_tasks" do
    field(:name, :string)
    field(:description, :string)
    field(:is_completed, :boolean, default: false)

    belongs_to(:group, Todo.TaskList.Group)
    belongs_to(:dependent_group_task, Todo.TaskList.GroupTask)

    has_many(:dependent_group_tasks, Todo.TaskList.GroupTask,
      foreign_key: :dependent_group_task_id
    )

    timestamps()
  end

  @doc false
  def changeset(group_task, attrs) do
    group_task
    |> cast(attrs, @attrs)
    |> validate_required(@required)
  end
end
