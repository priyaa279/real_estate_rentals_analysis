DROP TABLE IF EXISTS property_listings;
DROP TABLE IF EXISTS zhvi;
DROP TABLE IF EXISTS zori;
DROP TABLE IF EXISTS zori1;
DROP TABLE IF EXISTS crime_2024;
DROP TABLE IF EXISTS crime_2025;

CREATE TABLE property_listings(
	zipcode TEXT,
	price DOUBLE PRECISION,
	address TEXT,
	beds TEXT,
	baths TEXT,
	sqft DOUBLE PRECISION,
	city TEXT,
	state TEXT
);

CREATE TABLE zhvi(
	region_id INT,
	size_rank INT,
	zipcode TEXT,
	county TEXT,
	state TEXT,
	city TEXT,
	metro TEXT,
	date DATE,
	zhvi_value DOUBLE PRECISION
);

CREATE TABLE zori(
	region_id INT,
	size_rank INT,
	zipcode TEXT,
	county TEXT,
	state TEXT,
	city TEXT,
	metro TEXT,
	date DATE,
	zori_value DOUBLE PRECISION
);

CREATE TABLE zori1(
	region_id INT,
	size_rank INT,
	zipcode TEXT,
	county TEXT,
	state TEXT,
	city TEXT,
	metro TEXT,
	date DATE,
	zori_value DOUBLE PRECISION
);

CREATE TABLE crime_2024(
	occurence_date DATE,
	nibrs_description TEXT,
	offense_count INT,
	premise TEXT,
	street_no TEXT,
	street_name TEXT,
	street_type TEXT,
	city TEXT,
	zipcode TEXT,
	longitude DOUBLE PRECISION,
	latitude DOUBLE PRECISION
);

CREATE TABLE crime_2025(
	occurence_date DATE,
	nibrs_description TEXT,
	offense_count INT,
	premise TEXT,
	street_no TEXT,
	street_name TEXT,
	street_type TEXT,
	city TEXT,
	zipcode TEXT,
	longitude DOUBLE PRECISION,
	latitude DOUBLE PRECISION
);
