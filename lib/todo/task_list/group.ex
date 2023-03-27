defmodule Todo.TaskList.Group do
  use Ecto.Schema
  import Ecto.Changeset

  @required ~W(name)a
  @optional ~W(description)a
  @attrs @required ++ @optional

  schema "groups" do
    field(:description, :string)
    field(:name, :string)

    has_many(:group_tasks, Todo.TaskList.GroupTask)

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, @attrs)
    |> validate_required(@required)
  end
end
