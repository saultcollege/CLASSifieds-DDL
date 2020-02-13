-- -----------------------------------------------------
-- Schema eav
-- -----------------------------------------------------
GO
IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = N'eav')
BEGIN
	EXEC sp_executesql N'CREATE SCHEMA eav' --Create schema must be only call in script
END

GO
-- -----------------------------------------------------
-- drop any existing tables
-- -----------------------------------------------------



DROP TABLE IF EXISTS eav.listing_image ;
DROP TABLE IF EXISTS eav.watchlist ;
DROP TABLE IF EXISTS eav.message ;

DROP TABLE IF EXISTS eav.thread ;
DROP TABLE IF EXISTS eav.listing ;
DROP TABLE IF EXISTS eav.category ;
DROP TABLE IF EXISTS eav.[user] ;

GO
-- -----------------------------------------------------
-- Table eav.user
-- -----------------------------------------------------

CREATE TABLE eav.[user] (
  [id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY, --unsigned not supported
  [first_name] VARCHAR(45) NOT NULL,
  [last_name] VARCHAR(45) NOT NULL,
  [email] VARCHAR(45) NOT NULL,
  [phone] VARCHAR(16) NULL,
  [password] VARCHAR(256) NOT NULL,
  [profile_image_path] VARCHAR(256) NULL,
  CONSTRAINT [email_UNIQUE] UNIQUE (email asc))



-- -----------------------------------------------------
-- Table eav.category
-- -----------------------------------------------------

CREATE TABLE eav.category (
  id INT  NOT NULL IDENTITY(1,1) PRIMARY KEY,
  parent_category_id INT NULL,
  name VARCHAR(32) NOT NULL,
  description VARCHAR(256) NULL,
  INDEX fk_category_category1_idx (parent_category_id ASC),
  CONSTRAINT fk_category_category1
    FOREIGN KEY (parent_category_id)
    REFERENCES eav.category (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)

-- -----------------------------------------------------
-- Table eav.listing
-- -----------------------------------------------------

CREATE TABLE eav.listing (
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
    REFERENCES eav.[user] (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_listing_category1
    FOREIGN KEY (category_id)
    REFERENCES eav.category (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table eav.listing_image
-- -----------------------------------------------------

CREATE TABLE  eav.listing_image (
  id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  listing_id INT NOT NULL,
  path VARCHAR(256) NULL,
  INDEX fk_listing_image_listing1_idx (listing_id ASC),
  CONSTRAINT fk_listing_image_listing1
    FOREIGN KEY (listing_id)
    REFERENCES eav.listing (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)



-- -----------------------------------------------------
-- Table eav.watchlist
-- -----------------------------------------------------

CREATE TABLE eav.watchlist (
  user_id INT NOT NULL UNIQUE,
  listing_id INT NOT NULL,
  watched_since DATETIME NOT NULL,
  INDEX fk_user_has_listing_listing1_idx (listing_id ASC),
  INDEX fk_user_has_listing_user1_idx (user_id ASC),
  CONSTRAINT fk_user_has_listing_user1
    FOREIGN KEY (user_id)
    REFERENCES eav.[user] (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_user_has_listing_listing1
    FOREIGN KEY (listing_id)
    REFERENCES eav.listing (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)



-- -----------------------------------------------------
-- Table eav.thread
-- -----------------------------------------------------

CREATE TABLE eav.thread (
  id INT NOT NULL  IDENTITY(1,1) PRIMARY KEY,
  buyer_user_id INT NOT NULL,
  listing_id INT NOT NULL,
  buyer_last_read_timestamp DATETIME NOT NULL DEFAULT GETUTCDATE(),
  seller_last_read_timestamp DATETIME NOT NULL DEFAULT GETUTCDATE(), --can't have two timestamps, switched to datetime
  INDEX fk_thread_user1_idx (buyer_user_id ASC),
  INDEX fk_thread_listing1_idx (listing_id ASC),
  CONSTRAINT fk_thread_user1
    FOREIGN KEY (buyer_user_id)
    REFERENCES eav.[user] (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_thread_listing1
    FOREIGN KEY (listing_id)
    REFERENCES eav.listing (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table eav.message
-- -----------------------------------------------------

CREATE TABLE eav.message (
  id INT NOT NULL  IDENTITY(1,1) PRIMARY KEY,
  sender_user_id INT NOT NULL,
  thread_id INT NOT NULL,
  message_text TEXT NOT NULL,
  send_timestamp DATETIME NOT NULL DEFAULT GETUTCDATE(),
  INDEX fk_message_user1_idx (sender_user_id ASC),
  INDEX fk_message_thread1_idx (thread_id ASC),
  CONSTRAINT fk_message_user1
    FOREIGN KEY (sender_user_id)
    REFERENCES eav.[user] (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_message_thread1
    FOREIGN KEY (thread_id)
    REFERENCES eav.thread (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table CLASSifieds-EAV.attribute
-- -----------------------------------------------------
DROP TABLE IF EXISTS CLASSifieds-EAV.attribute ;

CREATE TABLE IF NOT EXISTS CLASSifieds-EAV.attribute (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(500) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX name_UNIQUE (name ASC))



-- -----------------------------------------------------
-- Table CLASSifieds-EAV.listing_attributes
-- -----------------------------------------------------
DROP TABLE IF EXISTS CLASSifieds-EAV.listing_attributes ;

CREATE TABLE IF NOT EXISTS CLASSifieds-EAV.listing_attributes (
  listing_id INT UNSIGNED NOT NULL,
  attribute_id INT UNSIGNED NOT NULL,
  value VARCHAR(1000) NOT NULL,
  PRIMARY KEY (listing_id, attribute_id),
  INDEX fk_listing_attributes_attribute1_idx (attribute_id ASC),
  CONSTRAINT fk_listing_attributes_listing1
    FOREIGN KEY (listing_id)
    REFERENCES CLASSifieds-EAV.listing (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_listing_attributes_attribute1
    FOREIGN KEY (attribute_id)
    REFERENCES CLASSifieds-EAV.attribute (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)


