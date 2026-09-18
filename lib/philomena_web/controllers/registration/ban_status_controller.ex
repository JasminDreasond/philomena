defmodule PhilomenaWeb.Registration.BanStatusController do
  use PhilomenaWeb, :controller

  import Ecto.Query
  alias Philomena.Repo
  alias PhilomenaWeb.BanReasonHelper
  alias Philomena.Bans.User

  defp user_bans(user) do
    User
    |> where(user_id: ^user.id)
    |> order_by(desc: :created_at)
    |> Repo.all()
  end

  # Role visibility hierarchy rules
  defp can_view_role?(user_role, item_role) do
    u_role = to_string(user_role)
    i_role = to_string(item_role)

    case {u_role, i_role} do
      {"admin", _} -> true
      {"moderator", "admin"} -> false
      {"moderator", _} -> true
      {"assistant", "admin"} -> false
      {"assistant", "moderator"} -> false
      {"assistant", _} -> true
      # The remaining roles can only see their own level
      {same, same} -> true
      _ -> false
    end
  end

  def show(conn, _params) do
    user_role = conn.assigns.current_user.role

    # Filter actions based on the user's role before sending them to the template
    grouped_actions =
      BanReasonHelper.actions_grouped_by_category()
      |> Enum.map(fn {category, actions} ->
        filtered_actions =
          Enum.filter(actions, fn {_action_key, metadata} ->
            can_view_role?(user_role, metadata.role)
          end)

        {category, filtered_actions}
      end)

    render(conn, "show.html",
      title: "Account Standing",
      grouped_actions: grouped_actions,
      bans: user_bans(conn.assigns.current_user)
    )
  end
end
