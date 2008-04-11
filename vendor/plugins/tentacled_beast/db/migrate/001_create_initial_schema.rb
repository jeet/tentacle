class CreateInitialSchema < ActiveRecord::Migration
  def self.up
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
    end

    add_index "forums", ["position", "site_id"], :name => "index_forums_on_position_and_site_id"
    add_index "forums", ["site_id", "permalink"], :name => "index_forums_on_site_id_and_permalink"

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

    create_table "posts", :force => true do |t|
      t.integer  "user_id"
      t.integer  "topic_id"
      t.text     "body"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "forum_id"
      t.text     "body_html"
      t.integer  "site_id"
    end

    add_index "posts", ["created_at", "forum_id"], :name => "index_posts_on_forum_id"
    add_index "posts", ["created_at", "user_id"], :name => "index_posts_on_user_id"
    add_index "posts", ["created_at", "topic_id"], :name => "index_posts_on_topic_id"

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
    end

    add_index "topics", ["sticky", "last_updated_at", "forum_id"], :name => "index_topics_on_sticky_and_last_updated_at"
    add_index "topics", ["last_updated_at", "forum_id"], :name => "index_topics_on_forum_id_and_last_updated_at"
    add_index "topics", ["forum_id", "permalink"], :name => "index_topics_on_forum_id_and_permalink"

    add_column :users, "token_expires_at", :datetime
    add_column :users, "activation_code", :string, :limit => 40
    add_column :users, "activated_at", :datetime 
    add_column :users, "state", :string, :default => "passive"
    add_column :users, "deleted_at", :datetime 
    add_column :users, "site_id", :integer  
    add_column :users, "last_login_at", :datetime 
    add_column :users, "openid_url", :string   
    add_column :users, "last_seen_at", :datetime 
    add_column :users, "posts_count", :integer, :default => 0
    add_column :users, "display_name", :string
    add_column :users, "permalink", :string

    add_index "users", ["last_seen_at"], :name => "index_users_on_last_seen_at"
    add_index "users", ["site_id", "posts_count"], :name => "index_site_users_on_posts_count"
    add_index "users", ["site_id", "permalink"], :name => "index_site_users_on_permalink"
  end

  def self.down
    remove_column :users, "token_expires_at", :datetime
    remove_column :users, "activation_code", :string, :limit => 40
    remove_column :users, "activated_at", :datetime 
    remove_column :users, "state", :string, :default => "passive"
    remove_column :users, "deleted_at", :datetime 
    remove_column :users, "site_id", :integer  
    remove_column :users, "last_login_at", :datetime 
    remove_column :users, "openid_url", :string   
    remove_column :users, "last_seen_at", :datetime 
    remove_column :users, "posts_count", :integer, :default => 0
    remove_column :users, "display_name", :string
    remove_column :users, "permalink", :string
    
    drop_table :forums
    drop_table :topics
    drop_table :sites
    drop_table :posts
    drop_table :moderatorships
    drop_table :monitorships
  end
end
