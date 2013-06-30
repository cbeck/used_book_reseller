CREATE TABLE `account_features` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `order` bigint(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `account_features_account_types` (
  `account_feature_id` bigint(11) default NULL,
  `account_type_id` bigint(11) default NULL,
  KEY `fk_account_features_account_types_account_feature_id` (`account_feature_id`),
  KEY `fk_account_features_account_types_account_type_id` (`account_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `account_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `current_price` float default '0',
  `order` bigint(11) default NULL,
  `max_monthly_sales` bigint(11) default NULL,
  `max_products` bigint(11) default NULL,
  `private_storefront` tinyint(1) default NULL,
  `allow_paypal` tinyint(1) default NULL,
  `allow_merchant_account` tinyint(1) default NULL,
  `commission` float default '0',
  `flat_fee` float default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL auto_increment,
  `account_type_id` bigint(11) default NULL,
  `member_id` bigint(11) default NULL,
  `payment_type_id` bigint(11) default NULL,
  `payment_info` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_accounts_account_type_id` (`account_type_id`),
  KEY `fk_accounts_member_id` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `amazon_products` (
  `id` int(11) NOT NULL auto_increment,
  `asin` varchar(255) default NULL,
  `xml` text,
  `amazonable_id` bigint(11) NOT NULL default '0',
  `amazonable_type` varchar(15) NOT NULL default '',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `avatars` (
  `id` int(11) NOT NULL auto_increment,
  `member_id` bigint(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `categories_products` (
  `category_id` bigint(11) NOT NULL default '0',
  `product_id` bigint(11) NOT NULL default '0',
  KEY `fk_categories_products_category_id` (`category_id`),
  KEY `fk_categories_products_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `comatose_pages` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` bigint(11) default NULL,
  `full_path` text,
  `title` varchar(255) default NULL,
  `slug` varchar(255) default NULL,
  `keywords` varchar(255) default NULL,
  `body` text,
  `filter_type` varchar(25) default 'Textile',
  `author` varchar(255) default NULL,
  `position` bigint(11) default '0',
  `version` bigint(11) default NULL,
  `updated_on` datetime default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL auto_increment,
  `feedback` varchar(255) default NULL,
  `line_item_id` bigint(11) default NULL,
  `created_at` datetime default NULL,
  `comment` text,
  PRIMARY KEY  (`id`),
  KEY `fk_feedback_line_item_id` (`line_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `followers` (
  `id` int(11) NOT NULL auto_increment,
  `member_id` bigint(11) default NULL,
  `following_id` bigint(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `forum_groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` text,
  `created_at` datetime default NULL,
  `enabled` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `forum_posts` (
  `id` int(11) NOT NULL auto_increment,
  `member_id` bigint(11) NOT NULL default '0',
  `subject` varchar(255) NOT NULL default '',
  `body` text,
  `root_id` bigint(11) default NULL,
  `parent_id` bigint(11) default NULL,
  `lft` bigint(11) default NULL,
  `rgt` bigint(11) default NULL,
  `depth` bigint(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `forum_id` bigint(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `fk_forum_posts_forum_id` (`forum_id`),
  KEY `fk_forum_posts_member_id` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `forums` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `description` text,
  `created_at` datetime default NULL,
  `enabled` tinyint(1) default NULL,
  `forum_group_id` bigint(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_forums_forum_group_id` (`forum_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `item_formats` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `line_items` (
  `id` int(11) NOT NULL auto_increment,
  `product_id` bigint(11) NOT NULL default '0',
  `order_id` bigint(11) NOT NULL default '0',
  `quantity` bigint(11) NOT NULL default '0',
  `total_price` float NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `fk_line_item_products` (`product_id`),
  KEY `fk_line_item_orders` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `members` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(40) default NULL,
  `name` varchar(100) default '',
  `email` varchar(100) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(40) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `activation_code` varchar(40) default NULL,
  `activated_at` datetime default NULL,
  `state` varchar(255) default 'passive',
  `deleted_at` datetime default NULL,
  `last_activity` varchar(255) default NULL,
  `last_activity_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_members_on_login` (`login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `members_roles` (
  `role_id` bigint(11) default NULL,
  `member_id` bigint(11) default NULL,
  KEY `index_members_roles_on_role_id` (`role_id`),
  KEY `index_members_roles_on_member_id` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `open_id_authentication_associations` (
  `id` int(11) NOT NULL auto_increment,
  `issued` bigint(11) default NULL,
  `lifetime` bigint(11) default NULL,
  `handle` varchar(255) default NULL,
  `assoc_type` varchar(255) default NULL,
  `server_url` blob,
  `secret` blob,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `open_id_authentication_nonces` (
  `id` int(11) NOT NULL auto_increment,
  `timestamp` bigint(11) NOT NULL,
  `server_url` varchar(255) default NULL,
  `salt` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `order_transactions` (
  `id` int(11) NOT NULL auto_increment,
  `order_id` bigint(11) default NULL,
  `amount` bigint(11) default NULL,
  `success` tinyint(1) default NULL,
  `reference` varchar(255) default NULL,
  `message` varchar(255) default NULL,
  `action` varchar(255) default NULL,
  `params` text,
  `test` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `orders` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `address_line_1` text,
  `email` varchar(255) default NULL,
  `pay_type` varchar(10) default NULL,
  `pay_info` varchar(255) default NULL,
  `address_line_2` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(20) default NULL,
  `zip` varchar(10) default NULL,
  `country` varchar(50) default NULL,
  `ship_to` varchar(255) default NULL,
  `ship_address_line_1` varchar(255) default NULL,
  `ship_address_line_2` varchar(255) default NULL,
  `ship_city` varchar(255) default NULL,
  `ship_state` varchar(20) default NULL,
  `ship_zip` varchar(10) default NULL,
  `ship_country` varchar(50) default NULL,
  `created_at` datetime default NULL,
  `member_id` bigint(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_orders_member_id` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `page_versions` (
  `id` int(11) NOT NULL auto_increment,
  `page_id` bigint(11) default NULL,
  `version` bigint(11) default NULL,
  `parent_id` bigint(11) default NULL,
  `full_path` text,
  `title` varchar(255) default NULL,
  `slug` varchar(255) default NULL,
  `keywords` varchar(255) default NULL,
  `body` text,
  `filter_type` varchar(25) default 'Textile',
  `author` varchar(255) default NULL,
  `position` bigint(11) default '0',
  `updated_on` datetime default NULL,
  `created_on` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `payment_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `payment_types_sellers` (
  `payment_type_id` bigint(11) NOT NULL default '0',
  `seller_id` bigint(11) NOT NULL default '0',
  KEY `fk_payment_types_sellers_payment_type_id` (`payment_type_id`),
  KEY `fk_payment_types_sellers_seller_id` (`seller_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `people` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(40) default NULL,
  `email` varchar(100) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `activation_code` varchar(40) default NULL,
  `activated_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `points` (
  `id` int(11) NOT NULL auto_increment,
  `member_id` bigint(11) default NULL,
  `rating_id` bigint(11) default NULL,
  `feedback` text,
  `created_at` datetime default NULL,
  `created_by` bigint(11) default NULL,
  `line_item_id` bigint(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_points_member_id` (`member_id`),
  KEY `fk_points_line_item_id` (`line_item_id`),
  KEY `fk_created_by_points` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `product_images` (
  `id` int(11) NOT NULL auto_increment,
  `data` blob,
  `product_id` bigint(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_product_images_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `product_reviews` (
  `id` int(11) NOT NULL auto_increment,
  `isbn` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `author` varchar(255) default NULL,
  `publisher` varchar(255) default NULL,
  `content` text,
  `member_id` bigint(11) default NULL,
  `created_at` datetime default NULL,
  `rating_id` bigint(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_product_reviews_member_id` (`member_id`),
  KEY `fk_product_reviews_rating_id` (`rating_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `products` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `description` text,
  `price` float default '0',
  `condition` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `publish_at` datetime default NULL,
  `published` tinyint(1) default '1',
  `discount_desc` varchar(255) default NULL,
  `discount_price` float default NULL,
  `quantity_avail` bigint(11) NOT NULL default '1',
  `isbn` varchar(255) default NULL,
  `internal_id` varchar(255) default NULL,
  `status_id` smallint(2) default NULL,
  `seller_id` bigint(11) default NULL,
  `item_format_id` bigint(11) default NULL,
  `publisher_name` varchar(255) default NULL,
  `author` varchar(255) default NULL,
  `small_image_url` varchar(255) default NULL,
  `medium_image_url` varchar(255) default NULL,
  `large_image_url` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_products_seller_id` (`seller_id`),
  KEY `fk_products_item_format_id` (`item_format_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `products_publishers` (
  `product_id` bigint(11) NOT NULL default '0',
  `publisher_id` bigint(11) NOT NULL default '0',
  KEY `fk_products_publishers_product_id` (`product_id`),
  KEY `fk_products_publishers_publisher_id` (`publisher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `profiles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` text,
  `active` tinyint(1) default NULL,
  `member_id` bigint(11) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `zip` varchar(255) default NULL,
  `gender` varchar(255) default NULL,
  `birth_month` varchar(255) default NULL,
  `birth_day` varchar(255) default NULL,
  `educational_philosophy` varchar(255) default NULL,
  `curriculum` varchar(255) default NULL,
  `primary_motivation` varchar(255) default NULL,
  `strengths` varchar(255) default NULL,
  `current_grade_levels` varchar(255) default NULL,
  `number_of_children` varchar(255) default NULL,
  `ages_of_children` varchar(255) default NULL,
  `genders_of_children` varchar(255) default NULL,
  `primary_teacher` varchar(255) default NULL,
  `blog_url` varchar(255) default NULL,
  `flickr_url` varchar(255) default NULL,
  `you_tube_url` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `publishers` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `score` bigint(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sellers` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `address_line_1` varchar(255) default NULL,
  `address_line_2` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(20) default NULL,
  `zip` varchar(10) default NULL,
  `country` varchar(50) default NULL,
  `email` varchar(80) NOT NULL default '',
  `member_id` bigint(11) default NULL,
  `phone` varchar(30) default NULL,
  `pay_pal_id` varchar(255) default NULL,
  `merchant_id` varchar(255) default NULL,
  `image` blob,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `sessions_session_id_index` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `statuses` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('20080911023857');

INSERT INTO schema_migrations (version) VALUES ('20080911213723');

INSERT INTO schema_migrations (version) VALUES ('20080911221454');

INSERT INTO schema_migrations (version) VALUES ('20080911222014');

INSERT INTO schema_migrations (version) VALUES ('20080911222453');

INSERT INTO schema_migrations (version) VALUES ('20080917190408');

INSERT INTO schema_migrations (version) VALUES ('20080918135739');

INSERT INTO schema_migrations (version) VALUES ('20080918170625');

INSERT INTO schema_migrations (version) VALUES ('20080918171419');

INSERT INTO schema_migrations (version) VALUES ('20081010164205');

INSERT INTO schema_migrations (version) VALUES ('20081030023032');