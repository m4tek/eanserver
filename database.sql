-- phpMyAdmin SQL Dump
-- version 4.9.2deb1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 23, 2020 at 12:57 PM
-- Server version: 10.3.18-MariaDB-0+deb10u1
-- PHP Version: 7.3.11-1~deb10u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `EAN`
--
CREATE DATABASE IF NOT EXISTS `EAN` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `EAN`;

-- --------------------------------------------------------

--
-- Table structure for table `brands`
--

DROP TABLE IF EXISTS `brands`;
CREATE TABLE `brands` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `brand` varchar(255) NOT NULL,
  `added` timestamp NOT NULL DEFAULT current_timestamp(),
  `old_name` bigint(20) UNSIGNED DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `catergory` varchar(40) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `manufacturers`
--

DROP TABLE IF EXISTS `manufacturers`;
CREATE TABLE `manufacturers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `manufacturer` varchar(255) NOT NULL,
  `old_name` bigint(20) UNSIGNED DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `added` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `ean` varchar(255) NOT NULL,
  `category` bigint(20) UNSIGNED DEFAULT NULL,
  `simple_name` varchar(255) NOT NULL,
  `manufacturer` bigint(20) UNSIGNED NOT NULL,
  `amount` float UNSIGNED DEFAULT NULL,
  `unit` varchar(10) DEFAULT NULL,
  `brand` bigint(20) UNSIGNED NOT NULL,
  `added` timestamp NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Stand-in structure for view `productviews`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `productviews`;
CREATE TABLE `productviews` (
`id` bigint(20) unsigned
,`name` varchar(255)
,`ean` varchar(255)
,`category` varchar(40)
,`simple_name` varchar(255)
,`manufacturer` varchar(255)
,`amount` float unsigned
,`unit` varchar(10)
,`brand` varchar(255)
);

-- --------------------------------------------------------

--
-- Structure for view `productviews`
--
DROP TABLE IF EXISTS `productviews`;

CREATE ALGORITHM=UNDEFINED DEFINER=`ean_user`@`localhost` SQL SECURITY DEFINER VIEW `productviews`  AS  select `products`.`id` AS `id`,`products`.`name` AS `name`,`products`.`ean` AS `ean`,`categories`.`catergory` AS `category`,`products`.`simple_name` AS `simple_name`,`manufacturers`.`manufacturer` AS `manufacturer`,`products`.`amount` AS `amount`,`products`.`unit` AS `unit`,`brands`.`brand` AS `brand` from (((`products` join `categories` on(`products`.`category` = `categories`.`id`)) join `manufacturers` on(`products`.`manufacturer` = `manufacturers`.`id`)) join `brands` on(`products`.`brand` = `brands`.`id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Old brand` (`old_name`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `manufacturers`
--
ALTER TABLE `manufacturers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ean` (`ean`,`active`) USING BTREE,
  ADD KEY `brand` (`brand`),
  ADD KEY `manufaturer` (`manufacturer`),
  ADD KEY `category` (`category`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `brands`
--
ALTER TABLE `brands`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `manufacturers`
--
ALTER TABLE `manufacturers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `brand` FOREIGN KEY (`brand`) REFERENCES `brands` (`id`),
  ADD CONSTRAINT `category` FOREIGN KEY (`category`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `manufaturer` FOREIGN KEY (`manufacturer`) REFERENCES `manufacturers` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
