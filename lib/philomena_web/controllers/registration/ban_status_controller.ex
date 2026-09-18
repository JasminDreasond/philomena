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

  def show(conn, _params) do
    grouped_actions = BanReasonHelper.actions_grouped_by_category()

    render(conn, "show.html",
      title: "Account Standing",
      grouped_actions: grouped_actions,
      bans: user_bans(conn.assigns.current_user)
    )
  end
end
