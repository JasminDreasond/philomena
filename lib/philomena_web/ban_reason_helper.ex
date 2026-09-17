defmodule PhilomenaWeb.BanReasonHelper do
  @moduledoc """
  Helper module to determine the reason for a request in the context of granular bans.
  """

  @available_actions %{
    "channel_manager" => %{title: "channel_manager", description: "", category: "", default_value: false},
    "show_user_donations" => %{title: "show_user_donations", description: "", category: "", default_value: false},
    "create_donation" => %{title: "create_donation", description: "", category: "", default_value: false},
    "dnp_entry" => %{title: "dnp_entry", description: "", category: "", default_value: false},
    "dnp_entry_transition" => %{title: "dnp_entry_transition", description: "", category: "", default_value: false},
    "badge_manager" => %{title: "badge_manager", description: "", category: "", default_value: false},
    "award_manager" => %{title: "award_manager", description: "", category: "", default_value: false},
    "fingerprint_ban_manager" => %{title: "fingerprint_ban_manager", description: "", category: "", default_value: false},
    "subnet_ban_manager" => %{title: "subnet_ban_manager", description: "", category: "", default_value: false},
    "user_ban_manager" => %{title: "user_ban_manager", description: "", category: "", default_value: false},
    "registration" => %{title: "registration", description: "", category: "", default_value: false},
    "delete_deactivation" => %{title: "delete_deactivation", description: "", category: "", default_value: false},
    "edit_profile_description" => %{title: "edit_profile_description", description: "", category: "", default_value: false},
    "edit_profile_avatar" => %{title: "edit_profile_avatar", description: "", category: "", default_value: false},
    "delete_profile_avatar" => %{title: "delete_profile_avatar", description: "", category: "", default_value: false},
    "edit_profile_name" => %{title: "edit_profile_name", description: "", category: "", default_value: false},
    "edit_user" => %{title: "edit_user", description: "", category: "", default_value: false},
    "user_activation_manager" => %{title: "user_activation_manager", description: "", category: "", default_value: false},
    "delete_user_api_key" => %{title: "delete_user_api_key", description: "", category: "", default_value: false},
    "delete_user_avatar" => %{title: "delete_user_avatar", description: "", category: "", default_value: false},
    "delete_user_downvotes" => %{title: "delete_user_downvotes", description: "", category: "", default_value: false},
    "new_user_erase" => %{title: "new_user_erase", description: "", category: "", default_value: false},
    "user_force_filter" => %{title: "user_force_filter", description: "", category: "", default_value: false},
    "create_user_unlock" => %{title: "create_user_unlock", description: "", category: "", default_value: false},
    "user_verification_manager" => %{title: "user_verification_manager", description: "", category: "", default_value: false},
    "delete_user_votes" => %{title: "delete_user_votes", description: "", category: "", default_value: false},
    "create_user_wipe" => %{title: "create_user_wipe", description: "", category: "", default_value: false},
    "profile_scratchpad_manager" => %{title: "profile_scratchpad_manager", description: "", category: "", default_value: false},
    "erase_source_change" => %{title: "erase_source_change", description: "", category: "", default_value: false},
    "duplicate_report" => %{title: "duplicate_report", description: "", category: "", default_value: false},
    "duplicate_report_accept" => %{title: "duplicate_report_accept", description: "", category: "", default_value: false},
    "duplicate_report_accept_reverse" => %{title: "duplicate_report_accept_reverse", description: "", category: "", default_value: false},
    "duplicate_report_accept_claim" => %{title: "duplicate_report_accept_claim", description: "", category: "", default_value: false},
    "delete_duplicate_report_claim" => %{title: "delete_duplicate_report_claim", description: "", category: "", default_value: false},
    "duplicate_report_reject" => %{title: "duplicate_report_reject", description: "", category: "", default_value: false},
    "advert" => %{title: "advert", description: "", category: "", default_value: false},
    "polls" => %{title: "polls", description: "", category: "", default_value: false},
    "report" => %{title: "report", description: "", category: "", default_value: false},
    "poll_votes" => %{title: "poll_votes", description: "", category: "", default_value: false},
    "create_artist_link" => %{title: "create_artist_link", description: "", category: "", default_value: false},
    "new_artist_link" => %{title: "new_artist_link", description: "", category: "", default_value: false},
    "edit_artist_link" => %{title: "edit_artist_link", description: "", category: "", default_value: false},
    "update_artist_link" => %{title: "update_artist_link", description: "", category: "", default_value: false},
    "create_artist_link_verification" => %{title: "create_artist_link_verification", description: "", category: "", default_value: false},
    "create_artist_link_reject" => %{title: "create_artist_link_reject", description: "", category: "", default_value: false},
    "create_artist_link_contact" => %{title: "create_artist_link_contact", description: "", category: "", default_value: false},
    "image_comment" => %{title: "image_comment", description: "", category: "", default_value: false},
    "image_comment_approve" => %{title: "image_comment_approve", description: "", category: "", default_value: false},
    "image_comment_delete" => %{title: "image_comment_delete", description: "", category: "", default_value: false},
    "image_comment_hide" => %{title: "image_comment_hide", description: "", category: "", default_value: false},
    "create_conversation" => %{title: "create_conversation", description: "", category: "", default_value: false},
    "create_message" => %{title: "create_message", description: "", category: "", default_value: false},
    "manage_commissions" => %{title: "manage_commissions", description: "", category: "", default_value: false},
    "manage_filters" => %{title: "manage_filters", description: "", category: "", default_value: false},
    "forum_manager" => %{title: "forum_manager", description: "", category: "", default_value: false},
    "topic_manager" => %{title: "topic_manager", description: "", category: "", default_value: false},
    "post_manager" => %{title: "post_manager", description: "", category: "", default_value: false},
    "mod_notes" => %{title: "mod_notes", description: "", category: "", default_value: false},
    "static_pages" => %{title: "static_pages", description: "", category: "", default_value: false},
    "site_notices" => %{title: "site_notices", description: "", category: "", default_value: false},
    "rule_manager" => %{title: "rule_manager", description: "", category: "", default_value: false},
    "gallery_manager" => %{title: "gallery_manager", description: "", category: "", default_value: false},
    "tag_manager" => %{title: "tag_manager", description: "", category: "", default_value: false},
    "image_interaction" => %{title: "image_interaction", description: "", category: "", default_value: false},
    "comment_changeset_for" => %{title: "comment_changeset_for", description: "", category: "", default_value: false},
    "image_changeset" => %{title: "image_changeset", description: "", category: "", default_value: false},
    "upload_image" => %{title: "upload_image", description: "", category: "", default_value: false},
    "image_aprove" => %{title: "image_aprove", description: "", category: "", default_value: false},
    "image_feature" => %{title: "image_feature", description: "", category: "", default_value: false},
    "image_destroy" => %{title: "image_destroy", description: "", category: "", default_value: false},
    "image_comment_lock" => %{title: "image_comment_lock", description: "", category: "", default_value: false},
    "image_description_lock" => %{title: "image_description_lock", description: "", category: "", default_value: false},
    "image_tag_lock" => %{title: "image_tag_lock", description: "", category: "", default_value: false},
    "load_hidable_image" => %{title: "load_hidable_image", description: "", category: "", default_value: false},
    "image_repair" => %{title: "image_repair", description: "", category: "", default_value: false},
    "image_hide" => %{title: "image_hide", description: "", category: "", default_value: false},
    "delete_user_image_vote" => %{title: "delete_user_image_vote", description: "", category: "", default_value: false},
    "delete_image_hash" => %{title: "delete_image_hash", description: "", category: "", default_value: false},
    "update_image_scratchpad" => %{title: "update_image_scratchpad", description: "", category: "", default_value: false},
    "delete_image_source_history" => %{title: "delete_image_source_history", description: "", category: "", default_value: false},
    "update_image_file" => %{title: "update_image_file", description: "", category: "", default_value: false},
    "update_image_description" => %{title: "update_image_description", description: "", category: "", default_value: false},
    "update_image_sources" => %{title: "update_image_sources", description: "", category: "", default_value: false},
    "update_image_locked_tags" => %{title: "update_image_locked_tags", description: "", category: "", default_value: false},
    "update_image_tags" => %{title: "update_image_tags", description: "", category: "", default_value: false},
    "update_image_uploader" => %{title: "update_image_uploader", description: "", category: "", default_value: false},
    "update_image_anonymous" => %{title: "update_image_anonymous", description: "", category: "", default_value: false},
    "image_user_hide" => %{title: "image_user_hide", description: "", category: "", default_value: false},
    "image_fav" => %{title: "image_fav", description: "", category: "", default_value: false},
    "image_vote_manager" => %{title: "image_vote_manager", description: "", category: "", default_value: false},
    "image_add_upvote" => %{title: "image_add_upvote", description: "", category: "", default_value: false},
    "image_add_downvote" => %{title: "image_add_downvote", description: "", category: "", default_value: false}
  }

  @doc """
  Returns the metadata for a specific action key.
  """
  def available_action(action_key) do
    Map.get(@available_actions, to_string(action_key))
  end

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
