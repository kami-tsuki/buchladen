-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 25. Feb 2022 um 12:57
-- Server-Version: 10.4.18-MariaDB
-- PHP-Version: 8.0.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `lager`
--
DROP DATABASE IF EXISTS `lager`;
CREATE DATABASE IF NOT EXISTS `lager` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `lager`;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `artikel`
--

CREATE TABLE `artikel` (
                           `Artikelnummer` int(2) NOT NULL,
                           `Artikelbezeichnung` varchar(25) DEFAULT NULL,
                           `Kategorienummer` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Daten für Tabelle `artikel`
--

INSERT INTO `artikel` (`Artikelnummer`, `Artikelbezeichnung`, `Kategorienummer`) VALUES
                                                                                     (1, 'Klopapier 4lg', 5),
                                                                                     (2, 'Klopapier 3lg', 5),
                                                                                     (3, 'Schokotafel', 6),
                                                                                     (4, 'Küchenrolle', 3),
                                                                                     (5, 'Weichspühler', 4),
                                                                                     (6, 'Energy', 2),
                                                                                     (7, 'Aufbackbrötchen', 1),
                                                                                     (8, 'Fladenbrot', 1),
                                                                                     (9, 'Wasser Still Geschmacklos', 2),
                                                                                     (10, 'Zahnpasta', 5),
                                                                                     (11, 'Schokokeks', 6);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bestand`
--

CREATE TABLE `bestand` (
                           `Artikelnummer` int(2) NOT NULL,
                           `Markennummer` int(2) NOT NULL,
                           `Lagerbestand` int(2) DEFAULT NULL,
                           `UVP in Euro` varchar(4) DEFAULT NULL,
                           `Naechstes Lieferdatum` varchar(10) DEFAULT NULL,
                           `Lieferantennummer` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Daten für Tabelle `bestand`
--

INSERT INTO `bestand` (`Artikelnummer`, `Markennummer`, `Lagerbestand`, `UVP in Euro`, `Naechstes Lieferdatum`, `Lieferantennummer`) VALUES
                                                                                                                                         (1, 1, 0, '3,00', '2020-10-29', 1),
                                                                                                                                         (1, 2, 2, '2,00', '2020-10-29', 3),
                                                                                                                                         (2, 1, 2, '2,50', '2020-11-03', 4),
                                                                                                                                         (2, 2, 1, '1,50', '2020-10-29', 2),
                                                                                                                                         (2, 3, 7, '1,40', '2020-11-03', 1),
                                                                                                                                         (3, 4, 10, '2,49', '2020-11-03', 1),
                                                                                                                                         (3, 5, 5, '2,49', '2020-11-03', 1),
                                                                                                                                         (4, 2, 12, '1,50', '2020-10-29', 2),
                                                                                                                                         (4, 3, 4, '1,50', '2020-10-29', 2),
                                                                                                                                         (5, 2, 20, '2,59', '2020-10-29', 4),
                                                                                                                                         (5, 7, 15, '3,49', '2020-11-03', 3),
                                                                                                                                         (5, 8, 10, '3,00', '2020-10-29', 4),
                                                                                                                                         (6, 9, 30, '1,60', '2020-10-29', 2),
                                                                                                                                         (6, 10, 50, '1,55', '2020-10-29', 2),
                                                                                                                                         (6, 11, 35, '1,80', '2020-10-29', 2),
                                                                                                                                         (7, 2, 10, '0,50', '2020-11-03', 5),
                                                                                                                                         (7, 12, 15, '0,70', '2020-11-03', 5),
                                                                                                                                         (8, 12, 5, '1,20', '2020-10-29', 5),
                                                                                                                                         (9, 2, 40, '0,20', '2020-10-29', 2),
                                                                                                                                         (9, 13, 20, '0,30', '2020-11-03', 2),
                                                                                                                                         (9, 14, 50, '0,25', '2020-11-03', 2),
                                                                                                                                         (10, 15, 40, '1,30', '2020-10-29', 1),
                                                                                                                                         (10, 16, 30, '1,35', '2020-10-29', 3),
                                                                                                                                         (10, 17, 40, '1,30', '2020-10-29', 3),
                                                                                                                                         (11, 4, 10, '2,70', '2020-11-03', 3),
                                                                                                                                         (11, 6, 42, '2,55', '2020-10-29', 4);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `kategorie`
--

CREATE TABLE `kategorie` (
                             `Kategorienummer` int(1) NOT NULL,
                             `Kategoriebezeichung` varchar(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Daten für Tabelle `kategorie`
--

INSERT INTO `kategorie` (`Kategorienummer`, `Kategoriebezeichung`) VALUES
                                                                       (1, 'Backwaren'),
                                                                       (2, 'Getränke'),
                                                                       (3, 'Haushalt'),
                                                                       (4, 'Waschmittel'),
                                                                       (5, 'Hygiene'),
                                                                       (6, 'Schokolade');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `lieferant`
--

CREATE TABLE `lieferant` (
                             `Lieferantennummer` int(1) NOT NULL,
                             `Lieferant` varchar(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Daten für Tabelle `lieferant`
--

INSERT INTO `lieferant` (`Lieferantennummer`, `Lieferant`) VALUES
                                                               (1, 'Klaasen Logistik'),
                                                               (2, 'GetränkeHarry'),
                                                               (3, 'TTT'),
                                                               (4, 'Road-HOG'),
                                                               (5, 'Hotte');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `marke`
--

CREATE TABLE `marke` (
                         `Markennummer` int(2) NOT NULL,
                         `Marke` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Daten für Tabelle `marke`
--

INSERT INTO `marke` (`Markennummer`, `Marke`) VALUES
                                                  (1, 'Charmin'),
                                                  (2, 'Gut und Günstig'),
                                                  (3, 'Ecorasa'),
                                                  (4, 'Milka'),
                                                  (5, 'Ritter Sport'),
                                                  (6, 'Leipnitz'),
                                                  (7, 'Vernell'),
                                                  (8, 'Weißer Riese'),
                                                  (9, 'Rockstar'),
                                                  (10, 'Monster'),
                                                  (11, 'Red Bull'),
                                                  (12, 'Harry'),
                                                  (13, 'Volvic'),
                                                  (14, 'Prinzquell'),
                                                  (15, 'Odol'),
                                                  (16, 'Colgate'),
                                                  (17, 'Blend a med');

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `artikel`
--
ALTER TABLE `artikel`
    ADD PRIMARY KEY (`Artikelnummer`),
  ADD KEY `Kategorie` (`Kategorienummer`);

--
-- Indizes für die Tabelle `bestand`
--
ALTER TABLE `bestand`
    ADD PRIMARY KEY (`Artikelnummer`,`Markennummer`),
  ADD KEY `Marke` (`Markennummer`),
  ADD KEY `Lieferant` (`Lieferantennummer`);

--
-- Indizes für die Tabelle `kategorie`
--
ALTER TABLE `kategorie`
    ADD PRIMARY KEY (`Kategorienummer`);

--
-- Indizes für die Tabelle `lieferant`
--
ALTER TABLE `lieferant`
    ADD PRIMARY KEY (`Lieferantennummer`);

--
-- Indizes für die Tabelle `marke`
--
ALTER TABLE `marke`
    ADD PRIMARY KEY (`Markennummer`);

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `artikel`
--
ALTER TABLE `artikel`
    ADD CONSTRAINT `Kategorie` FOREIGN KEY (`Kategorienummer`) REFERENCES `kategorie` (`Kategorienummer`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `bestand`
--
ALTER TABLE `bestand`
    ADD CONSTRAINT `Artikel` FOREIGN KEY (`Artikelnummer`) REFERENCES `artikel` (`Artikelnummer`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Lieferant` FOREIGN KEY (`Lieferantennummer`) REFERENCES `lieferant` (`Lieferantennummer`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Marke` FOREIGN KEY (`Markennummer`) REFERENCES `marke` (`Markennummer`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
