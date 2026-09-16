defmodule Philomena.Repo.Migrations.RenameBanCreateGalleriesToBanGalleries do
  use Ecto.Migration

  def up do
    rename table(:subnet_bans), :ban_create_galleries, to: :ban_galleries
    rename table(:fingerprint_bans), :ban_create_galleries, to: :ban_galleries
    rename table(:user_bans), :ban_create_galleries, to: :ban_galleries
  end

  def down do
    rename table(:subnet_bans), :ban_galleries, to: :ban_create_galleries
    rename table(:fingerprint_bans), :ban_galleries, to: :ban_create_galleries
    rename table(:user_bans), :ban_galleries, to: :ban_create_galleries
  end
end
