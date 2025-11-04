

CREATE DATABASE vector_db;

-- Connect to the new database to enable the extension
\c vector_db
CREATE EXTENSION IF NOT EXISTS vector;