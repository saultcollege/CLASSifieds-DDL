-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema CLASSifieds-Subtypes
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema CLASSifieds-Subtypes
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CLASSifieds-Subtypes` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `CLASSifieds-Subtypes` ;

-- -----------------------------------------------------
-- Table `CLASSifieds-Subtypes`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-Subtypes`.`user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(16) NULL,
  `password` VARCHAR(256) NOT NULL,
  `profile_image_path` VARCHAR(256) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-Subtypes`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-Subtypes`.`category` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent_category_id` INT UNSIGNED NULL,
  `name` VARCHAR(32) NOT NULL,
  `description` VARCHAR(256) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_category_category1_idx` (`parent_category_id` ASC),
  CONSTRAINT `fk_category_category1`
    FOREIGN KEY (`parent_category_id`)
    REFERENCES `CLASSifieds-Subtypes`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-Subtypes`.`listing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-Subtypes`.`listing` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `category_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `description` VARCHAR(2048) NULL,
  `price` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_listing_user_idx` (`user_id` ASC),
  INDEX `fk_listing_category1_idx` (`category_id` ASC),
  CONSTRAINT `fk_listing_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `CLASSifieds-Subtypes`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_listing_category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `CLASSifieds-Subtypes`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-Subtypes`.`listing_image`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-Subtypes`.`listing_image` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `listing_id` INT UNSIGNED NOT NULL,
  `path` VARCHAR(256) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_listing_image_listing1_idx` (`listing_id` ASC),
  CONSTRAINT `fk_listing_image_listing1`
    FOREIGN KEY (`listing_id`)
    REFERENCES `CLASSifieds-Subtypes`.`listing` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-Subtypes`.`watchlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-Subtypes`.`watchlist` (
  `user_id` INT UNSIGNED NOT NULL,
  `listing_id` INT UNSIGNED NOT NULL,
  `watched_since` DATETIME NOT NULL,
  PRIMARY KEY (`user_id`, `listing_id`),
  INDEX `fk_user_has_listing_listing1_idx` (`listing_id` ASC),
  INDEX `fk_user_has_listing_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_user_has_listing_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `CLASSifieds-Subtypes`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_listing_listing1`
    FOREIGN KEY (`listing_id`)
    REFERENCES `CLASSifieds-Subtypes`.`listing` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-Subtypes`.`thread`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-Subtypes`.`thread` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `buyer_user_id` INT UNSIGNED NOT NULL,
  `listing_id` INT UNSIGNED NOT NULL,
  `buyer_last_read_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `seller_last_read_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_thread_user1_idx` (`buyer_user_id` ASC),
  INDEX `fk_thread_listing1_idx` (`listing_id` ASC),
  CONSTRAINT `fk_thread_user1`
    FOREIGN KEY (`buyer_user_id`)
    REFERENCES `CLASSifieds-Subtypes`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_thread_listing1`
    FOREIGN KEY (`listing_id`)
    REFERENCES `CLASSifieds-Subtypes`.`listing` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-Subtypes`.`message`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-Subtypes`.`message` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `sender_user_id` INT UNSIGNED NOT NULL,
  `thread_id` INT UNSIGNED NOT NULL,
  `message_text` TEXT NOT NULL,
  `send_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_message_user1_idx` (`sender_user_id` ASC),
  INDEX `fk_message_thread1_idx` (`thread_id` ASC),
  CONSTRAINT `fk_message_user1`
    FOREIGN KEY (`sender_user_id`)
    REFERENCES `CLASSifieds-Subtypes`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_message_thread1`
    FOREIGN KEY (`thread_id`)
    REFERENCES `CLASSifieds-Subtypes`.`thread` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-Subtypes`.`textbook_listing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-Subtypes`.`textbook_listing` (
  `listing_id` INT UNSIGNED NOT NULL,
  `edition` VARCHAR(10) NULL,
  `author` VARCHAR(100) NULL,
  `publisher` VARCHAR(50) NULL,
  INDEX `fk_textbook_listing_listing1_idx` (`listing_id` ASC),
  PRIMARY KEY (`listing_id`),
  CONSTRAINT `fk_textbook_listing_listing1`
    FOREIGN KEY (`listing_id`)
    REFERENCES `CLASSifieds-Subtypes`.`listing` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-Subtypes`.`electronics_listing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-Subtypes`.`electronics_listing` (
  `listing_id` INT UNSIGNED NOT NULL,
  `make` VARCHAR(50) NULL,
  `model` VARCHAR(50) NULL,
  INDEX `fk_textbook_listing_listing1_idx` (`listing_id` ASC),
  PRIMARY KEY (`listing_id`),
  CONSTRAINT `fk_textbook_listing_listing10`
    FOREIGN KEY (`listing_id`)
    REFERENCES `CLASSifieds-Subtypes`.`listing` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-Subtypes`.`clothing_listing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-Subtypes`.`clothing_listing` (
  `listing_id` INT UNSIGNED NOT NULL,
  `size` VARCHAR(20) NULL,
  INDEX `fk_textbook_listing_listing1_idx` (`listing_id` ASC),
  PRIMARY KEY (`listing_id`),
  CONSTRAINT `fk_textbook_listing_listing11`
    FOREIGN KEY (`listing_id`)
    REFERENCES `CLASSifieds-Subtypes`.`listing` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-Subtypes`.`computer_listing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-Subtypes`.`computer_listing` (
  `listing_id` INT UNSIGNED NOT NULL,
  `processor` VARCHAR(50) NULL,
  PRIMARY KEY (`listing_id`),
  CONSTRAINT `fk_textbook_listing_listing100`
    FOREIGN KEY (`listing_id`)
    REFERENCES `CLASSifieds-Subtypes`.`electronics_listing` (`listing_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-Subtypes`.`storage_listing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-Subtypes`.`storage_listing` (
  `listing_id` INT UNSIGNED NOT NULL,
  `space` VARCHAR(50) NULL,
  PRIMARY KEY (`listing_id`),
  CONSTRAINT `fk_textbook_listing_listing1000`
    FOREIGN KEY (`listing_id`)
    REFERENCES `CLASSifieds-Subtypes`.`electronics_listing` (`listing_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-Subtypes`.`phone_listing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-Subtypes`.`phone_listing` (
  `listing_id` INT UNSIGNED NOT NULL,
  `screen_size` VARCHAR(50) NULL,
  PRIMARY KEY (`listing_id`),
  CONSTRAINT `fk_textbook_listing_listing10000`
    FOREIGN KEY (`listing_id`)
    REFERENCES `CLASSifieds-Subtypes`.`electronics_listing` (`listing_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-Subtypes`.`usb_listing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-Subtypes`.`usb_listing` (
  `listing_id` INT UNSIGNED NOT NULL,
  `space` VARCHAR(50) NULL,
  PRIMARY KEY (`listing_id`),
  CONSTRAINT `fk_textbook_listing_listing10001`
    FOREIGN KEY (`listing_id`)
    REFERENCES `CLASSifieds-Subtypes`.`storage_listing` (`listing_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-Subtypes`.`drive_listing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-Subtypes`.`drive_listing` (
  `listing_id` INT UNSIGNED NOT NULL,
  `ssd_hdd` VARCHAR(50) NULL,
  PRIMARY KEY (`listing_id`),
  CONSTRAINT `fk_textbook_listing_listing100010`
    FOREIGN KEY (`listing_id`)
    REFERENCES `CLASSifieds-Subtypes`.`storage_listing` (`listing_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
