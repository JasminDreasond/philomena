defmodule PhilomenaWeb.FilterBannedUsersPlug do
  @moduledoc """
  This plug redirects back if there is a ban for the current user.
  CurrentBanPlug must also be plugged, and this must come after it.

  ## Example

      plug PhilomenaWeb.FilterBannedUsersPlug
  """
  alias Phoenix.Controller
  alias Plug.Conn

  @doc false
  @spec init(any()) :: any()
  def init(opts), do: opts

  @doc false
  @spec call(Conn.t(), any()) :: Conn.t()
  def call(conn, _opts) do
    redirect_url = conn.assigns.referrer

    conn.assigns.current_ban
    |> maybe_halt(conn, redirect_url)
    |> maybe_halt_no_fingerprint()
  end

  defp apply_ban_protocol(conn, redirect_url) do
    conn
    |> Controller.put_flash(:error, "You are currently banned.")
    |> Controller.redirect(external: redirect_url)
    |> Conn.halt()
  end

  defp maybe_halt(nil, conn, _redirect_url), do: conn

  defp maybe_halt(bans, conn, redirect_url) when is_list(bans) do
    should_halt =
      Enum.any?(bans, fn current_ban ->
        not PhilomenaWeb.BanReasonHelper.any_granular_ban?(current_ban) or
          matches_granular_ban?(current_ban, conn)
      end)

    if should_halt, do: apply_ban_protocol(conn, redirect_url), else: conn
  end

  defp maybe_halt(current_ban, conn, redirect_url) do
    should_halt =
      not PhilomenaWeb.BanReasonHelper.any_granular_ban?(current_ban) or
        matches_granular_ban?(current_ban, conn)

    if should_halt, do: apply_ban_protocol(conn, redirect_url), else: conn
  end

  defp matches_granular_ban?(current_ban, conn) do
    case PhilomenaWeb.BanReasonHelper.get_current_request_reason(conn) do
      nil -> false
      reason -> Map.get(current_ban, reason) == true
    end
  end

  defp maybe_halt_no_fingerprint(%{halted: true} = conn), do: conn
  defp maybe_halt_no_fingerprint(%{method: "GET"} = conn), do: conn

  defp maybe_halt_no_fingerprint(conn) do
    case conn.assigns.fingerprint do
      nil ->
        PhilomenaWeb.NotAuthorizedPlug.call(conn)

      _other ->
        conn
    end
  end
end
