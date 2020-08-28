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

 Date: 28/08/2020 17:30:53
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for app01_filerepository
-- ----------------------------
DROP TABLE IF EXISTS `app01_filerepository`;
CREATE TABLE `app01_filerepository`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_type` smallint(6) NOT NULL,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `key` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `file_size` int(11) NULL DEFAULT NULL,
  `file_path` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `update_datetime` datetime(6) NOT NULL,
  `parent_id` int(11) NULL DEFAULT NULL,
  `project_id` int(11) NOT NULL,
  `update_user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `app01_filerepository_parent_id_246816f8_fk_app01_fil`(`parent_id`) USING BTREE,
  INDEX `app01_filerepository_project_id_4ef73a5e_fk_app01_project_id`(`project_id`) USING BTREE,
  INDEX `app01_filerepository_update_user_id_a2b1beff_fk_app01_use`(`update_user_id`) USING BTREE,
  CONSTRAINT `app01_filerepository_parent_id_246816f8_fk_app01_fil` FOREIGN KEY (`parent_id`) REFERENCES `app01_filerepository` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app01_filerepository_project_id_4ef73a5e_fk_app01_project_id` FOREIGN KEY (`project_id`) REFERENCES `app01_project` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app01_filerepository_update_user_id_a2b1beff_fk_app01_use` FOREIGN KEY (`update_user_id`) REFERENCES `app01_userinfo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 90 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_filerepository
-- ----------------------------
INSERT INTO `app01_filerepository` VALUES (86, 1, 'wlop.jpg', 'BAVQLZXTPS162656.jpg', 162656, 'http://be77cbd8-14e3-4985-baf4-f66ae3038c2c-8278.oss-cn-beijing.aliyuncs.com/BAVQLZXTPS162656.jpg', '2020-08-28 17:27:35.899164', NULL, 44, 8);
INSERT INTO `app01_filerepository` VALUES (87, 2, '打豆豆', NULL, NULL, NULL, '2020-08-28 17:27:40.897884', NULL, 44, 8);
INSERT INTO `app01_filerepository` VALUES (88, 2, '打怪兽', NULL, NULL, NULL, '2020-08-28 17:27:48.541427', 87, 44, 8);
INSERT INTO `app01_filerepository` VALUES (89, 1, 'wlop2.jpg', 'DTOHUHXQEP306909.jpg', 306909, 'http://be77cbd8-14e3-4985-baf4-f66ae3038c2c-8278.oss-cn-beijing.aliyuncs.com/DTOHUHXQEP306909.jpg', '2020-08-28 17:27:55.321780', 88, 44, 8);

-- ----------------------------
-- Table structure for app01_issues
-- ----------------------------
DROP TABLE IF EXISTS `app01_issues`;
CREATE TABLE `app01_issues`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `desc` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `priority` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `status` smallint(6) NOT NULL,
  `start_date` date NULL DEFAULT NULL,
  `end_date` date NULL DEFAULT NULL,
  `mode` smallint(6) NOT NULL,
  `create_datetime` datetime(6) NOT NULL,
  `latest_update_datetime` datetime(6) NOT NULL,
  `assign_id` int(11) NULL DEFAULT NULL,
  `creator_id` int(11) NOT NULL,
  `issues_type_id` int(11) NOT NULL,
  `module_id` int(11) NULL DEFAULT NULL,
  `parent_id` int(11) NULL DEFAULT NULL,
  `project_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `app01_issues_assign_id_8ea7e9b9_fk_app01_userinfo_id`(`assign_id`) USING BTREE,
  INDEX `app01_issues_creator_id_bf1a36c8_fk_app01_userinfo_id`(`creator_id`) USING BTREE,
  INDEX `app01_issues_issues_type_id_40451839_fk_app01_issuestype_id`(`issues_type_id`) USING BTREE,
  INDEX `app01_issues_module_id_7e5095eb_fk_app01_module_id`(`module_id`) USING BTREE,
  INDEX `app01_issues_parent_id_96a8baee_fk_app01_issues_id`(`parent_id`) USING BTREE,
  INDEX `app01_issues_project_id_57f76729_fk_app01_project_id`(`project_id`) USING BTREE,
  CONSTRAINT `app01_issues_assign_id_8ea7e9b9_fk_app01_userinfo_id` FOREIGN KEY (`assign_id`) REFERENCES `app01_userinfo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app01_issues_creator_id_bf1a36c8_fk_app01_userinfo_id` FOREIGN KEY (`creator_id`) REFERENCES `app01_userinfo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app01_issues_issues_type_id_40451839_fk_app01_issuestype_id` FOREIGN KEY (`issues_type_id`) REFERENCES `app01_issuestype` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app01_issues_module_id_7e5095eb_fk_app01_module_id` FOREIGN KEY (`module_id`) REFERENCES `app01_module` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app01_issues_parent_id_96a8baee_fk_app01_issues_id` FOREIGN KEY (`parent_id`) REFERENCES `app01_issues` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app01_issues_project_id_57f76729_fk_app01_project_id` FOREIGN KEY (`project_id`) REFERENCES `app01_project` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_issues
-- ----------------------------
INSERT INTO `app01_issues` VALUES (7, '去微软未确认', '阿斯顿发生打发十分的', 'danger', 3, '2020-08-28', '2020-08-28', 1, '2020-08-28 17:02:11.274213', '2020-08-28 17:02:11.274213', NULL, 8, 13, NULL, NULL, 43);
INSERT INTO `app01_issues` VALUES (8, '去微软未确认', '撒旦发生法发的', 'success', 4, '2020-08-28', '2020-08-30', 2, '2020-08-28 17:04:23.798831', '2020-08-28 17:04:23.798831', 8, 8, 16, NULL, NULL, 44);
INSERT INTO `app01_issues` VALUES (9, '去微软未确认', '爱的色放大大', 'danger', 6, '2020-08-28', NULL, 1, '2020-08-28 17:07:12.191951', '2020-08-28 17:07:12.191951', NULL, 8, 16, NULL, 8, 44);

-- ----------------------------
-- Table structure for app01_issues_attention
-- ----------------------------
DROP TABLE IF EXISTS `app01_issues_attention`;
CREATE TABLE `app01_issues_attention`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `issues_id` int(11) NOT NULL,
  `userinfo_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `app01_issues_attention_issues_id_userinfo_id_94da03f7_uniq`(`issues_id`, `userinfo_id`) USING BTREE,
  INDEX `app01_issues_attention_userinfo_id_8c4473ff_fk_app01_userinfo_id`(`userinfo_id`) USING BTREE,
  CONSTRAINT `app01_issues_attention_issues_id_d1e65f96_fk_app01_issues_id` FOREIGN KEY (`issues_id`) REFERENCES `app01_issues` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app01_issues_attention_userinfo_id_8c4473ff_fk_app01_userinfo_id` FOREIGN KEY (`userinfo_id`) REFERENCES `app01_userinfo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_issues_attention
-- ----------------------------
INSERT INTO `app01_issues_attention` VALUES (7, 7, 8);
INSERT INTO `app01_issues_attention` VALUES (8, 8, 8);

-- ----------------------------
-- Table structure for app01_issuesreply
-- ----------------------------
DROP TABLE IF EXISTS `app01_issuesreply`;
CREATE TABLE `app01_issuesreply`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reply_type` int(11) NOT NULL,
  `content` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `create_datetime` datetime(6) NOT NULL,
  `creator_id` int(11) NOT NULL,
  `issues_id` int(11) NOT NULL,
  `reply_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `app01_issuesreply_creator_id_4965da58_fk_app01_userinfo_id`(`creator_id`) USING BTREE,
  INDEX `app01_issuesreply_issues_id_f3a853ae_fk_app01_issues_id`(`issues_id`) USING BTREE,
  INDEX `app01_issuesreply_reply_id_6df066da_fk_app01_issuesreply_id`(`reply_id`) USING BTREE,
  CONSTRAINT `app01_issuesreply_creator_id_4965da58_fk_app01_userinfo_id` FOREIGN KEY (`creator_id`) REFERENCES `app01_userinfo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app01_issuesreply_issues_id_f3a853ae_fk_app01_issues_id` FOREIGN KEY (`issues_id`) REFERENCES `app01_issues` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app01_issuesreply_reply_id_6df066da_fk_app01_issuesreply_id` FOREIGN KEY (`reply_id`) REFERENCES `app01_issuesreply` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_issuesreply
-- ----------------------------

-- ----------------------------
-- Table structure for app01_issuestype
-- ----------------------------
DROP TABLE IF EXISTS `app01_issuestype`;
CREATE TABLE `app01_issuestype`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `project_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `app01_issuestype_project_id_e2535f95_fk_app01_project_id`(`project_id`) USING BTREE,
  CONSTRAINT `app01_issuestype_project_id_e2535f95_fk_app01_project_id` FOREIGN KEY (`project_id`) REFERENCES `app01_project` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_issuestype
-- ----------------------------
INSERT INTO `app01_issuestype` VALUES (13, '任务', 43);
INSERT INTO `app01_issuestype` VALUES (14, '功能', 43);
INSERT INTO `app01_issuestype` VALUES (15, 'Bug', 43);
INSERT INTO `app01_issuestype` VALUES (16, '任务', 44);
INSERT INTO `app01_issuestype` VALUES (17, '功能', 44);
INSERT INTO `app01_issuestype` VALUES (18, 'Bug', 44);

-- ----------------------------
-- Table structure for app01_module
-- ----------------------------
DROP TABLE IF EXISTS `app01_module`;
CREATE TABLE `app01_module`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `project_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `app01_module_project_id_57c7abf2_fk_app01_project_id`(`project_id`) USING BTREE,
  CONSTRAINT `app01_module_project_id_57c7abf2_fk_app01_project_id` FOREIGN KEY (`project_id`) REFERENCES `app01_project` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_module
-- ----------------------------
INSERT INTO `app01_module` VALUES (2, '第一阶段', 43);
INSERT INTO `app01_module` VALUES (3, '第一阶段', 44);
INSERT INTO `app01_module` VALUES (4, '第二阶段', 43);
INSERT INTO `app01_module` VALUES (5, '第二阶段', 44);

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
INSERT INTO `app01_pricepolicy` VALUES (2, 2, 200, 50, 30, 500, 50, 'VIP');
INSERT INTO `app01_pricepolicy` VALUES (3, 3, 500, 500, 300, 5000, 500, 'SVIP');

-- ----------------------------
-- Table structure for app01_project
-- ----------------------------
DROP TABLE IF EXISTS `app01_project`;
CREATE TABLE `app01_project`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `color` int(11) NOT NULL,
  `desc` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `use_space` bigint(20) NOT NULL,
  `star` tinyint(1) NOT NULL,
  `join_count` int(11) NOT NULL,
  `create_time` datetime(6) NOT NULL,
  `creator_id` int(11) NOT NULL,
  `bucket` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `region` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `app01_project_name_create_id_529c2857_uniq`(`name`, `creator_id`) USING BTREE,
  INDEX `app01_project_creator_id_a0f98ca3_fk_app01_userinfo_id`(`creator_id`) USING BTREE,
  CONSTRAINT `app01_project_creator_id_a0f98ca3_fk_app01_userinfo_id` FOREIGN KEY (`creator_id`) REFERENCES `app01_userinfo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_project
-- ----------------------------
INSERT INTO `app01_project` VALUES (43, '打豆豆', 1, '专业打豆豆18年，没有最专业，只有更专业', 0, 0, 1, '2020-08-28 17:01:22.901165', 8, '52ea5612-8721-47d4-9198-c52dd22a2047-8278', 'cn-beijing');
INSERT INTO `app01_project` VALUES (44, '打怪兽', 3, '专业打怪兽18年，没有最专业，只有更专业', 469565, 0, 1, '2020-08-28 17:03:44.679339', 8, 'be77cbd8-14e3-4985-baf4-f66ae3038c2c-8278', 'cn-beijing');

-- ----------------------------
-- Table structure for app01_projectinvite
-- ----------------------------
DROP TABLE IF EXISTS `app01_projectinvite`;
CREATE TABLE `app01_projectinvite`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `count` int(10) UNSIGNED NULL DEFAULT NULL,
  `use_count` int(10) UNSIGNED NOT NULL,
  `period` int(11) NOT NULL,
  `create_datetime` datetime(6) NOT NULL,
  `creator_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code`) USING BTREE,
  INDEX `app01_projectinvite_creator_id_47d9bfe9_fk_app01_userinfo_id`(`creator_id`) USING BTREE,
  INDEX `app01_projectinvite_project_id_002514a5_fk_app01_project_id`(`project_id`) USING BTREE,
  CONSTRAINT `app01_projectinvite_creator_id_47d9bfe9_fk_app01_userinfo_id` FOREIGN KEY (`creator_id`) REFERENCES `app01_userinfo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `app01_projectinvite_project_id_002514a5_fk_app01_project_id` FOREIGN KEY (`project_id`) REFERENCES `app01_project` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_projectinvite
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_projectuser
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_transaction
-- ----------------------------
INSERT INTO `app01_transaction` VALUES (16, 2, '8153f5a0-f220-4db4-8496-b4b3cca05281', 0, 0, '2020-08-28 17:00:27.097855', NULL, '2020-08-28 17:00:27.098820', 1, 8);

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_userinfo
-- ----------------------------
INSERT INTO `app01_userinfo` VALUES (8, 'eric', '13fa9d5c00c25dadcb255beb2e788ff2', '18582324628', 'eric@163.com');

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
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app01_wiki
-- ----------------------------
INSERT INTO `app01_wiki` VALUES (21, '哈哈哈', '啊手动阀手动阀手动阀十分', 1, NULL, 43);
INSERT INTO `app01_wiki` VALUES (22, '案说法', '阿斯顿发射点发范德萨', 1, NULL, 44);
INSERT INTO `app01_wiki` VALUES (23, 'd阿斯顿发生', '阿斯顿发射点发生发d', 2, 22, 44);
INSERT INTO `app01_wiki` VALUES (25, '去微软', '阿斯顿发撒打发', 1, NULL, 44);

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
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `auth_permission` VALUES (37, 'Can add file repository', 13, 'add_filerepository');
INSERT INTO `auth_permission` VALUES (38, 'Can change file repository', 13, 'change_filerepository');
INSERT INTO `auth_permission` VALUES (39, 'Can delete file repository', 13, 'delete_filerepository');
INSERT INTO `auth_permission` VALUES (40, 'Can add module', 14, 'add_module');
INSERT INTO `auth_permission` VALUES (41, 'Can change module', 14, 'change_module');
INSERT INTO `auth_permission` VALUES (42, 'Can delete module', 14, 'delete_module');
INSERT INTO `auth_permission` VALUES (43, 'Can add issues', 15, 'add_issues');
INSERT INTO `auth_permission` VALUES (44, 'Can change issues', 15, 'change_issues');
INSERT INTO `auth_permission` VALUES (45, 'Can delete issues', 15, 'delete_issues');
INSERT INTO `auth_permission` VALUES (46, 'Can add issues type', 16, 'add_issuestype');
INSERT INTO `auth_permission` VALUES (47, 'Can change issues type', 16, 'change_issuestype');
INSERT INTO `auth_permission` VALUES (48, 'Can delete issues type', 16, 'delete_issuestype');
INSERT INTO `auth_permission` VALUES (49, 'Can add issues reply', 17, 'add_issuesreply');
INSERT INTO `auth_permission` VALUES (50, 'Can change issues reply', 17, 'change_issuesreply');
INSERT INTO `auth_permission` VALUES (51, 'Can delete issues reply', 17, 'delete_issuesreply');
INSERT INTO `auth_permission` VALUES (52, 'Can add project invite', 18, 'add_projectinvite');
INSERT INTO `auth_permission` VALUES (53, 'Can change project invite', 18, 'change_projectinvite');
INSERT INTO `auth_permission` VALUES (54, 'Can delete project invite', 18, 'delete_projectinvite');

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
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (13, 'app01', 'filerepository');
INSERT INTO `django_content_type` VALUES (15, 'app01', 'issues');
INSERT INTO `django_content_type` VALUES (17, 'app01', 'issuesreply');
INSERT INTO `django_content_type` VALUES (16, 'app01', 'issuestype');
INSERT INTO `django_content_type` VALUES (14, 'app01', 'module');
INSERT INTO `django_content_type` VALUES (8, 'app01', 'pricepolicy');
INSERT INTO `django_content_type` VALUES (9, 'app01', 'project');
INSERT INTO `django_content_type` VALUES (18, 'app01', 'projectinvite');
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
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `django_migrations` VALUES (29, 'app01', '0016_auto_20200815_2057', '2020-08-15 12:57:20.074177');
INSERT INTO `django_migrations` VALUES (30, 'app01', '0017_filerepository', '2020-08-16 02:15:30.530872');
INSERT INTO `django_migrations` VALUES (31, 'app01', '0018_auto_20200817_0930', '2020-08-17 09:30:52.861167');
INSERT INTO `django_migrations` VALUES (32, 'app01', '0019_auto_20200817_2006', '2020-08-17 20:06:25.283841');
INSERT INTO `django_migrations` VALUES (33, 'app01', '0020_auto_20200819_1536', '2020-08-19 15:36:58.451902');
INSERT INTO `django_migrations` VALUES (34, 'app01', '0021_issuesreply', '2020-08-20 16:50:42.732963');
INSERT INTO `django_migrations` VALUES (35, 'app01', '0022_projectinvite', '2020-08-24 07:42:23.045335');

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
INSERT INTO `django_session` VALUES ('gj5n0trtb2uac6n629fkrqraj7ubr6rb', 'MTQ1MjU4MjM4YjBiYTc4MzkyMDY3NTBmYTMzOTE4MWVkNjg1YmMxNzp7InVzZXJfaWQiOjh9', '2020-09-11 17:00:36.769846');
INSERT INTO `django_session` VALUES ('rbifhooyes9sgpn11uqlhs5a6zlaqqa3', 'ZjEyYmQ5YjdiY2M0MThkYTI2MWJlNzAxYTQwMWQyYWRlY2E5Nzk4NDp7ImltYWdlX2NvZGUiOiJHa05kYSIsIl9zZXNzaW9uX2V4cGlyeSI6NjB9', '2020-08-28 16:59:31.313515');

SET FOREIGN_KEY_CHECKS = 1;
