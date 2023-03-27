defmodule TodoWeb.GroupLive.Show do
  use TodoWeb, :live_view

  alias Todo.TaskList

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Task Group")
     |> assign(:group, TaskList.get_group(id))}
  end

  @impl true
  def handle_event("toggle_task_completed", %{"id" => id} = params, socket) do
    is_completed = Map.has_key?(params, "value")

    TaskList.update_group_task_is_completed_by_id(id, is_completed)

    socket =
      socket
      |> assign(:group, TaskList.get_group(socket.assigns.group.id))

    {:noreply, socket}
  end

  defp get_group_tasks(%{group_tasks: group_tasks}),
    do: group_tasks |> Enum.sort_by(& &1.id) |> Enum.with_index()

  defp get_group_tasks(_), do: []
end
