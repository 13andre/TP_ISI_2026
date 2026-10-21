USE [master]
GO
/****** Object:  Database [mundial2026]    Script Date: 21/10/2026 17:30:42 ******/
CREATE DATABASE [mundial2026]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'mundial2026', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\mundial2026.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'mundial2026_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\mundial2026_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [mundial2026] SET COMPATIBILITY_LEVEL = 170
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [mundial2026].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [mundial2026] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [mundial2026] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [mundial2026] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [mundial2026] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [mundial2026] SET ARITHABORT OFF 
GO
ALTER DATABASE [mundial2026] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [mundial2026] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [mundial2026] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [mundial2026] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [mundial2026] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [mundial2026] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [mundial2026] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [mundial2026] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [mundial2026] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [mundial2026] SET  DISABLE_BROKER 
GO
ALTER DATABASE [mundial2026] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [mundial2026] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [mundial2026] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [mundial2026] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [mundial2026] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [mundial2026] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [mundial2026] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [mundial2026] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [mundial2026] SET  MULTI_USER 
GO
ALTER DATABASE [mundial2026] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [mundial2026] SET DB_CHAINING OFF 
GO
ALTER DATABASE [mundial2026] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [mundial2026] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [mundial2026] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [mundial2026] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [mundial2026] SET OPTIMIZED_LOCKING = OFF 
GO
ALTER DATABASE [mundial2026] SET QUERY_STORE = ON
GO
ALTER DATABASE [mundial2026] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [mundial2026]
GO
/****** Object:  User [kettle]    Script Date: 21/10/2026 17:30:42 ******/
CREATE USER [kettle] FOR LOGIN [kettle] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [kettle]
GO
/****** Object:  Table [dbo].[classificacao_grupo]    Script Date: 21/10/2026 17:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[classificacao_grupo](
	[team_id] [bigint] NULL,
	[team_name] [varchar](22) NULL,
	[group_letter] [varchar](1) NULL,
	[confederation] [varchar](8) NULL,
	[played] [bigint] NULL,
	[wins] [int] NULL,
	[draws] [int] NULL,
	[losses] [int] NULL,
	[goals_for] [int] NULL,
	[goals_against] [int] NULL,
	[goal_difference] [int] NULL,
	[points] [int] NULL,
	[position] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_match_details]    Script Date: 21/10/2026 17:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_match_details](
	[match_id] [bigint] NULL,
	[home_team] [varchar](100) NULL,
	[away_team] [varchar](100) NULL,
	[home_score] [bigint] NULL,
	[away_score] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_match_events]    Script Date: 21/10/2026 17:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_match_events](
	[event_id] [bigint] NULL,
	[match_id] [bigint] NULL,
	[minute] [bigint] NULL,
	[event_type] [varchar](100) NULL,
	[team_id] [bigint] NULL,
	[player_id] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_matches]    Script Date: 21/10/2026 17:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_matches](
	[match_id] [bigint] NULL,
	[date] [datetime] NULL,
	[kickoff_time_utc] [varchar](5) NULL,
	[stage_id] [bigint] NULL,
	[venue_id] [bigint] NULL,
	[home_team_id] [bigint] NULL,
	[away_team_id] [bigint] NULL,
	[home_score] [bigint] NULL,
	[away_score] [bigint] NULL,
	[home_penalty_score] [bigint] NULL,
	[away_penalty_score] [bigint] NULL,
	[status] [varchar](9) NULL,
	[result_type] [varchar](9) NULL,
	[home_xg] [bigint] NULL,
	[away_xg] [bigint] NULL,
	[referee_id] [bigint] NULL,
	[player_of_the_match_id] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_teams]    Script Date: 21/10/2026 17:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_teams](
	[team_id] [bigint] NULL,
	[team_name] [varchar](22) NULL,
	[fifa_code] [varchar](3) NULL,
	[group_letter] [varchar](1) NULL,
	[confederation] [varchar](8) NULL,
	[fifa_ranking_pre_tournament] [bigint] NULL,
	[elo_rating] [bigint] NULL,
	[manager_name] [varchar](19) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_tornement_stages]    Script Date: 21/10/2026 17:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_tornement_stages](
	[stage_id] [bigint] NULL,
	[stage_name] [varchar](17) NULL,
	[is_knockout] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_venues]    Script Date: 21/10/2026 17:30:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_venues](
	[venue_id] [bigint] NULL,
	[stadium_name] [varchar](47) NULL,
	[city] [varchar](15) NULL,
	[country] [varchar](3) NULL,
	[capacity] [bigint] NULL,
	[latitude] [bigint] NULL,
	[longitude] [bigint] NULL,
	[elevation_meters] [bigint] NULL
) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [mundial2026] SET  READ_WRITE 
GO
