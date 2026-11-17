-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: petcare
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctor_id` int NOT NULL,
  `user_id` int NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) DEFAULT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `reason` varchar(500) DEFAULT NULL,
  `status` enum('PENDING','CONFIRMED','COMPLETED','CANCELLED') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `doctor_message` varchar(500) DEFAULT NULL,
  `responded_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_appointment_doctor` (`doctor_id`),
  KEY `fk_appointment_user` (`user_id`),
  CONSTRAINT `fk_appointment_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctor_applications` (`id`),
  CONSTRAINT `fk_appointment_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (1,1,2,'tomi','Rabbit','2026-11-05','23:21:00','nothing','CONFIRMED','2026-10-23 15:49:32','i am there','2026-10-23 20:21:11'),(2,11,2,'dog','Bird','2026-10-29','18:09:00','he is not okey','CONFIRMED','2026-10-24 08:34:29','okk came at 6 pm','2026-10-24 08:34:56'),(3,12,2,'tomi','Rabbit','2026-10-31','19:00:00','very ill','CONFIRMED','2026-10-26 10:23:06','yes i will be there','2026-10-26 10:23:42'),(4,13,2,'tanmoy','Dog','2026-10-29','11:22:00','so much gandu dog','CONFIRMED','2026-10-27 04:53:05','there is no cure for that. leave that dog in streets','2026-10-27 04:55:04'),(5,13,2,'tomi','Cat','2026-11-11','20:26:00','xtddr','CONFIRMED','2026-11-03 14:51:52','hhhhhhhhhhh','2026-11-03 14:52:24');
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor_applications`
--

DROP TABLE IF EXISTS `doctor_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor_applications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `date_of_birth` date NOT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `qualification` varchar(100) NOT NULL,
  `specialization` varchar(100) NOT NULL,
  `registration_number` varchar(100) NOT NULL,
  `experience_years` varchar(20) NOT NULL,
  `clinic_name` varchar(150) DEFAULT NULL,
  `clinic_address` varchar(500) NOT NULL,
  `city` varchar(100) NOT NULL,
  `state` varchar(100) NOT NULL,
  `pin_code` varchar(6) NOT NULL,
  `registration_certificate` varchar(255) NOT NULL,
  `degree_certificate` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `status` enum('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
  `admin_note` varchar(500) DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor_applications`
--

LOCK TABLES `doctor_applications` WRITE;
/*!40000 ALTER TABLE `doctor_applications` DISABLE KEYS */;
INSERT INTO `doctor_applications` VALUES (1,'Pratyay & Prithwish Chatterjee','prithwishandpratyay024@gmail.com','7318940730','2026-10-01','Male','BVSc and AH','Animal Nutrition','7318940731','1','ggggggggggggggggggggggggggg','Gopalnager\r\nGopalnager','Asansol','West Bengal','713340','42263731-a2bc-41e5-a8a7-0fb4f8a5f3d8.png','85e2e6c4-c57c-4180-bc33-87d316c8e7c0.png','pbkdf2_sha256$210000$2NN1TnGGLcnZE6wRespxzA==$RV2gP7n6P6wU7c4i053JjggoaYaHoHP607VkKF+mtbI=','APPROVED',NULL,'2026-10-22 04:41:41','2026-10-22 16:54:17'),(2,'bkl kalu','prithwishandptyay024@gmail.com','7318940735','2024-02-27',NULL,'PhD Veterinary Science','Animal Nutrition','7318940731','2','gggggggggggggggg','Gopalnager\r\nGopalnager','Asansol','West Bengal','713340','4734bb66-a877-4c4d-876c-d726d7326151.png','512923e3-4ebd-485c-8d60-a5d8e803fd7d.png','pbkdf2_sha256$210000$iH3P3/GfHBThdlH8JD8uYA==$mjAgQ2ZuJXZy0kGPqzwnm2cayeZK7EDj3zfk7834Nd0=','REJECTED','sorry','2026-10-22 16:57:31','2026-10-22 20:18:35'),(3,'abn','prithwandpratyay024@gmail.com','7318940732','2026-10-20',NULL,'BVSc and AH','Dermatology','7318940731','1','ggggg','Gopalnager\r\nGopalnager','Asansol','West Bengal','713340','9336abec-fc46-4e88-9039-11195aabc691.png','4c6e9b6e-0069-42d4-94bb-9e95fa79c77f.png','pbkdf2_sha256$210000$8ylOeSpvJkqzjD6L7IcYpg==$9OX9P2bc3ekWnagT1/zo5NF7uyTJFGbNc0H6wxbM8oE=','APPROVED',NULL,'2026-10-22 20:03:09','2026-10-22 20:06:34'),(4,'bhenchod raghunath','prithwishandpratyay023@gmail.com','7318940735','2026-10-20',NULL,'BVSc','Animal Nutrition','7318940731','0','avn er bari','Gopalnager\r\nGopalnager','Asansol','West Bengal','713340','d8832845-0819-449c-994d-f687ee457505.png','97c9511a-b69e-404a-ab51-2f12ea8e2da7.png','pbkdf2_sha256$210000$G8DysvKcB9Sbp0MDe4ybYg==$0wJtzZ0DknkKkCTCQTuQ+er5c6pG49zzJ0rEav5B1oI=','REJECTED',NULL,'2026-10-23 04:22:12','2026-10-23 04:23:38'),(10,'kkr','prithwishandpratyay014@gmail.com','7318940731','2026-10-08','Other','BVSc','General Veterinary Care','7318940731','2','avn er bari','Gopalnager\r\nGopalnager','Asansol','West Bengal','713340','25971298-57e0-4bde-a7da-a1d1730b63ae.png','7d40e093-0a41-40c6-b295-8480cb493499.png','pbkdf2_sha256$210000$gshOSLBmgy/MseHB9P5kYA==$hyZUNfPxafV98Hi+ddtMDjc9VPzn2Vk4x0ycPsajLDM=','APPROVED',NULL,'2026-10-23 04:38:58','2026-10-23 04:39:11'),(11,'Dr kumer','d@gmail.com','7318940731','2026-10-14','Male','Other recognized qualification','Dentistry','7318940731','4','avn er bari','Gopalnager\r\nGopalnager','Asansol','West Bengal','713340','11cfb2d7-8b86-4081-bd6a-94ccf0863bf5.png','e0bbc8c8-fa83-4803-9cb6-39a2739ec2d9.png','pbkdf2_sha256$210000$eJYtQM/1wUybJdCsfgUkRQ==$ifDNFXs5UUYsLiTZgdgse4RmwCXFBxae1vByd3Xq8fY=','APPROVED',NULL,'2026-10-24 08:28:59','2026-10-24 08:30:24'),(12,'Sk','sk@gmail.com','7318940732','2026-10-16',NULL,'BVSc','Dermatology','7318940731','4','avn er bari','Gopalnager\r\nGopalnager','Asansol','West Bengal','713340','ddf7ffef-c1ef-4be3-b7a5-67ae87e05e05.png','3839f39e-98cb-46a5-8106-3af4f462b63e.png','pbkdf2_sha256$210000$i8Vv6jSvYL9BzvKd8JB25g==$IEnNuvQjK80GrG+WhIQNemnzPlaPlgz3gmGgKyPOHqg=','APPROVED',NULL,'2026-10-26 10:19:20','2026-10-26 10:20:21'),(13,'Samay Raina','latent@gmail.com','9876543210','2026-10-01','Male','PhD Veterinary Science','Animal Nutrition','012-3476-9876','3','India\'s got latent','near Comedy Club','Mumbai','Maharastra','678901','809950a0-210d-4b50-aa53-5a01a1c59220.png','80b971ca-6473-48aa-ba13-3a2807c1b02d.png','pbkdf2_sha256$210000$aApei5oPLfmsPtkd7w6Kpw==$YKx7hjsgt/xPDam5A+dVRLL21wnQ04dNQqkm7mGDTM4=','APPROVED',NULL,'2026-10-27 04:49:14','2026-10-27 04:50:17'),(14,'Doctor','a@gmail.com','7318940735','2026-11-02','Male','BVSc','Surgery','7318940731','2','gggggggggggggggg','Gopalnager\r\nGopalnager','Asansol','West Bengal','713340','b9c1f2e6-f138-4bf1-9a18-0c44ab5a1c3a.png','15a147b9-8825-42bc-ad15-a866a07dd243.png','pbkdf2_sha256$210000$zQ4Ls6wxB9uyDDOQ2brxag==$v4f8UMTN24SIIK052V/4MTHHA8zydG1kwnk4ZatU7bo=','APPROVED',NULL,'2026-11-03 14:46:09','2026-11-03 18:38:56'),(17,'Pratyay & Prithwish Chatterjee','prithwish024@gmail.com','7318940731','2026-11-10','Male','BVSc and AH','Dermatology','012-3476-9876','1','avn er bari','Gopalnager\r\nGopalnager','Asansol','West Bengal','713340','59c4553e-38ec-472f-acaf-75cf4fa44d50.png','2eb0105e-4dd1-46a9-a5a1-fff8a3e9ce51.png','pbkdf2_sha256$210000$Z2PNFYs2gDZIWGYMS+er6Q==$KGvhca2XtEEmtoM5w/aU/XUQHpLmtmsub7eTjUlHg2M=','APPROVED',NULL,'2026-11-14 09:38:15','2026-11-14 09:38:30'),(20,'john','b@gmail.com','7318940735','2026-11-04','Other','BVSc','Dermatology','7318940731','4','ggggggggggggggggggggggggggg','Gopalnager\r\nGopalnager','Asansol','West Bengal','713340','aea6d550-5463-4a1b-a1c1-031ced6f0b50.jpg','adb8d0ca-891f-4e54-a7c6-2e469fcb2764.jpg','pbkdf2_sha256$210000$/Mp+YufNbf4syoskGuhYZQ==$rlCzGNDpk5VS81UtUHQR+tyIXYrq75ZZpuLyJjiuGy8=','APPROVED',NULL,'2026-11-16 10:13:08','2026-11-16 10:13:42');
/*!40000 ALTER TABLE `doctor_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `my_pets`
--

DROP TABLE IF EXISTS `my_pets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `my_pets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `pet_id` int DEFAULT NULL,
  `seller_listing_id` int DEFAULT NULL,
  `order_id` int NOT NULL,
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `pet_id` (`pet_id`),
  KEY `order_id` (`order_id`),
  KEY `fk_my_pets_seller_listing` (`seller_listing_id`),
  CONSTRAINT `fk_my_pets_seller_listing` FOREIGN KEY (`seller_listing_id`) REFERENCES `seller_listings` (`id`),
  CONSTRAINT `my_pets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `my_pets_ibfk_3` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `my_pets`
--

LOCK TABLES `my_pets` WRITE;
/*!40000 ALTER TABLE `my_pets` DISABLE KEYS */;
INSERT INTO `my_pets` VALUES (17,2,NULL,1,17,'2026-10-31 06:36:21'),(19,2,NULL,3,19,'2026-10-31 06:37:30'),(26,2,NULL,4,26,'2026-10-31 07:32:55'),(27,7,NULL,6,30,'2026-11-02 19:57:45'),(28,2,NULL,7,32,'2026-11-14 09:36:17'),(29,2,NULL,8,34,'2026-11-14 14:26:00'),(30,2,NULL,9,38,'2026-11-14 19:01:11'),(31,2,NULL,10,39,'2026-11-14 19:09:43'),(32,2,NULL,11,41,'2026-11-15 04:11:19'),(33,2,NULL,14,46,'2026-11-16 20:31:40');
/*!40000 ALTER TABLE `my_pets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `item_type` varchar(30) NOT NULL,
  `seller_listing_id` int DEFAULT NULL,
  `product_name` varchar(150) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `subtotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_order_items_order` (`order_id`),
  KEY `fk_order_items_seller` (`seller_listing_id`),
  CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_order_items_seller` FOREIGN KEY (`seller_listing_id`) REFERENCES `seller_listings` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,27,'PRODUCT',NULL,'pedigri',200.00,2,400.00),(2,27,'PRODUCT',NULL,'egg',0.01,2,0.02),(3,28,'PRODUCT',NULL,'Pedigree Adult Dog Food',749.00,1,749.00),(4,28,'PRODUCT',NULL,'Adjustable Dog Collar',199.00,1,199.00),(5,29,'PRODUCT',NULL,'pedigri',200.00,1,200.00),(6,31,'PRODUCT',NULL,'Pedigree Adult Dog Food',749.00,1,749.00),(7,33,'PRODUCT',NULL,'Royal Canin Puppy Food',899.00,1,899.00),(8,35,'PRODUCT',NULL,'Royal Canin Puppy Food',899.00,1,899.00),(9,35,'PRODUCT',NULL,'Pedigree Adult Dog Food',749.00,1,749.00),(10,36,'PRODUCT',NULL,'Royal Canin Puppy Food',899.00,1,899.00),(11,36,'PRODUCT',NULL,'Whiskas Cat Food',499.00,1,499.00),(12,37,'PRODUCT',NULL,'Royal Canin Puppy Food',899.00,1,899.00),(13,37,'PRODUCT',NULL,'pedigri',200.00,1,200.00),(14,38,'PRODUCT',NULL,'pedigri',200.00,1,200.00),(15,38,'PRODUCT',NULL,'Pedigree Adult Dog Food',749.00,1,749.00),(16,38,'PRODUCT',NULL,'Cat Grooming Brush',249.00,1,249.00),(17,38,'PET',9,'Max',200.00,1,200.00),(18,39,'PET',10,'jjjjjjjj',7777.00,1,7777.00),(19,40,'PRODUCT',NULL,'egg',0.01,1,0.01),(20,40,'PRODUCT',NULL,'Cozy Pet Hoodie',499.00,1,499.00),(21,41,'PET',11,'kalu',20000.00,1,20000.00),(22,42,'PRODUCT',NULL,'Royal Canin Puppy Food',899.00,1,899.00),(23,43,'PRODUCT',NULL,'Royal Canin Puppy Food',899.00,1,899.00),(24,43,'PRODUCT',NULL,'Pedigree Adult Dog Food',749.00,1,749.00),(25,44,'PRODUCT',NULL,'Pedigree Adult Dog Food',749.00,1,749.00),(26,45,'PRODUCT',NULL,'Whiskas Cat Food',499.00,1,499.00),(27,45,'PRODUCT',NULL,'Cozy Pet Hoodie',499.00,1,499.00),(28,47,'PRODUCT',NULL,'Royal Canin Puppy Food',899.00,1,899.00);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `pet_id` int DEFAULT NULL,
  `seller_listing_id` int DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `order_status` varchar(30) DEFAULT 'PLACED',
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `full_name` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `delivery_address` varchar(500) DEFAULT NULL,
  `city` varchar(80) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `payment_method` varchar(30) DEFAULT 'COD',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `pet_id` (`pet_id`),
  KEY `fk_orders_seller_listing` (`seller_listing_id`),
  CONSTRAINT `fk_orders_seller_listing` FOREIGN KEY (`seller_listing_id`) REFERENCES `seller_listings` (`id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,2,7,NULL,2999.00,'PLACED','2026-10-08 20:21:01',NULL,NULL,NULL,NULL,NULL,'COD'),(2,2,7,NULL,2999.00,'PLACED','2026-10-10 17:23:04',NULL,NULL,NULL,NULL,NULL,'COD'),(3,2,7,NULL,2999.00,'PLACED','2026-10-10 17:23:24',NULL,NULL,NULL,NULL,NULL,'COD'),(4,2,7,NULL,2999.00,'PLACED','2026-10-10 18:58:38',NULL,NULL,NULL,NULL,NULL,'COD'),(5,2,7,NULL,2999.00,'PLACED','2026-10-21 04:35:01',NULL,NULL,NULL,NULL,NULL,'COD'),(6,2,7,NULL,2999.00,'PLACED','2026-10-21 04:35:24',NULL,NULL,NULL,NULL,NULL,'COD'),(7,2,7,NULL,2999.00,'PLACED','2026-10-23 16:50:03',NULL,NULL,NULL,NULL,NULL,'COD'),(8,2,7,NULL,2999.00,'PLACED','2026-10-23 16:57:50',NULL,NULL,NULL,NULL,NULL,'COD'),(9,2,7,NULL,2999.00,'PLACED','2026-10-23 20:35:39',NULL,NULL,NULL,NULL,NULL,'COD'),(10,6,7,NULL,2999.00,'PLACED','2026-10-24 08:38:51',NULL,NULL,NULL,NULL,NULL,'COD'),(11,2,7,NULL,2999.00,'PLACED','2026-10-26 10:15:09',NULL,NULL,NULL,NULL,NULL,'COD'),(12,2,8,NULL,5499.00,'PLACED','2026-10-26 20:09:21',NULL,NULL,NULL,NULL,NULL,'COD'),(13,2,9,NULL,3499.00,'PLACED','2026-10-26 20:10:45',NULL,NULL,NULL,NULL,NULL,'COD'),(14,2,10,NULL,4499.00,'PLACED','2026-10-26 20:13:12',NULL,NULL,NULL,NULL,NULL,'COD'),(15,2,7,NULL,2999.00,'PLACED','2026-10-30 12:03:15',NULL,NULL,NULL,NULL,NULL,'COD'),(16,2,7,NULL,2999.00,'PLACED','2026-10-31 04:15:13',NULL,NULL,NULL,NULL,NULL,'COD'),(17,2,NULL,1,0.01,'PLACED','2026-10-31 06:36:21',NULL,NULL,NULL,NULL,NULL,'COD'),(18,2,8,NULL,5499.00,'PLACED','2026-10-31 06:36:47',NULL,NULL,NULL,NULL,NULL,'COD'),(19,2,NULL,3,400.00,'PLACED','2026-10-31 06:37:30',NULL,NULL,NULL,NULL,NULL,'COD'),(20,2,7,NULL,2999.00,'PLACED','2026-10-31 06:59:01',NULL,NULL,NULL,NULL,NULL,'COD'),(21,2,8,NULL,5499.00,'PLACED','2026-10-31 07:17:34',NULL,NULL,NULL,NULL,NULL,'COD'),(22,2,7,NULL,2999.00,'PLACED','2026-10-31 07:27:24',NULL,NULL,NULL,NULL,NULL,'COD'),(23,2,7,NULL,2999.00,'PLACED','2026-10-31 07:28:05',NULL,NULL,NULL,NULL,NULL,'COD'),(24,2,7,NULL,2999.00,'PLACED','2026-10-31 07:29:32',NULL,NULL,NULL,NULL,NULL,'COD'),(25,2,7,NULL,2999.00,'PLACED','2026-10-31 07:29:52',NULL,NULL,NULL,NULL,NULL,'COD'),(26,2,NULL,4,4555.00,'PLACED','2026-10-31 07:32:55',NULL,NULL,NULL,NULL,NULL,'COD'),(27,2,NULL,NULL,400.02,'PLACED','2026-11-02 18:23:12','Pratyay & Prithwish Chatterjee','7318940731','Gopalnager\r\nGopalnager','Asansol','713340','COD'),(28,2,NULL,NULL,948.00,'PLACED','2026-11-02 18:35:05','Pratyay & Prithwish Chatterjee','7318940731','Gopalnager\r\nGopalnager','Asansol','713340','COD'),(29,2,NULL,NULL,200.00,'PLACED','2026-11-02 19:44:32','Pratyay & Prithwish Chatterjee','7318940735','Gopalnager\r\nGopalnager','Asansol','713340','COD'),(30,7,NULL,6,22221.97,'PLACED','2026-11-02 19:57:45',NULL,NULL,NULL,NULL,NULL,'COD'),(31,2,NULL,NULL,749.00,'PLACED','2026-11-14 04:22:41','Pratyay & Prithwish Chatterjee','7318940731','Gopalnager','Asansol','713340','COD'),(32,2,NULL,7,399.97,'PLACED','2026-11-14 09:36:17',NULL,NULL,NULL,NULL,NULL,'COD'),(33,2,NULL,NULL,899.00,'PLACED','2026-11-14 14:21:48','Pratyay & Prithwish Chatterjee','7318940730','Gopalnager','Asansol','713340','COD'),(34,2,NULL,8,1999.97,'PLACED','2026-11-14 14:26:00',NULL,NULL,NULL,NULL,NULL,'COD'),(35,2,NULL,NULL,1648.00,'PLACED','2026-11-14 15:34:45','Pratyay & Prithwish Chatterjee','7318940730','Gopalnager','Asansol','713340','COD'),(36,2,NULL,NULL,1398.00,'PLACED','2026-11-14 18:27:43','Pratyay & Prithwish Chatterjee','7318940731','Gopalnager','Asansol','713340','COD'),(37,2,NULL,NULL,1099.00,'PLACED','2026-11-14 18:30:58','Pratyay & Prithwish Chatterjee','7318940731','Gopalnager','Asansol','713340','COD'),(38,2,NULL,NULL,1398.00,'PLACED','2026-11-14 19:01:11','Pratyay & Prithwish Chatterjee','7318940731','Gopalnager','Asansol','713340','COD'),(39,2,NULL,NULL,7777.00,'PLACED','2026-11-14 19:09:43','Pratyay & Prithwish Chatterjee','7318940730','Gopalnager','Asansol','713340','COD'),(40,2,NULL,NULL,499.01,'PLACED','2026-11-15 04:07:34','Pratyay & Prithwish Chatterjee','7318940730','Gopalnager','Asansol','713340','COD'),(41,2,NULL,NULL,20000.00,'PLACED','2026-11-15 04:11:19','Pratyay & Prithwish Chatterjee','7318940730','Gopalnager','Asansol','713340','COD'),(42,2,NULL,NULL,899.00,'PLACED','2026-11-16 06:50:16','Pratyay & Prithwish Chatterjee','7318940730','Gopalnager','Asansol','713340','COD'),(43,2,NULL,NULL,1648.00,'PLACED','2026-11-16 10:06:17','Pratyay & Prithwish Chatterjee','7318940731','Gopalnager','Asansol','713340','COD'),(44,2,NULL,NULL,749.00,'PLACED','2026-11-16 10:06:40','Pratyay & Prithwish Chatterjee','7318940730','Gopalnager','Asansol','713340','COD'),(45,2,NULL,NULL,998.00,'PLACED','2026-11-16 10:17:02','Pratyay & Prithwish Chatterjee','7318940731','Gopalnager','Asansol','713340','COD'),(46,2,NULL,14,3999.94,'PLACED','2026-11-16 20:31:40',NULL,NULL,NULL,NULL,NULL,'COD'),(47,2,NULL,NULL,899.00,'PLACED','2026-11-17 04:27:06','Pratyay & Prithwish Chatterjee','7318940735','Gopalnager','Asansol','713340','COD');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pets`
--

DROP TABLE IF EXISTS `pets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `breed` varchar(100) NOT NULL,
  `animal_type` varchar(50) NOT NULL,
  `gender` varchar(20) NOT NULL,
  `age` varchar(50) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `status` varchar(30) DEFAULT 'AVAILABLE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pets`
--

LOCK TABLES `pets` WRITE;
/*!40000 ALTER TABLE `pets` DISABLE KEYS */;
INSERT INTO `pets` VALUES (6,'Max','Golden Retriever','dog','Male','1 year','Kolkata',4999.00,'images/max.jpg','AVAILABLE','2026-10-08 11:56:39'),(7,'Luna','Indian Cat','cat','Female','1 year','Howrah',2999.00,'images/luna.jpg','AVAILABLE','2026-10-08 11:56:39'),(8,'Rocky','Labrador Retriever','dog','Male','2 years','Kolkata',5499.00,'images/rocky.jpg','AVAILABLE','2026-10-08 11:56:39'),(9,'Misty','Persian Cat','cat','Female','1 year','Salt Lake',3499.00,'images/misty.jpg','AVAILABLE','2026-10-08 11:56:39'),(10,'Sunny','Beagle','dog','Female','10 months','Howrah',4499.00,'images/sunny.jpg','AVAILABLE','2026-10-08 11:56:39');
/*!40000 ALTER TABLE `pets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seller_applications`
--

DROP TABLE IF EXISTS `seller_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seller_applications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `seller_type` enum('PET_SELLER','PRODUCT_SELLER') NOT NULL,
  `business_name` varchar(150) DEFAULT NULL,
  `address` text NOT NULL,
  `identity_document` varchar(255) DEFAULT NULL,
  `application_status` enum('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seller_applications`
--

LOCK TABLES `seller_applications` WRITE;
/*!40000 ALTER TABLE `seller_applications` DISABLE KEYS */;
INSERT INTO `seller_applications` VALUES (1,'Pratyay & Prithwish Chatterjee','p@gamil.com','7318940731','RaxTfzVcZbtjAJvELefKww==:0aVzIlfdZceIlYFyThHA10AZMm0Bg+1owgeJt0XxreA=','PET_SELLER','rggregregerge','Gopalnager\r\nGopalnager',NULL,'APPROVED','2026-10-28 19:47:10'),(2,'Chatterjee','f@gmail.com','9876543210','5K4U2qGwWNUImiC9oZMGkw==:GbY1qt4OTkc3JH4jdz1ccyaJ5SIjSHH28zZU2bsOa24=','PRODUCT_SELLER','rggregregerge','Gopalnager',NULL,'APPROVED','2026-10-28 20:18:14'),(3,'drig','latent@gmail.com','7318940735','DJ51lXQbKpyekkRxLwA+dw==:+UBduzqLRm334+eG00LI8DoP7g1pL+P0VkeAvT/HY4g=','PRODUCT_SELLER','rggregregerge','Gopalnager',NULL,'APPROVED','2026-10-31 15:42:25'),(4,'Mukesh','m@gmail.com','7318940732','w6qBpqvskC+PNnaEOEVUPQ==:GPrJlU5batRkAp2JHWU1E8Ic15MftK5bP4B4kbxR/H0=','PET_SELLER','rggregregerge','hvjhwvjhwevfjhewvfjhewv',NULL,'APPROVED','2026-11-16 15:57:18');
/*!40000 ALTER TABLE `seller_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seller_listings`
--

DROP TABLE IF EXISTS `seller_listings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seller_listings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `seller_id` int NOT NULL,
  `listing_type` enum('PET','PRODUCT') NOT NULL,
  `title` varchar(150) NOT NULL,
  `description` text,
  `category` varchar(100) DEFAULT NULL,
  `animal_type` varchar(50) DEFAULT NULL,
  `breed` varchar(100) DEFAULT NULL,
  `age` varchar(50) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `weight` varchar(50) DEFAULT NULL,
  `size` varchar(50) DEFAULT NULL,
  `location` varchar(200) DEFAULT NULL,
  `is_food_item` tinyint(1) NOT NULL DEFAULT '0',
  `food_animal_type` varchar(50) DEFAULT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `price` decimal(10,2) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `listing_status` enum('AVAILABLE','SOLD') NOT NULL DEFAULT 'AVAILABLE',
  PRIMARY KEY (`id`),
  KEY `fk_listing_seller` (`seller_id`),
  CONSTRAINT `fk_listing_seller` FOREIGN KEY (`seller_id`) REFERENCES `seller_applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seller_listings`
--

LOCK TABLES `seller_listings` WRITE;
/*!40000 ALTER TABLE `seller_listings` DISABLE KEYS */;
INSERT INTO `seller_listings` VALUES (1,1,'PET','bholu','dytdytdtdtydtydtydtyd',NULL,'Rabbit','kkk','3','Female','','Medium','Goaplnager',0,NULL,1,0.01,'80c85279-9e7d-4e5c-a63f-d5e7fa81c47e.jpg','SOLD'),(2,2,'PRODUCT','egg','erger','Dress & Accessories',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,1,0.01,'c05fd0f7-7882-4031-966a-6f1cbdf6f4c9.jpg','AVAILABLE'),(3,1,'PET','Tomy','Very Energetic cat',NULL,'Cat','Indian','3 year','Male','1 kg','Small','Kolkata',0,NULL,1,400.00,'29f2517f-4a07-4129-a4ab-debe3bc18507.png','SOLD'),(4,1,'PET','meiw','hgchgchgcghgc',NULL,'Other','Indian','3','Female','1','Medium','Kolkata',0,NULL,1,4555.00,'4d0d174a-dc32-46a3-b2da-60e63bb255bf.png','SOLD'),(5,3,'PRODUCT','pedigri','gewghjwhfgewhjfgwehjygf','Pet Foods',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'Dog',1,200.00,'385ac6d9-6d37-431f-ad48-44369bad9d64.png','AVAILABLE'),(6,1,'PET','bholu2','fgergqergqrg',NULL,'Cat','kkk','3','Female','1 kg','Medium','Goaplnager',0,NULL,1,22221.97,'bed4a3fb-2df5-4f08-bd92-1cbad78ec8f1.png','SOLD'),(7,1,'PET','tom','gyytdtydtydytdytdytdtydtydty',NULL,'Dog','kkk','3 year','Male','1','Small','Goaplnager',0,NULL,1,399.97,'8d1393b3-62f4-4336-8794-fd1ae07a71d1.png','SOLD'),(8,1,'PET','kitty','sdvsdvsdvds',NULL,'Cat','kkk','3','Male','1','Small','Kolkata',0,NULL,1,1999.97,'97f09971-e5f7-4cd1-92be-36fdaa76ef3d.png','SOLD'),(9,1,'PET','Max','chgchcghcghcghcghcghchgcghc',NULL,'Rabbit','Indian','3 year','Female','1','Small','Kolkata',0,NULL,1,200.00,'6ee88f0b-789a-4234-a3ad-ada585d1b7bd.png','SOLD'),(10,1,'PET','jjjjjjjj','gcgchcch',NULL,'Dog','kkk','3','Male','1','Small','Goaplnager',0,NULL,1,7777.00,'8b0a9b79-65ed-4c5f-8214-9a68eb871217.png','SOLD'),(11,1,'PET','kalu','bfwebfweuibfweuifbquiq',NULL,'Bird','Indian','3','Female','1','Small','Goaplnager',0,NULL,1,20000.00,'a5f2c4b0-e080-447b-82b6-269f0ae8b730.png','SOLD'),(12,1,'PET','kitty','hbrbgerjegrgriuwrgwiuwg',NULL,'Cat','Indian','2 months','Female','100g','Small','Goaplnager',0,NULL,1,6000.00,'be9745e9-2079-4189-9e70-512d4d593231.jpg','AVAILABLE'),(13,3,'PRODUCT','Pet Bed','gfxgfcghgchgchg','Dress & Accessories',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,6,2000.00,'1907b5e4-530f-44a6-8453-44e8c43b2aa2.jpg','AVAILABLE'),(14,4,'PET','kalluu','vwehjfvwhjfvewhjfvwehj',NULL,'Dog','Indian','3 year','Male','200g','Medium','Goaplnager',0,NULL,1,3999.94,'b5c467fa-4b10-4b40-89c4-2c2f41660c51.jpg','SOLD');
/*!40000 ALTER TABLE `seller_listings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store_cart`
--

DROP TABLE IF EXISTS `store_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store_cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_name` varchar(150) NOT NULL,
  `seller_listing_id` int DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_product` (`user_id`,`product_name`),
  CONSTRAINT `store_cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store_cart`
--

LOCK TABLES `store_cart` WRITE;
/*!40000 ALTER TABLE `store_cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `store_cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Prithwish Chatterjee','prithwishandpratyay024@gmail.com','7318940730','JnEe78Lv3E!4@bS','2026-09-26 19:45:47'),(2,'PratyayChatterjee','p@gamil.com','7318940731','123456','2026-09-27 06:03:49'),(3,'kalu','k@gamil.com','7318940735','1234567','2026-09-27 07:09:34'),(4,'rajat dalal','g@gmail.com','7318940736','12345678','2026-10-01 18:58:05'),(5,'#kalu','kalu@gmail.com','7318940732','123','2026-10-06 13:59:40'),(6,'datal','k@gmail.com','7318940736','1234','2026-10-24 08:36:40'),(7,'tanmoy','prithwishandpratyay02@gmail.com','7318940736','1234','2026-11-02 19:47:56'),(8,'kalu','pratyay024@gmail.com','p@gamil.com','123456','2026-11-15 06:41:48');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-17 11:59:33
