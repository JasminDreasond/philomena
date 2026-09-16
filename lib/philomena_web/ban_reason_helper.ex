defmodule PhilomenaWeb.BanReasonHelper do
  @moduledoc """
  Helper module to determine the reason for a request in the context of granular bans.
  """
  alias Plug.Conn

  @doc false
  @spec get_current_request_reason(Conn.t()) :: atom() | nil
  def get_current_request_reason(conn) do
    controller = Phoenix.Controller.controller_module(conn)
    action = Phoenix.Controller.action_name(conn)

    case {controller, action} do
      # Image Uploads
      {c, action_name}
      when c in [PhilomenaWeb.ImageController, PhilomenaWeb.Api.Json.ImageController] and
             action_name in [:create, :new] ->
        :ban_upload_image

      # Send PM
      {c, action_name}
      when c in [PhilomenaWeb.ConversationController, PhilomenaWeb.Conversation.MessageController] and
             action_name in [:create, :new] ->
        :ban_send_pm

      # Comments
      {c, :create}
      when c in [PhilomenaWeb.CommentController] ->
        :ban_comment_images

      # Forum Posts/Replies
      {c, action_name} when c in [PhilomenaWeb.TopicController] and
             action_name in [:create, :new, :update] ->
        :ban_post_forum

      {c, action_name} when c in [PhilomenaWeb.PostController] and
             action_name in [:create, :new, :update] ->
        :ban_reply_forum

      # Galleries
      {c, action_name}
      when c in [PhilomenaWeb.GalleryController] and
             action_name in [:create, :new, :edit, :update] ->
        :ban_galleries

      # Commissions
      {c, action_name}
      when c in [PhilomenaWeb.Profile.CommissionController] and
             action_name in [:create, :new, :edit, :update] ->
        :ban_commissions

      # Voting (Upvote/Downvote)
      {c, action_name}
      when c in [PhilomenaWeb.Image.VoteController, PhilomenaWeb.Image.FaveController] and action_name in [:create, :delete] ->
        determine_vote_ban(conn)

      # Tag Management
      {c, action_name} when c in [PhilomenaWeb.TagController, PhilomenaWeb.Image.TagController] and action_name in [:delete, :edit, :update] ->
        :ban_manage_tags

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
    # In VoteController.create, it uses params["up"]
    # In FaveController.create, it seems to be an upvote by default (it calls create_fave and then create_vote with true)
    conn.params["up"] == true or conn.params["up"] == "true" or
      (conn.params["action"] == "create" and conn.params["controller"] =~ ~r/FaveController/)
  end

  defp is_downvote?(conn) do
    # If it's not an upvote, we assume downvote for these controllers if they are in the list
    not is_upvote?(conn) and
      (conn.params["action"] == "create" or conn.params["action"] == "delete")
  end

  @doc false
  def any_granular_ban?(ban) do
    [
      :ban_upload_image,
      :ban_downvote_image,
      :ban_upvote_image,
      :ban_comment_images,
      :ban_post_forum,
      :ban_reply_forum,
      :ban_send_pm,
      :ban_api_key,
      :ban_create_filters,
      :ban_galleries,
      :ban_manage_tags,
      :ban_commissions
    ]
    |> Enum.any?(fn field -> Map.get(ban, field) == true end)
  end
end
