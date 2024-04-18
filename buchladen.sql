-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 25. Feb 2022 um 12:58
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
-- Datenbank: `buchladen`
--
DROP DATABASE `buchladen`;
CREATE DATABASE IF NOT EXISTS `buchladen` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `buchladen`;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `autoren`
--

CREATE TABLE `autoren` (
                           `id` int(11) NOT NULL,
                           `vorname` varchar(45) NOT NULL,
                           `nachname` varchar(45) NOT NULL,
                           `geburtsdatum` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `autoren`
--

INSERT INTO `autoren` (`id`, `vorname`, `nachname`, `geburtsdatum`) VALUES
                                                                        (1, 'Heinrich', 'Müller', '1953-04-01'),
                                                                        (2, 'Sabrina', 'Müller', '1982-09-28'),
                                                                        (3, 'Walburga', 'Deichel-Hurz', '1948-09-29'),
                                                                        (4, 'Jürgen', 'Rasterfahndung', '1969-02-05'),
                                                                        (5, 'Johannes', 'Rastermann', '1972-12-12'),
                                                                        (6, 'Nico', 'Nikolaus', '1985-11-30'),
                                                                        (7, 'Olga', 'Osterhase', '1984-04-15'),
                                                                        (8, 'Rudi', 'Rüsselmann', '1978-03-22');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `autoren_has_buecher`
--

CREATE TABLE `autoren_has_buecher` (
                                       `autoren_id` int(11) NOT NULL,
                                       `buecher_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `autoren_has_buecher`
--

INSERT INTO `autoren_has_buecher` (`autoren_id`, `buecher_id`) VALUES
                                                                   (1, 1),
                                                                   (1, 2),
                                                                   (1, 3),
                                                                   (1, 17),
                                                                   (1, 18),
                                                                   (2, 3),
                                                                   (2, 4),
                                                                   (2, 5),
                                                                   (2, 6),
                                                                   (3, 7),
                                                                   (4, 7),
                                                                   (4, 19),
                                                                   (5, 7),
                                                                   (5, 16),
                                                                   (5, 17),
                                                                   (6, 8),
                                                                   (6, 9),
                                                                   (6, 10),
                                                                   (6, 20),
                                                                   (7, 10),
                                                                   (7, 11),
                                                                   (7, 14),
                                                                   (7, 15),
                                                                   (7, 16),
                                                                   (7, 17),
                                                                   (7, 22),
                                                                   (8, 12),
                                                                   (8, 13),
                                                                   (8, 21);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `buecher`
--

CREATE TABLE `buecher` (
                           `id` int(11) NOT NULL,
                           `titel` varchar(200) NOT NULL,
                           `verkaufspreis` decimal(5,2) NOT NULL,
                           `einkaufspreis` decimal(5,2) NOT NULL,
                           `erscheinungsjahr` int(11) NOT NULL,
                           `verlage_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `buecher`
--

INSERT INTO `buecher` (`id`, `titel`, `verkaufspreis`, `einkaufspreis`, `erscheinungsjahr`, `verlage_id`) VALUES
                                                                                                              (1, 'Liebe auf den ersten Blick', '15.95', '9.02', 1986, 1),
                                                                                                              (2, 'Hass', '9.95', '6.45', 1977, 1),
                                                                                                              (3, 'Mein Kaninchen, mein Bruder und ich', '11.90', '5.12', 1965, 2),
                                                                                                              (4, 'Wilde Jagd auf John Smith', '11.90', '5.63', 1956, 2),
                                                                                                              (5, 'Wilde Jagd auf John Smith - Die Rache', '15.90', '7.11', 1995, 1),
                                                                                                              (6, 'Wilde Jagd auf John Smith - Die Vergeltung', '23.95', '15.35', 2012, 3),
                                                                                                              (7, 'Ein letzter Kuss', '6.80', '2.49', 2008, 5),
                                                                                                              (8, 'Mondschein', '7.90', '6.23', 2008, 4),
                                                                                                              (9, 'Wagen 1331', '15.95', '9.62', 2008, 6),
                                                                                                              (10, 'Lass ihn doch singen!', '36.80', '23.95', 2007, 4),
                                                                                                              (11, 'Es war keinmal', '25.95', '18.83', 2006, 5),
                                                                                                              (12, 'Father and Son', '16.00', '8.00', 2011, 6),
                                                                                                              (13, 'Schluckauf', '9.90', '6.00', 1997, 5),
                                                                                                              (14, 'Friedrich Fritzlipitzli', '23.95', '12.90', 1989, 7),
                                                                                                              (15, 'Fritz Friedlipitzi', '13.90', '9.18', 1991, 5),
                                                                                                              (16, 'Winnetous Abenteuer - Reloaded', '40.00', '23.21', 1989, 3),
                                                                                                              (17, 'Der Landarzt und seine Sekretärin', '12.90', '6.98', 2001, 2),
                                                                                                              (18, 'Wann wirst du endlich kommen?', '15.75', '9.21', 2012, 3),
                                                                                                              (19, 'Schweigsame Vollmondnacht', '16.80', '10.94', 2012, 6),
                                                                                                              (20, 'Mondschein', '22.80', '15.09', 2012, 6),
                                                                                                              (21, 'Am Tag die Sonne, in der Nacht der Mond', '23.45', '15.99', 1979, 7),
                                                                                                              (22, 'Foliant der Hildegard von Bingen - Faksimile', '485.00', '205.60', 1957, 6);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `buecher_has_lieferanten`
--

CREATE TABLE `buecher_has_lieferanten` (
                                           `buecher_id` int(11) NOT NULL,
                                           `lieferanten_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `buecher_has_lieferanten`
--

INSERT INTO `buecher_has_lieferanten` (`buecher_id`, `lieferanten_id`) VALUES
                                                                           (1, 5),
                                                                           (2, 5),
                                                                           (3, 4),
                                                                           (4, 6),
                                                                           (5, 5),
                                                                           (5, 7),
                                                                           (6, 7),
                                                                           (7, 8),
                                                                           (8, 7),
                                                                           (8, 8),
                                                                           (9, 2),
                                                                           (9, 7),
                                                                           (10, 3),
                                                                           (11, 2),
                                                                           (12, 3),
                                                                           (13, 2),
                                                                           (13, 5),
                                                                           (13, 6),
                                                                           (13, 7),
                                                                           (14, 1),
                                                                           (15, 1),
                                                                           (16, 2),
                                                                           (17, 5),
                                                                           (18, 6),
                                                                           (19, 8),
                                                                           (20, 8),
                                                                           (21, 5),
                                                                           (22, 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `buecher_has_sparten`
--

CREATE TABLE `buecher_has_sparten` (
                                       `buecher_id` int(11) NOT NULL,
                                       `sparten_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `buecher_has_sparten`
--

INSERT INTO `buecher_has_sparten` (`buecher_id`, `sparten_id`) VALUES
                                                                   (1, 1),
                                                                   (1, 4),
                                                                   (2, 4),
                                                                   (3, 4),
                                                                   (4, 2),
                                                                   (5, 2),
                                                                   (5, 3),
                                                                   (6, 3),
                                                                   (7, 3),
                                                                   (8, 4),
                                                                   (9, 1),
                                                                   (9, 2),
                                                                   (10, 1),
                                                                   (11, 1),
                                                                   (12, 1),
                                                                   (12, 2),
                                                                   (13, 3),
                                                                   (14, 2),
                                                                   (15, 4),
                                                                   (16, 2),
                                                                   (17, 1),
                                                                   (18, 3),
                                                                   (19, 2),
                                                                   (20, 1),
                                                                   (20, 4),
                                                                   (21, 4),
                                                                   (22, 5);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `lieferanten`
--

CREATE TABLE `lieferanten` (
                               `id` int(11) NOT NULL,
                               `name` varchar(45) DEFAULT NULL,
                               `orte_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `lieferanten`
--

INSERT INTO `lieferanten` (`id`, `name`, `orte_id`) VALUES
                                                        (1, 'Schustermann', 1),
                                                        (2, 'Schusselmann', 1),
                                                        (3, '123 GmbH', 2),
                                                        (4, 'Lodwig GmbH', 3),
                                                        (5, 'Tschenz & Co', 3),
                                                        (6, 'Loedwig Books', 4),
                                                        (7, 'Loedwig Bookstore', 5),
                                                        (8, 'ABC-Lieferungen', 6);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `orte`
--

CREATE TABLE `orte` (
                        `id` int(11) NOT NULL,
                        `postleitzahl` varchar(5) NOT NULL,
                        `name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `orte`
--

INSERT INTO `orte` (`id`, `postleitzahl`, `name`) VALUES
                                                      (1, '79312', 'Emmendingen'),
                                                      (2, '79098', 'Freiburg'),
                                                      (3, '79111', 'Freiburg'),
                                                      (4, '79312', 'Wasser'),
                                                      (5, '79312', 'Reute'),
                                                      (6, '80895', 'München');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `sparten`
--

CREATE TABLE `sparten` (
                           `id` int(11) NOT NULL,
                           `bezeichnung` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `sparten`
--

INSERT INTO `sparten` (`id`, `bezeichnung`) VALUES
                                                (1, 'Liebe'),
                                                (2, 'Humor'),
                                                (3, 'Thriller'),
                                                (4, 'Krimi'),
                                                (5, 'Sachbuch');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `verlage`
--

CREATE TABLE `verlage` (
                           `id` int(11) NOT NULL,
                           `name` varchar(45) NOT NULL,
                           `orte_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `verlage`
--

INSERT INTO `verlage` (`id`, `name`, `orte_id`) VALUES
                                                    (1, 'Joengkers', 1),
                                                    (2, 'RBD', 3),
                                                    (3, 'LoveMyBooks', 4),
                                                    (4, 'Henry Smith & John Smuth', 6),
                                                    (5, 'Assal', 6),
                                                    (6, 'Libré Books', 6),
                                                    (7, 'Lost in Reading', 5);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `autoren`
--
ALTER TABLE `autoren`
    ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `autoren_has_buecher`
--
ALTER TABLE `autoren_has_buecher`
    ADD PRIMARY KEY (`autoren_id`,`buecher_id`),
  ADD KEY `fk_autoren_has_buecher_buecher1_idx` (`buecher_id`),
  ADD KEY `fk_autoren_has_buecher_autoren1_idx` (`autoren_id`);

--
-- Indizes für die Tabelle `buecher`
--
ALTER TABLE `buecher`
    ADD PRIMARY KEY (`id`),
  ADD KEY `fk_buecher_verlage1_idx` (`verlage_id`);

--
-- Indizes für die Tabelle `buecher_has_lieferanten`
--
ALTER TABLE `buecher_has_lieferanten`
    ADD PRIMARY KEY (`buecher_id`,`lieferanten_id`),
  ADD KEY `fk_buecher_has_lieferanten_lieferanten1_idx` (`lieferanten_id`),
  ADD KEY `fk_buecher_has_lieferanten_buecher1_idx` (`buecher_id`);

--
-- Indizes für die Tabelle `buecher_has_sparten`
--
ALTER TABLE `buecher_has_sparten`
    ADD PRIMARY KEY (`buecher_id`,`sparten_id`),
  ADD KEY `fk_buecher_has_sparten_sparten1_idx` (`sparten_id`),
  ADD KEY `fk_buecher_has_idx` (`buecher_id`);

--
-- Indizes für die Tabelle `lieferanten`
--
ALTER TABLE `lieferanten`
    ADD PRIMARY KEY (`id`),
  ADD KEY `fk_lieferanten_orte1_idx` (`orte_id`);

--
-- Indizes für die Tabelle `orte`
--
ALTER TABLE `orte`
    ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `sparten`
--
ALTER TABLE `sparten`
    ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `verlage`
--
ALTER TABLE `verlage`
    ADD PRIMARY KEY (`id`),
  ADD KEY `fk_verlage_orte1_idx` (`orte_id`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `autoren`
--
ALTER TABLE `autoren`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT für Tabelle `buecher`
--
ALTER TABLE `buecher`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT für Tabelle `lieferanten`
--
ALTER TABLE `lieferanten`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT für Tabelle `orte`
--
ALTER TABLE `orte`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT für Tabelle `sparten`
--
ALTER TABLE `sparten`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT für Tabelle `verlage`
--
ALTER TABLE `verlage`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `autoren_has_buecher`
--
ALTER TABLE `autoren_has_buecher`
    ADD CONSTRAINT `fk_autoren_has_buecher_autoren1` FOREIGN KEY (`autoren_id`) REFERENCES `autoren` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_autoren_has_buecher_buecher1` FOREIGN KEY (`buecher_id`) REFERENCES `buecher` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `buecher`
--
ALTER TABLE `buecher`
    ADD CONSTRAINT `fk_buecher_verlage1` FOREIGN KEY (`verlage_id`) REFERENCES `verlage` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `buecher_has_lieferanten`
--
ALTER TABLE `buecher_has_lieferanten`
    ADD CONSTRAINT `fk_buecher_has_lieferanten_buecher1` FOREIGN KEY (`buecher_id`) REFERENCES `buecher` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_buecher_has_lieferanten_lieferanten1` FOREIGN KEY (`lieferanten_id`) REFERENCES `lieferanten` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `buecher_has_sparten`
--
ALTER TABLE `buecher_has_sparten`
    ADD CONSTRAINT `fk_buecher_has_sparten_buecher` FOREIGN KEY (`buecher_id`) REFERENCES `buecher` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_buecher_has_sparten_sparten1` FOREIGN KEY (`sparten_id`) REFERENCES `sparten` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `lieferanten`
--
ALTER TABLE `lieferanten`
    ADD CONSTRAINT `fk_lieferanten_orte1` FOREIGN KEY (`orte_id`) REFERENCES `orte` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `verlage`
--
ALTER TABLE `verlage`
    ADD CONSTRAINT `fk_verlage_orte1` FOREIGN KEY (`orte_id`) REFERENCES `orte` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
