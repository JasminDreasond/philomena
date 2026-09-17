defmodule PhilomenaWeb.BanReasonHelper do
  @moduledoc """
  Helper module to determine the reason for a request in the context of granular bans.
  """

  @available_actions %{
    "channel_manager" => %{
      title: "Channel Manager",
      description: "",
      category: "System",
      default_value: false
    },
    "show_user_donations" => %{
      title: "Show User Donations",
      description: "",
      category: "Finance",
      default_value: false
    },
    "create_donation" => %{
      title: "Create Donation",
      description: "",
      category: "Finance",
      default_value: false
    },
    "dnp_entry" => %{
      title: "DNP Entry",
      description: "",
      category: "System",
      default_value: false
    },
    "dnp_entry_transition" => %{
      title: "DNP Entry Transition",
      description: "",
      category: "System",
      default_value: false
    },
    "badge_manager" => %{
      title: "Badge Manager",
      description: "",
      category: "Moderation",
      default_value: false
    },
    "award_manager" => %{
      title: "Award Manager",
      description: "",
      category: "Moderation",
      default_value: false
    },
    "fingerprint_ban_manager" => %{
      title: "Fingerprint Ban Manager",
      description: "",
      category: "Moderation",
      default_value: false
    },
    "subnet_ban_manager" => %{
      title: "Subnet Ban Manager",
      description: "",
      category: "Moderation",
      default_value: false
    },
    "user_ban_manager" => %{
      title: "User Ban Manager",
      description: "",
      category: "Moderation",
      default_value: false
    },
    "registration" => %{
      title: "Registration",
      description: "",
      category: "User Management",
      default_value: false
    },
    "delete_deactivation" => %{
      title: "Delete Deactivation",
      description: "",
      category: "User Management",
      default_value: false
    },
    "edit_profile_description" => %{
      title: "Edit Profile Description",
      description: "",
      category: "User Management",
      default_value: false
    },
    "edit_profile_avatar" => %{
      title: "Edit Profile Avatar",
      description: "",
      category: "User Management",
      default_value: false
    },
    "delete_profile_avatar" => %{
      title: "Delete Profile Avatar",
      description: "",
      category: "User Management",
      default_value: false
    },
    "edit_profile_name" => %{
      title: "Edit Profile Name",
      description: "",
      category: "User Management",
      default_value: false
    },
    "edit_user" => %{
      title: "Edit User",
      description: "",
      category: "User Management",
      default_value: false
    },
    "user_activation_manager" => %{
      title: "User Activation Manager",
      description: "",
      category: "User Management",
      default_value: false
    },
    "delete_user_api_key" => %{
      title: "Delete User API Key",
      description: "",
      category: "User Management",
      default_value: false
    },
    "delete_user_avatar" => %{
      title: "Delete User Avatar",
      description: "",
      category: "User Management",
      default_value: false
    },
    "delete_user_downvotes" => %{
      title: "Delete User Downvotes",
      description: "",
      category: "User Management",
      default_value: false
    },
    "new_user_erase" => %{
      title: "New User Erase",
      description: "",
      category: "User Management",
      default_value: false
    },
    "user_force_filter" => %{
      title: "User Force Filter",
      description: "",
      category: "User Management",
      default_value: false
    },
    "create_user_unlock" => %{
      title: "Create User Unlock",
      description: "",
      category: "User Management",
      default_value: false
    },
    "user_verification_manager" => %{
      title: "User Verification Manager",
      description: "",
      category: "User Management",
      default_value: false
    },
    "delete_user_votes" => %{
      title: "Delete User Votes",
      description: "",
      category: "User Management",
      default_value: false
    },
    "create_user_wipe" => %{
      title: "Create User Wipe",
      description: "",
      category: "User Management",
      default_value: false
    },
    "profile_scratchpad_manager" => %{
      title: "Profile Scratchpad Manager",
      description: "",
      category: "System",
      default_value: false
    },
    "erase_source_change" => %{
      title: "Erase Source Change",
      description: "",
      category: "System",
      default_value: false
    },
    "duplicate_report" => %{
      title: "Duplicate Report",
      description: "",
      category: "Moderation",
      default_value: false
    },
    "duplicate_report_accept" => %{
      title: "Duplicate Report Accept",
      description: "",
      category: "Moderation",
      default_value: false
    },
    "duplicate_report_accept_reverse" => %{
      title: "Duplicate Report Accept Reverse",
      description: "",
      category: "Moderation",
      default_value: false
    },
    "duplicate_report_accept_claim" => %{
      title: "Duplicate Report Accept Claim",
      description: "",
      category: "Moderation",
      default_value: false
    },
    "delete_duplicate_report_claim" => %{
      title: "Delete Duplicate Report Claim",
      description: "",
      category: "Moderation",
      default_value: false
    },
    "duplicate_report_reject" => %{
      title: "Duplicate Report Reject",
      description: "",
      category: "Moderation",
      default_value: false
    },
    "advert" => %{
      title: "Advert",
      description: "",
      category: "System",
      default_value: false
    },
    "polls" => %{
      title: "Polls",
      description: "",
      category: "Social",
      default_value: false
    },
    "report" => %{
      title: "Report",
      description: "",
      category: "Moderation",
      default_value: false
    },
    "poll_votes" => %{
      title: "Poll Votes",
      description: "",
      category: "Social",
      default_value: false
    },
    "create_artist_link" => %{
      title: "Create Artist Link",
      description: "",
      category: "Artist Management",
      default_value: false
    },
    "new_artist_link" => %{
      title: "New Artist Link",
      description: "",
      category: "Artist Management",
      default_value: false
    },
    "edit_artist_link" => %{
      title: "Edit Artist Link",
      description: "",
      category: "Artist Management",
      default_value: false
    },
    "update_artist_link" => %{
      title: "Update Artist Link",
      description: "",
      category: "Artist Management",
      default_value: false
    },
    "create_artist_link_verification" => %{
      title: "Create Artist Link Verification",
      description: "",
      category: "Artist Management",
      default_value: false
    },
    "create_artist_link_reject" => %{
      title: "Create Artist Link Reject",
      description: "",
      category: "Artist Management",
      default_value: false
    },
    "create_artist_link_contact" => %{
      title: "Create Artist Link Contact",
      description: "",
      category: "Artist Management",
      default_value: false
    },
    "image_comment" => %{
      title: "Image Comment",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_comment_approve" => %{
      title: "Image Comment Approve",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_comment_delete" => %{
      title: "Image Comment Delete",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_comment_hide" => %{
      title: "Image Comment Hide",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "create_conversation" => %{
      title: "Create Conversation",
      description: "",
      category: "Social",
      default_value: false
    },
    "create_message" => %{
      title: "Create Message",
      description: "",
      category: "Social",
      default_value: false
    },
    "manage_commissions" => %{
      title: "Manage Commissions",
      description: "",
      category: "Finance",
      default_value: false
    },
    "manage_filters" => %{
      title: "Manage Filters",
      description: "",
      category: "User Management",
      default_value: false
    },
    "forum_manager" => %{
      title: "Forum Manager",
      description: "",
      category: "Social",
      default_value: false
    },
    "topic_manager" => %{
      title: "Topic Manager",
      description: "",
      category: "Social",
      default_value: false
    },
    "post_manager" => %{
      title: "Post Manager",
      description: "",
      category: "Social",
      default_value: false
    },
    "mod_notes" => %{
      title: "Mod Notes",
      description: "",
      category: "Moderation",
      default_value: false
    },
    "static_pages" => %{
      title: "Static Pages",
      description: "",
      category: "System",
      default_value: false
    },
    "site_notices" => %{
      title: "Site Notices",
      description: "",
      category: "System",
      default_value: false
    },
    "rule_manager" => %{
      title: "Rule Manager",
      description: "",
      category: "Moderation",
      default_value: false
    },
    "gallery_manager" => %{
      title: "Gallery Manager",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "tag_manager" => %{
      title: "Tag Manager",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_interaction" => %{
      title: "Image Interaction",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "comment_changeset_for" => %{
      title: "Comment Changeset For",
      description: "",
      category: "Social",
      default_value: false
    },
    "image_changeset" => %{
      title: "Image Changeset",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "upload_image" => %{
      title: "Upload Image",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_aprove" => %{
      title: "Image Approve",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_feature" => %{
      title: "Image Feature",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_destroy" => %{
      title: "Image Destroy",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_comment_lock" => %{
      title: "Image Comment Lock",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_description_lock" => %{
      title: "Image Description Lock",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_tag_lock" => %{
      title: "Image Tag Lock",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "load_hidable_image" => %{
      title: "Load Hidable Image",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_repair" => %{
      title: "Image Repair",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_hide" => %{
      title: "Image Hide",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "delete_user_image_vote" => %{
      title: "Delete User Image Vote",
      description: "",
      category: "User Management",
      default_value: false
    },
    "delete_image_hash" => %{
      title: "Delete Image Hash",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "update_image_scratchpad" => %{
      title: "Update Image Scratchpad",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "delete_image_source_history" => %{
      title: "Delete Image Source History",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "update_image_file" => %{
      title: "Update Image File",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "update_image_description" => %{
      title: "Update Image Description",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "update_image_sources" => %{
      title: "Update Image Sources",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "update_image_locked_tags" => %{
      title: "Update Image Locked Tags",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "update_image_tags" => %{
      title: "Update Image Tags",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "update_image_uploader" => %{
      title: "Update Image Uploader",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "update_image_anonymous" => %{
      title: "Update Image Anonymous",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_user_hide" => %{
      title: "Image User Hide",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_fav" => %{
      title: "Image Fav",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_vote_manager" => %{
      title: "Image Vote Manager",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_add_upvote" => %{
      title: "Image Add Upvote",
      description: "",
      category: "Content Management",
      default_value: false
    },
    "image_add_downvote" => %{
      title: "Image Add Downvote",
      description: "",
      category: "Content Management",
      default_value: false
    }
  }

  @doc """
  Returns actions grouped by their category.
  Returns a map where keys are category names and values are lists of {action_key, metadata} tuples.
  """
  def actions_grouped_by_category do
    @available_actions
    |> Map.to_list()
    |> Enum.group_by(fn {_key, metadata} -> metadata.category end)
    |> Enum.sort_by(fn {category, _actions} -> category end)
  end

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
