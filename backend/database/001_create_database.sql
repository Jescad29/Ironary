-- Crea la base de datos del proyecto Ironary
-- Ejecutar una sola vez, conectando al servidor 

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Ironary')
BEGIN
    CREATE DATABASE Ironary;
END
GO