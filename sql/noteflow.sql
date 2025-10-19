/*
 Navicat Premium Dump SQL

 Source Server         : 本地docker_Mysql
 Source Server Type    : MySQL
 Source Server Version : 80406 (8.4.6)
 Source Host           : localhost:3306
 Source Schema         : noteflow

 Target Server Type    : MySQL
 Target Server Version : 80406 (8.4.6)
 File Encoding         : 65001

 Date: 09/10/2025 14:41:34
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` bigint NOT NULL COMMENT '笔记分类id',
  `user_id` bigint NOT NULL COMMENT '创建者id',
  `name` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名称',
  `discription` text COLLATE utf8mb4_general_ci COMMENT '分类介绍',
  `color` varchar(7) COLLATE utf8mb4_general_ci DEFAULT '#007bff' COMMENT '十六进制颜色 “#007bff”',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for note_shares
-- ----------------------------
DROP TABLE IF EXISTS `note_shares`;
CREATE TABLE `note_shares` (
  `id` bigint NOT NULL COMMENT '笔记分享id',
  `note_id` bigint NOT NULL COMMENT '笔记id',
  `share_token` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '后端生成分享链接',
  `password` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分享密码',
  `expires_time` timestamp NULL DEFAULT NULL COMMENT '过期时间',
  `view_count` int DEFAULT NULL COMMENT '观看人数',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for note_tags
-- ----------------------------
DROP TABLE IF EXISTS `note_tags`;
CREATE TABLE `note_tags` (
  `id` bigint NOT NULL COMMENT '笔记标签对应id',
  `note_id` bigint NOT NULL COMMENT '笔记id',
  `tag_id` bigint NOT NULL COMMENT '标签id',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for notes
-- ----------------------------
DROP TABLE IF EXISTS `notes`;
CREATE TABLE `notes` (
  `id` bigint NOT NULL COMMENT '笔记id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `category_id` bigint NOT NULL COMMENT '分类id',
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '笔记名',
  `content` text COLLATE utf8mb4_general_ci COMMENT '笔记内容',
  `content_type` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'markdown' COMMENT '文件类型 (''markdwn'', ''html''...)',
  `is_public` tinyint DEFAULT '0' COMMENT '是否公开',
  `is_favourite` tinyint DEFAULT '0' COMMENT '是否添加喜欢',
  `is_archived` tinyint DEFAULT '0' COMMENT '是否归档',
  `view_count` int DEFAULT '0' COMMENT '观看次数',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for oauth_user
-- ----------------------------
DROP TABLE IF EXISTS `oauth_user`;
CREATE TABLE `oauth_user` (
  `id` bigint NOT NULL COMMENT '授权关联id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `provider` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT '第三方授权提供方（google github wechat...）',
  `provider_user_id` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '第三方平台用户id',
  `provider_username` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '第三方平台用户名',
  `access_token` text COLLATE utf8mb4_general_ci COMMENT '第三方访问token',
  `refresh_token` text COLLATE utf8mb4_general_ci COMMENT '第三方刷新token',
  `expires_time` timestamp NULL DEFAULT NULL COMMENT '过期时间',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for tags
-- ----------------------------
DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags` (
  `id` bigint NOT NULL COMMENT '标签id',
  `user_id` bigint NOT NULL COMMENT '创建者id',
  `name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '标签名',
  `color` varchar(7) COLLATE utf8mb4_general_ci DEFAULT '#28a745' COMMENT '标签颜色 (''#28a745'')',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `user_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `password_hash` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '加密密码',
  `email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户邮箱',
  `avatar_url` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户头像url',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '账户创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '账户信息更新时间',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '账户状态',
  `last_login_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '账户最后登陆时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

SET FOREIGN_KEY_CHECKS = 1;
