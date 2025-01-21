-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : mar. 21 jan. 2025 à 21:22
-- Version du serveur : 8.2.0
-- Version de PHP : 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `locationsbiens`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `changer_prix`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `changer_prix` (IN `procedure_num_Id_Bien` INT, IN `procedure_Nouveau_Prix` DOUBLE)   BEGIN
UPDATE bien
SET prix = procedure_Nouveau_Prix
WHERE idBien = procedure_num_Id_Bien;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `bien`
--

DROP TABLE IF EXISTS `bien`;
CREATE TABLE IF NOT EXISTS `bien` (
  `idBien` int NOT NULL AUTO_INCREMENT,
  `type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `commune` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `prix` double(10,2) NOT NULL,
  `superficie` int NOT NULL,
  `estValide` tinyint(1) NOT NULL,
  `idPropriétaire` int NOT NULL,
  PRIMARY KEY (`idBien`),
  KEY `FkBienProprietaire` (`idPropriétaire`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `bien`
--

INSERT INTO `bien` (`idBien`, `type`, `commune`, `prix`, `superficie`, `estValide`, `idPropriétaire`) VALUES
(1, 'appartement', 'Ixelles', 800.00, 75, 1, 1),
(2, 'appartement', 'Ixelles', 1000.00, 120, 1, 1),
(3, 'appartement', 'Ixelles', 650.00, 65, 1, 1),
(4, 'maison', 'Uccle', 15000.99, 555, 1, 2),
(5, 'maison', 'Charleroi', 800.00, 800, 1, 3),
(6, 'appartement', 'Anderlecht', 850.00, 70, 1, 6),
(7, 'appartement', 'Saint-Gilles', 650.88, 88, 1, 4),
(8, 'appartement', 'Waterloo', 900.00, 120, 1, 5),
(9, 'appartement', 'Auderghem', 700.50, 99, 1, 5),
(10, 'maison', 'Etterbeek', 1128.60, 1140, 1, 6),
(11, 'appartement', 'Anderlecht', 850.00, 70, 1, 7),
(12, 'appartement', 'Saint-Gilles', 650.88, 88, 1, 8),
(13, 'appartement', 'Waterloo', 900.00, 120, 1, 9),
(14, 'appartement', 'Auderghem', 1050.75, 99, 1, 10);

-- --------------------------------------------------------

--
-- Structure de la table `locataire`
--

DROP TABLE IF EXISTS `locataire`;
CREATE TABLE IF NOT EXISTS `locataire` (
  `idLocataire` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(60) COLLATE utf8mb4_general_ci NOT NULL,
  `prénom` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `annéeNaissance` int NOT NULL,
  PRIMARY KEY (`idLocataire`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `locataire`
--

INSERT INTO `locataire` (`idLocataire`, `nom`, `prénom`, `annéeNaissance`) VALUES
(1, 'Lukins', 'Annotés', 1996),
(2, 'Buchett', 'Intéressant', 2004),
(3, 'Cahn', 'Annotée', 2000),
(4, 'Unthank', 'Cunégonde', 2007),
(5, 'Turnpenny', 'Nélie', 1993),
(6, 'Dufaur', 'Renée', 1996),
(7, 'Dobsons', 'Andrée', 1996),
(8, 'Stubbings', 'Yú', 1992),
(9, 'Melrose', 'Méryl', 1993),
(10, 'Yes', 'Méryl', 2008);

-- --------------------------------------------------------

--
-- Structure de la table `location`
--

DROP TABLE IF EXISTS `location`;
CREATE TABLE IF NOT EXISTS `location` (
  `idLocation` int NOT NULL AUTO_INCREMENT,
  `idBien` int NOT NULL,
  `idLocataire` int NOT NULL,
  `estLoué` tinyint(1) NOT NULL,
  PRIMARY KEY (`idLocation`),
  KEY `idBien` (`idBien`,`idLocataire`),
  KEY `fkLocationLocataire` (`idLocataire`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `location`
--

INSERT INTO `location` (`idLocation`, `idBien`, `idLocataire`, `estLoué`) VALUES
(1, 1, 1, 1),
(2, 1, 2, 1),
(3, 2, 3, 1),
(4, 3, 4, 1),
(5, 4, 5, 1),
(6, 5, 6, 1),
(7, 6, 7, 1),
(8, 7, 8, 1),
(9, 8, 9, 1),
(10, 9, 10, 1);

-- --------------------------------------------------------

--
-- Structure de la table `propriétaire`
--

DROP TABLE IF EXISTS `propriétaire`;
CREATE TABLE IF NOT EXISTS `propriétaire` (
  `idPropriétaire` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(60) COLLATE utf8mb4_general_ci NOT NULL,
  `prénom` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `domicile` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `annéeNaissance` int NOT NULL,
  `estValide` tinyint(1) NOT NULL,
  PRIMARY KEY (`idPropriétaire`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `propriétaire`
--

INSERT INTO `propriétaire` (`idPropriétaire`, `nom`, `prénom`, `domicile`, `annéeNaissance`, `estValide`) VALUES
(1, 'Usherwood', 'Ellsworth', 'Saint-Eustache', 1996, 1),
(2, 'Gallo', 'Thornie', 'Nanshi', 2004, 1),
(3, 'Nordass', 'Collin', 'Lanigan', 2013, 1),
(4, 'Mallock', 'Deerdre', 'Gubeikou', 2005, 1),
(5, 'Stoke', 'Philipa', 'Ya’erya', 2007, 1),
(6, 'Jeacock', 'Natty', 'Cacequi', 1994, 1),
(7, 'Blumsom', 'Padriac', 'Haikoudajie', 2012, 1),
(8, 'Bodimeade', 'Cordie', 'Marinilla', 2001, 1),
(9, 'Clive', 'Chrissy', 'Cândido Mota', 2003, 1),
(10, 'Gush', 'Caterina', 'Zlonice', 2005, 1),
(11, 'Julien', 'Doré', 'ici', 1587, 1),
(12, 'Julien', 'Doré', 'michoui', 1050, 1),
(13, 'bob', 'bob', 'liege', 2000, 1),
(14, 'Ikea', 'marson', 'ixelles', 1000, 1);

--
-- Déclencheurs `propriétaire`
--
DROP TRIGGER IF EXISTS `triggerDeleteProprietaire`;
DELIMITER $$
CREATE TRIGGER `triggerDeleteProprietaire` AFTER UPDATE ON `propriétaire` FOR EACH ROW BEGIN
    IF OLD.estValide = TRUE AND NEW.estValide = FALSE THEN        
        UPDATE `bien`
        SET estValide = 0
        WHERE idPropriétaire = NEW.idPropriétaire;
        
        UPDATE `location`
        SET estLoué = 0
        WHERE idBien IN (
            SELECT idBien FROM `Bien` WHERE idPropriétaire = NEW.idPropriétaire
        );
    END IF;
END
$$
DELIMITER ;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `bien`
--
ALTER TABLE `bien`
  ADD CONSTRAINT `FkBienProprietaire` FOREIGN KEY (`idPropriétaire`) REFERENCES `propriétaire` (`idPropriétaire`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `location`
--
ALTER TABLE `location`
  ADD CONSTRAINT `fkLocationBien` FOREIGN KEY (`idBien`) REFERENCES `bien` (`idBien`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fkLocationLocataire` FOREIGN KEY (`idLocataire`) REFERENCES `locataire` (`idLocataire`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
