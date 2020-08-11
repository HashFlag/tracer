/*
 Navicat Premium Data Transfer

 Source Server         : MySQL
 Source Server Type    : MySQL
 Source Server Version : 50725
 Source Host           : localhost:3306
 Source Schema         : tracer

 Target Server Type    : MySQL
 Target Server Version : 50725
 File Encoding         : 65001

 Date: 12/08/2020 00:12:04
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for app01_pricepolicy
-- ----------------------------
DROP TABLE IF EXISTS `app01_pricepolicy`;
CREATE TABLE `app01_pricepolicy`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `catogory` smallint(6) NOT NULL,
  `price` int(10) UNSIGNED NOT NULL,
  `project_num` int(10) UNSIGNED NOT NULL,
  `project_member` int(10) UNSIGNED NOT NULL,
  `project_space` int(10) UNSIGNED NOT NULL,
  `per_file_size` int(10) UNSIGNED NOT NULL,
  `title` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_pricepolicy
-- ----------------------------
INSERT INTO `app01_pricepolicy` VALUES (1, 1, 0, 5, 3, 50, 5, '免费版');
INSERT INTO `app01_pricepolicy` VALUES (2, 2, 100, 50, 30, 500, 50, 'VIP');
INSERT INTO `app01_pricepolicy` VALUES (3, 3, 200, 500, 300, 5000, 500, 'SVIP');

-- ----------------------------
-- Table structure for app01_project
-- ----------------------------
DROP TABLE IF EXISTS `app01_project`;
CREATE TABLE `app01_project`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `color` int(11) NOT NULL,
  `desc` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `use_space` int(11) NOT NULL,
  `star` tinyint(1) NOT NULL,
  `join_count` int(11) NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `creator_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `app01_project_name_create_id_529c2857_uniq`(`name`, `creator_id`) USING BTREE,
  INDEX `app01_project_creator_id_a0f98ca3_fk_app01_userinfo_id`(`creator_id`) USING BTREE,
  CONSTRAINT `app01_project_creator_id_a0f98ca3_fk_app01_userinfo_id` FOREIGN KEY (`creator_id`) REFERENCES `app01_userinfo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_project
-- ----------------------------
INSERT INTO `app01_project` VALUES (31, '打豆豆', 2, '专业打豆豆，专注于打豆豆。', 0, 1, 1, '2020-08-09 09:42:55.672796', 6);
INSERT INTO `app01_project` VALUES (32, '打豆豆2', 1, '打豆豆升级版', 0, 0, 1, '2020-08-09 09:43:46.630032', 6);
INSERT INTO `app01_project` VALUES (33, '打豆豆3', 3, '打豆豆加强版', 0, 0, 1, '2020-08-09 09:44:11.122542', 6);
INSERT INTO `app01_project` VALUES (34, '打怪兽', 4, '专注于打怪兽', 0, 0, 1, '2020-08-09 09:44:30.670844', 6);
INSERT INTO `app01_project` VALUES (35, '打怪兽2', 5, '大怪兽升级版', 0, 0, 1, '2020-08-09 09:45:15.535712', 6);
INSERT INTO `app01_project` VALUES (36, '起名字费劲', 3, '不喜欢起名字', 0, 0, 1, '2020-08-09 13:27:07.212594', 7);
INSERT INTO `app01_project` VALUES (37, '不喜欢起名字', 7, '艾弗森', 0, 1, 1, '2020-08-09 13:27:42.723256', 7);

-- ----------------------------
-- Table structure for app01_projectuser
-- ----------------------------
DROP TABLE IF EXISTS `app01_projectuser`;
CREATE TABLE `app01_projectuser`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `star` tinyint(1) NOT NULL,
  `create_datetime` datetime(6) NOT NULL,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `app01_projectuser_project_id_9d096d8d_fk_app01_project_id`(`project_id`) USING BTREE,
  INDEX `app01_projectuser_user_id_3a2c567a_fk_app01_userinfo_id`(`user_id`) USING BTREE,
  CONSTRAINT `app01_projectuser_project_id_9d096d8d_fk_app01_project_id` FOREIGN KEY (`project_id`) REFERENCES `app01_project` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app01_projectuser_user_id_3a2c567a_fk_app01_userinfo_id` FOREIGN KEY (`user_id`) REFERENCES `app01_userinfo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_projectuser
-- ----------------------------
INSERT INTO `app01_projectuser` VALUES (1, 0, '2020-08-09 21:29:52.000000', 36, 6);
INSERT INTO `app01_projectuser` VALUES (2, 0, '2020-08-09 21:29:58.000000', 37, 6);
INSERT INTO `app01_projectuser` VALUES (3, 0, '2020-08-09 21:30:01.000000', 35, 7);
INSERT INTO `app01_projectuser` VALUES (4, 0, '2020-08-09 21:30:03.000000', 34, 7);

-- ----------------------------
-- Table structure for app01_transaction
-- ----------------------------
DROP TABLE IF EXISTS `app01_transaction`;
CREATE TABLE `app01_transaction`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` smallint(6) NOT NULL,
  `order` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `count` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `start_datetime` datetime(6) NULL DEFAULT NULL,
  `end_datetime` datetime(6) NULL DEFAULT NULL,
  `create_datetime` datetime(6) NOT NULL,
  `price_policy_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order`(`order`) USING BTREE,
  INDEX `app01_transaction_price_policy_id_bf0af31b_fk_app01_pri`(`price_policy_id`) USING BTREE,
  INDEX `app01_transaction_user_id_fe8bacce_fk_app01_userinfo_id`(`user_id`) USING BTREE,
  CONSTRAINT `app01_transaction_price_policy_id_bf0af31b_fk_app01_pri` FOREIGN KEY (`price_policy_id`) REFERENCES `app01_pricepolicy` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app01_transaction_user_id_fe8bacce_fk_app01_userinfo_id` FOREIGN KEY (`user_id`) REFERENCES `app01_userinfo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_transaction
-- ----------------------------
INSERT INTO `app01_transaction` VALUES (1, 2, 'f43586fc-5384-474d-a982-da940006839e', 0, 0, '2020-08-09 17:30:29.606858', NULL, '2020-08-09 09:30:29.608776', 1, 6);
INSERT INTO `app01_transaction` VALUES (2, 2, 'fb7d9826-72e8-41f9-9ab3-6d79d44f47b5', 0, 0, '2020-08-09 21:25:48.401271', NULL, '2020-08-09 13:25:48.402247', 1, 7);

-- ----------------------------
-- Table structure for app01_userinfo
-- ----------------------------
DROP TABLE IF EXISTS `app01_userinfo`;
CREATE TABLE `app01_userinfo`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `email` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `app01_userinfo_phone_b65760b6_uniq`(`phone`) USING BTREE,
  UNIQUE INDEX `app01_userinfo_email_94e89ea2_uniq`(`email`) USING BTREE,
  UNIQUE INDEX `app01_userinfo_username_9d9c6733_uniq`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_userinfo
-- ----------------------------
INSERT INTO `app01_userinfo` VALUES (6, 'eric', '13fa9d5c00c25dadcb255beb2e788ff2', '17767962834', 'eric@163.com');
INSERT INTO `app01_userinfo` VALUES (7, 'jack', '13fa9d5c00c25dadcb255beb2e788ff2', '18582324628', 'jack@163.com');

-- ----------------------------
-- Table structure for app01_wiki
-- ----------------------------
DROP TABLE IF EXISTS `app01_wiki`;
CREATE TABLE `app01_wiki`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `content` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `deepth` int(11) NOT NULL,
  `parent_id` int(11) NULL DEFAULT NULL,
  `project_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `app01_wiki_parent_id_c95f7d68_fk_app01_wiki_id`(`parent_id`) USING BTREE,
  INDEX `app01_wiki_project_id_ec88a2ef_fk_app01_project_id`(`project_id`) USING BTREE,
  CONSTRAINT `app01_wiki_parent_id_c95f7d68_fk_app01_wiki_id` FOREIGN KEY (`parent_id`) REFERENCES `app01_wiki` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app01_wiki_project_id_ec88a2ef_fk_app01_project_id` FOREIGN KEY (`project_id`) REFERENCES `app01_project` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_wiki
-- ----------------------------
INSERT INTO `app01_wiki` VALUES (11, '哈哈哈', '哈哈哈哈', 1, NULL, 37);
INSERT INTO `app01_wiki` VALUES (12, '阿斯蒂', '阿松大', 1, NULL, 37);

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group
-- ----------------------------

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id`, `permission_id`) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id`, `codename`) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (5, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (8, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (9, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (10, 'Can add user', 4, 'add_user');
INSERT INTO `auth_permission` VALUES (11, 'Can change user', 4, 'change_user');
INSERT INTO `auth_permission` VALUES (12, 'Can delete user', 4, 'delete_user');
INSERT INTO `auth_permission` VALUES (13, 'Can add content type', 5, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (14, 'Can change content type', 5, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (15, 'Can delete content type', 5, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (16, 'Can add session', 6, 'add_session');
INSERT INTO `auth_permission` VALUES (17, 'Can change session', 6, 'change_session');
INSERT INTO `auth_permission` VALUES (18, 'Can delete session', 6, 'delete_session');
INSERT INTO `auth_permission` VALUES (19, 'Can add user info', 7, 'add_userinfo');
INSERT INTO `auth_permission` VALUES (20, 'Can change user info', 7, 'change_userinfo');
INSERT INTO `auth_permission` VALUES (21, 'Can delete user info', 7, 'delete_userinfo');
INSERT INTO `auth_permission` VALUES (22, 'Can add price policy', 8, 'add_pricepolicy');
INSERT INTO `auth_permission` VALUES (23, 'Can change price policy', 8, 'change_pricepolicy');
INSERT INTO `auth_permission` VALUES (24, 'Can delete price policy', 8, 'delete_pricepolicy');
INSERT INTO `auth_permission` VALUES (25, 'Can add project', 9, 'add_project');
INSERT INTO `auth_permission` VALUES (26, 'Can change project', 9, 'change_project');
INSERT INTO `auth_permission` VALUES (27, 'Can delete project', 9, 'delete_project');
INSERT INTO `auth_permission` VALUES (28, 'Can add project user', 10, 'add_projectuser');
INSERT INTO `auth_permission` VALUES (29, 'Can change project user', 10, 'change_projectuser');
INSERT INTO `auth_permission` VALUES (30, 'Can delete project user', 10, 'delete_projectuser');
INSERT INTO `auth_permission` VALUES (31, 'Can add transaction', 11, 'add_transaction');
INSERT INTO `auth_permission` VALUES (32, 'Can change transaction', 11, 'change_transaction');
INSERT INTO `auth_permission` VALUES (33, 'Can delete transaction', 11, 'delete_transaction');
INSERT INTO `auth_permission` VALUES (34, 'Can add wiki', 12, 'add_wiki');
INSERT INTO `auth_permission` VALUES (35, 'Can change wiki', 12, 'change_wiki');
INSERT INTO `auth_permission` VALUES (36, 'Can delete wiki', 12, 'delete_wiki');

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `first_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `last_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user
-- ----------------------------

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_groups_user_id_group_id_94350c0c_uniq`(`user_id`, `group_id`) USING BTREE,
  INDEX `auth_user_groups_group_id_97559544_fk_auth_group_id`(`group_id`) USING BTREE,
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user_groups
-- ----------------------------

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq`(`user_id`, `permission_id`) USING BTREE,
  INDEX `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user_user_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `content_type_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id`) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk`(`user_id`) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label`, `model`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (8, 'app01', 'pricepolicy');
INSERT INTO `django_content_type` VALUES (9, 'app01', 'project');
INSERT INTO `django_content_type` VALUES (10, 'app01', 'projectuser');
INSERT INTO `django_content_type` VALUES (11, 'app01', 'transaction');
INSERT INTO `django_content_type` VALUES (7, 'app01', 'userinfo');
INSERT INTO `django_content_type` VALUES (12, 'app01', 'wiki');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (4, 'auth', 'user');
INSERT INTO `django_content_type` VALUES (5, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (6, 'sessions', 'session');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2020-08-02 12:12:19.964536');
INSERT INTO `django_migrations` VALUES (2, 'auth', '0001_initial', '2020-08-02 12:12:28.197134');
INSERT INTO `django_migrations` VALUES (3, 'admin', '0001_initial', '2020-08-02 12:12:30.256295');
INSERT INTO `django_migrations` VALUES (4, 'admin', '0002_logentry_remove_auto_add', '2020-08-02 12:12:30.347188');
INSERT INTO `django_migrations` VALUES (5, 'app01', '0001_initial', '2020-08-02 12:12:30.675338');
INSERT INTO `django_migrations` VALUES (6, 'contenttypes', '0002_remove_content_type_name', '2020-08-02 12:12:31.723018');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0002_alter_permission_name_max_length', '2020-08-02 12:12:32.449720');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0003_alter_user_email_max_length', '2020-08-02 12:12:33.221998');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0004_alter_user_username_opts', '2020-08-02 12:12:33.277637');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0005_alter_user_last_login_null', '2020-08-02 12:12:33.749754');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0006_require_contenttypes_0002', '2020-08-02 12:12:33.792693');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0007_alter_validators_add_error_messages', '2020-08-02 12:12:33.857537');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0008_alter_user_username_max_length', '2020-08-02 12:12:35.823229');
INSERT INTO `django_migrations` VALUES (14, 'sessions', '0001_initial', '2020-08-02 12:12:36.565419');
INSERT INTO `django_migrations` VALUES (15, 'app01', '0002_auto_20200803_1306', '2020-08-03 05:06:39.185646');
INSERT INTO `django_migrations` VALUES (16, 'app01', '0003_auto_20200803_2248', '2020-08-03 14:49:07.135958');
INSERT INTO `django_migrations` VALUES (17, 'app01', '0004_auto_20200803_2314', '2020-08-03 15:14:17.837952');
INSERT INTO `django_migrations` VALUES (18, 'app01', '0005_auto_20200807_1300', '2020-08-07 05:01:15.709051');
INSERT INTO `django_migrations` VALUES (19, 'app01', '0006_auto_20200807_1614', '2020-08-07 08:14:29.176697');
INSERT INTO `django_migrations` VALUES (20, 'app01', '0007_auto_20200807_1615', '2020-08-07 08:16:04.086725');
INSERT INTO `django_migrations` VALUES (21, 'app01', '0008_auto_20200807_1618', '2020-08-07 08:18:36.719498');
INSERT INTO `django_migrations` VALUES (22, 'app01', '0009_auto_20200809_1041', '2020-08-09 02:42:03.149256');
INSERT INTO `django_migrations` VALUES (23, 'app01', '0010_pricepolicy_title', '2020-08-09 03:48:50.706888');
INSERT INTO `django_migrations` VALUES (24, 'app01', '0011_auto_20200809_1207', '2020-08-09 04:07:43.632118');
INSERT INTO `django_migrations` VALUES (25, 'app01', '0012_auto_20200809_1739', '2020-08-09 09:39:12.551067');
INSERT INTO `django_migrations` VALUES (26, 'app01', '0013_auto_20200809_2131', '2020-08-09 13:31:35.006355');
INSERT INTO `django_migrations` VALUES (27, 'app01', '0014_auto_20200811_1950', '2020-08-11 11:50:57.691584');
INSERT INTO `django_migrations` VALUES (28, 'app01', '0015_wiki', '2020-08-11 12:30:03.247672');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_session
-- ----------------------------
INSERT INTO `django_session` VALUES ('0cd8jbigun6qbfl91oydu6icyrxwgc7c', 'YjgwOWQ1ZWM0NzhjNTRhYWE5OTJlMzllOGJkNTA4Y2I1Y2ExNzYxMDp7ImltYWdlX2NvZGUiOiJDcVlQIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 16:38:48.437236');
INSERT INTO `django_session` VALUES ('0ls21vmyxgu7o0insan1vzoiao1q8axo', 'ZGU3YzlmZTc3NTU4ZTdlYjZkNmRjZDMxYzYzYTgxYzJhMWU1YzE2MDp7ImltYWdlX2NvZGUiOiJwZ3VBIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 15:45:27.693296');
INSERT INTO `django_session` VALUES ('0xlk6m7rinz2rnnjp9gdun4ophcywtmy', 'MzFiOWZjYWQxZTVmMWUyZmYxZmNjNGM0ZGUxYTZhMDEyNmM5ZjZhYjp7InVzZXJfaWQiOjQsImltYWdlX2NvZGUiOiIzSldYNiIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-09 09:19:29.214813');
INSERT INTO `django_session` VALUES ('12g7fpnvjlurr96ow8m7ykhrlyg49kn6', 'YmMyYzM1N2RlNzI4ZTc3NTNmYmY1ODUwZWM3ZjU5MjQzMzQyYzEzNzp7InVzZXJfaWQiOjF9', '2020-08-21 01:11:54.436922');
INSERT INTO `django_session` VALUES ('1cax3qel06w7b48ktvbbt9v6sjzak122', 'YTBiMjYwYmI1NThjNzNkNzM5NTFlOTNhMTQwYWM4MzIyZDRiY2Y3ZTp7ImltYWdlX2NvZGUiOiJkVE10IiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 15:37:43.933943');
INSERT INTO `django_session` VALUES ('26dtgng9cz8j3eba6crd9u37g5cmd9yj', 'NzU5MDcxYzZkNjJmY2I1NTYyZWQ1YWI2MjUzOGNmM2M0MTcwMmIxYTp7ImltYWdlX2NvZGUiOiJmVFR3TSIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-06 04:11:38.002345');
INSERT INTO `django_session` VALUES ('3c6fjqxo7yt5d71mu68vk8q81ebkwiyi', 'MGU4OTNjNDJiZThmNGQ0YzExNGQzNmYzYzgzMjc5ODM1ZjI1ODM2ZDp7ImltYWdlX2NvZGUiOiJ5SnVqYiIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-07 00:48:07.482142');
INSERT INTO `django_session` VALUES ('3td69jy6fb9qih4m1bl5lp2ibpegdb1l', 'YzA4MzZlODA2MDE5N2E3NjE4Y2MxZTczMGFlZjdmNmUyNWU4Mzc5ZDp7ImltYWdlX2NvZGUiOiJ0TmY2IiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 16:29:36.027908');
INSERT INTO `django_session` VALUES ('45hl9270j6skzkeotfrj072ydvqmmg7r', 'YzY2YjFlYmFiOTZkNGQ2ZmU5Nzg0MTI3MzRlOTAyOGVjNDFiMTRlYTp7ImltYWdlX2NvZGUiOiJBRnJKIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 16:12:32.117913');
INSERT INTO `django_session` VALUES ('4745imonlgrof7onyu1zytmtdtblj6qk', 'OGVlZDNiYjg2Yjg5YmU0OWJkMDczZDYxNDY1NzM5MWMzOTc4MDUzYjp7InVzZXJfaWQiOjd9', '2020-08-24 11:45:56.905719');
INSERT INTO `django_session` VALUES ('4iyyvwuw2i8cjk50ponmgeyu6ckshwlr', 'ZGQ4OGEzMWE0ZTNlYmY4MzAzYjBkMWJhMDQwMTlhNTU1ZGQ3ODJhMjp7ImltYWdlX2NvZGUiOiJDTnVZTSIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-06 13:10:18.356494');
INSERT INTO `django_session` VALUES ('4l115yee1nj2qcsaplpp7e65bdhv2l6k', 'NGY4MGJiNjJlYmJjN2RjY2ZhYjlhZmJlZmRjMzZhYzcxYjZjZWFjNzp7ImltYWdlX2NvZGUiOiJqNnBUIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 15:41:52.875289');
INSERT INTO `django_session` VALUES ('5ugwam02yov314eoss31cvfq2nyohyow', 'OGE2NGQ4OTU0ODViYWRkNDBkODJkMzJiYWQ0MTRiOWExMTM5NWFmODp7ImltYWdlX2NvZGUiOiJmSFJXIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 15:06:32.315096');
INSERT INTO `django_session` VALUES ('74syt2fxw6ljvkducny92i9hdh0nf47s', 'NjYxNzVlYmQyNTcxZmFmMGU3N2JiOTg2YjQ2ZGI1NzlmYzg0ZjRiMzp7ImltYWdlX2NvZGUiOiJ2RDczbSIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-06 05:01:50.025580');
INSERT INTO `django_session` VALUES ('90evbalu7smk7jsl7nfhbjm4rrzplsyc', 'NjdiYzM5NjI1NmM2NmM1ZDNkM2EwZDljMTg0MmRkZDFmZjMzNzg5ZDp7ImltYWdlX2NvZGUiOiJqazU2VSIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-06 04:53:27.199588');
INSERT INTO `django_session` VALUES ('9dthi1453eg9hvpcwgmjxwjqk2srnim7', 'ZjNkMWU5N2U0NTljNDFlNDc4YjdmNWEwZDhmMTFkMjExNWU2MTU2Yzp7ImltYWdlX2NvZGUiOiJLUkQzIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 16:18:49.895867');
INSERT INTO `django_session` VALUES ('bgr7lf295drztm8sy9pgwyoo0qk4vwy1', 'ZWRkNjIzN2FlNmE0ODE5OGNiNTdiMDlkMDdmMmZkMzM2YWY2ZjViNDp7ImltYWdlX2NvZGUiOiJ3RXhuIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 14:53:52.208090');
INSERT INTO `django_session` VALUES ('caku8p515vdl92jok5amnzyenzjqkgfl', 'YzdlOTkxY2Q3MTAyZjRjN2UzNzkyNTBjNmUxMGRkMDVkNzA4NGMzOTp7ImltYWdlX2NvZGUiOiJnZkJXIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 15:00:09.094289');
INSERT INTO `django_session` VALUES ('cxs772oh9yapezhmsc5wjhyp4x7wo12n', 'YjM3NTgwM2MyZTA1OTBkYTJiMTdhYWUwY2NiMGU2MzQzOGQxZjY2YTp7InVzZXJfaWQiOjEsImltYWdlX2NvZGUiOiJGZlV2QyIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-09 00:52:30.570087');
INSERT INTO `django_session` VALUES ('df5evtx1xkhi84vuiym1av5e1me5x752', 'OGVlZDNiYjg2Yjg5YmU0OWJkMDczZDYxNDY1NzM5MWMzOTc4MDUzYjp7InVzZXJfaWQiOjd9', '2020-08-24 11:23:49.988624');
INSERT INTO `django_session` VALUES ('dqttimtv6zp8c4xss3hie8apsia1tedk', 'NGU4MDhhMmI5NzFiZDJjODlmNmFiODNmMTk0MzVjYzczODcxZjdmMzp7ImltYWdlX2NvZGUiOiJNUkhqRiIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-06 04:48:53.998412');
INSERT INTO `django_session` VALUES ('du26l0vafk0d4pq1vljsyks6ig928ktm', 'YWE2MzU2M2U1MzhiYTdjMDFlNjlhNDU1ZDY5ZmYxYTEwMDAyNjMyYzp7ImltYWdlX2NvZGUiOiJ2cXdNZyIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-07 00:49:57.613834');
INSERT INTO `django_session` VALUES ('e9z99bneecabuxawqw5v16jl63oqe6co', 'YTlkZWU4YThjNGY1NGYzYjBlOGY3ZmM2YzJlNWE3MWQwMzJhNTAzMTp7ImltYWdlX2NvZGUiOiJIQ3llIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-06 00:24:52.468464');
INSERT INTO `django_session` VALUES ('eltc9l75zelzunhgksk8yz2hx5m7oozt', 'OWZmZTYwM2ZkNmVmZjI1ZDgxMjQ1MjhlZGQ2YWU2NzNkM2U3MjI1Mzp7InVzZXJfaWQiOjEsImltYWdlX2NvZGUiOiI4dnZCbSIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-07 02:25:55.444029');
INSERT INTO `django_session` VALUES ('f0jv5jl69n0vdd8c0x81boc7g3pzd4aw', 'OWI3NzZjMDI3YTgwOWUwOTFlNjY4YWM2OGY5MzUzN2ZkZTNiM2I3NDp7ImltYWdlX2NvZGUiOiJqYjdyOCIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-06 04:44:26.456953');
INSERT INTO `django_session` VALUES ('f82qwmqpqsta3tnx4h1b9pusfkmrrzl5', 'NTYzNjZlZDRkMGFjZTdiYWU3ZWUzMTBjYWI5NmU2MGQ2N2MxOTZhNDp7InVzZXJfaWQiOjEsImltYWdlX2NvZGUiOiJhWEtXRyIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-09 09:10:01.521808');
INSERT INTO `django_session` VALUES ('fhfj3k6r4j8pv38js7626f25019tmk8g', 'MzU1NDQwNDc0MzA3MTc3OGFhZjBkMTFkM2IyZGJlMTk1NmQwOTkxYjp7ImltYWdlX2NvZGUiOiJ0Tmt5dCIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-07 01:24:48.195126');
INSERT INTO `django_session` VALUES ('ft2zbuaglxi6ms7nhjvuqpjoy77unohd', 'NTdjMzE2MzA2YWUxNTVjMjRmMTc1MzhjYjAxYjFlNWQwOTdlYmEyYTp7ImltYWdlX2NvZGUiOiJKR2JYIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 15:13:15.543603');
INSERT INTO `django_session` VALUES ('g96fnz26tq3596401865gvhvqt8wascf', 'M2RkZjk5Y2QyODJmY2RlODFhMzhiNmRmZDZhNmJjNGY5MzhiNDI3ZTp7ImltYWdlX2NvZGUiOiJnZnZDIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 16:31:28.421182');
INSERT INTO `django_session` VALUES ('g9stl220pgdeu8p2gkl0dl0084xeyhof', 'Y2Q5MzFkNzIwZTFlNzc0ZDhmM2U0NzAzMDM1ZTQ5M2Y4YjU5MmJmZDp7ImltYWdlX2NvZGUiOiJHdW1SVCIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-06 04:50:31.108554');
INSERT INTO `django_session` VALUES ('gavxry50vbwkm5fgn01rqrudvuucayj6', 'OTFhMDFiYmU1YTNlOTY3Yzg4ZDY3NTFlODliOGM4ZjQxMjg5YjZiMTp7ImltYWdlX2NvZGUiOiJZd21rIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-06 00:40:28.136313');
INSERT INTO `django_session` VALUES ('gnd8c7kxp8mawyp3fgirlg5v2nsukh4p', 'ZTVjNmYyZmE4ZWE2MjY4MGM5MjFmZjJjM2U0ZjA1NWNiYzE4NTVmMjp7ImltYWdlX2NvZGUiOiJFMzR0IiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 15:32:55.378020');
INSERT INTO `django_session` VALUES ('h9zg1pwq813x4iezujmeg7auqfk767po', 'ZjZjMzhjMjE3N2Y2ZTQzZDRlMmIyZWVkZGFmOGM1YmI4NjA2MmU0Yzp7ImltYWdlX2NvZGUiOiJQNllWIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-06 01:03:18.635358');
INSERT INTO `django_session` VALUES ('hzm0q6rbtyk39sdgv7j5rz86hjhaji8k', 'OTU3NTUxNjJhNzY0NTZjODRjOTg0ZWUxOTQ5ZGJhNTFlMTdjMzE0Nzp7ImltYWdlX2NvZGUiOiJGeXdyIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-06 00:29:36.758947');
INSERT INTO `django_session` VALUES ('ir167ardc3lsogswo3drg4odnfwtsi0y', 'YzNjNTA1YjU0ZGNmNmI1YTYxMGRmOTFkYTk4ZmExOTRkZGE1NjlmYzp7ImltYWdlX2NvZGUiOiJqYTdrayIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-06 05:04:26.561535');
INSERT INTO `django_session` VALUES ('j4br5n7lhhnvhg6ty65wwbytzt7l8qyd', 'YmMyYzM1N2RlNzI4ZTc3NTNmYmY1ODUwZWM3ZjU5MjQzMzQyYzEzNzp7InVzZXJfaWQiOjF9', '2020-08-21 01:20:06.157827');
INSERT INTO `django_session` VALUES ('j563g0vgp0cka3rlsjoz8lywna930utz', 'M2Y5YzVmYmZiOGEzZjIzNGVhOTVkMTMwMjBkNGEwOGUzYTkzZDFlNzp7ImltYWdlX2NvZGUiOiJwZ05rIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 14:52:32.011369');
INSERT INTO `django_session` VALUES ('jcbkpkjij7lyh35bgj29t0qktgbk5wa3', 'Mzg0MjEwNGFhYjY0MDY0MmQ0OTYxOThjNDMwYTAxYzg5ZDY0MmYyNDp7ImltYWdlX2NvZGUiOiJDcTZtIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 15:39:44.774506');
INSERT INTO `django_session` VALUES ('jo44ygy8boejq02nl5x4epqq2hwqqvzw', 'MzU5MDRjZjJkNjQ2N2ViYWFiOWQyMjA4YjMzN2RkM2QwYTkzNGJkMzp7ImltYWdlX2NvZGUiOiJBdUtmNyIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-06 11:06:00.303802');
INSERT INTO `django_session` VALUES ('jvrjrr3vte2710iuo3tyv4eg8q5t7hfv', 'OTExMzI2MTU0OTQ1NTY0MmNmOTFhZDMzZjA4ZDQzODQwNzU2ZWZhNzp7ImltYWdlX2NvZGUiOiJSNFV4IiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 15:48:22.265461');
INSERT INTO `django_session` VALUES ('k8j7qqnqzefmodxlefad4yd607xdzzn3', 'ZGMxNWZhZThkMTFmZmIzMTRiMTVkNDljZTBmNjliYmM3NTJmMGY5Yjp7InVzZXJfaWQiOjN9', '2020-08-21 02:15:23.312539');
INSERT INTO `django_session` VALUES ('k9yaa4rzws4wsey1c6nxrg0bzgqvcce4', 'YTY1MTRlMTBmZmU5Y2IwNDQwMWZmYWE2YWY4MGY4MTkyNTE3MjBjNjp7ImltYWdlX2NvZGUiOiJTUUdiIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-06 05:08:12.616307');
INSERT INTO `django_session` VALUES ('kj710338nua6036mhzq2gqm4kgfi2byv', 'ZDNhMTAxMDJkNzM0Mjc5MGRjNzhiYTBkMTI3NzU5ZTZiOTIxZDkzNjp7ImltYWdlX2NvZGUiOiJwU0hlIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-06 00:31:46.228459');
INSERT INTO `django_session` VALUES ('koibtfoqql6i46yquaxvyv0pboxsyew7', 'MzlmYzZmNzdhMWYwZThhNWEzZjJmN2Y3YWU3Yzc5NWZkNDRiMGQ2Nzp7ImltYWdlX2NvZGUiOiJBREpFIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-06 00:36:17.602911');
INSERT INTO `django_session` VALUES ('lbcyt5tpm2xw1b35gixuuk3z33fax6bt', 'ZTNjMWVmNjZmNjU2MTNmNDkyMWU2ZTdhZTYzNjVhYjYyNjE5NjFlNzp7ImltYWdlX2NvZGUiOiJEcHJuIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 16:10:22.892176');
INSERT INTO `django_session` VALUES ('ldsgiaid8juxl78pbgbbe8smispcwd6j', 'ZGZmYmM4ODQ2MjljYTczYzM1ODkyMDA0NWExZTM4NzUyY2NmM2FlNTp7ImltYWdlX2NvZGUiOiJkQlBlOCIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-07 01:11:02.414051');
INSERT INTO `django_session` VALUES ('maniwgs6cz1vk63r5cixstsfrd18cx0x', 'Njc3YmFkNzZlOTBmNGRlNjA0NjAzNGM1ODczMDA1Yzg0ZjU2NzU0NTp7ImltYWdlX2NvZGUiOiJqWVF5IiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 16:21:54.840064');
INSERT INTO `django_session` VALUES ('mmwq52n20630disfbg6d09vbspxc43k5', 'ZTA1MTJiYzgxZGQ2ZmYyNGIyNmFkOTRhYjhjMzJkNTIwNmQ4YTgzMjp7InVzZXJfaWQiOjZ9', '2020-08-23 13:33:42.536375');
INSERT INTO `django_session` VALUES ('mrn1ocy0two1oeev94kr0gz6ku6rimu6', 'OTViZWJmOGRlYTI3ZGVmZjIxMmY2OTBhZDM1NmYwYzUyNDM2ODNjMDp7InVzZXJfaWQiOjcsImltYWdlX2NvZGUiOiJNZjhINSIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-10 00:51:47.882062');
INSERT INTO `django_session` VALUES ('ob4dgip1xgry2nxogizvcxn115ysywkw', 'ODIwODljOTY1MTEzMmUzNWYwZjkyZjhmM2E1NzQ3MzlkZjdjNjJiNzp7ImltYWdlX2NvZGUiOiI4bVI5IiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-06 01:17:19.538125');
INSERT INTO `django_session` VALUES ('osttqgy1u16de2oeleghaukxt1wzkdzx', 'YmMyYzM1N2RlNzI4ZTc3NTNmYmY1ODUwZWM3ZjU5MjQzMzQyYzEzNzp7InVzZXJfaWQiOjF9', '2020-08-21 01:26:09.305025');
INSERT INTO `django_session` VALUES ('otsap4k1hdotci31ibs25j0b8ellqp4v', 'MjVjYTcyOTYwZDVlZWExZDBjNmI2ZDkwZGUxZjliMTEyZTUwNjk4NDp7ImltYWdlX2NvZGUiOiJHZkVTVSIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-06 10:42:18.448967');
INSERT INTO `django_session` VALUES ('p3mq7jmn8hz0iueexdelk2myjm5lnrbi', 'OTg5ZDUyMzUwNWUxNGQyMzM0YmMwNjMxYTRiMWZkMmUzYmQxNTQwZTp7ImltYWdlX2NvZGUiOiJTNXFlIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 16:20:03.715643');
INSERT INTO `django_session` VALUES ('pfsenq0hln1uj097zwcst3vj5c5fs9d6', 'OTBhZmEzM2Q5YTkyY2U2YmY4ZDA1MWNjZTA4ZTI4ODM5NjM4OTMxZjp7ImltYWdlX2NvZGUiOiJIOVc3IiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-06 01:03:06.547386');
INSERT INTO `django_session` VALUES ('pylnb5ko6lgsi28ue9ep66rhe99haqaq', 'M2NhMWY5NGNlNWZhYjhjNzZhNjViZTAyMWY3Y2M4ZDBiZjAzZThkYTp7ImltYWdlX2NvZGUiOiJzVkVNIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-06 01:07:36.443253');
INSERT INTO `django_session` VALUES ('r8cfwqg09tsqwd4uy36mgaa8tcqrcekr', 'YjllM2NhMmJkNTA5NWIwZGVjZjFjMmNkMTUwODgzMDYxYjE5OGM0MTp7ImltYWdlX2NvZGUiOiJmVk1NUiIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-07 02:02:03.402552');
INSERT INTO `django_session` VALUES ('rweij9e5la85ia8ik8ivkfwrxi1iuew4', 'NzdkMzJkNjEzMmEyNzRmNzQ2NTI4ZTA5YTE4YzkyNzlhYWMwMTIwMTp7ImltYWdlX2NvZGUiOiI3UlBjIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 15:30:55.912182');
INSERT INTO `django_session` VALUES ('s031nnl9krzsns3eyss9xi1igtp11qsq', 'OTFiZmZmZDgzZmJiMDYyYTk1YTM2YjJjODQyMmRjZDRlYTdjNDJiMzp7ImltYWdlX2NvZGUiOiJCWXdNIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-06 05:07:54.097642');
INSERT INTO `django_session` VALUES ('ts8fy7l22zp4topy5oatkz33uvg6u11z', 'MTBlYWE4ZTdiYTc5NzVlMWYwNTc1ODZiMGVlN2ZjMjhjMzNjZWE5ODp7ImltYWdlX2NvZGUiOiJ0NUVGUyIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-07 02:27:23.254870');
INSERT INTO `django_session` VALUES ('tsbaaf9vz5gkkzer4awlirce7uzzjpnp', 'MjZiYzlhMmJjNGMyMzIyYWRiZWY3ZWE3MzdmZmZjODlmNGQwNWE3MDp7ImltYWdlX2NvZGUiOiJIZEtKIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 15:03:37.375926');
INSERT INTO `django_session` VALUES ('ue7avcl7w5224ld7v61qhcur7e67xez7', 'NGFiM2E3YjA0MDhlMTNlMWJhM2Q4M2IzN2EzZjU0ODFjYWQwNGE4NTp7InVzZXJfaWQiOjcsImltYWdlX2NvZGUiOiJNUXhINiIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-10 11:23:31.261900');
INSERT INTO `django_session` VALUES ('vkp6tmpkn2jd2h5loxpgmwi4yp8koa4q', 'MzE4ODI4MTcwNGMzYWE1MGY1YTc2YTUyZDllY2M4MzFlYTA4ODA2Yjp7ImltYWdlX2NvZGUiOiJZV3BxIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 15:35:48.972792');
INSERT INTO `django_session` VALUES ('w10nyh9elx5ys7sx2scxg44h16b9y0g5', 'Njg0ZDFlMGViZGY5ZmMyMzZhMGUyNjE0ZDRkNzE2NWY0YjlhYjYyZTp7ImltYWdlX2NvZGUiOiJlZ0Y3IiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-05 14:56:08.503799');
INSERT INTO `django_session` VALUES ('xij4a28u477kcxwm39fwk18vbgcwlwa7', 'NmU1OGQwNWM2YWU3ZGI1MDlkMTVhNTE1MjBmOTc2YTY5ZDlhYTBhODp7ImltYWdlX2NvZGUiOiI1Q3dheSIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-06 13:12:05.146122');
INSERT INTO `django_session` VALUES ('y0ig4suwrwdqcd3sb4bbd6r8o5qt077g', 'Zjg2YWY2MjY2OTIyMTdjYTkyZjhkNDBmODYwOTc4ZjA5ZTQyNWQ1Mjp7ImltYWdlX2NvZGUiOiJnbjlkIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-06 00:33:17.825941');
INSERT INTO `django_session` VALUES ('zzuhxi0alilm6xfcfj6humato73ydqvs', 'OGYwZGRlZjVhZGE4M2I0NGI4OWJkMjA0Y2YwMjMzYmNiY2E4N2I2ZTp7ImltYWdlX2NvZGUiOiJFVnZOIiwiX3Nlc3Npb25fZXhwaXJ5Ijo2MH0=', '2020-08-06 01:12:33.371829');

SET FOREIGN_KEY_CHECKS = 1;
