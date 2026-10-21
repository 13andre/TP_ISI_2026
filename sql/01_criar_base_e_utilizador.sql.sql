USE master;
GO
IF DB_ID('mundial2026') IS NULL
    CREATE DATABASE mundial2026;
GO
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'kettle')
    CREATE LOGIN kettle WITH PASSWORD = 'A-Tua-Senha-Aqui1!', CHECK_EXPIRATION = OFF;
GO
USE mundial2026;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'kettle')
    CREATE USER kettle FOR LOGIN kettle;
GO
ALTER ROLE db_owner ADD MEMBER kettle;
GO