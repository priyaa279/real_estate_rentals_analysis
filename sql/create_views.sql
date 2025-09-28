-- Drop and create the 'housing' view
DROP VIEW IF EXISTS housing;

CREATE OR REPLACE VIEW housing AS
SELECT
    p.zipcode,
    p.price,
    p.address,
    p.beds,
    p.baths,
    p.sqft,
    p.city,
    p.state,

    -- Crime totals (aggregated by zipcode)
    COALESCE(c24.total_crimes_2024, 0) AS total_crimes_2024,
    COALESCE(c25.total_crimes_2025, 0) AS total_crimes_2025,
    COALESCE(c24.total_crimes_2024, 0) + COALESCE(c25.total_crimes_2025, 0) AS total_crimes,

    -- ZHVI values (recent or fallback)
    COALESCE(z1.zhvi_value, z2.zhvi_value) AS recent_zhvi_value,
    COALESCE(z1.date, z2.date) AS recent_zhvi_date,

    -- ZORI values (recent or fallback)
    COALESCE(r1.zori_value, r2.zori_value) AS recent_zori_value,
    COALESCE(r1.date, r2.date) AS recent_zori_date

FROM property_listings p

-- Join aggregated 2024 crime data
LEFT JOIN (
    SELECT zipcode, COUNT(*) AS total_crimes_2024
    FROM crime_2024
    GROUP BY zipcode
) c24 ON p.zipcode = c24.zipcode

-- Join aggregated 2025 crime data
LEFT JOIN (
    SELECT zipcode, COUNT(*) AS total_crimes_2025
    FROM crime_2025
    GROUP BY zipcode
) c25 ON p.zipcode = c25.zipcode

-- ZHVI ZIP-level data
LEFT JOIN (
    SELECT zipcode, city, state, date, zhvi_value
    FROM zhvi
    WHERE date = (SELECT MAX(date) FROM zhvi)
) z1 ON p.zipcode = z1.zipcode

-- ZHVI City-level average fallback
LEFT JOIN (
    SELECT city, state, MAX(date) AS date, AVG(zhvi_value) AS zhvi_value
    FROM zhvi
    WHERE date = (SELECT MAX(date) FROM zhvi)
    GROUP BY city, state
) z2 ON p.state = z2.state AND p.city = z2.city

-- ZORI ZIP-level (primary)
LEFT JOIN (
    SELECT zipcode, city, state, date, zori_value
    FROM zori
    WHERE date = (SELECT MAX(date) FROM zori)
) r1 ON p.zipcode = r1.zipcode

-- ZORI ZIP-level (alternative source)
LEFT JOIN (
    SELECT zipcode, city, state, date, zori_value
    FROM zori1
    WHERE date = (SELECT MAX(date) FROM zori1)
) r2 ON p.zipcode = r2.zipcode;


-- Drop and create the 'zori_zhvi_time_data' view
DROP VIEW IF EXISTS zori_zhvi_time_data;

CREATE OR REPLACE VIEW zori_zhvi_time_data AS
SELECT
    z1.zipcode,
    z1.zhvi_value AS zhvi_value,
    z1.date AS zhvi_date,
    COALESCE(r1.zori_value, r2.zori_value) AS zori_value,
    COALESCE(r1.date, r2.date) AS zori_date

FROM zhvi z1
LEFT JOIN zori r1 ON z1.zipcode = r1.zipcode AND z1.date = r1.date
LEFT JOIN zori1 r2 ON z1.zipcode = r2.zipcode AND z1.date = r2.date;
