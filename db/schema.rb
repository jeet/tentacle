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

ActiveRecord::Schema.define(:version => 7) do

  create_table "activity_feed_entries", :force => true do |t|
    t.integer  "profile_id"
    t.string   "entry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", :force => true do |t|
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "height"
    t.integer  "width"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "avatars", :force => true do |t|
    t.string  "content_type"
    t.string  "filename"
    t.integer "size"
    t.integer "parent_id"
    t.string  "thumbnail"
    t.integer "width"
    t.integer "height"
  end

  create_table "flags", :force => true do |t|
    t.integer  "flaggable_id"
    t.string   "flaggable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "flagger_id"
    t.string   "flagger_type"
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "users_count",                 :default => 0
    t.integer  "posts_count",                 :default => 0
    t.integer  "topics_count"
    t.boolean  "wiki_requires_approval",      :default => false
    t.boolean  "wiki_requires_login_to_post", :default => true
    t.boolean  "disable_wiki_teh",            :default => false
  end

  create_table "links", :force => true do |t|
    t.integer  "from_page_id"
    t.integer  "to_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moderatorships", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monitorships", :force => true do |t|
    t.integer  "profile_id"
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

  create_table "page_versions", :force => true do |t|
    t.integer  "page_id"
    t.integer  "version"
    t.string   "title"
    t.text     "body"
    t.integer  "profile_id"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private_page"
    t.integer  "group_id"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "profile_id"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private_page"
    t.integer  "version"
    t.integer  "group_id"
    t.datetime "locked_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "profile_id"
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
  add_index "posts", ["created_at", "profile_id"], :name => "index_posts_on_profile_id"
  add_index "posts", ["created_at", "topic_id"], :name => "index_posts_on_topic_id"

  create_table "private_messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "title"
    t.text     "body"
    t.text     "body_html"
    t.boolean  "sender_deleted",    :default => false
    t.boolean  "recipient_deleted", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "private_messages", ["sender_id"], :name => "index_private_messages_on_sender_id"
  add_index "private_messages", ["recipient_id"], :name => "index_private_messages_on_recipient_id"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "website"
    t.string   "about"
    t.string   "email"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "posts_count",  :default => 0
    t.datetime "last_seen_at"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "host"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topics_count",   :default => 0
    t.integer  "profiles_count", :default => 0
    t.integer  "posts_count",    :default => 0
  end

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "profile_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hits",            :default => 0
    t.integer  "sticky",          :default => 0
    t.integer  "posts_count",     :default => 0
    t.boolean  "locked",          :default => false
    t.integer  "last_post_id"
    t.datetime "last_updated_at"
    t.integer  "last_profile_id"
    t.integer  "site_id"
    t.string   "permalink"
    t.integer  "group_id"
  end

  add_index "topics", ["sticky", "last_updated_at", "forum_id"], :name => "index_topics_on_sticky_and_last_updated_at"
  add_index "topics", ["last_updated_at", "forum_id"], :name => "index_topics_on_forum_id_and_last_updated_at"
  add_index "topics", ["forum_id", "permalink"], :name => "index_topics_on_forum_id_and_permalink"

  create_table "users", :force => true do |t|
    t.string  "identity_url"
    t.boolean "admin"
    t.string  "token"
    t.string  "login"
    t.integer "avatar_id"
    t.string  "avatar_path"
    t.string  "crypted_password"
  end

  add_index "users", ["token"], :name => "index_users_on_token"
  add_index "users", ["login"], :name => "index_users_on_login"

end
