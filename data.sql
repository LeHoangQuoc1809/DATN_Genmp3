CREATE DATABASE  IF NOT EXISTS `genmp3` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `genmp3`;
-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: 192.168.0.106    Database: genmp3
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `album`
--

DROP TABLE IF EXISTS `album`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `album` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `release_date` datetime NOT NULL,
  `picture` varchar(255) NOT NULL,
  `artist_id` int NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_album_artist1_idx` (`artist_id`),
  CONSTRAINT `fk_album_artist1` FOREIGN KEY (`artist_id`) REFERENCES `artist` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `album`
--

LOCK TABLES `album` WRITE;
/*!40000 ALTER TABLE `album` DISABLE KEYS */;
INSERT INTO `album` VALUES (1,'Chưa','2024-07-25 07:58:00','1_photo',1,''),(2,'Nếu em muốn chia tay','2024-07-25 07:58:00','2_photo',1,''),(3,'Aucostic Bằng Kiều 2020','2024-07-25 08:00:00','177_photo',4,''),(4,'Album của Châu Khải Phong','2024-07-25 08:07:00','23_Anh-Dau-Muon-Thay-Em-Buon-Chau-Khai-Phong-ACV',1,'');
/*!40000 ALTER TABLE `album` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artist`
--

DROP TABLE IF EXISTS `artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artist` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `picture` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist`
--

LOCK TABLES `artist` WRITE;
/*!40000 ALTER TABLE `artist` DISABLE KEYS */;
INSERT INTO `artist` VALUES (1,'Châu Khải Phong','','1_Chau-Khai-Phong'),(2,'Trúc Anh Babe','','2_Truc-Anh-Babe'),(3,'Đỗ Minh Quân','','3_Do-Minh-Quan'),(4,'Bằng Kiều','','4_Bang-Kieu'),(5,'Tuấn Hưng','','5_Tuan-Hung');
/*!40000 ALTER TABLE `artist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artist_song`
--

DROP TABLE IF EXISTS `artist_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artist_song` (
  `artist_id` int NOT NULL,
  `song_id` int NOT NULL,
  `create_at` timestamp NOT NULL,
  PRIMARY KEY (`artist_id`,`song_id`),
  KEY `fk_artist_song_song1_idx` (`song_id`),
  CONSTRAINT `fk_artist_song_artist1` FOREIGN KEY (`artist_id`) REFERENCES `artist` (`id`),
  CONSTRAINT `fk_artist_song_song1` FOREIGN KEY (`song_id`) REFERENCES `song` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist_song`
--

LOCK TABLES `artist_song` WRITE;
/*!40000 ALTER TABLE `artist_song` DISABLE KEYS */;
INSERT INTO `artist_song` VALUES (1,1,'2024-07-24 18:03:42'),(1,2,'2024-07-24 18:05:43'),(1,3,'2024-07-24 18:08:50'),(1,4,'2024-07-24 18:10:51'),(1,5,'2024-07-24 18:12:48'),(1,6,'2024-07-24 18:14:09'),(1,7,'2024-07-24 18:15:55'),(1,8,'2024-07-24 18:18:01'),(1,9,'2024-07-24 18:20:28'),(1,10,'2024-07-24 18:25:24'),(1,11,'2024-07-24 18:28:38'),(1,12,'2024-07-24 18:30:06');
/*!40000 ALTER TABLE `artist_song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `follower`
--

DROP TABLE IF EXISTS `follower`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `follower` (
  `user_email` varchar(255) NOT NULL,
  `artist_id` int NOT NULL,
  PRIMARY KEY (`user_email`,`artist_id`),
  KEY `fk_follower_artist1_idx` (`artist_id`),
  CONSTRAINT `fk_follower_artist1` FOREIGN KEY (`artist_id`) REFERENCES `artist` (`id`),
  CONSTRAINT `fk_follower_user1` FOREIGN KEY (`user_email`) REFERENCES `user` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `follower`
--

LOCK TABLES `follower` WRITE;
/*!40000 ALTER TABLE `follower` DISABLE KEYS */;
/*!40000 ALTER TABLE `follower` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
INSERT INTO `genre` VALUES (1,'rock',''),(2,'vpop',''),(3,'ballad',''),(4,'edm',''),(5,'bolero',''),(6,'rap','');
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `time` timestamp NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `song_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `time_UNIQUE` (`time`),
  KEY `fk_history_user1_idx` (`user_email`),
  KEY `fk_history_song1_idx` (`song_id`),
  CONSTRAINT `fk_history_song1` FOREIGN KEY (`song_id`) REFERENCES `song` (`id`),
  CONSTRAINT `fk_history_user1` FOREIGN KEY (`user_email`) REFERENCES `user` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `history`
--

LOCK TABLES `history` WRITE;
/*!40000 ALTER TABLE `history` DISABLE KEYS */;
/*!40000 ALTER TABLE `history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlist`
--

DROP TABLE IF EXISTS `playlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modify_date` datetime NOT NULL,
  `picture` varchar(255) DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist`
--

LOCK TABLES `playlist` WRITE;
/*!40000 ALTER TABLE `playlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `playlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlist_song`
--

DROP TABLE IF EXISTS `playlist_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist_song` (
  `id` int NOT NULL AUTO_INCREMENT,
  `playlist_id` int NOT NULL,
  `song_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_playlist_song_song1_idx` (`song_id`),
  KEY `fk_playlist_song_playlist1_idx` (`playlist_id`),
  CONSTRAINT `fk_playlist_song_playlist1` FOREIGN KEY (`playlist_id`) REFERENCES `playlist` (`id`),
  CONSTRAINT `fk_playlist_song_song1` FOREIGN KEY (`song_id`) REFERENCES `song` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist_song`
--

LOCK TABLES `playlist_song` WRITE;
/*!40000 ALTER TABLE `playlist_song` DISABLE KEYS */;
/*!40000 ALTER TABLE `playlist_song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlist_user`
--

DROP TABLE IF EXISTS `playlist_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_email` varchar(255) NOT NULL,
  `playlist_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_playlist_user_user1` (`user_email`),
  KEY `fk_playlist_user_playlist1_idx` (`playlist_id`),
  CONSTRAINT `fk_playlist_user_playlist1` FOREIGN KEY (`playlist_id`) REFERENCES `playlist` (`id`),
  CONSTRAINT `fk_playlist_user_user1` FOREIGN KEY (`user_email`) REFERENCES `user` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist_user`
--

LOCK TABLES `playlist_user` WRITE;
/*!40000 ALTER TABLE `playlist_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `playlist_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recommended_playlist`
--

DROP TABLE IF EXISTS `recommended_playlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recommended_playlist` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_email` varchar(255) NOT NULL,
  `playlist_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_recommended_playlist_user1_idx` (`user_email`),
  KEY `fk_recommended_playlist_playlist1_idx` (`playlist_id`),
  CONSTRAINT `fk_recommended_playlist_playlist1` FOREIGN KEY (`playlist_id`) REFERENCES `playlist` (`id`),
  CONSTRAINT `fk_recommended_playlist_user1` FOREIGN KEY (`user_email`) REFERENCES `user` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recommended_playlist`
--

LOCK TABLES `recommended_playlist` WRITE;
/*!40000 ALTER TABLE `recommended_playlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `recommended_playlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `song`
--

DROP TABLE IF EXISTS `song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `song` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `duration` time NOT NULL,
  `picture` varchar(255) NOT NULL,
  `lyric` text,
  `album_id` int NOT NULL,
  `listen_count` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_song_album1_idx` (`album_id`),
  FULLTEXT KEY `name` (`name`),
  FULLTEXT KEY `name_2` (`name`),
  CONSTRAINT `fk_song_album1` FOREIGN KEY (`album_id`) REFERENCES `album` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song`
--

LOCK TABLES `song` WRITE;
/*!40000 ALTER TABLE `song` DISABLE KEYS */;
INSERT INTO `song` VALUES (1,'Chưa','00:04:35','1_Chua-Chau-Khai-Phong-Truc-Anh-Babe','[00:38.74] Chưa tìm thấy tình yêu\n[00:42.72] Chưa chạm lấy bình yên\n[00:46.44] Chưa gặp gỡ\n[00:48.30] Để nói một tiếng bắt đầu\n[00:54.43] Chưa nhận ra hợp nhau\n[00:58.14] Chưa đủ để dài lâu\n[01:02.13] Chưa hạnh phúc\n[01:03.67] Làm sao sẻ chia với ai khác\n[01:09.45] Ánh trăng kiêu sa nhìn người đang say\n[01:13.52] Bóng đêm kỉ niệm\n[01:14.78] Chính là bàn tay êm ái\n[01:19.00] Chỉ lòng mình không thấy\n[01:24.10] Thời gian qua thật sự đã quá dài\n[01:29.15] Xé nát cõi lòng anh\n[01:32.06] Giờ anh như một ngàn nỗi nhớ\n[01:35.52] Đến trong đêm buồn\n[01:40.04] Bình minh ơi đừng để anh ngóng đợi\n[01:44.54] Bởi trái tim nhỏ nhoi\n[01:47.48] Cần quan tâm\n[01:49.06] Cần làn hơi ấm của chỉ một người\n[01:54.12] Chẳng dễ để yêu một ai\n[02:00.70] Khi niềm tin đã vụn vỡ\n[02:02.57] Mang nỗi đau khiến tim điên dại\n[02:08.41] Chưa nhận ra đâu là yêu\n[02:10.26] Sao lại đau thấu nát tâm can\n[02:23.95] Thời gian sẽ trút u buồn tình yêu này\n[02:30.60] Ánh trăng kiêu sa nhìn người đang say\n[02:34.54] Bóng đêm kỉ niệm\n[02:36.14] Chính là bàn tay êm ái\n[02:40.38] Chỉ lòng mình không thấy\n[02:45.44] Thời gian qua thật sự đã quá dài\n[02:50.48] Xé nát cõi lòng anh\n[02:53.40] Và em như một ngàn nỗi nhớ\n[02:56.84] Đến trong đêm buồn\n[03:01.29] Bình minh ơi đừng để anh ngóng đợi\n[03:05.81] Bởi trái tim nhỏ nhoi\n[03:09.01] Cần quan tâm\n[03:10.33] Cần làn hơi ấm của chỉ một người\n[03:15.05] Chẳng dễ để yêu một ai\n[03:20.37] Thời gian qua thật sự đã quá dài\n[03:25.35] Xé nát cõi lòng anh\n[03:28.05] Và anh như một ngàn nỗi nhớ\n[03:31.76] Đến trong đêm buồn\n[03:36.02] Bình minh ơi đừng để anh ngóng đợi\n[03:40.83] Bởi trái tim nhỏ nhoi\n[03:43.48] Cần quan tâm\n[03:45.08] Cần làn hơi ấm của chỉ một người\n[03:50.11] Chẳng dễ để yêu một ai\n[03:56.23] Chưa tìm thấy tình yêu\n[04:00.00] Chưa chạm lấy bình yên\n[04:03.98] Chưa hạnh phúc\n[04:05.54] Làm sao sẻ chia với ai',1,0),(2,'Nếu em muốn chia tay','00:04:49','10_Neu-Em-Muon-Chia-Tay-Chau-Khai-Phong-ACV','[00:05.77] Người nói yêu anh làm chi\n[00:07.36] Để rồi nay phải chia ly\n[00:08.97] Ngày đầu bên nhau thì vui\n[00:10.97] Giờ đã mất đi tiếng cười\n[00:12.55] Có phải em đã yêu thêm\n[00:14.15] Một người một người mới\n[00:16.15] Bỏ lại anh chơi vơi giữa cuộc đời\n[00:18.93] Chỉ trách ta quá vội vàng\n[00:20.91] Tình mình hợp rồi lại tan\n[00:23.24] Cứ ngỡ trăm năm\n[00:24.44] Ai ngờ giờ quá xa xăm\n[00:26.02] Anh biết sẽ thật đau\n[00:27.64] Khi buông lời lìa xa nhau\n[00:29.63] Chúc em hạnh phúc bên người\n[00:31.63] Một đời dài lâu\n[01:01.93] Đã từng hạnh phúc đã từng rất vui\n[01:04.73] Anh ngỡ như là cả cuộc đời\n[01:07.91] Chuyện mình hôm nay\n[01:09.50] Có lẽ nên xem lại\n[01:11.49] Có phải em đã hết thương rồi\n[01:14.68] Anh không muốn hai ta\n[01:15.87] Cứ tiếp tục sống trong sai lầm\n[01:17.86] Cứ mãi lưng chừng chơi vơi\n[01:19.44] Chẳng đi đến đâu\n[01:21.45] Anh cảm thấy mình đang cô đơn\n[01:23.08] Giữa chính cuộc tình này\n[01:24.65] Có phải em giờ muốn mình chia tay\n[01:29.47] Người nói yêu anh làm chi\n[01:31.05] Để rồi nay phải chia ly\n[01:33.06] Ngày đầu bên nhau thì vui\n[01:35.05] Giờ đã mất đi tiếng cười\n[01:36.64] Có phải em đã yêu thêm\n[01:38.24] Một người một người mới\n[01:40.23] Bỏ lại anh chơi vơi giữa cuộc đời\n[01:43.01] Chỉ trách ta quá vội vàng\n[01:45.02] Tình mình hợp rồi lại tan\n[01:47.01] Cứ ngỡ trăm năm\n[01:48.19] Ai ngờ giờ quá xa xăm\n[01:50.18] Anh biết sẽ thật đau\n[01:51.36] Khi buông lời lìa xa nhau\n[01:53.76] Chúc em hạnh phúc bên người\n[01:55.77] Một đời dài lâu\n[02:25.53] Anh không muốn hai ta\n[02:26.31] Cứ tiếp tục sống trong sai lầm\n[02:28.33] Cứ mãi lưng chừng chơi vơi\n[02:29.91] Chẳng đi đến đâu\n[02:31.52] Anh cảm thấy mình đang cô đơn\n[02:33.51] Giữa chính cuộc tình này\n[02:35.11] Có phải em giờ muốn mình chia tay\n[03:06.03] Người nói yêu anh làm chi\n[03:07.23] Để rồi nay phải chia ly\n[03:09.22] Ngày đầu bên nhau thì vui\n[03:10.82] Giờ đã mất đi tiếng cười\n[03:12.42] Có phải em đã yêu thêm\n[03:14.00] Một người một người mới\n[03:16.00] Bỏ lại anh chơi vơi giữa cuộc đời\n[03:18.81] Chỉ trách ta quá vội vàng\n[03:20.81] Tình mình hợp rồi lại tan\n[03:22.79] Cứ ngỡ trăm năm\n[03:23.97] Ai ngờ giờ quá xa xăm\n[03:25.98] Anh biết sẽ thật đau\n[03:27.20] Khi buông lời lìa xa nhau\n[03:29.60] Chúc em hạnh phúc bên người\n[03:31.58] Một đời dài lâu\n[03:34.81] Người nói yêu anh làm chi\n[03:36.41] Để rồi nay bước ra đi\n[03:38.42] Ngày đầu bên nhau thì vui\n[03:40.05] Giờ đã mất đi tiếng cười\n[03:41.62] Có phải em đã yêu thêm\n[03:43.22] Một người một người mới\n[03:45.20] Bỏ lại anh chơi vơi giữa cuộc đời\n[03:48.42] Chỉ trách ta quá vội vàng\n[03:49.99] Tình mình hợp rồi lại tan\n[03:52.49] Cứ ngỡ trăm năm\n[03:53.67] Ai ngờ giờ quá xa xăm\n[03:55.68] Anh biết sẽ thật đau\n[03:56.89] Khi buông lời lìa xa nhau\n[03:59.10] Chúc em hạnh phúc bên người\n[04:00.67] Một đời dài lâu',2,0),(3,'Chốn phồn hoa','00:04:30','30_Chon-Phon-Hoa-Chau-Khai-Phong-ACV','[00:27.78] Ngày còn bình yên xơ xác mái hiên\n[00:32.76] Nắng mưa gió sương không than phiền\n[00:37.76] Hẹn ước về sau suốt kiếp có nhau\n[00:42.80] Nhưng ai nào ngờ sắp úa màu\n[00:46.52] Để ngày hôm nay hoen lệ cay\n[00:49.18] Thấy em đẹp trong chiếc váy\n[00:51.83] Tay nắm tay bên người ấy\n[00:56.54] Lặng nhìn từ sau không chào nhau\n[00:59.20] Hai bên họ đang đưa dâu\n[01:01.59] Nén nỗi đau\n[01:03.20] Quay lưng chạnh lòng bước mau\n[01:06.38] Bàn tay thấp hèn\n[01:07.99] Nào níu giữ được chữ duyên\n[01:11.45] Đời chẳng an yên\n[01:13.04] Tất cả cũng bởi vì bạc tiền\n[01:17.29] Nơi bình yên\n[01:19.15] Chỉ mỗi anh còn ôm mộng\n[01:22.53] Đêm đêm với chén đắng\n[01:23.86] U sầu nhớ mong\n[01:26.52] Người ta cho vàng\n[01:27.84] Chỉ để có được tấm thân\n[01:31.31] Đời lắm trái ngang\n[01:32.90] Cầu mong em không phải ân hận\n[01:37.42] Chốn phồn hoa\n[01:39.28] Lụa gấm ngọc ngà như ý\n[01:42.47] Bao nhiêu ân tình xưa\n[01:44.06] Em nỡ xóa đi\n[02:14.00] Để ngày hôm nay hoen lệ cay\n[02:16.65] Thấy em đẹp trong chiếc váy\n[02:19.31] Tay nắm tay bên người ấy\n[02:24.04] Lặng nhìn từ sau không chào nhau\n[02:26.69] Hai bên họ đang đưa dâu\n[02:29.08] Nén nỗi đau\n[02:30.68] Quay lưng chạnh lòng bước mau\n[02:34.07] Bàn tay thấp hèn\n[02:35.40] Nào níu giữ được chữ duyên\n[02:39.13] Đời chẳng an yên\n[02:40.46] Tất cả cũng bởi vì bạc tiền\n[02:44.98] Nơi bình yên\n[02:46.84] Chỉ mỗi anh còn ôm mộng\n[02:49.76] Đêm đêm với chén đắng\n[02:51.37] U sầu nhớ mong\n[02:54.02] Người ta cho vàng\n[02:55.35] Chỉ để có được tấm thân\n[02:58.81] Đời lắm trái ngang\n[03:00.40] Cầu mong em không phải ân hận\n[03:04.91] Chốn phồn hoa\n[03:06.77] Lụa gấm ngọc ngà như ý\n[03:09.96] Bao nhiêu ân tình xưa\n[03:11.55] Em nỡ xóa đi\n[03:16.34] Bàn tay thấp hèn\n[03:17.93] Nào níu giữ được chữ duyên\n[03:21.38] Đời chẳng an yên\n[03:22.98] Tất cả cũng bởi vì bạc tiền\n[03:27.49] Nơi bình yên\n[03:29.09] Chỉ mỗi anh còn ôm mộng\n[03:32.27] Đêm đêm với chén đắng\n[03:33.87] U sầu nhớ mong\n[03:36.52] Người ta cho vàng\n[03:37.85] Chỉ để có được tấm thân\n[03:41.32] Đời lắm trái ngang\n[03:42.92] Cầu mong em không phải ân hận\n[03:47.43] Chốn phồn hoa\n[03:49.29] Lụa gấm ngọc ngà như ý\n[03:52.48] Bao nhiêu ân tình xưa\n[03:53.81] Em nỡ xóa đi\n[03:59.91] Bao nhiêu ân tình xưa\n[04:05.70] Em nỡ xóa đi',4,0),(4,'Ân tình sang trang','00:05:19','52_An-Tinh-Sang-Trang-Chau-Khai-Phong-ACV','[00:40.33] Có bao giờ em thương anh thật lòng\n[00:45.91] Cách xa rồi cũng chỉ còn là số không\n[00:51.49] Thế nào là đủ, bao nhiêu cho vừa\n[00:57.87] Tình cảm anh trao nay quá dư thừa\n[01:02.65] Có bao giờ em nhớ thương một người\n[01:08.24] Chắc không phải anh\n[01:10.36] Nên em rời xa đấy thôi\n[01:13.82] Hứa hẹn cùng nhau đến khi bạc đầu\n[01:20.19] Lời ước thề kia em vứt đi đâu\n[01:24.97] Em cứ bước đi đi\n[01:27.10] Xem tình yêu này không có gì\n[01:30.57] Anh cũng chẳng cao sang\n[01:32.69] Chăm lo em toại nguyện như ý\n[01:36.15] Chuyện tình mình rẽ ngang\n[01:38.27] Khi em buông lời nói phũ phàng\n[01:41.72] Tất cả đã muộn màng\n[01:43.85] Nay ân tình mình vội sang trang\n[01:47.24] Vỡ nát trái tim anh\n[01:49.37] Bao đau thương chẳng ai chữa lành\n[01:52.82] Có níu cũng không thành đôi\n[01:55.21] Nên em lựa chọn xa cách\n[01:58.40] Một ngày dài chóng qua\n[02:00.54] Anh sẽ xóa hình bóng ấy mà\n[02:04.25] Tạm biệt em nhé\n[02:05.85] Cô thiếu nữ anh từng yêu\n[02:32.06] Chuyện tình mình khác xưa\n[02:54.30] Có bao giờ em nhớ thương một người\n[02:59.88] Chắc không phải anh\n[03:02.01] Nên em rời xa đấy thôi\n[03:05.46] Hứa hẹn cùng nhau đến khi bạc đầu\n[03:11.85] Lời ước thề kia em vứt đi đâu\n[03:16.57] Em cứ bước đi đi\n[03:18.69] Xem tình yêu này không có gì\n[03:22.14] Anh cũng chẳng cao sang\n[03:24.27] Chăm lo em toại nguyện như ý\n[03:27.72] Chuyện tình mình rẽ ngang\n[03:29.85] Khi em buông lời nói phũ phàng\n[03:33.23] Tất cả đã muộn màng\n[03:35.35] Nay ân tình mình vội sang trang\n[03:38.81] Vỡ nát trái tim anh\n[03:40.93] Bao đau thương chẳng ai chữa lành\n[03:44.38] Có níu cũng không thành đôi\n[03:46.77] Nên em lựa chọn xa cách\n[03:50.23] Một ngày dài chóng qua\n[03:52.09] Anh sẽ xóa hình bóng ấy mà\n[03:56.07] Tạm biệt em nhé\n[03:57.40] Cô thiếu nữ anh từng yêu\n[04:04.04] Em cứ bước đi đi\n[04:06.17] Xem tình yêu này không có gì\n[04:09.62] Anh cũng chẳng cao sang\n[04:11.74] Chăm lo em toại nguyện như ý\n[04:15.20] Chuyện tình mình rẽ ngang\n[04:17.32] Khi em buông lời nói phũ phàng\n[04:20.77] Tất cả đã muộn màng\n[04:22.84] Nay ân tình mình vội sang trang\n[04:26.49] Vỡ nát trái tim anh\n[04:28.35] Bao đau thương chẳng ai chữa lành\n[04:31.82] Có níu cũng không thành đôi\n[04:34.48] Nên em lựa chọn xa cách\n[04:37.40] Một ngày dài chóng qua\n[04:39.53] Anh sẽ xóa hình bóng ấy mà\n[04:43.51] Tạm biệt em nhé\n[04:44.84] Cô thiếu nữ anh từng yêu\n[04:51.75] Tạm biệt em nhé\n[04:53.07] Cô thiếu nữ anh từng yêu',4,0),(5,'Thương em','00:05:00','54_Thuong-Em-Chau-Khai-Phong-ACV','[00:37.60] Ngày mà em vui nhất\n[00:39.99] Là ngày em theo người\n[00:42.78] Trong áo hoa màu trắng\n[00:45.17] Miệng cười rất tươi\n[00:47.58] Buồn nào hơn lúc này\n[00:49.97] Đôi mắt khóe cay\n[00:52.37] Bâng khuâng đứng nhìn theo\n[00:55.15] Nỗi buồn khô héo\n[00:57.94] Người ta cho em\n[00:59.54] Cuộc sống trong sang giàu\n[01:02.33] Lụa là phấn son\n[01:04.32] Cầu mong em sẽ quên anh\n[01:07.91] Cuộc tình một thuở ấm êm\n[01:10.30] Nay đã phai màu\n[01:12.69] Đành ôm thương đau\n[01:13.88] Chúc em yên vui về sau\n[01:17.47] Thầm trách lương duyên\n[01:18.66] Cho anh gặp người con gái\n[01:20.66] Anh đã rất thương\n[01:23.33] Trong khi bản thân khốn khó đủ đường\n[01:28.11] Thương em ngày tháng bên anh\n[01:30.50] Em chẳng sung sướng\n[01:33.29] Từ nay hãy sống tốt\n[01:34.88] Bên người anh đã nhường\n[01:37.67] Nặng tình khóc trong cơn say\n[01:40.06] Lòng đau lắm em đâu có hay\n[01:43.25] Kể từ khi rời xa\n[01:45.24] Đến nay vẫn còn áy náy\n[01:48.43] Thương em cho đến khi\n[01:50.42] Cạn hơi thở vẫn thương\n[01:52.69] Thật xin lỗi không thể cùng em\n[01:55.08] Đến cuối con đường\n[02:28.97] Người ta cho em cuộc sống trong sang giàu\n[02:33.36] Lụa là phấn son\n[02:35.75] Cầu mong em sẽ quên anh\n[02:38.93] Cuộc tình một thuở ấm êm\n[02:41.33] Nay đã phai màu\n[02:43.32] Đành ôm thương đau\n[02:44.91] Chúc em yên vui về sau\n[02:48.50] Thầm trách lương duyên\n[02:49.72] Cho anh gặp người con gái\n[02:51.71] Anh đã rất thương\n[02:54.10] Trong khi bản thân khốn khó đủ đường\n[02:58.88] Thương em ngày tháng bên anh\n[03:01.67] Em chẳng sung sướng\n[03:04.06] Từ nay hãy sống tốt\n[03:06.05] Bên người anh đã nhường\n[03:08.44] Nặng tình khóc trong cơn say\n[03:11.23] Lòng đau lắm em đâu có hay\n[03:14.42] Kể từ khi rời xa đến nay\n[03:16.81] Vẫn còn áy náy\n[03:19.60] Thương em cho đến khi\n[03:21.22] Cạn hơi thở vẫn thương\n[03:23.61] Thật xin lỗi không thể cùng em\n[03:26.40] Đến cuối con đường\n[03:31.57] Thầm trách lương duyên\n[03:32.77] Cho anh gặp người con gái\n[03:34.36] Anh đã rất thương\n[03:37.16] Trong khi bản thân khốn khó đủ đường\n[03:41.93] Thương em ngày tháng bên anh\n[03:44.32] Em chẳng sung sướng\n[03:47.11] Từ nay hãy sống tốt\n[03:49.11] Bên người anh đã nhường\n[03:51.50] Nặng tình khóc trong cơn say\n[03:54.29] Lòng đau lắm em đâu có hay\n[03:57.47] Kể từ khi rời xa đến nay\n[03:59.87] Vẫn còn áy náy\n[04:02.25] Thương em cho đến khi\n[04:04.25] Cạn hơi thở vẫn thương\n[04:06.64] Thật xin lỗi không thể cùng em\n[04:09.03] Đến cuối con đường\n[04:15.00] Thương em cho đến khi\n[04:16.60] Cạn hơi thở vẫn thương\n[04:19.39] Thật xin lỗi không thể cùng em\n[04:25.36] Đến cuối con đường',4,0),(6,'Không trọn vẹn nữa','00:05:07','55_Khong-Tron-Ven-Nua-Chau-Khai-Phong-ACV','[00:41.59] Con đường hạnh phúc\n[00:43.09] Đôi ta từng bước qua\n[00:46.83] Cũng đã đến lúc\n[00:49.08] Kết thúc em à\n[00:52.84] Em đã thay đổi đã lừa dối\n[00:55.83] Tình cảm bấy lâu\n[00:58.08] Có lẽ thâm tâm\n[00:59.96] Em chẳng muốn vậy đâu\n[01:03.71] Anh thấy nhớ em nhớ vòng tay\n[01:06.70] Nhớ khoảnh khắc từng đắm say\n[01:09.33] Nhớ những chiều mưa\n[01:11.21] Vui đùa dưới mái tranh êm dịu bình yên\n[01:15.34] Thương em nhiều lắm\n[01:16.84] Thương tấm thân gầy mòn xơ xác lụi tàn\n[01:20.58] Thấy em đớn đau\n[01:22.83] Anh đâu chịu được nổi\n[01:25.82] Hôm qua em còn nơi đó\n[01:28.45] Hôm nay tan về nơi đâu\n[01:31.45] Anh chơi vơi giữa đêm thâu\n[01:33.72] Hỡi thế gian sao lắm u sầu\n[01:37.07] Cô ấy là cả thế giới\n[01:39.71] Là cả bầu trời tương lai\n[01:42.70] Mai này chẳng còn một ai\n[01:44.96] Bên cạnh anh lắng lo mỗi ngày\n[01:48.32] Kiếp này cho anh xin lỗi\n[01:50.96] Chẳng thể bước đi cùng em\n[01:53.95] Đi hết cuộc đời để xem\n[01:56.21] Mối lương duyên liệu có an bài\n[01:59.57] Tình yêu không trọn vẹn nữa\n[02:02.21] Anh đem cất giấu vào tim\n[02:05.20] Kiếp sau có duyên gặp lại\n[02:07.46] Anh chẳng để lạc mất em đâu\n[02:34.46] Anh thấy nhớ em nhớ vòng tay\n[02:37.09] Nhớ khoảnh khắc từng đắm say\n[02:39.70] Nhớ những chiều mưa\n[02:41.58] Vui đùa dưới mái tranh êm dịu bình yên\n[02:45.34] Thương em nhiều lắm\n[02:47.21] Thương tấm thân gầy mòn xơ xác lụi tàn\n[02:50.95] Thấy em đớn đau\n[02:53.21] Anh đâu chịu được nổi\n[02:55.82] Hôm qua em còn nơi đó\n[02:58.84] Hôm nay tan về nơi đâu\n[03:01.83] Anh chơi vơi giữa đêm thâu\n[03:04.08] Hỡi thế gian sao lắm u sầu\n[03:07.46] Cô ấy là cả thế giới\n[03:10.09] Là cả bầu trời tương lai\n[03:13.08] Mai này chẳng còn một ai\n[03:15.33] Bên cạnh anh lắng lo mỗi ngày\n[03:18.71] Kiếp này cho anh xin lỗi\n[03:21.34] Chẳng thể bước đi cùng em\n[03:24.33] Đi hết cuộc đời để xem\n[03:26.58] Mối lương duyên liệu có an bài\n[03:29.96] Tình yêu không trọn vẹn nữa\n[03:32.59] Anh đem cất giấu vào tim\n[03:35.58] Kiếp sau có duyên gặp lại\n[03:38.21] Anh chẳng để lạc mất em đâu\n[03:41.21] Hôm qua em còn nơi đó\n[03:43.84] Hôm nay tan về nơi đâu\n[03:46.83] Anh chơi vơi giữa đêm thâu\n[03:49.08] Hỡi thế gian sao lắm u sầu\n[03:52.46] Cô ấy là cả thế giới\n[03:55.45] Là cả bầu trời tương lai\n[03:58.08] Mai này chẳng còn một ai\n[04:00.63] Bên cạnh anh để lo lắng\n[04:03.64] Kiếp này cho anh xin lỗi\n[04:06.64] Chẳng thể bước đi cùng em\n[04:09.63] Đi hết cuộc đời để xem\n[04:11.88] Mối lương duyên liệu có an bài\n[04:14.89] Tình yêu không trọn vẹn nữa\n[04:17.89] Anh đem cất giấu vào tim\n[04:20.89] Kiếp sau có duyên gặp lại\n[04:23.13] Anh chẳng để lạc mất em đâu\n[04:29.43] Kiếp sau có duyên gặp lại\n[04:31.67] Anh chẳng để lạc mất em đâu',4,0),(7,'Sợ ta mất nhau','00:04:45','59_So-Ta-Mat-Nhau-Chau-Khai-Phong-ACV','[00:40.85] Có những lúc anh hay nặng lời\n[00:44.97] Nói với em những câu chuyện không vui\n[00:49.48] Thật tâm anh cũng chẳng muốn đâu người ơi\n[00:54.36] Vì yêu em quá nên anh sợ cô đơn chơi vơi\n[00:59.23] Anh biết rằng ngoài kia có bao người yêu em\n[01:04.11] Nên anh sợ một ngày anh chẳng thể níu lấy\n[01:08.60] Đôi tay này và tình yêu này\n[01:13.10] Sợ đến một ngày em vội vàng lìa xa anh\n[01:18.36] Anh sợ lắm em ơi, sợ mỗi khi đêm về\n[01:22.85] Khi chẳng còn em chẳng có, tay ai vỗ về\n[01:27.72] Anh sợ khi em nói câu chia tay phũ phàng\n[01:32.60] Sợ duyên chưa hợp mà tình lại lìa tan\n[01:37.09] Sợ tình mình mong manh\n[01:38.97] Sau cơn mưa sẽ vỡ tan tành\n[01:41.99] Sợ em vội theo ai em xa rời anh\n[01:46.85] Sợ đắng cay nếu như tình mình gặp không may\n[01:51.72] Sợ chung con đường nhưng hai ta đi ngược hướng\n[02:35.23] Anh biết rằng ngoài kia có bao người yêu em\n[02:39.73] Nên anh sợ một ngày anh chẳng thể níu lấy\n[02:44.59] Đôi tay này và tình yêu này\n[02:49.11] Sợ đến một ngày em vội vàng lìa xa anh\n[02:53.98] Anh sợ lắm em ơi, sợ mỗi khi đêm về\n[02:58.86] Khi chẳng còn em chẳng có, tay ai vỗ về\n[03:03.73] Anh sợ khi em nói câu chia tay phũ phàng\n[03:08.61] Sợ duyên chưa hợp mà tình lại lìa tan\n[03:12.74] Sợ tình mình mong manh\n[03:14.60] Sau cơn mưa sẽ vỡ tan tành\n[03:17.98] Sợ em vội theo ai em xa rời anh\n[03:22.47] Sợ đắng cay nếu như tình mình gặp không may\n[03:27.73] Sợ chung con đường nhưng hai ta đi ngược hướng\n[03:35.60] Anh sợ lắm em ơi, sợ mỗi khi đêm về\n[03:39.73] Khi chẳng còn em chẳng có, tay ai vỗ về\n[03:44.61] Anh sợ khi em nói câu chia tay phũ phàng\n[03:49.10] Sợ duyên chưa hợp mà tình lại lìa tan\n[03:53.61] Sợ tình mình mong manh\n[03:55.47] Sau cơn mưa sẽ vỡ tan tành\n[03:58.85] Sợ em vội theo ai em xa rời anh\n[04:03.73] Sợ đắng cay nếu như tình mình gặp không may\n[04:08.54] Sợ chung con đường nhưng hai ta đi ngược hướng\n[04:16.03] Sợ đắng cay nếu như tình mình gặp không may\n[04:20.54] Sợ chung con đường nhưng hai ta đi ngược hướng',4,0),(8,'Anh làm gì sai','00:04:59','62_Anh-Lam-Gi-Sai-Chau-Khai-Phong-ACV','[00:39.36] Ngày xưa em đã nói\n[00:41.81] Em thương anh nhất mà\n[00:44.81] Ngày xưa em cũng nói\n[00:47.31] Yêu anh cho đến già\n[00:50.56] Mà giờ đây em đã\n[00:53.31] Thương thêm ai nữa à\n[00:56.25] Có lẽ bây giờ\n[00:57.51] Em muốn ta rời xa\n[01:00.26] Anh cũng đã từng nghĩ rằng\n[01:02.51] Em coi anh là tất cả\n[01:05.72] Nhưng sao hôm nay\n[01:08.16] Anh mới nhận ra là\n[01:11.41] Em đã có thêm một người\n[01:13.91] Một người thứ hai\n[01:17.17] Và em buông lời nói\n[01:19.66] Chúng ta nên dừng lại\n[01:22.67] Em ơi anh làm gì sai\n[01:25.16] Sao em nỡ buông câu dừng lại\n[01:28.42] Em ơi anh làm gì sai\n[01:30.67] Sao em yêu thêm người thứ hai\n[01:33.91] Anh thương em thật lòng đấy\n[01:36.42] Sao em không thương anh thật lòng\n[01:40.80] Tình cảm đó em coi là số không\n[01:45.31] Nếu anh đã làm gì sai\n[01:47.81] Thì xin em nói\n[01:51.55] Em nói đi em sao cứ im lặng\n[01:56.74] Tình mình bao lâu\n[01:59.25] Nay hóa thành tro tàn\n[02:02.21] Đớn đau này anh gánh\n[02:04.19] Hạnh phúc còn lại nhường em\n[02:30.43] Anh cũng đã từng nghĩ rằng\n[02:32.93] Em coi anh là tất cả\n[02:36.11] Nhưng sao hôm nay\n[02:38.61] Anh mới nhận ra là\n[02:41.61] Em đã có thêm một người\n[02:44.30] Một người thứ hai\n[02:47.30] Và em buông lời nói\n[02:49.81] Chúng ta nên dừng lại\n[02:53.06] Em ơi anh làm gì sai\n[02:55.56] Sao em nỡ buông câu dừng lại\n[02:58.80] Em ơi anh làm gì sai\n[03:01.05] Sao em yêu thêm người thứ hai\n[03:04.31] Anh thương em thật lòng đấy\n[03:06.80] Sao em không thương anh thật lòng\n[03:11.25] Tình cảm đó em coi là số không\n[03:15.50] Nếu anh đã làm gì sai\n[03:18.00] Thì xin em nói\n[03:22.00] Em nói đi em sao cứ im lặng\n[03:26.95] Tình mình bao lâu\n[03:29.40] Nay hóa thành tro tàn\n[03:32.60] Đớn đau này anh gánh\n[03:34.61] Hạnh phúc còn lại nhường em\n[03:41.11] Em ơi anh làm gì sai\n[03:43.60] Sao em nỡ buông câu dừng lại\n[03:46.61] Em ơi anh làm gì sai\n[03:49.10] Sao em yêu thêm người thứ hai\n[03:52.36] Anh thương em thật lòng đấy\n[03:54.86] Sao em không thương anh thật lòng\n[03:58.81] Tình cảm đó em coi là số không\n[04:03.55] Nếu anh đã làm gì sai\n[04:06.07] Thì xin em nói\n[04:10.02] Em nói đi em sao cứ im lặng\n[04:14.78] Tình mình bao lâu\n[04:17.53] Nay hóa thành tro tàn\n[04:20.52] Đớn đau này anh gánh\n[04:22.78] Hạnh phúc còn lại nhường em\n[04:29.02] Đớn đau này anh gánh\n[04:31.28] Hạnh phúc còn lại nhường em',4,0),(9,'Khách sang đò','00:05:38','67_Khach-Sang-Do-Chau-Khai-Phong','[00:28.57]Anh sẽ chẳng thể im lặng\r\n[00:30.94]Khi quan tâm người lãng quên\r\n[00:35.32]Anh sẽ chẳng cách xa đâu\r\n[00:37.80]Vì thứ ta không còn giữ nữa\r\n[00:43.49]Vì tôi muốn uống cho say \r\n[00:47.17]Để chẳng phải mơ \r\n[00:50.18]Mơ làm chi để \r\n[00:52.05]Khi thức dậy phải nhớ \r\n[00:57.11]Đời tôi vốn quá chua cay \r\n[01:01.11]Nên chẳng thích thơ \r\n[01:03.74]Ngâm vài câu thấy đau \r\n[01:06.61]Nên đành bỏ lỡ \r\n[01:18.25]Đợi một chút để tôi \r\n[01:21.57]Đi vay đời mấy trăm \r\n[01:24.82]Xem người ta bỏ nhau \r\n[01:27.57]Diễn trò quan tâm \r\n[01:32.07]Đợi tôi bán chút đau thương \r\n[01:35.63]Trả đời mấy xu \r\n[01:38.05]Khách sang đò còn \r\n[01:39.86]Tư cách đâu tò mò chuyện cũ \r\n[01:44.36]Lời yêu thương em đã xóa\r\n[01:47.74]Sao lại mủi lòng đắn đo \r\n[01:51.11]Nghiệt ngã theo sau \r\n[01:53.68]Ngay từ khi chúng ta hẹn hò \r\n[01:57.99]Dù cho yêu nhau đến mấy\r\n[02:01.67]Mặn nồng rồi thì đắng cay \r\n[02:05.67]Tại lỗi duyên phận \r\n[02:08.05]Không phải em đâu đừng áy náy \r\n[02:12.05]Đừng nhìn anh đôi mắt đó\r\n[02:15.42]Chỉ làm nghẹn lòng lắng lo \r\n[02:19.67]Bởi lẽ bây giờ em chỉ \r\n[02:22.42]Như khách đã sang đò \r\n[02:26.11]Đừng lôi anh về quá khứ \r\n[02:29.36]Rồi thì thầm rằng giá như \r\n[02:33.36]Chẳng muốn chẳng cần\r\n[02:35.55]Đau lắm anh chẳng muốn giữ\r\n[02:40.32]\r\n[02:54.82]Anh sẽ chẳng thể im lặng\r\n[02:57.13]Khi quan tâm người lãng quên\r\n[03:01.32]Anh sẽ chẳng cách xa đâu\r\n[03:03.95]Vì thứ ta không còn giữ nữa\r\n[03:09.51]Đợi một chút để tôi \r\n[03:13.13]Đi vay đời mấy trăm \r\n[03:16.26]Xem người ta bỏ nhau \r\n[03:18.63]Diễn trò quan tâm \r\n[03:23.32]Đợi tôi bán chút đau thương \r\n[03:27.34]Trả đời mấy xu \r\n[03:29.40]Khách sang đò còn \r\n[03:31.27]Tư cách đâu tò mò chuyện cũ \r\n[03:35.52]Lời yêu thương em đã xóa\r\n[03:38.84]Sao lại mủi lòng đắn đo \r\n[03:42.90]Nghiệt ngã theo sau \r\n[03:45.17]Ngay từ khi chúng ta hẹn hò \r\n[03:49.54]Dù cho yêu nhau đến mấy\r\n[03:52.79]Mặn nồng rồi thì đắng cay \r\n[03:56.98]Tại lỗi duyên phận \r\n[03:58.85]Không phải em đâu đừng áy náy \r\n[04:03.29]Đừng nhìn anh đôi mắt đó\r\n[04:06.79]Chỉ làm nghẹn lòng lắng lo \r\n[04:11.04]Bởi lẽ bây giờ em chỉ \r\n[04:13.91]Như khách đã sang đò \r\n[04:17.29]Đừng lôi anh về quá khứ \r\n[04:20.66]Rồi thì thầm rằng giá như \r\n[04:24.60]Chẳng muốn chẳng cần\r\n[04:26.85]Đau lắm anh chẳng muốn giữ\r\n[04:31.21]Đừng nhìn anh đôi mắt đó\r\n[04:34.58]Chỉ làm nghẹn lòng lắng lo \r\n[04:38.43]Bởi lẽ bây giờ em chỉ \r\n[04:40.68]Như khách đã sang đò \r\n[04:45.11]Đừng lôi anh về quá khứ \r\n[04:48.55]Rồi thì thầm rằng giá như \r\n[04:52.46]Chẳng muốn chẳng cần\r\n[04:54.71]Đau lắm anh chẳng muốn giữ\r\n[04:59.52]Chẳng muốn chẳng cần\r\n[05:02.02]Đau lắm anh chẳng muốn giữ\r\n[05:16.96]',4,0),(10,'Áo cũ tình mới','00:04:07','79_Ao-Cu-Tinh-Moi-Chau-Khai-Phong','[ar: Áo Cũ Tình Mới]\r\n[length: 05:07]\r\n[00:00.00]Bài hát: Áo Cũ Tình Mới\r\n[00:02.00]Ca sĩ: Châu Khải Phong\r\n[00:04.00]\r\n[00:48.44]Anh như áo cũ em mặc nhiều lần \r\n[00:52.91]Em chê áo cũ chẳng có gì quý thân \r\n[00:57.53]Em tìm áo mới để thay phủ phàng \r\n[01:01.81]Quên bao năm tháng \r\n[01:03.34]Khiến anh ngỡ ngàng \r\n[01:06.56]Khi xưa em hứa đôi ta lâu dài \r\n[01:10.89]Em nói đạo lý nhưng em lại sống sai  \r\n[01:15.72]Bỏ mặc điều tiếng thế gian chê cười \r\n[01:20.02]Vội mặc áo mới với ai cười rất tươi \r\n[01:24.55]\r\n[01:29.22]Chiếc áo thay màu \r\n[01:30.81]Đắng cay phần anh mang \r\n[01:33.83]Em đổi thay lòng \r\n[01:35.41]Khiến ân tình sang ngang \r\n[01:38.25]Chiếc áo cũ rồi \r\n[01:39.57]Người vứt đi chẳng tiếc đời \r\n[01:42.85]Để ngày hôm nay em mặc áo mới \r\n[01:47.39]Người chẳng trân trọng \r\n[01:48.73]Những thứ quan trọng bên mình \r\n[01:51.81]Vì trong cuộc đời \r\n[01:53.19]Nào dễ kiếm được chân tình \r\n[01:56.25]Để mất đi rồi \r\n[01:57.66]Cảm thấy ân hận trong lòng \r\n[02:00.78]Áo mới tuy đẹp \r\n[02:02.18]Nhưng chật đúng không?\r\n[02:05.63]\r\n[02:43.82]Khi xưa em hứa đôi ta lâu dài \r\n[02:48.35]Em nói đạo lý nhưng em lại sống sai  \r\n[02:52.96]Bỏ mặc điều tiếng thế gian chê cười \r\n[02:57.32]Vội mặc áo mới với ai cười rất tươi \r\n[03:02.00]\r\n[03:06.59]Chiếc áo thay màu \r\n[03:07.88]Đắng cay phần anh mang \r\n[03:11.13]Em đổi thay lòng \r\n[03:12.79]Khiến ân tình sang ngang \r\n[03:15.48]Chiếc áo cũ rồi \r\n[03:17.21]Người vứt đi chẳng tiếc đời \r\n[03:20.16]Để ngày hôm nay em mặc áo mới \r\n[03:24.57]Người chẳng trân trọng \r\n[03:26.12]Những thứ quan trọng bên mình \r\n[03:29.18]Vì trong cuộc đời \r\n[03:30.45]Nào dễ kiếm được chân tình \r\n[03:33.52]Để mất đi rồi \r\n[03:35.07]Cảm thấy ân hận trong lòng \r\n[03:38.21]Áo mới tuy đẹp \r\n[03:39.49]Nhưng chật đúng không?\r\n[03:41.92]\r\n[03:47.36]Chiếc áo thay màu \r\n[03:48.81]Đắng cay phần anh mang \r\n[03:51.83]Em đổi thay lòng \r\n[03:53.48]Khiến ân tình sang ngang \r\n[03:56.29]Chiếc áo cũ rồi \r\n[03:57.95]Người vứt đi chẳng tiếc đời \r\n[04:00.74]Để ngày hôm nay em mặc áo mới \r\n[04:05.35]Người chẳng trân trọng \r\n[04:06.71]Những thứ quan trọng bên mình \r\n[04:09.85]Vì trong cuộc đời \r\n[04:11.21]Nào dễ kiếm được chân tình \r\n[04:14.42]Để mất đi rồi \r\n[04:15.82]Cảm thấy ân hận trong lòng \r\n[04:18.85]Áo mới tuy đẹp \r\n[04:20.18]Nhưng chật đúng không?\r\n[04:23.54]\r\n[04:25.54]Để mất đi rồi \r\n[04:27.23]Cảm thấy ân hận trong lòng \r\n[04:30.47]Áo mới tuy đẹp \r\n[04:31.70]Nhưng chật đúng không?\r\n[04:38.59]',4,0),(11,'Khó hiểu','00:04:26','103_Kho-Hieu-Chau-Khai-Phong','[ar: Châu Khải Phong]\r\n[ti: Khó Hiểu]\r\n[al: Bữa Tối Một Mình]\r\n[00:00.00]Bài hát: Khó Hiểu\r\n[00:02.00]Ca sĩ: Châu Khải Phong\r\n[00:04.00]\r\n[00:38.94]Trên đường về nhà anh \r\n[00:40.37]Cũng chẳng thể hiểu\r\n[00:42.68]Lí do em bước ra đi \r\n[00:46.92]Có điều gì làm tim \r\n[00:49.11]Em chợt đổi thay\r\n[00:51.54]Khiến cho đôi mình xa cách \r\n[00:55.78]Hay là vì anh chẳng \r\n[00:57.66]Có nhiều thời gian\r\n[00:59.72]Lắng lo chăm sóc cho em \r\n[01:04.33]Hay vì một người \r\n[01:05.83]Bước đến bên cạnh em \r\n[01:08.45]Lấp đầy khoảng trống trong tim \r\n[01:12.20]Và anh không thể \r\n[01:13.51]Tin đắng cay hôm nay \r\n[01:17.13]Sẽ đến với bản thân mình \r\n[01:20.50]Chỉ cách đây vài \r\n[01:22.24]Hôm em vẫn từng nói \r\n[01:24.93]Chỉ yêu riêng anh mãi mãi\r\n[01:29.11]Giờ anh chẳng thể \r\n[01:30.79]Hiểu bấy nhiêu lâu nay \r\n[01:34.22]Tình yêu của em ở đâu \r\n[01:37.66]Vẫn cho anh nụ cười bình yên \r\n[01:40.65]Nhưng sâu trong em nghĩ gì \r\n[01:45.46]Buồn vui hạnh phúc \r\n[01:47.76]Ngày ta có nhau \r\n[01:51.45]Liệu em có tiếc nuối không \r\n[01:54.82]Trước khi xa lìa xin nhìn về lý do \r\n[01:59.19]Tại sao bắt đầu  \r\n[02:38.94]Đêm rồi lại ngày anh \r\n[02:40.25]Vẫn thầm chờ đợi \r\n[02:42.87]Phút giây em sẽ quay về \r\n[02:46.93]Những điều còn lại \r\n[02:48.80]Trong anh là niềm đau \r\n[02:51.30]Bóng em xa khuất nơi đâu\r\n[02:55.11]Từng ngày trôi vội vã \r\n[02:57.66]Chỉ anh trong cô đơn\r\n[03:00.09]Lặng lẽ với bao kỉ niệm \r\n[03:03.46]Đến bây giời thì anh mới hiểu \r\n[03:07.20]Tình yêu của em \r\n[03:09.20]Ngày nào đã chết \r\n[03:12.07]Giờ anh phải làm \r\n[03:13.82]Gì để quên em đi\r\n[03:17.06]Một người mà anh rất yêu\r\n[03:20.62]Biết bao lâu để anh tìm lại \r\n[03:23.42]Tháng năm bình yên đã từng \r\n[03:28.17]Vì anh hãy có một người tốt hơn \r\n[03:34.28]Bên em mỗi khi em cần \r\n[03:37.59]Nói cho anh vì sao \r\n[03:39.28]Người vội đánh rơi \r\n[03:41.90]Tình yêu thuở nào\r\n[03:45.35]Buồn vui hạnh phúc \r\n[03:47.54]Ngày ta có nhau \r\n[03:51.41]Liệu em có tiếc nuối không \r\n[03:54.78]Nói cho anh vì sao \r\n[03:56.40]Người vội đánh rơi \r\n[04:01.58]Tình yêu thuở nào…\r\n[04:07.26]',4,0),(12,'test','00:04:35','RegesterFlowChart','[00:38.74] Chưa tìm thấy tình yêu\n[00:42.72] Chưa chạm lấy bình yên\n[00:46.44] Chưa gặp gỡ\n[00:48.30] Để nói một tiếng bắt đầu\n[00:54.43] Chưa nhận ra hợp nhau\n[00:58.14] Chưa đủ để dài lâu\n[01:02.13] Chưa hạnh phúc\n[01:03.67] Làm sao sẻ chia với ai khác\n[01:09.45] Ánh trăng kiêu sa nhìn người đang say\n[01:13.52] Bóng đêm kỉ niệm\n[01:14.78] Chính là bàn tay êm ái\n[01:19.00] Chỉ lòng mình không thấy\n[01:24.10] Thời gian qua thật sự đã quá dài\n[01:29.15] Xé nát cõi lòng anh\n[01:32.06] Giờ anh như một ngàn nỗi nhớ\n[01:35.52] Đến trong đêm buồn\n[01:40.04] Bình minh ơi đừng để anh ngóng đợi\n[01:44.54] Bởi trái tim nhỏ nhoi\n[01:47.48] Cần quan tâm\n[01:49.06] Cần làn hơi ấm của chỉ một người\n[01:54.12] Chẳng dễ để yêu một ai\n[02:00.70] Khi niềm tin đã vụn vỡ\n[02:02.57] Mang nỗi đau khiến tim điên dại\n[02:08.41] Chưa nhận ra đâu là yêu\n[02:10.26] Sao lại đau thấu nát tâm can\n[02:23.95] Thời gian sẽ trút u buồn tình yêu này\n[02:30.60] Ánh trăng kiêu sa nhìn người đang say\n[02:34.54] Bóng đêm kỉ niệm\n[02:36.14] Chính là bàn tay êm ái\n[02:40.38] Chỉ lòng mình không thấy\n[02:45.44] Thời gian qua thật sự đã quá dài\n[02:50.48] Xé nát cõi lòng anh\n[02:53.40] Và em như một ngàn nỗi nhớ\n[02:56.84] Đến trong đêm buồn\n[03:01.29] Bình minh ơi đừng để anh ngóng đợi\n[03:05.81] Bởi trái tim nhỏ nhoi\n[03:09.01] Cần quan tâm\n[03:10.33] Cần làn hơi ấm của chỉ một người\n[03:15.05] Chẳng dễ để yêu một ai\n[03:20.37] Thời gian qua thật sự đã quá dài\n[03:25.35] Xé nát cõi lòng anh\n[03:28.05] Và anh như một ngàn nỗi nhớ\n[03:31.76] Đến trong đêm buồn\n[03:36.02] Bình minh ơi đừng để anh ngóng đợi\n[03:40.83] Bởi trái tim nhỏ nhoi\n[03:43.48] Cần quan tâm\n[03:45.08] Cần làn hơi ấm của chỉ một người\n[03:50.11] Chẳng dễ để yêu một ai\n[03:56.23] Chưa tìm thấy tình yêu\n[04:00.00] Chưa chạm lấy bình yên\n[04:03.98] Chưa hạnh phúc\n[04:05.54] Làm sao sẻ chia với ai',4,0);
/*!40000 ALTER TABLE `song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `song_genre`
--

DROP TABLE IF EXISTS `song_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `song_genre` (
  `song_id` int NOT NULL,
  `genre_id` int NOT NULL,
  PRIMARY KEY (`song_id`,`genre_id`),
  KEY `fk_song_genre_genre1_idx` (`genre_id`),
  CONSTRAINT `fk_song_genre_genre1` FOREIGN KEY (`genre_id`) REFERENCES `genre` (`id`),
  CONSTRAINT `fk_song_genre_song1` FOREIGN KEY (`song_id`) REFERENCES `song` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song_genre`
--

LOCK TABLES `song_genre` WRITE;
/*!40000 ALTER TABLE `song_genre` DISABLE KEYS */;
INSERT INTO `song_genre` VALUES (1,2),(2,2),(3,2),(4,2),(5,2),(6,2),(8,2),(9,2),(12,2),(1,3),(2,3),(4,3),(5,3),(6,3),(8,3),(9,3),(12,3),(10,5),(11,5);
/*!40000 ALTER TABLE `song_genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `song_topic`
--

DROP TABLE IF EXISTS `song_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `song_topic` (
  `song_id` int NOT NULL,
  `topic_id` int NOT NULL,
  PRIMARY KEY (`song_id`,`topic_id`),
  KEY `fk_song_topic_topic1_idx` (`topic_id`),
  CONSTRAINT `fk_song_topic_song1` FOREIGN KEY (`song_id`) REFERENCES `song` (`id`),
  CONSTRAINT `fk_song_topic_topic1` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song_topic`
--

LOCK TABLES `song_topic` WRITE;
/*!40000 ALTER TABLE `song_topic` DISABLE KEYS */;
INSERT INTO `song_topic` VALUES (1,2),(2,2),(3,2),(4,2),(5,2),(6,2),(7,2),(8,2),(9,2),(10,2),(11,2),(12,2);
/*!40000 ALTER TABLE `song_topic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topic`
--

DROP TABLE IF EXISTS `topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `topic` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topic`
--

LOCK TABLES `topic` WRITE;
/*!40000 ALTER TABLE `topic` DISABLE KEYS */;
INSERT INTO `topic` VALUES (1,'Tình Yêu Lãng Mạn',''),(2,'Tình Buồn',''),(3,'Tình Bạn',''),(4,'Tình Yêu Quê Hương',''),(5,'Trải Nghiệm',''),(6,'Tình Cảm Gia Đình','');
/*!40000 ALTER TABLE `topic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `email` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `birthdate` datetime NOT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `picture` varchar(255) NOT NULL,
  `user_type_id` int NOT NULL,
  PRIMARY KEY (`email`),
  UNIQUE KEY `phone_UNIQUE` (`phone`),
  KEY `fk_user_user_type1_idx` (`user_type_id`),
  CONSTRAINT `fk_user_user_type1` FOREIGN KEY (`user_type_id`) REFERENCES `user_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('1@gmail.com','1','2006-01-01 00:00:00',NULL,'123123123','av-none',1),('chautantai201102@gmail.com','CHÂU TẤN TÀI (Tài Bến Tre)','2002-11-20 00:00:00','0399559051','11111111','chautantai201102@gmail.com',1),('hoangquoc18092002@gmail.com','LÊ HOÀNG QUỐC','2002-09-18 00:00:00',NULL,'taikhonn','hoangquoc18092002@gmail.com',1),('thieukhiem2002@gmail.com','Nguyễn Thiệu Khiêm','2002-01-01 00:00:00',NULL,'taikhonn','thieukhiem2002@gmail.com',1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_session`
--

DROP TABLE IF EXISTS `user_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_session` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_active_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_email` varchar(255) NOT NULL,
  `active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_id` (`session_id`),
  KEY `fk_user_session_user1_idx` (`user_email`),
  CONSTRAINT `fk_user_session_user1` FOREIGN KEY (`user_email`) REFERENCES `user` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_session`
--

LOCK TABLES `user_session` WRITE;
/*!40000 ALTER TABLE `user_session` DISABLE KEYS */;
INSERT INTO `user_session` VALUES (1,'ff5b0ee4-7f15-4a93-800e-27c102a94872','2024-07-25 01:28:57','2024-07-25 01:28:57','thieukhiem2002@gmail.com',1);
/*!40000 ALTER TABLE `user_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_type`
--

DROP TABLE IF EXISTS `user_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_type`
--

LOCK TABLES `user_type` WRITE;
/*!40000 ALTER TABLE `user_type` DISABLE KEYS */;
INSERT INTO `user_type` VALUES (1,'Normal','Người dùng nghèo'),(2,'Vip','Người dùng giàu');
/*!40000 ALTER TABLE `user_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_upload_song`
--

DROP TABLE IF EXISTS `user_upload_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_upload_song` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `upload_at` timestamp NOT NULL,
  `lyric` text,
  `duration` time NOT NULL,
  `user_email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user_upload_song_user1_idx` (`user_email`),
  CONSTRAINT `fk_user_upload_song_user1` FOREIGN KEY (`user_email`) REFERENCES `user` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_upload_song`
--

LOCK TABLES `user_upload_song` WRITE;
/*!40000 ALTER TABLE `user_upload_song` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_upload_song` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-25  8:42:26
