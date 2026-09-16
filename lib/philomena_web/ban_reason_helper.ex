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
        :upload_image

      # Send PM
      {c, action_name}
      when c in [
             "PhilomenaWeb.ConversationController",
             "PhilomenaWeb.Conversation.MessageController"
           ] and
             action_name in [:create, :new] ->
        :send_pm

      # Comments
      {c, action_name}
      when c in ["PhilomenaWeb.CommentController", "PhilomenaWeb.Image.CommentController"] and
             action_name in [:create, :edit, :update] ->
        :comment_images

      # Forum Posts/Replies
      {c, action_name}
      when c in ["PhilomenaWeb.TopicController"] and
             action_name in [:create, :new, :update] ->
        :post_forum

      {c, action_name}
      when c in ["PhilomenaWeb.PostController", "PhilomenaWeb.Topic.PostController"] and
             action_name in [:create, :new, :edit, :update] ->
        :reply_forum

      # Filters
      {c, action_name}
      when c in [
             "PhilomenaWeb.Image.HideController",
             "PhilomenaWeb.Filter.HideController",
             "PhilomenaWeb.Filter.SpoilerController"
           ] and
             action_name in [:create, :delete] ->
        :manage_filters

      # Galleries
      {c, action_name}
      when c in [
             "PhilomenaWeb.GalleryController",
             "PhilomenaWeb.Gallery.OrderController",
             "PhilomenaWeb.Gallery.ImageController"
           ] and
             action_name in [:create, :new, :edit, :update] ->
        :manage_galleries

      # Commissions
      {c, action_name}
      when c in ["PhilomenaWeb.Profile.CommissionController"] and
             action_name in [:create, :new, :edit, :update] ->
        :manage_commissions

      # Voting (Upvote/Downvote)
      {c, action_name}
      when c in ["PhilomenaWeb.Image.VoteController"] and
             action_name in [:create] ->
        determine_vote_ban(conn)

      # Fav Image
      {c, action_name}
      when c in ["PhilomenaWeb.Image.FaveController"] and
             action_name in [:create] ->
        :fav_image

      # Tag Management
      {c, action_name}
      when c in ["PhilomenaWeb.TagController", "PhilomenaWeb.Image.TagController"] and
             action_name in [:delete, :edit, :update] ->
        :manage_tags

      # Source Management
      {c, action_name}
      when c in ["PhilomenaWeb.Image.SourceController"] and
             action_name in [:update] ->
        :manage_sources

      _ ->
        nil
    end
  end

  defp determine_vote_ban(conn) do
    cond do
      is_upvote?(conn) -> :upvote_image
      is_downvote?(conn) -> :downvote_image
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
    "fav_image",
    "manage_sources",
    "upload_image",
    "downvote_image",
    "upvote_image",
    "comment_images",
    "post_forum",
    "reply_forum",
    "send_pm",
    "api_key",
    "manage_filters",
    "manage_galleries",
    "manage_tags",
    "manage_commissions"
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
    # to_string/1 converts safely. Accepts both atoms and strings (:fav_image or "fav_image")
    reason = to_string(action)

    ban
    |> Map.get(:permitted_actions, [])
    # Ensures it is always a list, even if the value is nil
    |> List.wrap()
    # Flattens any level of nesting (lists within lists become a flat list)
    |> List.flatten()
    |> Enum.any?(fn
      # If it is the PermittedAction struct (or any map/struct that has the :action key)
      %{action: permitted_action} -> permitted_action == reason
      # If the action string is loose directly in the list, for some reason
      permitted_action when is_binary(permitted_action) -> permitted_action == reason
      # If anything else that doesn't make sense comes in (nil, empty list, tuples), it is ignored and returns false
      _ -> false
    end)
  end
end
