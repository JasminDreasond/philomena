defmodule PhilomenaWeb.BanReasonHelper do
  @moduledoc """
  Helper module to determine the reason for a request in the context of granular bans.
  """

  @available_actions [
    "channel_manager",
    "show_user_donations",
    "create_donation",
    "dnp_entry",
    "dnp_entry_transition",
    "badge_manager",
    "award_manager",
    "fingerprint_ban_manager",
    "subnet_ban_manager",
    "user_ban_manager",
    "registration",
    "delete_deactivation",
    "edit_profile_description",
    "edit_profile_avatar",
    "delete_profile_avatar",
    "edit_profile_name",
    "edit_user",
    "user_activation_manager",
    "delete_user_api_key",
    "delete_user_avatar",
    "delete_user_downvotes",
    "new_user_erase",
    "user_force_filter",
    "create_user_unlock",
    "user_verification_manager",
    "delete_user_votes",
    "create_user_wipe",
    "profile_scratchpad_manager",
    "erase_source_change",
    "duplicate_report",
    "duplicate_report_accept",
    "duplicate_report_accept_reverse",
    "duplicate_report_accept_claim",
    "delete_duplicate_report_claim",
    "duplicate_report_reject",
    "advert",
    "polls",
    "report",
    "poll_votes",
    "create_artist_link",
    "new_artist_link",
    "edit_artist_link",
    "update_artist_link",
    "create_artist_link_verification",
    "create_artist_link_reject",
    "create_artist_link_contact",
    "image_comment",
    "image_comment_approve",
    "image_comment_delete",
    "image_comment_hide",
    "create_conversation",
    "create_message",
    "manage_commissions",
    "manage_filters",
    "forum_manager",
    "topic_manager",
    "post_manager",
    "mod_notes",
    "static_pages",
    "site_notices",
    "rule_manager",
    "mod_notes",
    "gallery_manager",
    "tag_manager",
    "image_interaction",
    "comment_changeset_for",
    "image_changeset",
    "upload_image",
    "image_aprove",
    "image_feature",
    "image_destroy",
    "image_comment_lock",
    "image_description_lock",
    "image_tag_lock",
    "load_hidable_image",
    "image_repair",
    "image_hide",
    "delete_user_image_vote",
    "delete_image_hash",
    "update_image_scratchpad",
    "delete_image_source_history",
    "update_image_file",
    "update_image_description",
    "update_image_sources",
    "update_image_locked_tags",
    "update_image_tags",
    "update_image_uploader",
    "update_image_anonymous",
    "image_hide",
    "image_user_hide",
    "image_fav",
    "image_vote_manager",
    "image_add_upvote",
    "image_add_downvote"
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
    # to_string/1 converts safely. Accepts both atoms and strings (:image_fav or "image_fav")
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
