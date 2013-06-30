# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090925185606) do

  create_table "account_features", :force => true do |t|
    t.string  "name"
    t.integer "position"
    t.string  "description"
  end

  create_table "account_features_account_types", :id => false, :force => true do |t|
    t.integer "account_feature_id"
    t.integer "account_type_id"
  end

  add_index "account_features_account_types", ["account_feature_id"], :name => "fk_account_features_account_types_account_feature_id"
  add_index "account_features_account_types", ["account_type_id"], :name => "fk_account_features_account_types_account_type_id"

  create_table "account_types", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "max_products"
    t.boolean "private_storefront"
    t.integer "price_cents",                     :default => 0
    t.integer "flat_fee_cents",                  :default => 0
    t.string  "currency",           :limit => 3, :default => "USD"
    t.integer "position"
    t.float   "commission"
    t.boolean "enabled"
    t.boolean "allow_signup"
    t.boolean "pricing_tbd"
  end

  create_table "accounts", :force => true do |t|
    t.integer  "account_type_id"
    t.integer  "member_id"
    t.integer  "payment_type_id"
    t.string   "payment_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["account_type_id"], :name => "fk_accounts_account_type_id"
  add_index "accounts", ["member_id"], :name => "fk_accounts_member_id"

  create_table "amazon_products", :force => true do |t|
    t.string   "asin"
    t.text     "xml"
    t.integer  "amazonable_id",                 :default => 0,  :null => false
    t.string   "amazonable_type", :limit => 15, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "avatars", :force => true do |t|
    t.integer "member_id"
  end

  create_table "carriers", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "tracking_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string "name"
  end

  create_table "categories_products", :id => false, :force => true do |t|
    t.integer "category_id", :default => 0, :null => false
    t.integer "product_id",  :default => 0, :null => false
  end

  add_index "categories_products", ["category_id"], :name => "fk_categories_products_category_id"
  add_index "categories_products", ["product_id"], :name => "fk_categories_products_product_id"

  create_table "comatose_pages", :force => true do |t|
    t.integer  "parent_id"
    t.text     "full_path"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.text     "body"
    t.string   "filter_type", :limit => 25, :default => "Textile"
    t.string   "author"
    t.integer  "position",                  :default => 0
    t.integer  "version"
    t.datetime "updated_on"
    t.datetime "created_on"
  end

  create_table "conditions", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "requires_comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", :force => true do |t|
    t.integer  "line_item_id"
    t.integer  "rating"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followers", :force => true do |t|
    t.integer  "member_id"
    t.integer  "following_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.boolean  "enabled"
  end

  create_table "forum_posts", :force => true do |t|
    t.integer  "member_id",  :default => 0,  :null => false
    t.string   "subject",    :default => "", :null => false
    t.text     "body"
    t.integer  "root_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forum_id",   :default => 0,  :null => false
  end

  add_index "forum_posts", ["forum_id"], :name => "fk_forum_posts_forum_id"
  add_index "forum_posts", ["member_id"], :name => "fk_forum_posts_member_id"

  create_table "forums", :force => true do |t|
    t.string   "name",           :limit => 50, :default => "", :null => false
    t.text     "description"
    t.datetime "created_at"
    t.boolean  "enabled"
    t.integer  "forum_group_id"
  end

  add_index "forums", ["forum_group_id"], :name => "fk_forums_forum_group_id"

  create_table "freecycles", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "member_id"
    t.integer  "metro_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_formats", :force => true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "line_items", :force => true do |t|
    t.integer  "product_id",                   :default => 0,         :null => false
    t.integer  "order_id",                     :default => 0,         :null => false
    t.integer  "quantity",                     :default => 0,         :null => false
    t.integer  "total_cents",                  :default => 0
    t.string   "currency",        :limit => 3, :default => "USD"
    t.string   "status",                       :default => "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "shipped_at"
    t.string   "tracking_number"
    t.integer  "carrier_id"
  end

  add_index "line_items", ["order_id"], :name => "fk_line_item_orders"
  add_index "line_items", ["product_id"], :name => "fk_line_item_products"

  create_table "media_mails", :force => true do |t|
    t.integer  "factor",                      :default => 35
    t.integer  "starting_point",              :default => 188
    t.string   "currency",       :limit => 3, :default => "USD"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
    t.string   "last_activity"
    t.datetime "last_activity_at"
    t.string   "password_reset_code",       :limit => 40
    t.datetime "password_reset_at"
  end

  add_index "members", ["login"], :name => "index_members_on_login", :unique => true

  create_table "members_roles", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "member_id"
  end

  add_index "members_roles", ["member_id"], :name => "index_members_roles_on_member_id"
  add_index "members_roles", ["role_id"], :name => "index_members_roles_on_role_id"

  create_table "metro_areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :default => 0,  :null => false
    t.string  "server_url"
    t.string  "salt",       :default => "", :null => false
  end

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "reference"
    t.string   "message"
    t.string   "action"
    t.text     "params"
    t.boolean  "test"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.string   "name"
    t.text     "address_line_1"
    t.string   "email"
    t.string   "pay_type",            :limit => 10
    t.string   "pay_info"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state",               :limit => 20
    t.string   "zip",                 :limit => 10
    t.string   "country",             :limit => 50
    t.string   "ship_to"
    t.string   "ship_address_line_1"
    t.string   "ship_address_line_2"
    t.string   "ship_city"
    t.string   "ship_state",          :limit => 20
    t.string   "ship_zip",            :limit => 10
    t.string   "ship_country",        :limit => 50
    t.datetime "created_at"
    t.integer  "member_id"
    t.string   "status",                            :default => "pending"
    t.datetime "updated_at"
    t.datetime "purchased_at"
    t.string   "session_id"
  end

  add_index "orders", ["member_id"], :name => "fk_orders_member_id"

  create_table "page_versions", :force => true do |t|
    t.integer  "page_id"
    t.integer  "version"
    t.integer  "parent_id"
    t.text     "full_path"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.text     "body"
    t.string   "filter_type", :limit => 25, :default => "Textile"
    t.string   "author"
    t.integer  "position",                  :default => 0
    t.datetime "updated_on"
    t.datetime "created_on"
  end

  create_table "payment_notifications", :force => true do |t|
    t.text     "params"
    t.integer  "order_id"
    t.string   "status"
    t.string   "transaction_id"
    t.string   "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_types", :force => true do |t|
    t.string "name"
  end

  create_table "payment_types_sellers", :id => false, :force => true do |t|
    t.integer "payment_type_id", :default => 0, :null => false
    t.integer "seller_id",       :default => 0, :null => false
  end

  add_index "payment_types_sellers", ["payment_type_id"], :name => "fk_payment_types_sellers_payment_type_id"
  add_index "payment_types_sellers", ["seller_id"], :name => "fk_payment_types_sellers_seller_id"

  create_table "people", :force => true do |t|
    t.string   "name",                      :limit => 40
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

  create_table "points", :force => true do |t|
    t.integer  "member_id"
    t.integer  "rating_id"
    t.text     "feedback"
    t.datetime "created_at"
    t.integer  "created_by"
    t.integer  "line_item_id"
  end

  add_index "points", ["created_by"], :name => "fk_created_by_points"
  add_index "points", ["line_item_id"], :name => "fk_points_line_item_id"
  add_index "points", ["member_id"], :name => "fk_points_member_id"

  create_table "product_images", :force => true do |t|
    t.binary  "data"
    t.integer "product_id"
    t.integer "position"
  end

  add_index "product_images", ["product_id"], :name => "fk_product_images_product_id"

  create_table "product_reviews", :force => true do |t|
    t.string   "isbn"
    t.string   "name"
    t.string   "author"
    t.string   "publisher"
    t.text     "content"
    t.integer  "member_id"
    t.datetime "created_at"
    t.integer  "rating_id"
  end

  add_index "product_reviews", ["member_id"], :name => "fk_product_reviews_member_id"
  add_index "product_reviews", ["rating_id"], :name => "fk_product_reviews_rating_id"

  create_table "products", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "condition_comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "publish_at"
    t.boolean  "published",                       :default => true
    t.string   "discount_desc"
    t.integer  "quantity_avail",                  :default => 1,     :null => false
    t.string   "isbn"
    t.string   "internal_id"
    t.integer  "status_id",          :limit => 2
    t.integer  "seller_id"
    t.integer  "item_format_id"
    t.string   "publisher_name"
    t.string   "author"
    t.string   "small_image_url"
    t.string   "medium_image_url"
    t.string   "large_image_url"
    t.integer  "offer_cents",                     :default => 0
    t.integer  "retail_cents",                    :default => 0
    t.string   "currency",           :limit => 3, :default => "USD"
    t.integer  "weight"
    t.datetime "held_at"
    t.integer  "condition_id"
    t.boolean  "nonsmoking_home"
    t.boolean  "no_pets_in_home"
    t.boolean  "use_amazon_image"
    t.string   "held_by"
  end

  add_index "products", ["item_format_id"], :name => "fk_products_item_format_id"
  add_index "products", ["seller_id"], :name => "fk_products_seller_id"

  create_table "products_publishers", :id => false, :force => true do |t|
    t.integer "product_id",   :default => 0, :null => false
    t.integer "publisher_id", :default => 0, :null => false
  end

  add_index "products_publishers", ["product_id"], :name => "fk_products_publishers_product_id"
  add_index "products_publishers", ["publisher_id"], :name => "fk_products_publishers_publisher_id"

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "active"
    t.integer  "member_id"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "gender"
    t.string   "birth_month"
    t.string   "birth_day"
    t.string   "educational_philosophy"
    t.string   "curriculum"
    t.string   "primary_motivation"
    t.string   "strengths"
    t.string   "current_grade_levels"
    t.string   "number_of_children"
    t.string   "ages_of_children"
    t.string   "genders_of_children"
    t.string   "primary_teacher"
    t.string   "blog_url"
    t.string   "flickr_url"
    t.string   "you_tube_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitter_url"
  end

  create_table "publishers", :force => true do |t|
    t.string "name"
    t.string "url"
  end

  create_table "ratings", :force => true do |t|
    t.string  "name"
    t.integer "score"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "sellers", :force => true do |t|
    t.string  "name"
    t.string  "address_line_1"
    t.string  "address_line_2"
    t.string  "city"
    t.string  "state",                    :limit => 20
    t.string  "zip",                      :limit => 10
    t.string  "country",                  :limit => 50
    t.string  "email",                    :limit => 80, :default => "", :null => false
    t.integer "member_id"
    t.string  "phone",                    :limit => 30
    t.string  "pay_pal_id"
    t.string  "merchant_id"
    t.binary  "image"
    t.boolean "accepted_terms"
    t.string  "preferred_payment_method"
    t.integer "shipping_term_id"
    t.text    "description"
    t.string  "name_on_check"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "sessions_session_id_index"

  create_table "shipping_terms", :force => true do |t|
    t.string   "name"
    t.integer  "max_ship_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.string "name"
  end

end
