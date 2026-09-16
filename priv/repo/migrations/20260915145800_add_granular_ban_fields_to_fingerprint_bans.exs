defmodule Philomena.Repo.Migrations.AddGranularBanFieldsToFingerprintBans do
  use Ecto.Migration

  def up do
    alter table(:fingerprint_bans) do
      add :ban_upload_image, :boolean, default: false, null: false
      add :ban_downvote_image, :boolean, default: false, null: false
      add :ban_upvote_image, :boolean, default: false, null: false
      add :ban_comment_images, :boolean, default: false, null: false
      add :ban_post_forum, :boolean, default: false, null: false
      add :ban_reply_forum, :boolean, default: false, null: false
      add :ban_send_pm, :boolean, default: false, null: false
      add :ban_api_key, :boolean, default: false, null: false
      add :ban_create_filters, :boolean, default: false, null: false
      add :ban_create_galleries, :boolean, default: false, null: false
      add :ban_manage_tags, :boolean, default: false, null: false
      add :ban_commissions, :boolean, default: false
    end
  end

  def down do
    alter table(:fingerprint_bans) do
      remove :ban_upload_image
      remove :ban_downvote_image
      remove :ban_upvote_image
      remove :ban_comment_images
      remove :ban_post_forum
      remove :ban_reply_forum
      remove :ban_send_pm
      remove :ban_api_key
      remove :ban_create_filters
      remove :ban_create_galleries
      remove :ban_manage_tags
      remove :ban_commissions
    end
  end
end
