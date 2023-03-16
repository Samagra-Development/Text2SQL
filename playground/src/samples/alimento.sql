-- MySQL dump 10.13  Distrib 5.7.40, for Linux (x86_64)
--
-- Host: localhost    Database: alimento_db
-- ------------------------------------------------------
-- Server version	5.7.40-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE SCHEMA public;

--
-- Table structure for table `cart_tb`
--

DROP TABLE IF EXISTS `public`.`cart_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `public`.`cart_tb` (
  `r_id` bigint(10) NOT NULL,
  `d_id` bigint(10) NOT NULL,
  `c_email` varchar(50) COLLATE utf8_bin NOT NULL,
  `d_cost` int(20) NOT NULL,
  `cart_quantity` int(11) NOT NULL DEFAULT '1',
  `d_name` varchar(50) COLLATE utf8_bin NOT NULL,
  `cart_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`r_id`,`d_id`,`c_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_tb`
--

LOCK TABLES `public`.`cart_tb` WRITE;
/*!40000 ALTER TABLE `cart_tb` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customerlogin_tb`
--

DROP TABLE IF EXISTS `public`.`customerlogin_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `public`.`customerlogin_tb` (
  `c_id` int(11) NOT NULL AUTO_INCREMENT,
  `c_name` varchar(60) COLLATE utf8_bin NOT NULL,
  `c_phone` int(10) NOT NULL,
  `c_preference` varchar(10) COLLATE utf8_bin NOT NULL,
  `c_address` varchar(100) COLLATE utf8_bin NOT NULL,
  `c_email` varchar(50) COLLATE utf8_bin NOT NULL,
  `c_password` varchar(100) COLLATE utf8_bin NOT NULL,
  `c_image` varchar(100) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`c_id`),
  UNIQUE KEY `c_email` (`c_email`),
  UNIQUE KEY `c_id` (`c_id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customerlogin_tb`
--

LOCK TABLES `public`.`customerlogin_tb` WRITE;
/*!40000 ALTER TABLE `customerlogin_tb` DISABLE KEYS */;
INSERT INTO `public`.`customerlogin_tb` VALUES (9,'Customer2',2147483647,'Veg','Delhi','customer2@gmail.com','1234','Customer/image/raphael-lovaski-2sEgCoO9dkY-unsplash.jpg'),(10,'Customer3',2147483647,'Veg','Lucknow','customer3@gmail.com','1234','Customer/image/michael-dam-mEZ3PoFGs_k-unsplash.jpg'),(11,'Customer4',2147483647,'Veg','Delhi','customer4@gmail.com','1234','Customer/image/yasin-pixel-zrJO_KVWZZw-unsplash.jpg'),(16,'Shraddha',2147483647,'Veg','Indira','Chuttan@gmail.com','$2b$10$C/iY8VDQeWon4RsrraDIN.TozK7Kdd21.mZbyTW52gdf6kK.fyX.O','/Customer/image/2022-10-18T19-15-03.196Z'),(47,'Suyash',2147483647,'Veg','3/335','suyash.gautam97@gmail.com','$2b$10$jOjrNQc2em59gl7zwFtkE..zcXZnxyXcs./cT9IZXoXZ2hylpoRyC',''),(48,'Renu Gautam',1234567897,'Veg','Vishal Nagar, Lucknow','suyashgautam23@gmail.com','$2b$10$s9Z8GBXRHZqBSK3RFz/miuQTnCJuWHBqfiBuqoIkg9RpVsa0RtmT.',''),(52,'Rahul Gautam',1231231234,'Veg','33, Lohia Vihar, Indira Nagar, Lucknow','rahul.gauty97@gmail.com','$2b$10$2u7QgLyGvgrAx1k/tPGp7.5Sk5WeKZLJwnJRS8F0NqNtJFCK9IFnq','Customer//image/2022-10-19T16-56-34.211Z');
/*!40000 ALTER TABLE `customerlogin_tb` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `restaurantlogin_tb`
--

DROP TABLE IF EXISTS `public`.`restaurantlogin_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `public`.`restaurantlogin_tb` (
  `rest_id` int(11) NOT NULL AUTO_INCREMENT,
  `r_name` varchar(50) COLLATE utf8_bin NOT NULL,
  `r_address` varchar(100) COLLATE utf8_bin NOT NULL,
  `r_email` varchar(50) COLLATE utf8_bin NOT NULL,
  `r_password` varchar(100) COLLATE utf8_bin NOT NULL,
  `r_image` varchar(100) COLLATE utf8_bin NOT NULL,
  `r_city` varchar(100) COLLATE utf8_bin NOT NULL,
  `r_totalRatings` int(11) NOT NULL DEFAULT '0',
  `r_totalCustomers` int(11) NOT NULL DEFAULT '0',
  `r_latitude` varchar(30) COLLATE utf8_bin NOT NULL,
  `r_longitude` varchar(30) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`rest_id`),
  UNIQUE KEY `r_email` (`r_email`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurantlogin_tb`
--

LOCK TABLES `public`.`restaurantlogin_tb` WRITE;
/*!40000 ALTER TABLE `restaurantlogin_tb` DISABLE KEYS */;
INSERT INTO `public`.`restaurantlogin_tb` VALUES (8,'dominos','Lucknow','vendor1@gmail.com','$2b$10$Q4Se2J3F3YN2v3bjg4PGTuZjzkQjj/B98shESl8pH/0wC7UzC8p4e','Restaurants/image/aleks-marinkovic-dlVOoZSYf0-unsplash.jpg','lucknow',14,3,'26.848759336138','80.990495682199'),(9,'haldiram','Lucknow','rest2@gmail.com','$2b$10$Q4Se2J3F3YN2v3bjg4PGTuZjzkQjj/B98shESl8pH/0wC7UzC8p4e','Restaurants/image/pexels-anna-tis-6341164.jpg','lucknow',0,0,'26.85403','80.9445099'),(10,'sagar ratna','Lucknow','rest3@gmail.com','$2b$10$Q4Se2J3F3YN2v3bjg4PGTuZjzkQjj/B98shESl8pH/0wC7UzC8p4e','Restaurants/image/pexels-olya-kobruseva-4676640.jpg','lucknow',7,2,'26.83366','80.88501'),(11,'moti mahal','Lucknow','rest4@gmail.com','$2b$10$Q4Se2J3F3YN2v3bjg4PGTuZjzkQjj/B98shESl8pH/0wC7UzC8p4e','Restaurants/image/pexels-rene-asmussen-1581384.jpg','lucknow',0,0,'26.8471','80.9453'),(12,'bikanervala','Delhi','rest5@gmail.com','$2b$10$Q4Se2J3F3YN2v3bjg4PGTuZjzkQjj/B98shESl8pH/0wC7UzC8p4e','Restaurants/image/pexels-volkan-vardar-3887985.jpg','delhi',0,0,'',''),(13,'namaste punjab','Delhi','rest6@gmail.com','$2b$10$Q4Se2J3F3YN2v3bjg4PGTuZjzkQjj/B98shESl8pH/0wC7UzC8p4e','Restaurants/image/proriat-hospitality-7fuDHi1CG8s-unsplash.jpg','delhi',0,0,'',''),(14,'nazeer foods','Lucknow','rest7@gmail.com','$2b$10$Q4Se2J3F3YN2v3bjg4PGTuZjzkQjj/B98shESl8pH/0wC7UzC8p4e','Restaurants/image/rod-long-WC7LeX79iEU-unsplash.jpg','lucknow',0,0,'26.85','80.9167'),(30,'aryan','Lucknow','suyashgautam23@gmail.com','$2b$10$Q2Qm52M/P8C14eXhFdFNrupPCp7KWlxeU0O13li6dPA9GUtz2J2/y','','lucknow',0,0,'26.8551','81.0010');
/*!40000 ALTER TABLE `restaurantlogin_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurantreview_tb`
--

DROP TABLE IF EXISTS `public`.`restaurantreview_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `public`.`restaurantreview_tb` (
  `rest_id` int(11) NOT NULL,
  `c_id` int(11) NOT NULL,
  `review` varchar(240) COLLATE utf8_bin NOT NULL,
  `stars` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rest_id`,`c_id`),
  KEY `Foreign Key` (`c_id`),
  CONSTRAINT `Foreign Key` FOREIGN KEY (`c_id`) REFERENCES `customerlogin_tb` (`c_id`) ON DELETE CASCADE,
  CONSTRAINT `Foreign Key 2` FOREIGN KEY (`rest_id`) REFERENCES `restaurantlogin_tb` (`rest_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurantreview_tb`
--

LOCK TABLES `public`.`restaurantreview_tb` WRITE;
/*!40000 ALTER TABLE `restaurantreview_tb` DISABLE KEYS */;
INSERT INTO `public`.`restaurantreview_tb` VALUES (8,16,'Awesome',5,'2022-09-13 15:27:57'),(8,47,'Good Food',4,'2022-09-13 12:20:30'),(8,52,'Delicious food, enjoyed a lot.',5,'2022-10-20 17:09:05'),(10,47,'Good Food',3,'2022-10-06 15:43:26'),(10,48,'Delicious',4,'2022-10-17 11:52:35');
/*!40000 ALTER TABLE `restaurantreview_tb` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-13 16:17:03


--
-- Table structure for table `dishes_tb`
--

DROP TABLE IF EXISTS `public`.`dishes_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `public`.`dishes_tb` (
  `d_id` int(11) NOT NULL AUTO_INCREMENT,
  `rest_id` int(11) NOT NULL,
  `d_name` varchar(100) COLLATE utf8_bin NOT NULL,
  `d_cost` bigint(15) NOT NULL,
  `d_type` text COLLATE utf8_bin NOT NULL,
  `d_image` varchar(200) COLLATE utf8_bin NOT NULL,
  `d_totalRatings` int(11) NOT NULL DEFAULT '0',
  `d_totalCustomers` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`d_id`),
  UNIQUE KEY `rest_id_2` (`rest_id`,`d_name`),
  KEY `rest_id` (`rest_id`),
  CONSTRAINT `rest_id` FOREIGN KEY (`rest_id`) REFERENCES `restaurantlogin_tb` (`rest_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dishes_tb`
--

LOCK TABLES `public`.`dishes_tb` WRITE;
/*!40000 ALTER TABLE `dishes_tb` DISABLE KEYS */;
INSERT INTO `public`.`dishes_tb` VALUES (11,8,'corn pizza',300,'Veg','Restaurants/image/pexels-cats-coming-367915.jpg',24,6),(12,8,'veggie pizza',300,'Veg','Restaurants/image/pexels-daria-shevtsova-1260968.jpg',89,34),(13,8,'pepperoni pizza',400,'Non Veg','Restaurants/image/pexels-polina-tankilevitch-4109111.jpg',133,42),(14,9,'chole bhature',100,'Veg','Restaurants/image/_650x_2019121214325859.jpg',243,93),(16,9,'pav bhaji',150,'Veg','Restaurants/image/pav.png',186,59),(17,10,'idli sambhar',90,'Veg','Restaurants/image/idli.jpg',101,34),(18,10,'masala dosa',150,'Veg','Restaurants/image/Masala-Dosa-500x500.jpg',22,8),(19,10,'uttapam',120,'Veg','Restaurants/image/uttapam.jpg',116,39),(20,11,'kadhai paneer',250,'Veg','Restaurants/image/kadai-paneer-1-500x500.jpg',405,90),(21,11,'naan',60,'Veg','Restaurants/image/naan-recipe-2.jpg',23,7),(22,11,'palak paneer',230,'Veg','Restaurants/image/Palak-Paneer-4x5-LOWRES.jpg',40,12),(23,12,'mix veg',200,'Veg','Restaurants/image/mix veg.jpg',51,16),(24,12,'tandoori roti',25,'Veg','Restaurants/image/Tandoori-roti-5.jpg',23,6),(25,12,'tawa roti',15,'Veg','Restaurants/image/tawa.jpg',47,15),(26,13,'butter chicken',350,'Non Veg','Restaurants/image/butter chicken.jpg',0,0),(27,13,'mutton rogan josh',400,'Non Veg','Restaurants/image/Mutton-Rogan-Josh.jpg',47,15),(28,13,'tandoori chicken',370,'Non Veg','Restaurants/image/Tandoori-Chicken-1-3.jpg',47,17),(29,14,'chicken curry',350,'Non Veg','Restaurants/image/chicken-curry-recipe.jpg',9,2),(30,14,'mutton curry',370,'Non Veg','Restaurants/image/Kolhapuri-mutton-curry.jpg',19,7),(31,14,'paneer lababdar',250,'Veg','Restaurants/image/Paneer-Lababdar-3.jpg',22,7),(51,10,'kadhai paneer',310,'Veg','Restaurants/image/kadai-paneer-1-500x500.jpg',22,7);
/*!40000 ALTER TABLE `dishes_tb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_tb`
--

DROP TABLE IF EXISTS `public`.`order_tb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `public`.`order_tb` (
  `od_id` int(11) NOT NULL AUTO_INCREMENT,
  `o_id` varchar(100) COLLATE utf8_bin NOT NULL,
  `d_id` int(11) NOT NULL,
  `d_name` varchar(100) COLLATE utf8_bin NOT NULL,
  `d_quantity` int(11) NOT NULL,
  `r_id` int(11) NOT NULL,
  `o_status` enum('Order Confirmation','Preparing food','On its way','Delievered','Canceled') COLLATE utf8_bin NOT NULL DEFAULT 'Order Confirmation',
  `o_payment` int(11) NOT NULL,
  `c_email` varchar(50) COLLATE utf8_bin NOT NULL,
  `c_address` varchar(500) COLLATE utf8_bin NOT NULL,
  `c_latitude` varchar(30) COLLATE utf8_bin NOT NULL,
  `c_longitude` varchar(30) COLLATE utf8_bin NOT NULL,
  `o_datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`od_id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_tb`
--

LOCK TABLES `public`.`order_tb` WRITE;
/*!40000 ALTER TABLE `order_tb` DISABLE KEYS */;
INSERT INTO `public`.`order_tb` VALUES (59,'5f9c7210-43ea-11ed-9faf-63153f375fe9',12,'veggie pizza',1,8,'Delievered',300,'suyash.gautam97@gmail.com','S 85 kisaan bazaar vibhuti khand. opposite cinepolis one awadh mall, Gomti Nagar, Uttar Pradesh 226010, India','26.8496445','80.9770594','2022-10-04 19:12:22'),(60,'5f9c7210-43ea-11ed-9faf-63153f375fe9',13,'pepperoni pizza',1,8,'Delievered',400,'suyash.gautam97@gmail.com','S 85 kisaan bazaar vibhuti khand. opposite cinepolis one awadh mall, Gomti Nagar, Uttar Pradesh 226010, India','26.8496445','80.9770594','2022-10-04 19:12:22'),(61,'5bb56520-43f0-11ed-8c44-1f9f94416cfd',18,'masala dosa',1,10,'Order Confirmation',150,'suyash.gautam97@gmail.com','3/335 Vishal Khand, Gomti Nagar, Lucknow, Uttar Pradesh, India, 226010','26.847583002080484','80.98927974700926','2022-10-04 19:55:12'),(62,'5bb56520-43f0-11ed-8c44-1f9f94416cfd',19,'uttapam',1,10,'Order Confirmation',120,'suyash.gautam97@gmail.com','3/335 Vishal Khand, Gomti Nagar, Lucknow, Uttar Pradesh, India, 226010','26.847583002080484','80.98927974700926','2022-10-04 19:55:12'),(63,'142c7d40-43f2-11ed-8c44-1f9f94416cfd',21,'naan',4,11,'Order Confirmation',240,'suyash.gautam97@gmail.com','D-2313 Sector 4 Indira Nagar, Lucknow, Uttar Pradesh, India, 226016','26.8689082690969','80.98983764648438','2022-10-04 20:07:31'),(64,'142c7d40-43f2-11ed-8c44-1f9f94416cfd',22,'palak paneer',2,11,'Order Confirmation',460,'suyash.gautam97@gmail.com','D-2313 Sector 4 Indira Nagar, Lucknow, Uttar Pradesh, India, 226016','26.8689082690969','80.98983764648438','2022-10-04 20:07:31'),(65,'abeebd50-43f2-11ed-8c44-1f9f94416cfd',16,'pav bhaji',1,9,'Order Confirmation',150,'suyash.gautam97@gmail.com','D-2313 Block D Indira Nagar, Lucknow, Uttar Pradesh, India, 226016','26.879952181563638','80.9931206703186','2022-10-04 20:11:46'),(66,'cfca77e0-43f3-11ed-8c44-1f9f94416cfd',11,'corn pizza',1,8,'Delievered',300,'suyash.gautam97@gmail.com','C-117 H SECTOR A, Mandir Marg, Mahanagar, Lucknow, Uttar Pradesh 226006, India','26.847621291619046','80.98936557769775','2022-10-04 20:19:56'),(67,'d98fabe0-455d-11ed-8e0d-4d6e78744c6e',11,'corn pizza',1,8,'Canceled',300,'suyash.gautam97@gmail.com','3/335 Vishal Khand, Gomti Nagar, Lucknow, Uttar Pradesh, India, 226010','26.857097554074464','81.00013732910155','2022-10-06 15:31:30'),(68,'976cfcf0-46c4-11ed-8c7a-8f85317a427e',12,'veggie pizza',1,8,'Canceled',300,'suyash.gautam97@gmail.com','80, VIMAL KUNJ COLONY, PICNIC SPOT ROAD, Lucknow, Uttar Pradesh 226016, India','26.8466937','80.946166','2022-10-08 10:19:28'),(69,'91f24d20-46c9-11ed-8c7a-8f85317a427e',11,'corn pizza',1,8,'Canceled',300,'suyash.gautam97@gmail.com','3/335  Vishal Khand, Gomti Nagar, Lucknow , Uttar Pradesh, India, 226010','26.847468133387117','80.94898223876953','2022-10-08 10:55:06'),(70,'9c7e7520-4737-11ed-ae11-5d3466715f17',12,'veggie pizza',1,8,'Canceled',300,'suyash.gautam97@gmail.com','1/140, near Mantri Awas, Vibhav Khand, Gomti Nagar, Lucknow, Uttar Pradesh 226010, India','26.8466937','80.946166','2022-10-09 00:02:49'),(71,'10891410-479d-11ed-b3af-f90b5afc15e2',12,'veggie pizza',1,8,'Delievered',300,'suyash.gautam97@gmail.com','4/445, Vijayant Khand, Gomti Nagar, Lucknow, Uttar Pradesh 226010, India','26.8510379','80.9981468','2022-10-09 12:09:03'),(72,'7f3b1350-47c9-11ed-8f95-43709ef9d88a',11,'corn pizza',1,30,'Delievered',300,'suyash.gautam97@gmail.com','a aa, a, a, a, a','26.8510379','80.9981468','2022-10-09 17:27:06'),(73,'16a8d210-4fde-11ed-8bde-0333b192a636',12,'veggie pizza',1,8,'Canceled',300,'suyash.gautam97@gmail.com','5/599, Gwari Village, Vikas Khand, Gomti Nagar, Lucknow, Uttar Pradesh 226010, India','26.8477644','80.9890739','2022-10-19 18:44:39'),(74,'e0b50f50-4fe9-11ed-9689-c532e4d0d811',11,'corn pizza',2,8,'Delievered',600,'rahul.gauty97@gmail.com','78 Vishal Khand, Lucknow, Uttar Pradesh, India, 226010','26.851737341475044','80.98767042160034','2022-10-19 20:09:03');
/*!40000 ALTER TABLE `order_tb` ENABLE KEYS */;
UNLOCK TABLES;
