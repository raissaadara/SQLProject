CREATE DATABASE RoCALink
USE RoCALink


CREATE TABLE BikeType(
  ID CHAR(5) PRIMARY KEY CHECK (ID LIKE 'BT[0-9][0-9][0-9]'),
  Name VARCHAR(64) NOT NULL
)


CREATE TABLE BikeGroupSet(
 ID CHAR(5) PRIMARY KEY CHECK (ID LIKE 'GR[0-9][0-9][0-9]'),
 Name VARCHAR(64) NOT NULL,
 GearNumber INT NOT NULL CHECK (GearNumber > 4 AND GearNumber < 12),
 WirelessCapability VARCHAR(8) NOT NULL CHECK (WirelessCapability IN ('True', 'False'))
)


CREATE TABLE BikeBrand (
 ID CHAR(5) PRIMARY KEY CHECK (ID LIKE 'BR[0-9][0-9][0-9]'),
 Name VARCHAR(64) NOT NULL,
 Description VARCHAR(255) NOT NULL,
 Website VARCHAR(64) NOT NULL CHECK (Website LIKE 'www.%'),
 Nationality VARCHAR(32) NOT NULL
)


CREATE TABLE Bike (
	ID CHAR(5) PRIMARY KEY CHECK (ID Like 'BK[0-9][0-9][0-9]'),
	Name VARCHAR(64) NOT NULL,
	Price INT NOT NULL CHECK (Price > 0),
	
	TypeID CHAR(5) NOT NULL CHECK (TypeID Like 'BT[0-9][0-9][0-9]'),
	GroupSetID CHAR(5) NOT NULL CHECK (GroupSetID Like 'GR[0-9][0-9][0-9]'),
	BrandID CHAR(5) NOT NULL CHECK (BrandID LIKE 'BR[0-9][0-9][0-9]'),

	FOREIGN KEY (TypeID) REFERENCES BikeType(ID),
	FOREIGN KEY (GroupSetID) REFERENCES BikeGroupSet(ID),
	FOREIGN KEY (BrandID) REFERENCES BikeBrand(ID)
)


CREATE TABLE Staff (
	ID CHAR(5) PRIMARY KEY CHECK (ID Like 'ST[0-9][0-9][0-9]'),
	Name VARCHAR(64) NOT NULL CHECK (LEN(Name) > 4),
	Email VARCHAR(64) NOT NULL CHECK (Email Like '%@rocalink.com'),
	Phone VARCHAR(16) NOT NULL CHECK (Phone LIKE '08%'),
	Gender VARCHAR(8) NOT NULL CHECK (Gender IN ('Male', 'Female')),
	Salary INT NOT NULL
)


CREATE TABLE Customer (
	ID CHAR(5) PRIMARY KEY CHECK (ID Like 'CU[0-9][0-9][0-9]'),
	Name VARCHAR(64) NOT NULL CHECK (LEN(Name) > 4),
	Email VARCHAR(64) NOT NULL CHECK (Email Like '%@gmail.com'),
	Phone VARCHAR(16) NOT NULL CHECK (Phone LIKE '08%'),
	Gender VARCHAR(8) NOT NULL CHECK (Gender IN ('Male', 'Female')),
)


CREATE TABLE TransactionHeader (
	ID CHAR(5) PRIMARY KEY CHECK (ID Like 'TR[0-9][0-9][0-9]'),
	Date DATE NOT NULL CHECK (Date<= GETDATE()),
	StaffID CHAR(5) NOT NULL CHECK (StaffID LIKE 'ST[0-9][0-9][0-9]'),
	CustomerID CHAR(5) NOT NULL CHECK (CustomerID LIKE 'CU[0-9][0-9][0-9]'),


	FOREIGN KEY (StaffID) REFERENCES Staff(ID),
	FOREIGN KEY (CustomerID) REFERENCES Customer(ID)
)


CREATE TABLE TransactionDetail (
	ID CHAR(5) NOT NULL CHECK (ID Like 'TR[0-9][0-9][0-9]'),

	BikeID CHAR(5) NOT NULL CHECK (BikeID LIKE 'BK[0-9][0-9][0-9]'),
	Quantity INT NOT NULL CHECK (Quantity > 0)


	FOREIGN KEY (ID) REFERENCES TransactionHeader(ID)
)