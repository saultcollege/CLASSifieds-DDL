-- -----------------------------------------------------
-- Schema subtypes
-- -----------------------------------------------------
GO
IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = N'subtypes')
BEGIN
	EXEC sp_executesql N'CREATE SCHEMA subtypes' --Create schema must be only call in script
END

GO
-- -----------------------------------------------------
-- drop any existing tables
-- -----------------------------------------------------



DROP TABLE IF EXISTS subtypes.listing_image ;
DROP TABLE IF EXISTS subtypes.watchlist ;
DROP TABLE IF EXISTS subtypes.thread ;
DROP TABLE IF EXISTS subtypes.message ;
DROP TABLE IF EXISTS subtypes.textbook_listing ;
DROP TABLE IF EXISTS subtypes.electronics_listing ;
DROP TABLE IF EXISTS subtypes.clothing_listing ;
DROP TABLE IF EXISTS subtypes.computer_listing ;
DROP TABLE IF EXISTS subtypes.storage_listing ;
DROP TABLE IF EXISTS subtypes.phone_listing ;
DROP TABLE IF EXISTS subtypes.usb_listing ;
DROP TABLE IF EXISTS subtypes.drive_listing ;

DROP TABLE IF EXISTS subtypes.listing ;
DROP TABLE IF EXISTS subtypes.category ;
DROP TABLE IF EXISTS subtypes.[user] ;

GO
-- -----------------------------------------------------
-- Table subtypes.user
-- -----------------------------------------------------

CREATE TABLE subtypes.[user] (
  [id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY, --unsigned not supported
  [first_name] VARCHAR(45) NOT NULL,
  [last_name] VARCHAR(45) NOT NULL,
  [email] VARCHAR(45) NOT NULL,
  [phone] VARCHAR(16) NULL,
  [password] VARCHAR(256) NOT NULL,
  [profile_image_path] VARCHAR(256) NULL,
  CONSTRAINT [email_UNIQUE] UNIQUE (email asc))



-- -----------------------------------------------------
-- Table subtypes.category
-- -----------------------------------------------------

CREATE TABLE subtypes.category (
  id INT  NOT NULL IDENTITY(1,1) PRIMARY KEY,
  parent_category_id INT NULL,
  name VARCHAR(32) NOT NULL,
  description VARCHAR(256) NULL,
  INDEX fk_category_category1_idx (parent_category_id ASC),
  CONSTRAINT fk_category_category1
    FOREIGN KEY (parent_category_id)
    REFERENCES subtypes.category (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)

-- -----------------------------------------------------
-- Table subtypes.listing
-- -----------------------------------------------------

CREATE TABLE subtypes.listing (
  id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  user_id INT NOT NULL,
  category_id INT NOT NULL,
  title VARCHAR(45) NOT NULL,
  description VARCHAR(2048) NULL,
  price INT NOT NULL,
  INDEX fk_listing_user_idx (user_id ASC),
  INDEX fk_listing_category1_idx (category_id ASC),
  CONSTRAINT fk_listing_user
    FOREIGN KEY (user_id)
    REFERENCES subtypes.[user] (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_listing_category1
    FOREIGN KEY (category_id)
    REFERENCES subtypes.category (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table subtypes.listing_image
-- -----------------------------------------------------

CREATE TABLE  subtypes.listing_image (
  id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  listing_id INT NOT NULL,
  path VARCHAR(256) NULL,
  INDEX fk_listing_image_listing1_idx (listing_id ASC),
  CONSTRAINT fk_listing_image_listing1
    FOREIGN KEY (listing_id)
    REFERENCES subtypes.listing (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)



-- -----------------------------------------------------
-- Table subtypes.watchlist
-- -----------------------------------------------------

CREATE TABLE subtypes.watchlist (
  user_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  listing_id INT NOT NULL,
  watched_since DATETIME NOT NULL,
  INDEX fk_user_has_listing_listing1_idx (listing_id ASC),
  INDEX fk_user_has_listing_user1_idx (user_id ASC),
  CONSTRAINT fk_user_has_listing_user1
    FOREIGN KEY (user_id)
    REFERENCES subtypes.[user] (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_user_has_listing_listing1
    FOREIGN KEY (listing_id)
    REFERENCES subtypes.listing (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)



-- -----------------------------------------------------
-- Table subtypes.thread
-- -----------------------------------------------------

CREATE TABLE subtypes.thread (
  id INT NOT NULL  IDENTITY(1,1) PRIMARY KEY,
  buyer_user_id INT NOT NULL,
  listing_id INT NOT NULL,
  buyer_last_read_timestamp DATETIME NOT NULL DEFAULT GETUTCDATE(),
  seller_last_read_timestamp DATETIME NOT NULL DEFAULT GETUTCDATE(), --can't have two timestamps, switched to datetime
  INDEX fk_thread_user1_idx (buyer_user_id ASC),
  INDEX fk_thread_listing1_idx (listing_id ASC),
  CONSTRAINT fk_thread_user1
    FOREIGN KEY (buyer_user_id)
    REFERENCES subtypes.[user] (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_thread_listing1
    FOREIGN KEY (listing_id)
    REFERENCES subtypes.listing (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table subtypes.message
-- -----------------------------------------------------

CREATE TABLE subtypes.message (
  id INT NOT NULL  IDENTITY(1,1) PRIMARY KEY,
  sender_user_id INT NOT NULL,
  thread_id INT NOT NULL,
  message_text TEXT NOT NULL,
  send_timestamp DATETIME NOT NULL DEFAULT GETUTCDATE(),
  INDEX fk_message_user1_idx (sender_user_id ASC),
  INDEX fk_message_thread1_idx (thread_id ASC),
  CONSTRAINT fk_message_user1
    FOREIGN KEY (sender_user_id)
    REFERENCES subtypes.[user] (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_message_thread1
    FOREIGN KEY (thread_id)
    REFERENCES subtypes.thread (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table subtypes.textbook_listing
-- -----------------------------------------------------

CREATE TABLE subtypes.textbook_listing (
  listing_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  edition VARCHAR(10) NULL,
  author VARCHAR(100) NULL,
  publisher VARCHAR(50) NULL,
  INDEX fk_textbook_listing_listing1_idx (listing_id ASC),
  CONSTRAINT fk_textbook_listing_listing1
    FOREIGN KEY (listing_id)
    REFERENCES subtypes.listing (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)



-- -----------------------------------------------------
-- Table subtypes.electronics_listing
-- -----------------------------------------------------

CREATE TABLE subtypes.electronics_listing (
  listing_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  make VARCHAR(50) NULL,
  model VARCHAR(50) NULL,
  INDEX fk_textbook_listing_listing1_idx (listing_id ASC),
  CONSTRAINT fk_textbook_listing_listing10
    FOREIGN KEY (listing_id)
    REFERENCES subtypes.listing (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)



-- -----------------------------------------------------
-- Table subtypes.clothing_listing
-- -----------------------------------------------------

CREATE TABLE subtypes.clothing_listing (
  listing_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  size VARCHAR(20) NULL,
  INDEX fk_textbook_listing_listing1_idx (listing_id ASC),
  CONSTRAINT fk_textbook_listing_listing11
    FOREIGN KEY (listing_id)
    REFERENCES subtypes.listing (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)



-- -----------------------------------------------------
-- Table subtypes.computer_listing
-- -----------------------------------------------------

CREATE TABLE subtypes.computer_listing (
  listing_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  processor VARCHAR(50) NULL,
  CONSTRAINT fk_textbook_listing_listing100
    FOREIGN KEY (listing_id)
    REFERENCES subtypes.electronics_listing (listing_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)



-- -----------------------------------------------------
-- Table subtypes.storage_listing
-- -----------------------------------------------------

CREATE TABLE subtypes.storage_listing (
  listing_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  space VARCHAR(50) NULL,
  CONSTRAINT fk_textbook_listing_listing1000
    FOREIGN KEY (listing_id)
    REFERENCES subtypes.electronics_listing (listing_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)



-- -----------------------------------------------------
-- Table subtypes.phone_listing
-- -----------------------------------------------------

CREATE TABLE subtypes.phone_listing (
  listing_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  screen_size VARCHAR(50) NULL,
  CONSTRAINT fk_textbook_listing_listing10000
    FOREIGN KEY (listing_id)
    REFERENCES subtypes.electronics_listing (listing_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)



-- -----------------------------------------------------
-- Table subtypes.usb_listing
-- -----------------------------------------------------

CREATE TABLE subtypes.usb_listing (
  listing_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  space VARCHAR(50) NULL,
  CONSTRAINT fk_textbook_listing_listing10001
    FOREIGN KEY (listing_id)
    REFERENCES subtypes.storage_listing (listing_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)



-- -----------------------------------------------------
-- Table subtypes.drive_listing
-- -----------------------------------------------------


CREATE TABLE subtypes.drive_listing (
  listing_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  ssd_hdd VARCHAR(50) NULL,
  CONSTRAINT fk_textbook_listing_listing100010
    FOREIGN KEY (listing_id)
    REFERENCES subtypes.storage_listing (listing_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)


