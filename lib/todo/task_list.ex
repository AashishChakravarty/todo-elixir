defmodule Todo.TaskList do
  @moduledoc """
  The TaskList context.
  """

  import Ecto.Query, warn: false
  alias Todo.Repo
  alias Ecto.Multi

  alias Todo.TaskList.Group
  alias Todo.TaskList.GroupTask

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    Repo.all(Group)
  end

  def get_list_groups do
    Repo.all(Group) |> Repo.preload(group_tasks: :dependent_group_task)
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id), do: Repo.get!(Group, id)

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{data: %Group{}}

  """
  def change_group(%Group{} = group, attrs \\ %{}) do
    Group.changeset(group, attrs)
  end

  @doc """
  Returns the list of group_tasks.

  ## Examples

      iex> list_group_tasks()
      [%GroupTask{}, ...]

  """
  def list_group_tasks do
    Repo.all(GroupTask)
  end

  @doc """
  Gets a single group_task.

  Raises `Ecto.NoResultsError` if the Group task does not exist.

  ## Examples

      iex> get_group_task!(123)
      %GroupTask{}

      iex> get_group_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group_task!(id), do: Repo.get!(GroupTask, id)

  @doc """
  Creates a group_task.

  ## Examples

      iex> create_group_task(%{field: value})
      {:ok, %GroupTask{}}

      iex> create_group_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group_task(attrs \\ %{}) do
    %GroupTask{}
    |> GroupTask.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group_task.

  ## Examples

      iex> update_group_task(group_task, %{field: new_value})
      {:ok, %GroupTask{}}

      iex> update_group_task(group_task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group_task(%GroupTask{} = group_task, attrs) do
    group_task
    |> GroupTask.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group_task.

  ## Examples

      iex> delete_group_task(group_task)
      {:ok, %GroupTask{}}

      iex> delete_group_task(group_task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group_task(%GroupTask{} = group_task) do
    Repo.delete(group_task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group_task changes.

  ## Examples

      iex> change_group_task(group_task)
      %Ecto.Changeset{data: %GroupTask{}}

  """
  def change_group_task(%GroupTask{} = group_task, attrs \\ %{}) do
    GroupTask.changeset(group_task, attrs)
  end

  def get_group(id), do: Repo.get(Group, id) |> Repo.preload(group_tasks: :dependent_group_task)

  def get_group_task_by_name(name) do
    Repo.get_by(GroupTask, name: name)
  end

  def update_group_task_is_completed_by_id(id, true) do
    get_group_task!(id)
    |> update_group_task(%{is_completed: true})
  end

  def update_group_task_is_completed_by_id(id, false) do
    Multi.new()
    |> Multi.run(:group_tasks, fn _repo, _ ->
      dependent_group_tasks_ids =
        from(group_task in GroupTask,
          where: group_task.id == ^id,
          join: dependent_group_tasks in assoc(group_task, :dependent_group_tasks),
          select: dependent_group_tasks.id
        )
        |> Repo.all()

      {:ok, [id | dependent_group_tasks_ids]}
    end)
    |> Multi.update_all(
      :destination_material_movement,
      fn %{group_tasks: group_tasks} ->
        from(group_task in GroupTask,
          where: group_task.id in ^group_tasks,
          update: [set: [is_completed: false]]
        )
      end,
      []
    )
    |> Repo.transaction()
  end
end
