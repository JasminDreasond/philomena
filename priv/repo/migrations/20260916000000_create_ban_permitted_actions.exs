defmodule Philomena.Repo.Migrations.CreateBanPermittedActions do
  use Ecto.Migration

  def up do
    create table(:ban_permitted_actions) do
      add :user_ban_id, references(:user_bans, on_delete: :delete_all)
      add :subnet_ban_id, references(:subnet_bans, on_delete: :delete_all)
      add :fingerprint_ban_id, references(:fingerprint_bans, on_delete: :delete_all)
      add :action, :text, null: false

      timestamps()
    end

    create constraint(:ban_permitted_actions, :num_nonnulls,
             check: "num_nonnulls(user_ban_id, subnet_ban_id, fingerprint_ban_id) = 1"
           )

    alter table(:user_bans) do
      remove :ban_upload_image
      remove :ban_downvote_image
      remove :ban_upvote_image
      remove :ban_comment_images
      remove :ban_post_forum
      remove :ban_reply_forum
      remove :ban_send_pm
      remove :ban_api_key
      remove :ban_create_filters
      remove :ban_galleries
      remove :ban_manage_tags
      remove :ban_commissions
    end

    alter table(:subnet_bans) do
      remove :ban_upload_image
      remove :ban_downvote_image
      remove :ban_upvote_image
      remove :ban_comment_images
      remove :ban_post_forum
      remove :ban_reply_forum
      remove :ban_send_pm
      remove :ban_api_key
      remove :ban_create_filters
      remove :ban_galleries
      remove :ban_manage_tags
      remove :ban_commissions
    end

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
      remove :ban_galleries
      remove :ban_manage_tags
      remove :ban_commissions
    end
  end

  def down do
    alter table(:user_bans) do
      add :ban_upload_image, :boolean, default: false
      add :ban_downvote_image, :boolean, default: false
      add :ban_upvote_image, :boolean, default: false
      add :ban_comment_images, :boolean, default: false
      add :ban_post_forum, :boolean, default: false
      add :ban_reply_forum, :boolean, default: false
      add :ban_send_pm, :boolean, default: false
      add :ban_api_key, :boolean, default: false
      add :ban_create_filters, :boolean, default: false
      add :ban_galleries, :boolean, default: false
      add :ban_manage_tags, :boolean, default: false
      add :ban_commissions, :boolean, default: false
    end

    alter table(:subnet_bans) do
      add :ban_upload_image, :boolean, default: false
      add :ban_downvote_image, :boolean, default: false
      add :ban_upvote_image, :boolean, default: false
      add :ban_comment_images, :boolean, default: false
      add :ban_post_forum, :boolean, default: false
      add :ban_reply_forum, :boolean, default: false
      add :ban_send_pm, :boolean, default: false
      add :ban_api_key, :boolean, default: false
      add :ban_create_filters, :boolean, default: false
      add :ban_galleries, :boolean, default: false
      add :ban_manage_tags, :boolean, default: false
      add :ban_commissions, :boolean, default: false
    end

    alter table(:fingerprint_bans) do
      add :ban_upload_image, :boolean, default: false
      add :ban_downvote_image, :boolean, default: false
      add :ban_upvote_image, :boolean, default: false
      add :ban_comment_images, :boolean, default: false
      add :ban_post_forum, :boolean, default: false
      add :ban_reply_forum, :boolean, default: false
      add :ban_send_pm, :boolean, default: false
      add :ban_api_key, :boolean, default: false
      add :ban_create_filters, :boolean, default: false
      add :ban_galleries, :boolean, default: false
      add :ban_manage_tags, :boolean, default: false
      add :ban_commissions, :boolean, default: false
    end

    drop table(:ban_permitted_actions)
  end
end
