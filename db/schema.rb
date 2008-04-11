# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 9) do

  create_table "avatars", :force => true do |t|
    t.string  "content_type"
    t.string  "filename"
    t.integer "size"
    t.integer "parent_id"
    t.string  "thumbnail"
    t.integer "width"
    t.integer "height"
  end

  create_table "bookmarks", :force => true do |t|
    t.integer "repository_id"
    t.string  "path"
    t.string  "label"
    t.text    "description"
  end

  add_index "bookmarks", ["repository_id"], :name => "index_bookmarks_on_repository_id"

  create_table "changes", :force => true do |t|
    t.integer "changeset_id"
    t.string  "name"
    t.text    "path"
    t.text    "from_path"
    t.integer "from_revision"
    t.boolean "diffable",      :default => false
  end

  add_index "changes", ["changeset_id"], :name => "index_changes_on_changeset_id"

  create_table "changesets", :force => true do |t|
    t.string   "author"
    t.text     "message"
    t.datetime "changed_at"
    t.integer  "repository_id"
    t.string   "revision"
    t.boolean  "diffable"
  end

  add_index "changesets", ["repository_id"], :name => "index_changesets_on_repository_id"
  add_index "changesets", ["repository_id", "author"], :name => "idx_changesets_on_repo_id_and_author"
  add_index "changesets", ["repository_id", "changed_at"], :name => "index_changesets_on_repository_id_and_changed_at"

  create_table "forums", :force => true do |t|
    t.integer "site_id"
    t.string  "name"
    t.string  "description"
    t.integer "topics_count",     :default => 0
    t.integer "posts_count",      :default => 0
    t.integer "position",         :default => 0
    t.text    "description_html"
    t.string  "state",            :default => "public"
    t.string  "permalink"
    t.integer "group_id"
  end

  add_index "forums", ["position", "site_id"], :name => "index_forums_on_position_and_site_id"
  add_index "forums", ["site_id", "permalink"], :name => "index_forums_on_site_id_and_permalink"

  create_table "friendships", :force => true do |t|
    t.integer  "requester_id"
    t.integer  "requested_id"
    t.integer  "approved"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topics_count", :default => 0
    t.integer  "users_count",  :default => 0
    t.integer  "posts_count",  :default => 0
  end

  create_table "hooks", :force => true do |t|
    t.integer  "repository_id"
    t.string   "name"
    t.text     "options"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
    t.string   "label"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moderatorships", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monitorships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     :default => true
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.binary  "server_url"
    t.string  "handle"
    t.binary  "secret"
    t.integer "issued"
    t.integer "lifetime"
    t.string  "assoc_type"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.string  "nonce"
    t.integer "created"
  end

  create_table "open_id_authentication_settings", :force => true do |t|
    t.string "setting"
    t.binary "value"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "repository_id"
    t.boolean  "active"
    t.boolean  "admin"
    t.string   "path"
    t.boolean  "full_access"
    t.integer  "changesets_count", :default => 0
    t.datetime "last_changed_at"
  end

  add_index "permissions", ["repository_id", "active"], :name => "index_permissions_on_repository_id"

  create_table "plugins", :force => true do |t|
    t.string   "name"
    t.text     "options"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forum_id"
    t.text     "body_html"
    t.integer  "site_id"
    t.integer  "group_id"
  end

  add_index "posts", ["created_at", "forum_id"], :name => "index_posts_on_forum_id"
  add_index "posts", ["created_at", "user_id"], :name => "index_posts_on_user_id"
  add_index "posts", ["created_at", "topic_id"], :name => "index_posts_on_topic_id"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "website"
    t.string   "about"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "repositories", :force => true do |t|
    t.string   "name"
    t.string   "path"
    t.string   "subdomain"
    t.boolean  "public"
    t.string   "full_url"
    t.string   "scm_type",          :default => "svn"
    t.datetime "synced_changed_at"
    t.string   "synced_revision"
    t.integer  "changesets_count",  :default => 0
  end

  add_index "repositories", ["subdomain"], :name => "index_repositories_on_subdomain"
  add_index "repositories", ["public"], :name => "index_repositories_on_public"

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "host"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topics_count", :default => 0
    t.integer  "users_count",  :default => 0
    t.integer  "posts_count",  :default => 0
  end

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hits",            :default => 0
    t.integer  "sticky",          :default => 0
    t.integer  "posts_count",     :default => 0
    t.boolean  "locked",          :default => false
    t.integer  "last_post_id"
    t.datetime "last_updated_at"
    t.integer  "last_user_id"
    t.integer  "site_id"
    t.string   "permalink"
    t.integer  "group_id"
  end

  add_index "topics", ["sticky", "last_updated_at", "forum_id"], :name => "index_topics_on_sticky_and_last_updated_at"
  add_index "topics", ["last_updated_at", "forum_id"], :name => "index_topics_on_forum_id_and_last_updated_at"
  add_index "topics", ["forum_id", "permalink"], :name => "index_topics_on_forum_id_and_permalink"

  create_table "users", :force => true do |t|
    t.string   "identity_url"
    t.boolean  "admin"
    t.integer  "avatar_id"
    t.string   "avatar_path"
    t.string   "token"
    t.string   "login"
    t.string   "crypted_password"
    t.text     "public_key"
    t.datetime "token_expires_at"
    t.string   "activation_code",  :limit => 40
    t.datetime "activated_at"
    t.string   "state",                          :default => "passive"
    t.datetime "deleted_at"
    t.integer  "site_id"
    t.datetime "last_login_at"
    t.string   "openid_url"
    t.datetime "last_seen_at"
    t.integer  "posts_count",                    :default => 0
    t.string   "display_name"
    t.string   "permalink"
  end

  add_index "users", ["token"], :name => "index_users_on_token"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["last_seen_at"], :name => "index_users_on_last_seen_at"
  add_index "users", ["site_id", "posts_count"], :name => "index_site_users_on_posts_count"
  add_index "users", ["site_id", "permalink"], :name => "index_site_users_on_permalink"

end
