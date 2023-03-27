defmodule Todo.Repo.Migrations.CreateGroupTasks do
  use Ecto.Migration

  def change do
    create table(:group_tasks) do
      add(:name, :string)
      add(:description, :string)
      add(:is_completed, :boolean, default: false, null: false)
      add(:group_id, references(:groups))
      add(:dependent_group_task_id, references(:group_tasks))

      timestamps()
    end
  end
end
