defmodule TodoWeb.GroupLive.Index do
  use TodoWeb, :live_view

  alias Todo.TaskList

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :groups, TaskList.get_list_groups())}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, :page_title, "Things To Do")}
  end

  defp count_completed_group_tasks(%{group_tasks: group_tasks}) do
    group_tasks |> Enum.count(& &1.is_completed)
  end

  defp count_completed_group_tasks(_), do: 0
end
