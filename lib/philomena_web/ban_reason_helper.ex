defmodule PhilomenaWeb.BanReasonHelper do
  @moduledoc """
  Helper module to determine the reason for a request in the context of granular bans.
  """
  alias Plug.Conn

  @doc false
  @spec get_current_request_reason(Conn.t()) :: atom() | nil
  def get_current_request_reason(conn) do
    controller_str = conn |> Phoenix.Controller.controller_module() |> inspect()
    action = Phoenix.Controller.action_name(conn)

    case {controller_str, action} do
      # Image Uploads
      {c, action_name}
      when c in ["PhilomenaWeb.ImageController", "PhilomenaWeb.Api.Json.ImageController"] and
             action_name in [:create, :new, :update] ->
        :ban_upload_image

      # Send PM
      {c, action_name}
      when c in [
             "PhilomenaWeb.ConversationController",
             "PhilomenaWeb.Conversation.MessageController"
           ] and
             action_name in [:create, :new] ->
        :ban_send_pm

      # Comments
      {c, action_name}
      when c in ["PhilomenaWeb.CommentController", "PhilomenaWeb.Image.CommentController"] and
             action_name in [:create, :edit, :update] ->
        :ban_comment_images

      # Forum Posts/Replies
      {c, action_name}
      when c in ["PhilomenaWeb.TopicController"] and
             action_name in [:create, :new, :update] ->
        :ban_post_forum

      {c, action_name}
      when c in ["PhilomenaWeb.PostController", "PhilomenaWeb.Topic.PostController"] and
             action_name in [:create, :new, :edit, :update] ->
        :ban_reply_forum

      # Filters
      {c, action_name}
      when c in [
             "PhilomenaWeb.Image.HideController",
             "PhilomenaWeb.Filter.HideController",
             "PhilomenaWeb.Filter.SpoilerController"
           ] and
             action_name in [:create, :delete] ->
        :ban_create_filters

      # Galleries
      {c, action_name}
      when c in [
             "PhilomenaWeb.GalleryController",
             "PhilomenaWeb.Gallery.OrderController",
             "PhilomenaWeb.Gallery.ImageController"
           ] and
             action_name in [:create, :new, :edit, :update] ->
        :ban_galleries

      # Commissions
      {c, action_name}
      when c in ["PhilomenaWeb.Profile.CommissionController"] and
             action_name in [:create, :new, :edit, :update] ->
        :ban_commissions

      # Voting (Upvote/Downvote)
      {c, action_name}
      when c in ["PhilomenaWeb.Image.VoteController"] and
             action_name in [:create] ->
        determine_vote_ban(conn)

      # Fav Image
      {c, action_name}
      when c in ["PhilomenaWeb.Image.FaveController"] and
             action_name in [:create] ->
        :ban_fav_image

      # Tag Management
      {c, action_name}
      when c in ["PhilomenaWeb.TagController", "PhilomenaWeb.Image.TagController"] and
             action_name in [:delete, :edit, :update] ->
        :ban_manage_tags

      # Source Management
      {c, action_name}
      when c in ["PhilomenaWeb.Image.SourceController"] and
             action_name in [:update] ->
        :ban_manage_sources

      _ ->
        nil
    end
  end

  defp determine_vote_ban(conn) do
    cond do
      is_upvote?(conn) -> :ban_upvote_image
      is_downvote?(conn) -> :ban_downvote_image
      true -> nil
    end
  end

  defp is_upvote?(conn) do
    conn.params["up"] in [true, "true"]
  end

  defp is_downvote?(conn) do
    conn.params["up"] in [false, "false"]
  end

  @available_actions [
    "ban_fav_image",
    "ban_manage_sources",
    "ban_upload_image",
    "ban_downvote_image",
    "ban_upvote_image",
    "ban_comment_images",
    "ban_post_forum",
    "ban_reply_forum",
    "ban_send_pm",
    "ban_api_key",
    "ban_create_filters",
    "ban_galleries",
    "ban_manage_tags",
    "ban_commissions"
  ]

  @doc false
  def available_actions do
    @available_actions
  end

  @doc false
  def any_granular_ban?(ban) do
    !Enum.empty?(Map.get(ban, :permitted_actions, []))
  end

  @doc false
  def has_action?(nil, _action), do: false

  @doc false
  def has_action?(ban, action) do
    # to_string/1 converte com segurança. Aceita tanto atoms quanto strings (:ban_fav_image ou "ban_fav_image")
    reason = to_string(action)

    ban
    |> Map.get(:permitted_actions, [])
    |> List.wrap()      # Garante que sempre será uma lista, mesmo se o valor for nil
    |> List.flatten()   # Achata qualquer nível de aninhamento (listas dentro de listas viram uma lista plana)
    |> Enum.any?(fn
      # Se for o struct PermittedAction (ou qualquer mapa/struct que tenha a chave :action)
      %{action: permitted_action} -> permitted_action == reason

      # Se a string da action estiver solta direto na lista, por algum motivo
      permitted_action when is_binary(permitted_action) -> permitted_action == reason

      # Se vier qualquer outra coisa que não faça sentido (nil, lista vazia, tuplas), ele só ignora e retorna false
      _ -> false
    end)
  end
end
