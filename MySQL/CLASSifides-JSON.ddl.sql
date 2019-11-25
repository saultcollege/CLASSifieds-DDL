-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema CLASSifieds-JSON
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema CLASSifieds-JSON
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CLASSifieds-JSON` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `CLASSifieds-JSON` ;

-- -----------------------------------------------------
-- Table `CLASSifieds-JSON`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-JSON`.`user` (
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
-- Table `CLASSifieds-JSON`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-JSON`.`category` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent_category_id` INT UNSIGNED NULL,
  `name` VARCHAR(32) NOT NULL,
  `description` VARCHAR(256) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_category_category1_idx` (`parent_category_id` ASC),
  CONSTRAINT `fk_category_category1`
    FOREIGN KEY (`parent_category_id`)
    REFERENCES `CLASSifieds-JSON`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-JSON`.`listing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-JSON`.`listing` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `category_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `description` VARCHAR(2048) NULL,
  `price` INT UNSIGNED NOT NULL,
  `attributes` JSON NOT NULL DEFAULT '{}',
  PRIMARY KEY (`id`),
  INDEX `fk_listing_user_idx` (`user_id` ASC),
  INDEX `fk_listing_category1_idx` (`category_id` ASC),
  CONSTRAINT `fk_listing_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `CLASSifieds-JSON`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_listing_category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `CLASSifieds-JSON`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-JSON`.`listing_image`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-JSON`.`listing_image` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `listing_id` INT UNSIGNED NOT NULL,
  `path` VARCHAR(256) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_listing_image_listing1_idx` (`listing_id` ASC),
  CONSTRAINT `fk_listing_image_listing1`
    FOREIGN KEY (`listing_id`)
    REFERENCES `CLASSifieds-JSON`.`listing` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-JSON`.`watchlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-JSON`.`watchlist` (
  `user_id` INT UNSIGNED NOT NULL,
  `listing_id` INT UNSIGNED NOT NULL,
  `watched_since` DATETIME NOT NULL,
  PRIMARY KEY (`user_id`, `listing_id`),
  INDEX `fk_user_has_listing_listing1_idx` (`listing_id` ASC),
  INDEX `fk_user_has_listing_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_user_has_listing_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `CLASSifieds-JSON`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_listing_listing1`
    FOREIGN KEY (`listing_id`)
    REFERENCES `CLASSifieds-JSON`.`listing` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-JSON`.`thread`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-JSON`.`thread` (
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
    REFERENCES `CLASSifieds-JSON`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_thread_listing1`
    FOREIGN KEY (`listing_id`)
    REFERENCES `CLASSifieds-JSON`.`listing` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CLASSifieds-JSON`.`message`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CLASSifieds-JSON`.`message` (
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
    REFERENCES `CLASSifieds-JSON`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_message_thread1`
    FOREIGN KEY (`thread_id`)
    REFERENCES `CLASSifieds-JSON`.`thread` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
