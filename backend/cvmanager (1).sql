-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 02, 2026 at 09:11 PM
-- Server version: 11.8.8-MariaDB-ubu2404
-- PHP Version: 8.5.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cvmanager`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` uuid NOT NULL,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `label`, `icon`, `description`, `order`) VALUES
('9ccceb18-6dd7-4a1c-8746-04f5b06ed230', 'sysadmin', 'System Administration', 'mdi:monitor-dashboard', 'System administration, networking, and IT support', 2),
('e65c2bad-6638-4c09-aabb-3f893ca2aada', 'dev', 'Development', 'mdi:code', 'Web development, software engineering, and application development', 0),
('fa8d9e86-3ff2-4472-a45a-a35cc1422c92', 'Soft', 'Soft skills', 'uil:key-skeleton', NULL, 3),
('1a928c01-a1f1-4486-98eb-a4d877a8b1f5', 'infra', 'Infrastructure', 'mdi:server', 'Infrastructure, DevOps, and cloud technologies', 1);

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `id` uuid NOT NULL,
  `label` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'info',
  `isPrivate` tinyint(4) NOT NULL DEFAULT 0,
  `order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `contacts`
--

INSERT INTO `contacts` (`id`, `label`, `value`, `icon`, `type`, `isPrivate`, `order`) VALUES
('3a3d6817-4ea3-42f4-b78b-54f3db20c955', 'GitHub', 'https://github.com/d3vex', 'mdi:github', 'link', 0, 4),
('511d43c3-9613-41fe-a7ef-5d0bce63082f', 'City', 'Villemoustaussou, 11620', 'mdi:map-marker', 'info', 1, 2),
('0054036e-a6b2-42ba-b0fe-867fd3ea186b', 'City', 'Combaillaux, 34980', 'mdi:location', 'info', 1, 2),
('a7b0aa52-1641-45ad-aa36-9cf0f93b5fa5', 'Email', 'loanmata4@gmail.com', 'mdi:email', 'info', 0, 1),
('f5401c4e-3966-40d2-95f1-9e087c6fc6ab', 'City', 'Montpellier, 34', 'mdi:location', 'info', 1, 2),
('d164fa25-b8c5-415b-8a21-c125f2450999', 'Phone number', '+33 7 64 02 11 78', 'mdi:telephone', 'info', 1, 0),
('e9259fc2-414b-4c26-809c-db6fa30d5682', 'LinkedIn', 'https://linkedin.com/in/loan-mata', 'mdi:linkedin', 'link', 0, 3);

-- --------------------------------------------------------

--
-- Table structure for table `cvs`
--

CREATE TABLE `cvs` (
  `id` uuid NOT NULL,
  `name` varchar(255) NOT NULL,
  `specialization` varchar(255) DEFAULT NULL,
  `titleOverride` varchar(255) DEFAULT NULL,
  `aboutText` text DEFAULT NULL,
  `pictureId` uuid DEFAULT NULL,
  `availability` varchar(255) DEFAULT NULL,
  `isDefault` tinyint(4) NOT NULL DEFAULT 0,
  `createdAt` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `projectBullets` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`projectBullets`)),
  `candidateName` varchar(255) DEFAULT NULL,
  `style` varchar(64) NOT NULL DEFAULT 'classic',
  `createdBy` varchar(64) DEFAULT NULL,
  `aiGenerated` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `cvs`
--

INSERT INTO `cvs` (`id`, `name`, `specialization`, `titleOverride`, `aboutText`, `pictureId`, `availability`, `isDefault`, `createdAt`, `updatedAt`, `projectBullets`, `candidateName`, `style`, `createdBy`, `aiGenerated`) VALUES
('d9be75ef-b6da-48bc-a672-17db1d1c1316', 'AdminSysReseau SDIS 11', 'devops', 'Administrateur Système & Réseau', 'Étudiant en **Bachelor Informatique à Ynov Campus Montpellier**, je recherche une **alternance en administration systèmes et réseaux** à partir de septembre 2026. J\'administre au quotidien des environnements **Linux et Windows Server**, gère un **cluster Proxmox**, et configure des architectures réseau complexes — le tout en grande partie de manière **autodidacte**, par curiosité et par passion pour l\'infrastructure.\n\nAdaptable et orienté **résolution de problèmes**, je m\'intègre facilement à une équipe et suis capable de monter rapidement en compétence sur de nouveaux outils ou environnements. Au-delà du technique, je suis engagé en tant que **porte-drapeau pour des anciens combattants**, un engagement qui m\'a forgé le sens des responsabilités et du collectif — des valeurs que je retrouve naturellement dans l\'univers des sapeurs-pompiers.', '8b3fddc1-00ae-4bbe-b4e4-19466159b47a', 'Recherche alternance: 1 sem. école / 2 sem. entreprise', 0, '2026-06-26 13:07:20.711495', '2026-06-26 16:19:56.000000', '{\"e86bf4ae-63a3-4bc1-9745-12dfdbdda064\":[0,1,2],\"46559190-c45e-416a-a546-dfc6039d52de\":[1,3,0],\"089bae36-8066-4730-809e-960745dfa09d\":[0,1,2]}', 'Loan MATA', 'classic', NULL, 0),
('0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'G. Tech IT', 'itsupport', 'Tech. Support IT/ Sys et réseau', 'Étudiant en 2ᵉ année Bachelor Informatique (Ynov Campus Montpellier), classé premier de promotion en infrastructure, je combine 8 ans de pratique autodidacte du développement à une spécialisation récente en infrastructure et DevOps. Solide à l\'aise sur l\'ensemble de la chaîne technique avec: Windows Server, Active Directory/GPO, Linux, virtualisation (VMware, Proxmox, TrueNAS, Docker), réseaux (TCP/IP, DNS, VPN, firewall, PfSense). Je résous les incidents avec méthode et pédagogie, du diagnostic N1 jusqu\'aux problématiques plus poussées d\'infrastructure. Habitué aux outils de ticketing (Trello, Jira) et à l\'accompagnement utilisateur, je recherche une alternance en tant que technicien support IT/systèmes & réseaux à partir de septembre 2026, avec l\'envie de mettre mes compétences transverses au service d\'environnements techniques variés.', '8b3fddc1-00ae-4bbe-b4e4-19466159b47a', 'Recherche alternance: 1 sem. école / 2 sem. entreprise', 0, '2026-08-16 19:12:57.522049', '2026-08-16 19:17:16.000000', '{\"e86bf4ae-63a3-4bc1-9745-12dfdbdda064\":[0,1,2,3],\"46559190-c45e-416a-a546-dfc6039d52de\":[8,1,3],\"089bae36-8066-4730-809e-960745dfa09d\":[3,5,0]}', 'Loan MATA', 'classic', '55ca3360-9e47-4e2b-ac37-a221c74f319b', 0),
('dd88abba-061c-4363-8255-58a5e79bf0a1', 'Pradeo', 'itsupport', 'Alternant Technicien IT', '**Étudiant en Bachelor Informatique à Ynov Campus Montpellier**, je recherche une **alternance en tant que Technicien IT interne** pour ma 3ème année, à partir de septembre 2026, sur un rythme d\'une semaine à l\'école pour deux semaines en entreprise. Autodidacte depuis 8 ans, je maîtrise les environnements **Windows et Linux**, l\'installation et la maintenance de matériel et logiciels, le dépannage utilisateur et la **virtualisation** (Proxmox, VMware, Docker, **Kubernetes**). Sensibilisé aux enjeux de cybersécurité et aux méthodologies **DevOps**, je sais mettre en place des automatisations utiles pour fiabiliser et faire évoluer une infrastructure. Rigoureux et **bon communicant**, j\'ai une vraie appétence pour **l\'accompagnement des utilisateurs** au quotidien.', '8b3fddc1-00ae-4bbe-b4e4-19466159b47a', '1 sem. école / 2 sem. entreprise', 0, '2026-08-31 19:14:37.835511', '2026-08-31 19:25:37.000000', '{\"e86bf4ae-63a3-4bc1-9745-12dfdbdda064\":[1,2,3,0],\"46559190-c45e-416a-a546-dfc6039d52de\":[0,3,1],\"089bae36-8066-4730-809e-960745dfa09d\":[0,5,3]}', 'Loan MATA', 'classic', NULL, 0),
('7523c9ed-86d8-4932-bc0c-5aea50b39319', 'GAZECHIM', 'devops', 'Alternant Administrateur Système', 'Étudiant en **3ème année de Bachelor Informatique** à Ynov Campus Montpellier, je recherche une **alternance en administration systèmes** dès septembre 2026. J\'administre au quotidien des environnements **Linux et Windows Server**, gère un cluster Proxmox et configure des architectures réseau, en grande partie de manière **autodidacte**, par passion pour l\'infrastructure.\n\nRigoureux et à l\'aise à l\'écrit comme à l\'oral, je m\'intègre facilement à une équipe et monte rapidement en compétence. Je suis aussi engagé en tant que **porte-drapeau** pour des anciens combattants, un engagement qui m\'a forgé le sens des responsabilités et de la fiabilité, des qualités que je compte mettre au service de votre équipe', '8b3fddc1-00ae-4bbe-b4e4-19466159b47a', 'Recherche alternance: 1 sem. école / 2 sem. entreprise', 0, '2026-08-27 13:44:48.060498', '2026-08-27 14:08:10.000000', '{\"e86bf4ae-63a3-4bc1-9745-12dfdbdda064\":[0,2,3,1],\"46559190-c45e-416a-a546-dfc6039d52de\":[3,0,1],\"089bae36-8066-4730-809e-960745dfa09d\":[0,3,5]}', 'Loan MATA', 'classic', NULL, 0),
('8eb80784-dd54-400b-a477-69e9c1685287', 'E-MSN', 'devops', 'Administrateur Système & Réseau', 'Étudiant en **Bachelor Informatique à Ynov Campus Montpellier**, je recherche une **alternance en administration systèmes et réseaux** à partir de septembre 2026. J\'administre au quotidien des environnements **Linux et Windows Server**, gère un **cluster Proxmox**, et configure des architectures réseau complexes, le tout en grande partie de manière **autodidacte**, par curiosité et par passion pour l\'infrastructure.\n\nAdaptable et orienté **résolution de problèmes**, je m\'intègre facilement à une équipe et suis capable de monter rapidement en compétence sur de nouveaux outils ou environnements. Au-delà du technique, je suis engagé en tant que **porte-drapeau pour des anciens combattants**, un engagement qui m\'a forgé le sens des responsabilités et du collectif — des valeurs que je retrouve naturellement dans l\'univers des sapeurs-pompiers.', '8b3fddc1-00ae-4bbe-b4e4-19466159b47a', 'Recherche alternance: 1 sem. école / 2 sem. entreprise', 0, '2026-07-06 12:53:13.354282', '2026-07-06 12:55:16.000000', '{\"e86bf4ae-63a3-4bc1-9745-12dfdbdda064\":[0,2,3,1],\"46559190-c45e-416a-a546-dfc6039d52de\":[3,0,2],\"089bae36-8066-4730-809e-960745dfa09d\":[0,1,2]}', 'Loan MATA', 'classic', NULL, 0),
('8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'SN-groupe Yannick', 'devops', 'Administrateur Système & Réseau', 'Étudiant en **Bachelor Informatique à Ynov Campus Montpellier**, je recherche une **alternance en administration systèmes et réseaux** à partir de septembre 2026. J\'administre au quotidien des environnements **Linux et Windows Server**, gère un **cluster Proxmox**, et configure des architectures réseau complexes — le tout en grande partie de manière **autodidacte**, par curiosité et par passion pour l\'infrastructure.\n\nAdaptable et orienté **résolution de problèmes**, je m\'intègre facilement à une équipe et suis capable de monter rapidement en compétence sur de nouveaux outils ou environnements. Au-delà du technique, je suis engagé en tant que **porte-drapeau pour des anciens combattants**, un engagement qui m\'a forgé le sens des responsabilités et du collectif — des valeurs que je retrouve naturellement dans l\'univers des sapeurs-pompiers.', '8b3fddc1-00ae-4bbe-b4e4-19466159b47a', 'Recherche alternance: 1 sem. école / 2 sem. entreprise', 0, '2026-06-26 15:43:17.981666', '2026-06-26 16:18:26.000000', '{\"e86bf4ae-63a3-4bc1-9745-12dfdbdda064\":[0,2,3,1],\"46559190-c45e-416a-a546-dfc6039d52de\":[1,3,0],\"089bae36-8066-4730-809e-960745dfa09d\":[0,1,2]}', 'Loan MATA', 'classic', NULL, 0),
('f51627d4-449b-45ae-ada5-92a2f16b8794', 'ALX Support IT', 'itsupport', 'Tech Support Hotline', 'Etudiant en **Bachelor Informatique à Ynov Campus Montpellier**, je recherche une **alternance en support informatique et relation client** à partir de septembre 2026, sur un rythme d\'une semaine à l\'école pour deux semaines en entreprise. Autodidacte depuis 8 ans, je maîtrise les environnements **Windows**, l\'installation de logiciels sur postes et serveurs, et le dépannage matériel, logiciel et réseau. Rigoureux et **bon communicant**, j\'ai une vraie appétence pour **la formation et l\'accompagnement** des utilisateurs à distance comme en présentiel. Je cherche une structure à taille humaine où la qualité du service client et l\'entraide sont des valeurs réelles.', '8b3fddc1-00ae-4bbe-b4e4-19466159b47a', '1 sem. école / 2 sem. entreprise', 0, '2026-07-21 08:42:19.078367', '2026-07-21 08:42:19.078367', '{\"e86bf4ae-63a3-4bc1-9745-12dfdbdda064\":[1,2,3],\"46559190-c45e-416a-a546-dfc6039d52de\":[0,2,3],\"089bae36-8066-4730-809e-960745dfa09d\":[0,1,2]}', 'Loan MATA', 'classic', NULL, 0),
('b169aa86-f12f-4689-ada1-92dd5c59e26a', 'Dev backend & IA - ENSO Groupe', 'devops', 'Dev Backend & IA', 'Étudiant en 2ᵉ année à Ynov Campus Montpellier, **premier de ma promotion en infrastructure**, je code depuis **huit ans en autodidacte** avant de me spécialiser en DevOps. Cette double culture dev/infra me permet d\'aborder un backend **Node.js/TypeScript** aussi bien sous l\'angle du code que de la fiabilité des échanges et de la sécurité des systèmes.\nL\'IA générative est un terrain que j\'explore concrètement à travers plusieurs projets personnels : un agent de résolution de captchas combinant OCR et **LLM**, un serveur **MCP** couplé à une IA pour générer des CV à partir de mes projets, ou encore un agent de recherche d\'exposants d\'événements.\nRejoindre l\'équipe technique d\'ENSO pour contribuer à la fois à la modernisation du backend et à l\'intégration de l\'IA dans un produit SaaS utilisé au quotidien est exactement le type de défi que je recherche pour mon alternance.', '8b3fddc1-00ae-4bbe-b4e4-19466159b47a', 'Recherche alternance: 1 sem. école - 2 sem. entreprise', 0, '2026-08-07 13:22:07.722360', '2026-08-07 13:46:56.000000', '{\"28e23076-b51a-43ca-ad75-97b050ee64d0\":[0,4,2,1],\"089bae36-8066-4730-809e-960745dfa09d\":[0,3,1],\"3e830952-4412-4872-9ddb-ea7dadd33bfa\":[0,1,2]}', 'Loan MATA', 'classic', NULL, 0),
('a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'Septeo - Support IT', 'itsupport', 'Tech Support IT', 'Etudiant en **Bachelor Informatique à Ynov Campus Montpellier**, je recherche une **alternance en support informatique et relation client** à partir de septembre 2026, sur un rythme d\'une semaine à l\'école pour deux semaines en entreprise. Autodidacte depuis 8 ans, je maîtrise les environnements **Windows**, l\'installation de logiciels sur postes et serveurs, et le dépannage matériel, logiciel et réseau. Rigoureux et **bon communicant**, j\'ai une vraie appétence pour **la formation et l\'accompagnement** des utilisateurs à distance comme en présentiel. Je cherche une structure à taille humaine où la qualité du service client et l\'entraide sont des valeurs réelles.', '8b3fddc1-00ae-4bbe-b4e4-19466159b47a', '1 sem. école / 2 sem. entreprise', 0, '2026-07-27 12:47:47.727646', '2026-07-27 12:50:32.000000', '{\"e86bf4ae-63a3-4bc1-9745-12dfdbdda064\":[1,2,3],\"46559190-c45e-416a-a546-dfc6039d52de\":[0,2,3],\"089bae36-8066-4730-809e-960745dfa09d\":[0,1]}', 'Loan MATA', 'classic', NULL, 0),
('bc92a979-3236-403b-a3ed-c7ac645051c5', 'Mentor YNOV', '', 'Mentor informatique', 'Étudiant en Bachelor Informatique à Ynov Campus Montpellier et **major de promo**, je recherche une alternance en tant que **mentor informatique** à partir de septembre 2026, pour accompagner les nouveaux élèves grâce à mes compétences **autodidactes** en Linux, réseau et développement.\n\nJe suis aussi **profondément investi dans la vie du campus** : **ambassadeur lors des journées portes ouvertes** (visites, accueil des familles, présentations aux côtés de la directrice), **soutien technique aux Ydays**, et aide ponctuelle à des groupes d\'élèves sur leurs projets. Cette proximité avec les nouveaux arrivants est ce qui me pousse aujourd\'hui vers un rôle de mentorat.', '8b3fddc1-00ae-4bbe-b4e4-19466159b47a', 'Alternant sur le campus 2sem. /3', 0, '2026-07-03 14:21:12.894352', '2026-07-03 15:15:18.000000', '{\"46559190-c45e-416a-a546-dfc6039d52de\":[0,1,2],\"e86bf4ae-63a3-4bc1-9745-12dfdbdda064\":[0,1,3],\"089bae36-8066-4730-809e-960745dfa09d\":[0,1,2]}', 'Loan  MATA', 'classic', NULL, 0),
('814d2b1e-7256-4603-a0ad-cb05fd28e509', 'G. Tech IT - Link', 'itsupport', 'Tech. Support IT/ Sys et réseau', 'Étudiant en 2ᵉ année Bachelor Informatique (Ynov Campus Montpellier), classé premier de promotion en infrastructure, je combine 8 ans de pratique autodidacte du développement à une spécialisation récente en infrastructure et DevOps. Solide à l\'aise sur l\'ensemble de la chaîne technique avec: Windows Server, Active Directory/GPO, Linux, virtualisation (VMware, Proxmox, TrueNAS, Docker), réseaux (TCP/IP, DNS, VPN, firewall, PfSense). Je résous les incidents avec méthode et pédagogie, du diagnostic N1 jusqu\'aux problématiques plus poussées d\'infrastructure. Habitué aux outils de ticketing (Trello, Jira) et à l\'accompagnement utilisateur, je recherche une alternance en tant que technicien support IT/systèmes & réseaux à partir de septembre 2026, avec l\'envie de mettre mes compétences transverses au service d\'environnements techniques variés.', '8b3fddc1-00ae-4bbe-b4e4-19466159b47a', 'Recherche alternance: 1 sem. école / 2 sem. entreprise', 0, '2026-08-26 15:33:36.135489', '2026-08-26 15:34:00.000000', '{\"e86bf4ae-63a3-4bc1-9745-12dfdbdda064\":[0,1,2,3],\"46559190-c45e-416a-a546-dfc6039d52de\":[8,1,3],\"089bae36-8066-4730-809e-960745dfa09d\":[3,5,0]}', 'Loan MATA', 'classic', NULL, 0),
('2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'Tech sys/it - ISP', 'itsupport', 'Alternant - Tech. Support IT/ Sys et réseau', 'Étudiant en 3ᵉ année Bachelor Informatique (Ynov Campus Montpellier), classé premier de promotion en infrastructure, je combine 8 ans de pratique autodidacte du développement à une spécialisation récente en infrastructure et DevOps. Solide à l\'aise sur l\'ensemble de la chaîne technique avec: Windows Server, Active Directory/GPO, Linux, virtualisation (VMware, Proxmox, TrueNAS, Docker), réseaux (TCP/IP, DNS, VPN, firewall, PfSense). Je résous les incidents avec méthode et pédagogie, du diagnostic N1 jusqu\'aux problématiques plus poussées d\'infrastructure. Habitué aux outils de ticketing (Trello, Jira) et à l\'accompagnement utilisateur, je recherche une alternance en tant que technicien support IT/systèmes & réseaux à partir de septembre 2026, avec l\'envie de mettre mes compétences transverses au service d\'environnements techniques variés.', '8b3fddc1-00ae-4bbe-b4e4-19466159b47a', 'Recherche alternance: 1 sem. école / 2 sem. entreprise', 0, '2026-09-01 12:52:40.822895', '2026-09-01 12:53:35.000000', '{\"e86bf4ae-63a3-4bc1-9745-12dfdbdda064\":[0,1,2,3],\"46559190-c45e-416a-a546-dfc6039d52de\":[8,1,3,2],\"089bae36-8066-4730-809e-960745dfa09d\":[3,5,0,1]}', 'Loan MATA', 'classic', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `cv_contacts`
--

CREATE TABLE `cv_contacts` (
  `cvsId` uuid NOT NULL,
  `contactsId` uuid NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `cv_contacts`
--

INSERT INTO `cv_contacts` (`cvsId`, `contactsId`) VALUES
('d9be75ef-b6da-48bc-a672-17db1d1c1316', '3a3d6817-4ea3-42f4-b78b-54f3db20c955'),
('d9be75ef-b6da-48bc-a672-17db1d1c1316', '511d43c3-9613-41fe-a7ef-5d0bce63082f'),
('d9be75ef-b6da-48bc-a672-17db1d1c1316', 'a7b0aa52-1641-45ad-aa36-9cf0f93b5fa5'),
('d9be75ef-b6da-48bc-a672-17db1d1c1316', 'd164fa25-b8c5-415b-8a21-c125f2450999'),
('d9be75ef-b6da-48bc-a672-17db1d1c1316', 'e9259fc2-414b-4c26-809c-db6fa30d5682'),
('0b7abd38-08a5-42a2-bd6f-1943e7dda836', '3a3d6817-4ea3-42f4-b78b-54f3db20c955'),
('0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'a7b0aa52-1641-45ad-aa36-9cf0f93b5fa5'),
('0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'f5401c4e-3966-40d2-95f1-9e087c6fc6ab'),
('0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'd164fa25-b8c5-415b-8a21-c125f2450999'),
('0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'e9259fc2-414b-4c26-809c-db6fa30d5682'),
('dd88abba-061c-4363-8255-58a5e79bf0a1', '3a3d6817-4ea3-42f4-b78b-54f3db20c955'),
('dd88abba-061c-4363-8255-58a5e79bf0a1', 'a7b0aa52-1641-45ad-aa36-9cf0f93b5fa5'),
('dd88abba-061c-4363-8255-58a5e79bf0a1', 'f5401c4e-3966-40d2-95f1-9e087c6fc6ab'),
('dd88abba-061c-4363-8255-58a5e79bf0a1', 'd164fa25-b8c5-415b-8a21-c125f2450999'),
('dd88abba-061c-4363-8255-58a5e79bf0a1', 'e9259fc2-414b-4c26-809c-db6fa30d5682'),
('7523c9ed-86d8-4932-bc0c-5aea50b39319', '3a3d6817-4ea3-42f4-b78b-54f3db20c955'),
('7523c9ed-86d8-4932-bc0c-5aea50b39319', 'a7b0aa52-1641-45ad-aa36-9cf0f93b5fa5'),
('7523c9ed-86d8-4932-bc0c-5aea50b39319', 'f5401c4e-3966-40d2-95f1-9e087c6fc6ab'),
('7523c9ed-86d8-4932-bc0c-5aea50b39319', 'd164fa25-b8c5-415b-8a21-c125f2450999'),
('7523c9ed-86d8-4932-bc0c-5aea50b39319', 'e9259fc2-414b-4c26-809c-db6fa30d5682'),
('8eb80784-dd54-400b-a477-69e9c1685287', '3a3d6817-4ea3-42f4-b78b-54f3db20c955'),
('8eb80784-dd54-400b-a477-69e9c1685287', 'a7b0aa52-1641-45ad-aa36-9cf0f93b5fa5'),
('8eb80784-dd54-400b-a477-69e9c1685287', 'f5401c4e-3966-40d2-95f1-9e087c6fc6ab'),
('8eb80784-dd54-400b-a477-69e9c1685287', 'd164fa25-b8c5-415b-8a21-c125f2450999'),
('8eb80784-dd54-400b-a477-69e9c1685287', 'e9259fc2-414b-4c26-809c-db6fa30d5682'),
('8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '3a3d6817-4ea3-42f4-b78b-54f3db20c955'),
('8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'a7b0aa52-1641-45ad-aa36-9cf0f93b5fa5'),
('8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'f5401c4e-3966-40d2-95f1-9e087c6fc6ab'),
('8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'd164fa25-b8c5-415b-8a21-c125f2450999'),
('8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'e9259fc2-414b-4c26-809c-db6fa30d5682'),
('f51627d4-449b-45ae-ada5-92a2f16b8794', '3a3d6817-4ea3-42f4-b78b-54f3db20c955'),
('f51627d4-449b-45ae-ada5-92a2f16b8794', '0054036e-a6b2-42ba-b0fe-867fd3ea186b'),
('f51627d4-449b-45ae-ada5-92a2f16b8794', 'a7b0aa52-1641-45ad-aa36-9cf0f93b5fa5'),
('f51627d4-449b-45ae-ada5-92a2f16b8794', 'd164fa25-b8c5-415b-8a21-c125f2450999'),
('f51627d4-449b-45ae-ada5-92a2f16b8794', 'e9259fc2-414b-4c26-809c-db6fa30d5682'),
('b169aa86-f12f-4689-ada1-92dd5c59e26a', '3a3d6817-4ea3-42f4-b78b-54f3db20c955'),
('b169aa86-f12f-4689-ada1-92dd5c59e26a', '0054036e-a6b2-42ba-b0fe-867fd3ea186b'),
('b169aa86-f12f-4689-ada1-92dd5c59e26a', 'a7b0aa52-1641-45ad-aa36-9cf0f93b5fa5'),
('b169aa86-f12f-4689-ada1-92dd5c59e26a', 'd164fa25-b8c5-415b-8a21-c125f2450999'),
('b169aa86-f12f-4689-ada1-92dd5c59e26a', 'e9259fc2-414b-4c26-809c-db6fa30d5682'),
('a74e7a39-e352-4a48-8414-bcd2f89f31c5', '3a3d6817-4ea3-42f4-b78b-54f3db20c955'),
('a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'a7b0aa52-1641-45ad-aa36-9cf0f93b5fa5'),
('a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'f5401c4e-3966-40d2-95f1-9e087c6fc6ab'),
('a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'd164fa25-b8c5-415b-8a21-c125f2450999'),
('a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'e9259fc2-414b-4c26-809c-db6fa30d5682'),
('bc92a979-3236-403b-a3ed-c7ac645051c5', '3a3d6817-4ea3-42f4-b78b-54f3db20c955'),
('bc92a979-3236-403b-a3ed-c7ac645051c5', '0054036e-a6b2-42ba-b0fe-867fd3ea186b'),
('bc92a979-3236-403b-a3ed-c7ac645051c5', 'a7b0aa52-1641-45ad-aa36-9cf0f93b5fa5'),
('bc92a979-3236-403b-a3ed-c7ac645051c5', 'd164fa25-b8c5-415b-8a21-c125f2450999'),
('bc92a979-3236-403b-a3ed-c7ac645051c5', 'e9259fc2-414b-4c26-809c-db6fa30d5682'),
('814d2b1e-7256-4603-a0ad-cb05fd28e509', '3a3d6817-4ea3-42f4-b78b-54f3db20c955'),
('814d2b1e-7256-4603-a0ad-cb05fd28e509', 'a7b0aa52-1641-45ad-aa36-9cf0f93b5fa5'),
('814d2b1e-7256-4603-a0ad-cb05fd28e509', 'f5401c4e-3966-40d2-95f1-9e087c6fc6ab'),
('814d2b1e-7256-4603-a0ad-cb05fd28e509', 'e9259fc2-414b-4c26-809c-db6fa30d5682'),
('2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '3a3d6817-4ea3-42f4-b78b-54f3db20c955'),
('2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'a7b0aa52-1641-45ad-aa36-9cf0f93b5fa5'),
('2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'f5401c4e-3966-40d2-95f1-9e087c6fc6ab'),
('2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'd164fa25-b8c5-415b-8a21-c125f2450999'),
('2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'e9259fc2-414b-4c26-809c-db6fa30d5682');

-- --------------------------------------------------------

--
-- Table structure for table `cv_education`
--

CREATE TABLE `cv_education` (
  `cvsId` uuid NOT NULL,
  `educationId` uuid NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `cv_education`
--

INSERT INTO `cv_education` (`cvsId`, `educationId`) VALUES
('d9be75ef-b6da-48bc-a672-17db1d1c1316', '629811f5-5f8f-484d-9b1d-bd1dc4945a05'),
('d9be75ef-b6da-48bc-a672-17db1d1c1316', '6c367130-ee60-4d71-81ff-ffcd2bd217b4'),
('0b7abd38-08a5-42a2-bd6f-1943e7dda836', '629811f5-5f8f-484d-9b1d-bd1dc4945a05'),
('0b7abd38-08a5-42a2-bd6f-1943e7dda836', '6c367130-ee60-4d71-81ff-ffcd2bd217b4'),
('dd88abba-061c-4363-8255-58a5e79bf0a1', '629811f5-5f8f-484d-9b1d-bd1dc4945a05'),
('dd88abba-061c-4363-8255-58a5e79bf0a1', '6c367130-ee60-4d71-81ff-ffcd2bd217b4'),
('7523c9ed-86d8-4932-bc0c-5aea50b39319', '629811f5-5f8f-484d-9b1d-bd1dc4945a05'),
('7523c9ed-86d8-4932-bc0c-5aea50b39319', '6c367130-ee60-4d71-81ff-ffcd2bd217b4'),
('8eb80784-dd54-400b-a477-69e9c1685287', '629811f5-5f8f-484d-9b1d-bd1dc4945a05'),
('8eb80784-dd54-400b-a477-69e9c1685287', '6c367130-ee60-4d71-81ff-ffcd2bd217b4'),
('8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '629811f5-5f8f-484d-9b1d-bd1dc4945a05'),
('8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '6c367130-ee60-4d71-81ff-ffcd2bd217b4'),
('f51627d4-449b-45ae-ada5-92a2f16b8794', '629811f5-5f8f-484d-9b1d-bd1dc4945a05'),
('f51627d4-449b-45ae-ada5-92a2f16b8794', '6c367130-ee60-4d71-81ff-ffcd2bd217b4'),
('b169aa86-f12f-4689-ada1-92dd5c59e26a', '629811f5-5f8f-484d-9b1d-bd1dc4945a05'),
('b169aa86-f12f-4689-ada1-92dd5c59e26a', '6c367130-ee60-4d71-81ff-ffcd2bd217b4'),
('a74e7a39-e352-4a48-8414-bcd2f89f31c5', '629811f5-5f8f-484d-9b1d-bd1dc4945a05'),
('a74e7a39-e352-4a48-8414-bcd2f89f31c5', '6c367130-ee60-4d71-81ff-ffcd2bd217b4'),
('bc92a979-3236-403b-a3ed-c7ac645051c5', '629811f5-5f8f-484d-9b1d-bd1dc4945a05'),
('bc92a979-3236-403b-a3ed-c7ac645051c5', '6c367130-ee60-4d71-81ff-ffcd2bd217b4'),
('814d2b1e-7256-4603-a0ad-cb05fd28e509', '629811f5-5f8f-484d-9b1d-bd1dc4945a05'),
('814d2b1e-7256-4603-a0ad-cb05fd28e509', '6c367130-ee60-4d71-81ff-ffcd2bd217b4'),
('2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '629811f5-5f8f-484d-9b1d-bd1dc4945a05'),
('2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '6c367130-ee60-4d71-81ff-ffcd2bd217b4');

-- --------------------------------------------------------

--
-- Table structure for table `cv_experiences`
--

CREATE TABLE `cv_experiences` (
  `cvsId` uuid NOT NULL,
  `experiencesId` uuid NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `cv_experiences`
--

INSERT INTO `cv_experiences` (`cvsId`, `experiencesId`) VALUES
('d9be75ef-b6da-48bc-a672-17db1d1c1316', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('d9be75ef-b6da-48bc-a672-17db1d1c1316', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('0b7abd38-08a5-42a2-bd6f-1943e7dda836', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('0b7abd38-08a5-42a2-bd6f-1943e7dda836', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('dd88abba-061c-4363-8255-58a5e79bf0a1', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('dd88abba-061c-4363-8255-58a5e79bf0a1', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('7523c9ed-86d8-4932-bc0c-5aea50b39319', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('7523c9ed-86d8-4932-bc0c-5aea50b39319', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('8eb80784-dd54-400b-a477-69e9c1685287', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('8eb80784-dd54-400b-a477-69e9c1685287', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('f51627d4-449b-45ae-ada5-92a2f16b8794', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('f51627d4-449b-45ae-ada5-92a2f16b8794', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('b169aa86-f12f-4689-ada1-92dd5c59e26a', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('b169aa86-f12f-4689-ada1-92dd5c59e26a', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('a74e7a39-e352-4a48-8414-bcd2f89f31c5', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('a74e7a39-e352-4a48-8414-bcd2f89f31c5', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('bc92a979-3236-403b-a3ed-c7ac645051c5', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('bc92a979-3236-403b-a3ed-c7ac645051c5', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('814d2b1e-7256-4603-a0ad-cb05fd28e509', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('814d2b1e-7256-4603-a0ad-cb05fd28e509', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '00b2aafd-d82c-497e-b563-df4b0eb82b64');

-- --------------------------------------------------------

--
-- Table structure for table `cv_languages`
--

CREATE TABLE `cv_languages` (
  `cvsId` uuid NOT NULL,
  `languagesId` uuid NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `cv_languages`
--

INSERT INTO `cv_languages` (`cvsId`, `languagesId`) VALUES
('d9be75ef-b6da-48bc-a672-17db1d1c1316', 'b0100012-5f98-436c-b0f8-91c48914391b'),
('d9be75ef-b6da-48bc-a672-17db1d1c1316', '4bc16d08-b33b-4692-abc8-ef90225ddcdd'),
('0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'b0100012-5f98-436c-b0f8-91c48914391b'),
('0b7abd38-08a5-42a2-bd6f-1943e7dda836', '4bc16d08-b33b-4692-abc8-ef90225ddcdd'),
('dd88abba-061c-4363-8255-58a5e79bf0a1', 'b0100012-5f98-436c-b0f8-91c48914391b'),
('dd88abba-061c-4363-8255-58a5e79bf0a1', '4bc16d08-b33b-4692-abc8-ef90225ddcdd'),
('7523c9ed-86d8-4932-bc0c-5aea50b39319', 'b0100012-5f98-436c-b0f8-91c48914391b'),
('7523c9ed-86d8-4932-bc0c-5aea50b39319', '4bc16d08-b33b-4692-abc8-ef90225ddcdd'),
('8eb80784-dd54-400b-a477-69e9c1685287', 'b0100012-5f98-436c-b0f8-91c48914391b'),
('8eb80784-dd54-400b-a477-69e9c1685287', '4bc16d08-b33b-4692-abc8-ef90225ddcdd'),
('8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'b0100012-5f98-436c-b0f8-91c48914391b'),
('8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '4bc16d08-b33b-4692-abc8-ef90225ddcdd'),
('f51627d4-449b-45ae-ada5-92a2f16b8794', 'b0100012-5f98-436c-b0f8-91c48914391b'),
('f51627d4-449b-45ae-ada5-92a2f16b8794', '4bc16d08-b33b-4692-abc8-ef90225ddcdd'),
('b169aa86-f12f-4689-ada1-92dd5c59e26a', 'b0100012-5f98-436c-b0f8-91c48914391b'),
('b169aa86-f12f-4689-ada1-92dd5c59e26a', '4bc16d08-b33b-4692-abc8-ef90225ddcdd'),
('a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'b0100012-5f98-436c-b0f8-91c48914391b'),
('a74e7a39-e352-4a48-8414-bcd2f89f31c5', '4bc16d08-b33b-4692-abc8-ef90225ddcdd'),
('bc92a979-3236-403b-a3ed-c7ac645051c5', 'b0100012-5f98-436c-b0f8-91c48914391b'),
('bc92a979-3236-403b-a3ed-c7ac645051c5', '4bc16d08-b33b-4692-abc8-ef90225ddcdd'),
('814d2b1e-7256-4603-a0ad-cb05fd28e509', 'b0100012-5f98-436c-b0f8-91c48914391b'),
('814d2b1e-7256-4603-a0ad-cb05fd28e509', '4bc16d08-b33b-4692-abc8-ef90225ddcdd'),
('2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'b0100012-5f98-436c-b0f8-91c48914391b'),
('2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '4bc16d08-b33b-4692-abc8-ef90225ddcdd');

-- --------------------------------------------------------

--
-- Table structure for table `cv_passions`
--

CREATE TABLE `cv_passions` (
  `id` uuid NOT NULL,
  `cvId` uuid NOT NULL,
  `passionId` uuid NOT NULL,
  `order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `cv_passions`
--

INSERT INTO `cv_passions` (`id`, `cvId`, `passionId`, `order`) VALUES
('fdebc0c4-8879-42a5-a84b-03473fa05081', '8eb80784-dd54-400b-a477-69e9c1685287', 'ccb304b5-8d21-41c4-8f3f-6cc8203a5c60', 1),
('75f86d40-309c-49e9-9c35-0734c7932040', '814d2b1e-7256-4603-a0ad-cb05fd28e509', '18cb9b62-30b6-4b3e-997a-9afc32086a41', 1),
('74dad10a-d4c9-409f-9a24-17ff6b2097ea', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', 'ccb304b5-8d21-41c4-8f3f-6cc8203a5c60', 1),
('b754729f-ba4b-48ca-a80b-1c69bf29726d', 'bc92a979-3236-403b-a3ed-c7ac645051c5', '18cb9b62-30b6-4b3e-997a-9afc32086a41', 1),
('1b7e5ec2-a5de-46ff-b8e4-253072f752d6', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'f8181a98-7ba7-4cce-8ab8-ebc682532766', 0),
('79383080-5a02-41d7-b86e-4da1206fb49e', '814d2b1e-7256-4603-a0ad-cb05fd28e509', 'ccb304b5-8d21-41c4-8f3f-6cc8203a5c60', 0),
('1f6ea0fc-9528-4f34-99d9-67f09fa49b22', '7523c9ed-86d8-4932-bc0c-5aea50b39319', 'f8181a98-7ba7-4cce-8ab8-ebc682532766', 0),
('841ab6be-0566-4c36-a6b7-6842ef242821', '8eb80784-dd54-400b-a477-69e9c1685287', 'f8181a98-7ba7-4cce-8ab8-ebc682532766', 0),
('95b7d695-c362-47dc-bd53-6afbb2a1beb8', 'f51627d4-449b-45ae-ada5-92a2f16b8794', 'ccb304b5-8d21-41c4-8f3f-6cc8203a5c60', 2),
('b2a2944e-779d-440e-8383-6e966d6f161e', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'ccb304b5-8d21-41c4-8f3f-6cc8203a5c60', 1),
('13bcdcf8-6b67-43ef-8e18-7552bf919ccc', 'f51627d4-449b-45ae-ada5-92a2f16b8794', '18cb9b62-30b6-4b3e-997a-9afc32086a41', 1),
('21486153-e4b3-49ae-b4dc-874626255d29', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', 'f8181a98-7ba7-4cce-8ab8-ebc682532766', 0),
('ab4f1be9-db4b-400a-8c9b-8d7881cd258c', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', '18cb9b62-30b6-4b3e-997a-9afc32086a41', 1),
('21e1f3d4-27cd-4b05-a907-90ead76d831f', 'bc92a979-3236-403b-a3ed-c7ac645051c5', 'f8181a98-7ba7-4cce-8ab8-ebc682532766', 0),
('7a3ee14d-dc6a-44ce-b8c8-b10aa0c5f139', 'f51627d4-449b-45ae-ada5-92a2f16b8794', 'f8181a98-7ba7-4cce-8ab8-ebc682532766', 0),
('052ee10d-7903-4fde-b046-b7dd72130380', 'bc92a979-3236-403b-a3ed-c7ac645051c5', 'ccb304b5-8d21-41c4-8f3f-6cc8203a5c60', 2),
('7c787356-e4fa-4ac1-b123-b9325c43ee9e', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'ccb304b5-8d21-41c4-8f3f-6cc8203a5c60', 2),
('04e8dc75-94a2-48a4-94c4-c5d67e413298', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'ccb304b5-8d21-41c4-8f3f-6cc8203a5c60', 0),
('d7d5dae3-bfce-4f95-be22-c9817946947e', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'ccb304b5-8d21-41c4-8f3f-6cc8203a5c60', 0),
('1ea4fa5d-f8f6-4d8e-a4da-da44fbc19682', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', 'f8181a98-7ba7-4cce-8ab8-ebc682532766', 0),
('0224ec92-88cf-492d-803a-dff71b4d34a8', 'dd88abba-061c-4363-8255-58a5e79bf0a1', '18cb9b62-30b6-4b3e-997a-9afc32086a41', 1),
('fe8b0ae5-780d-42e9-846b-e808f2cae2c0', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', 'ccb304b5-8d21-41c4-8f3f-6cc8203a5c60', 2),
('283f9e6f-9c22-497d-a322-f0f31c2e5a40', '7523c9ed-86d8-4932-bc0c-5aea50b39319', 'ccb304b5-8d21-41c4-8f3f-6cc8203a5c60', 1),
('18bb41f3-3274-46d8-9ceb-f16e57a98e01', 'dd88abba-061c-4363-8255-58a5e79bf0a1', 'f8181a98-7ba7-4cce-8ab8-ebc682532766', 0),
('70d4b489-ca9d-44dc-8121-fd435d249b38', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'f8181a98-7ba7-4cce-8ab8-ebc682532766', 0),
('daa11a71-efaf-4a08-a433-fecee538b607', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', '18cb9b62-30b6-4b3e-997a-9afc32086a41', 1);

-- --------------------------------------------------------

--
-- Table structure for table `cv_projects`
--

CREATE TABLE `cv_projects` (
  `id` uuid NOT NULL,
  `cvId` uuid NOT NULL,
  `projectId` uuid NOT NULL,
  `order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `cv_projects`
--

INSERT INTO `cv_projects` (`id`, `cvId`, `projectId`, `order`) VALUES
('3e11b685-ff8c-4916-ad4a-011e0f0bbb14', '8eb80784-dd54-400b-a477-69e9c1685287', 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064', 0),
('d5072687-ec24-444d-a5ac-08214d8bee16', 'f51627d4-449b-45ae-ada5-92a2f16b8794', 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064', 0),
('018a1423-c97e-40a9-a5a4-10b7dfd7a918', '7523c9ed-86d8-4932-bc0c-5aea50b39319', '089bae36-8066-4730-809e-960745dfa09d', 2),
('be945dce-2e34-4211-aa5c-111491ee6b5c', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064', 0),
('54bf9a4a-85c8-44cc-b33a-1d99c265ad6d', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064', 0),
('aaccf18e-a64f-4a92-a192-1ef2e6a5a263', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', '28e23076-b51a-43ca-ad75-97b050ee64d0', 0),
('daade784-b6a2-43dd-acc5-236ec8969dd7', 'f51627d4-449b-45ae-ada5-92a2f16b8794', '089bae36-8066-4730-809e-960745dfa09d', 2),
('53948919-f8ce-4cf2-9c70-3481a86fa405', 'dd88abba-061c-4363-8255-58a5e79bf0a1', '46559190-c45e-416a-a546-dfc6039d52de', 2),
('7008a3e9-1578-41f8-97c2-375fbde3177b', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', '089bae36-8066-4730-809e-960745dfa09d', 2),
('f9ca1ff5-dd32-4bf3-acfa-45c16a1cff9e', 'bc92a979-3236-403b-a3ed-c7ac645051c5', '46559190-c45e-416a-a546-dfc6039d52de', 1),
('f31462a8-92cb-4c26-81b0-57394956f843', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', '46559190-c45e-416a-a546-dfc6039d52de', 1),
('8b7cb19e-7b17-44d8-9665-587c913bfc01', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', '089bae36-8066-4730-809e-960745dfa09d', 2),
('874178d2-0689-417f-8f58-5bde8a04f6ad', 'f51627d4-449b-45ae-ada5-92a2f16b8794', '46559190-c45e-416a-a546-dfc6039d52de', 1),
('689a4074-d8f8-4b3c-a9cd-6939e8c1ee58', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064', 0),
('70e26541-e06b-4fef-9170-7546ad56580e', '814d2b1e-7256-4603-a0ad-cb05fd28e509', '46559190-c45e-416a-a546-dfc6039d52de', 1),
('74b1211e-270e-4ee8-810e-78ee5e6ec4d8', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064', 0),
('823b56cd-b25e-475d-ba6b-7a2ae304e3a8', 'dd88abba-061c-4363-8255-58a5e79bf0a1', 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064', 0),
('011b0ba3-ef5f-49d8-b549-7bf50a820f4d', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064', 0),
('b86d3a50-600e-42c0-92ae-7ed8c2351537', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', '46559190-c45e-416a-a546-dfc6039d52de', 1),
('e2c9b710-475c-402e-a853-8b63bffea020', '814d2b1e-7256-4603-a0ad-cb05fd28e509', 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064', 0),
('bc358f2d-bcc0-408e-a60f-a3a227f00834', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '089bae36-8066-4730-809e-960745dfa09d', 1),
('882b6708-f063-4eec-8cf9-aaf7684e3c1a', 'bc92a979-3236-403b-a3ed-c7ac645051c5', '089bae36-8066-4730-809e-960745dfa09d', 2),
('4d95e399-5cf2-4897-b818-acaf0e836e33', '8eb80784-dd54-400b-a477-69e9c1685287', '089bae36-8066-4730-809e-960745dfa09d', 2),
('36453c8a-7e2d-449d-8674-acff16265631', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '46559190-c45e-416a-a546-dfc6039d52de', 1),
('5e7a5998-6d33-4b98-82a5-b0574376bd91', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '089bae36-8066-4730-809e-960745dfa09d', 2),
('0bd35a2f-1ebc-41ca-90a2-b068654fa011', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', '089bae36-8066-4730-809e-960745dfa09d', 2),
('fca8f022-c1a1-459e-8851-bfd01a6fa892', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '46559190-c45e-416a-a546-dfc6039d52de', 2),
('cbca02f9-051f-444b-a7ec-bfe8ecc75456', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', '089bae36-8066-4730-809e-960745dfa09d', 2),
('176c36a3-635e-4818-b140-c16cfea13a89', '7523c9ed-86d8-4932-bc0c-5aea50b39319', '46559190-c45e-416a-a546-dfc6039d52de', 1),
('2b5ec1cb-eba9-4ba4-90fe-c224b5577afd', 'dd88abba-061c-4363-8255-58a5e79bf0a1', '089bae36-8066-4730-809e-960745dfa09d', 1),
('e3f09eb5-4a9d-4e44-8d00-c4f132c6acf8', '814d2b1e-7256-4603-a0ad-cb05fd28e509', '089bae36-8066-4730-809e-960745dfa09d', 2),
('957a5fec-8f38-4415-bb9d-ca41dd348ac8', '8eb80784-dd54-400b-a477-69e9c1685287', '46559190-c45e-416a-a546-dfc6039d52de', 1),
('d90cd27d-d67e-404c-838d-daffab0dfe21', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', '3e830952-4412-4872-9ddb-ea7dadd33bfa', 1),
('ee9bfcfe-c8e1-4b56-bec2-dcd7535b32ba', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', '46559190-c45e-416a-a546-dfc6039d52de', 1),
('21390523-7659-4d1c-a758-e1f68bfb23b5', 'bc92a979-3236-403b-a3ed-c7ac645051c5', 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064', 0),
('cad0ebce-8cc4-4c1d-9622-feceb40c1ec6', '7523c9ed-86d8-4932-bc0c-5aea50b39319', 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064', 0);

-- --------------------------------------------------------

--
-- Table structure for table `cv_skills`
--

CREATE TABLE `cv_skills` (
  `id` uuid NOT NULL,
  `cvId` uuid NOT NULL,
  `skillId` uuid NOT NULL,
  `order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `cv_skills`
--

INSERT INTO `cv_skills` (`id`, `cvId`, `skillId`, `order`) VALUES
('105cba81-3285-4667-a3e8-005467761fbb', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'fc2596c3-0dc4-4bf0-ac99-aebe184070bd', 17),
('71912c0d-32b4-4d4f-b267-00bdaba073bb', '8eb80784-dd54-400b-a477-69e9c1685287', '3ce98505-438e-4383-bc70-8eda7810d11a', 11),
('afd9f730-b525-4775-a0fd-027f11cef7e8', '814d2b1e-7256-4603-a0ad-cb05fd28e509', 'fc2596c3-0dc4-4bf0-ac99-aebe184070bd', 17),
('9a976858-cb20-49a6-9277-02f393627082', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '6430f088-e016-4fde-a938-9c15ccecae90', 0),
('55e90370-bb80-4006-9b5a-0664f07aba51', '814d2b1e-7256-4603-a0ad-cb05fd28e509', 'b74f4bf5-edbf-43e8-ad49-3a3347f1f8cc', 4),
('3b4c2158-d52e-4087-ba07-06b4ec0aded3', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', '49f3f30a-9daf-450f-b6a6-8959e45c6d54', 5),
('b437fb3e-c0fc-408b-9234-06ba0c30585d', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'fe0c8701-95d6-4c83-a8ae-66fcee8f7342', 20),
('cc91537b-aa93-4b3c-b552-076f735084a6', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'dbc31c97-a63d-453c-ac2a-ca85dc432deb', 16),
('c21c89b2-8efc-4bcb-b707-08494cb3a23a', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', '23c326fa-1ad5-44a5-a028-fbd91fdc4e71', 7),
('50d507e5-0e5b-4dca-9c7a-0a0de17cc118', '8eb80784-dd54-400b-a477-69e9c1685287', '2d330da5-b291-4b36-81f7-2ed26ac87a10', 9),
('0411d53f-814f-4daa-bf86-0b98b6f0bf74', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'dbc31c97-a63d-453c-ac2a-ca85dc432deb', 3),
('ba3e05fc-a14f-48b3-8e7b-0c670bc12d89', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', 'f68bdf74-6845-4d60-aa09-4f0d149a600c', 13),
('64a49712-876f-4840-8fda-0e58672077d4', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'f918d709-7452-4945-b27d-2db06c7a8315', 3),
('4298c40e-af92-4bfc-81ca-0ead5c1f7576', 'bc92a979-3236-403b-a3ed-c7ac645051c5', '6430f088-e016-4fde-a938-9c15ccecae90', 0),
('b61c3e40-70a3-4fe9-ae13-1015ced7205b', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', '6430f088-e016-4fde-a938-9c15ccecae90', 0),
('b7865b3e-737b-40b1-b182-110d0769bc08', '814d2b1e-7256-4603-a0ad-cb05fd28e509', 'fe0c8701-95d6-4c83-a8ae-66fcee8f7342', 20),
('da0c5f42-a8ff-4f05-8e49-11f00746e198', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '20361c79-a798-41d1-a9f6-f808e78ea4b2', 2),
('aa60cf08-689e-4750-a684-1250c5e9563a', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '23e706a8-8c15-4464-9243-015730036121', 11),
('ece19ec0-7987-40e7-837c-12947556b98e', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'b1c840fe-4c2a-49ea-b541-50387052524e', 6),
('01d38a47-92c6-4234-b119-14e8cc5c1fbb', '814d2b1e-7256-4603-a0ad-cb05fd28e509', '23c326fa-1ad5-44a5-a028-fbd91fdc4e71', 10),
('4564cf96-421c-48a1-a11e-15a1db99a859', '8eb80784-dd54-400b-a477-69e9c1685287', '8df15dce-8267-430f-b1f5-b2103e51eb6a', 5),
('d2b7d4f2-4cb9-46b9-b129-162d496a1440', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'fc2596c3-0dc4-4bf0-ac99-aebe184070bd', 9),
('576a3ed1-2c20-4dc8-a278-19371c75712f', 'bc92a979-3236-403b-a3ed-c7ac645051c5', '64140dce-ddd9-4b46-a385-e0b4c35e2374', 12),
('7f5dfa39-d85e-4f6d-9185-19420a354c70', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'f68bdf74-6845-4d60-aa09-4f0d149a600c', 13),
('e73f61f5-3109-4485-84e0-1bee68f9475a', '814d2b1e-7256-4603-a0ad-cb05fd28e509', 'f918d709-7452-4945-b27d-2db06c7a8315', 3),
('a4b4a954-375d-434f-a77a-1d90ed5b94d8', 'bc92a979-3236-403b-a3ed-c7ac645051c5', 'c95ed783-d391-4c55-b046-1c71925157be', 10),
('6026b198-6f1c-43b7-8573-1e2c87ac88bc', 'f51627d4-449b-45ae-ada5-92a2f16b8794', '2d330da5-b291-4b36-81f7-2ed26ac87a10', 7),
('2de32c7a-060b-484d-8977-1e7579853e7f', '8eb80784-dd54-400b-a477-69e9c1685287', 'b1c840fe-4c2a-49ea-b541-50387052524e', 4),
('b6fe425d-513c-4625-a3b3-204db2a19c1b', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '237b275b-9bc5-41d8-b70f-2c3d49032abe', 5),
('945e4b37-6183-4176-ab25-22409690818a', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', '2d330da5-b291-4b36-81f7-2ed26ac87a10', 1),
('6b6ce978-5931-43a7-be6e-26d5a80e9c68', 'bc92a979-3236-403b-a3ed-c7ac645051c5', '15ff098f-c421-4d4a-b6bc-030f2bc2a6b6', 1),
('95b6e873-adf8-47ab-9cbc-272e0e26b5e8', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', 'bbcf0f8b-93b9-437a-a9f5-248899a774d3', 1),
('0c4844fc-944f-48fb-a70f-28adc0cc5053', 'dd88abba-061c-4363-8255-58a5e79bf0a1', '3ce98505-438e-4383-bc70-8eda7810d11a', 18),
('bc1ccde7-9ae5-418d-9f1d-29fbb599de9f', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'b74f4bf5-edbf-43e8-ad49-3a3347f1f8cc', 15),
('10f0eea7-67e6-4f1c-a4ac-2a862526610c', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', 'f918d709-7452-4945-b27d-2db06c7a8315', 17),
('1cbdb1ce-ac14-4734-b6f1-2b3832ce2304', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', '227206b4-44a4-42b3-87f1-0b7528ef12ce', 14),
('79aeca14-fe1d-44dd-aac4-2d7bb72e0b8e', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', 'c95ed783-d391-4c55-b046-1c71925157be', 16),
('73fe57c4-c50f-41fd-bc94-2fb63f33e477', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', '2ea576d5-44d3-42a8-b2c0-b1319942b64b', 4),
('df3ae993-3a79-4f1f-ae18-3177b15e8041', '7523c9ed-86d8-4932-bc0c-5aea50b39319', '5d9f55fe-bd88-422b-b8e0-acddca6707ab', 6),
('803ec062-9bf6-4e18-8bca-31823633dbc6', '814d2b1e-7256-4603-a0ad-cb05fd28e509', '2ea576d5-44d3-42a8-b2c0-b1319942b64b', 18),
('27aed164-a69c-4e22-ab98-326a1ad0d62d', '7523c9ed-86d8-4932-bc0c-5aea50b39319', '23e706a8-8c15-4464-9243-015730036121', 9),
('61be5bc4-3325-4c18-9bb2-33b90f785617', '814d2b1e-7256-4603-a0ad-cb05fd28e509', '5d9f55fe-bd88-422b-b8e0-acddca6707ab', 2),
('eff8447d-de4e-4ad7-a063-34851ca583ce', 'f51627d4-449b-45ae-ada5-92a2f16b8794', 'f918d709-7452-4945-b27d-2db06c7a8315', 12),
('5344251b-4cb2-42b1-9e6b-3746e3f79bbd', '814d2b1e-7256-4603-a0ad-cb05fd28e509', '5e5187bc-859b-4c5d-a45f-6c37df1bead6', 9),
('93db3c43-a6c7-49d0-9cd0-37473a0e4538', '8eb80784-dd54-400b-a477-69e9c1685287', 'c95ed783-d391-4c55-b046-1c71925157be', 14),
('705e580c-082c-4514-b45a-38ac4de0373d', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', '2d330da5-b291-4b36-81f7-2ed26ac87a10', 7),
('ba28157b-f185-449f-aba9-38f58aa8f48b', '7523c9ed-86d8-4932-bc0c-5aea50b39319', 'b778a492-0b34-428c-bc6e-8ffff11448d5', 2),
('4e50cb28-6278-4df5-b30f-39fbe4ca37b8', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '2ea576d5-44d3-42a8-b2c0-b1319942b64b', 18),
('e1876950-9b0b-444a-a7ee-3a95264c5519', 'dd88abba-061c-4363-8255-58a5e79bf0a1', 'dbc31c97-a63d-453c-ac2a-ca85dc432deb', 16),
('8a59ffd1-f327-4992-a778-43eeedbafb26', 'dd88abba-061c-4363-8255-58a5e79bf0a1', '5e5187bc-859b-4c5d-a45f-6c37df1bead6', 15),
('e2e579ba-6441-4f86-8f9d-458bfef75892', 'f51627d4-449b-45ae-ada5-92a2f16b8794', '3ce98505-438e-4383-bc70-8eda7810d11a', 9),
('46232a40-9ec9-4dce-b41b-45b7d58ee440', '7523c9ed-86d8-4932-bc0c-5aea50b39319', 'f918d709-7452-4945-b27d-2db06c7a8315', 7),
('2f389969-c00c-4deb-b33f-46806bbabcd2', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'f918d709-7452-4945-b27d-2db06c7a8315', 13),
('02b5a052-2063-4ef7-b80f-4813eef39552', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', 'f5294185-b125-4861-8762-300971b92a9f', 1),
('60b38783-4dfd-479f-8f94-48a9174f7fac', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '8262a153-e75f-4685-b7df-2398dff69d43', 15),
('6966e730-6fbc-4afa-9443-49c38852fed6', 'bc92a979-3236-403b-a3ed-c7ac645051c5', 'b1c840fe-4c2a-49ea-b541-50387052524e', 6),
('b3fa903d-f07e-4752-809c-4ca089780502', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'f68bdf74-6845-4d60-aa09-4f0d149a600c', 13),
('df16a321-5336-4147-adc8-4de8876c93d7', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'daf31fd1-0f62-4e2b-9013-cc001c305fce', 12),
('f50b2523-6a8e-4dd2-a86b-4e5fe0e5acc5', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', '237b275b-9bc5-41d8-b70f-2c3d49032abe', 5),
('fa4bd713-4df6-4ae8-bd51-4fd1ac7da85a', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', '8262a153-e75f-4685-b7df-2398dff69d43', 14),
('058d1735-aeaf-4c34-becb-51ff53d4adaf', '7523c9ed-86d8-4932-bc0c-5aea50b39319', '8df15dce-8267-430f-b1f5-b2103e51eb6a', 3),
('768d2aa1-0f28-4644-9488-5359d73c5dbd', 'dd88abba-061c-4363-8255-58a5e79bf0a1', 'daf31fd1-0f62-4e2b-9013-cc001c305fce', 13),
('241f4555-a943-4347-8724-555b9cdd63d3', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', '3ce98505-438e-4383-bc70-8eda7810d11a', 9),
('c4c2fcba-3cbc-41f3-bc46-57b5fecb4d4b', 'bc92a979-3236-403b-a3ed-c7ac645051c5', '20361c79-a798-41d1-a9f6-f808e78ea4b2', 4),
('d8f00a2a-a81b-42f4-8929-5896681666f1', '814d2b1e-7256-4603-a0ad-cb05fd28e509', 'bbcf0f8b-93b9-437a-a9f5-248899a774d3', 7),
('be20c410-a0ea-496d-b5b6-591c5fa17e4a', 'bc92a979-3236-403b-a3ed-c7ac645051c5', '49f3f30a-9daf-450f-b6a6-8959e45c6d54', 9),
('5a011ac2-9af9-4c4b-bec6-5abd7416133e', '814d2b1e-7256-4603-a0ad-cb05fd28e509', '2d330da5-b291-4b36-81f7-2ed26ac87a10', 1),
('3d5c9027-7d7b-4de4-882d-5ba27b97ee73', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', 'b1c840fe-4c2a-49ea-b541-50387052524e', 4),
('914ca008-d899-45fb-a886-5c7dee8c2e53', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', 'd0e45f72-b2b8-4217-993d-60d9f03671a2', 15),
('18ef1fbe-9f8e-44af-81bb-5e5577eae89f', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', '6430f088-e016-4fde-a938-9c15ccecae90', 0),
('5101b6ee-7f0a-4918-b7ea-5e59a449fa10', '814d2b1e-7256-4603-a0ad-cb05fd28e509', '237b275b-9bc5-41d8-b70f-2c3d49032abe', 5),
('9b764146-9b80-417a-9a99-61b507934a82', '7523c9ed-86d8-4932-bc0c-5aea50b39319', '552e0ef2-8dd7-40da-a1d9-d4960c715cec', 5),
('7c0c84b3-8394-47d1-84f7-623d32a01178', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'e2868b5d-97d6-4556-8f5f-a586dc6a8c91', 0),
('6cead9c2-369f-419f-a298-635b36c9960f', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '5e5187bc-859b-4c5d-a45f-6c37df1bead6', 9),
('1efdb0ac-d203-4144-a56d-63d005f397c0', 'dd88abba-061c-4363-8255-58a5e79bf0a1', '237b275b-9bc5-41d8-b70f-2c3d49032abe', 5),
('5e70662c-ca71-4977-ac42-64645145d560', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', '552e0ef2-8dd7-40da-a1d9-d4960c715cec', 8),
('002c8409-bd2b-4980-8a21-647d5fe3c751', 'bc92a979-3236-403b-a3ed-c7ac645051c5', '7cd2ef39-c4b6-48ac-bdd6-614675788d56', 2),
('74e16bb3-7a30-4a4c-85ea-64c9adfa0694', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'e2868b5d-97d6-4556-8f5f-a586dc6a8c91', 3),
('45eb2aa4-9ea8-43ed-96cd-6580d47b0019', '7523c9ed-86d8-4932-bc0c-5aea50b39319', 'fc2596c3-0dc4-4bf0-ac99-aebe184070bd', 14),
('63e963b4-cbcd-4050-8228-67a3262da7b9', 'dd88abba-061c-4363-8255-58a5e79bf0a1', 'e2868b5d-97d6-4556-8f5f-a586dc6a8c91', 6),
('bf8f63c0-d02a-480f-ab1e-6906d9e6deab', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', '237b275b-9bc5-41d8-b70f-2c3d49032abe', 6),
('dda2c590-9b27-4337-b5be-6b31e80ff478', '8eb80784-dd54-400b-a477-69e9c1685287', 'bbcf0f8b-93b9-437a-a9f5-248899a774d3', 0),
('eaefb9b6-ebfa-47c6-9b3a-6beb80ca970a', '814d2b1e-7256-4603-a0ad-cb05fd28e509', 'c95ed783-d391-4c55-b046-1c71925157be', 6),
('2bb6d050-e407-42d3-973c-6e876eda5584', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '23c326fa-1ad5-44a5-a028-fbd91fdc4e71', 10),
('c74b84d6-7b3f-4ff4-b55e-70d0f5b093c0', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', '8df15dce-8267-430f-b1f5-b2103e51eb6a', 2),
('823139c6-ccbd-452a-a0ed-71402d379055', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', '237b275b-9bc5-41d8-b70f-2c3d49032abe', 5),
('ae9b7965-3750-4f17-b3c2-736c0deb3d56', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '2ea576d5-44d3-42a8-b2c0-b1319942b64b', 10),
('3fba87cd-2ff8-425e-9182-744c834019e9', 'f51627d4-449b-45ae-ada5-92a2f16b8794', '552e0ef2-8dd7-40da-a1d9-d4960c715cec', 10),
('73d59ef3-29bb-42f4-81b2-74d0f78192e5', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'daf31fd1-0f62-4e2b-9013-cc001c305fce', 0),
('239b26a8-df37-4bc5-bbff-77aadeac8e35', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', 'bbcf0f8b-93b9-437a-a9f5-248899a774d3', 5),
('69d73e66-8f25-42b9-9489-7ae11a2536fe', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'bbcf0f8b-93b9-437a-a9f5-248899a774d3', 7),
('c581dd14-06bd-48ed-a674-7bb61ff21f6e', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', '0c69d863-5e67-4205-9a30-c666f726b10e', 14),
('571464ab-b186-4e71-bdba-7d2ef905d8b6', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', '20361c79-a798-41d1-a9f6-f808e78ea4b2', 2),
('abd19870-8049-4b9d-9eda-802040d9f1b9', 'dd88abba-061c-4363-8255-58a5e79bf0a1', '23c326fa-1ad5-44a5-a028-fbd91fdc4e71', 11),
('25064142-3cd3-45b3-9ccb-80fcda2bab6a', '814d2b1e-7256-4603-a0ad-cb05fd28e509', '552e0ef2-8dd7-40da-a1d9-d4960c715cec', 8),
('28c8ff34-a8ba-481a-ad08-8117237bb642', '814d2b1e-7256-4603-a0ad-cb05fd28e509', 'dbc31c97-a63d-453c-ac2a-ca85dc432deb', 16),
('22c51e87-f28c-46f1-9dda-82d0891fae34', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'c95ed783-d391-4c55-b046-1c71925157be', 6),
('9285ba34-34b0-42f7-a4bc-83197e08ee7f', 'dd88abba-061c-4363-8255-58a5e79bf0a1', '0c69d863-5e67-4205-9a30-c666f726b10e', 3),
('648e3dbe-8a91-46f4-bbcc-83975dd17d40', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', 'b74f4bf5-edbf-43e8-ad49-3a3347f1f8cc', 15),
('74e5c643-ab86-4dbe-be91-8412a9d36fa5', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '49f3f30a-9daf-450f-b6a6-8959e45c6d54', 19),
('60cbbc15-5c2d-4aec-98d0-85dd2c774c31', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', '5d9f55fe-bd88-422b-b8e0-acddca6707ab', 2),
('e28c9087-1149-402c-ab05-85f1d4a52f54', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'dbc31c97-a63d-453c-ac2a-ca85dc432deb', 16),
('98913695-f4d9-40c9-bc8f-86b637464862', 'f51627d4-449b-45ae-ada5-92a2f16b8794', 'b2361fc2-4484-492f-b62a-4372b7391a10', 6),
('27b521fb-85dc-40da-982c-882e72f28639', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', 'fc2596c3-0dc4-4bf0-ac99-aebe184070bd', 9),
('2da10791-f074-4133-9539-88d6fb6a2edc', '8eb80784-dd54-400b-a477-69e9c1685287', '552e0ef2-8dd7-40da-a1d9-d4960c715cec', 12),
('7852f0c2-8422-4364-a6e1-8aa6c6e44f53', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'bbcf0f8b-93b9-437a-a9f5-248899a774d3', 1),
('2bd5ddbe-8d5e-454a-896e-8db2a9a797c8', '814d2b1e-7256-4603-a0ad-cb05fd28e509', '49f3f30a-9daf-450f-b6a6-8959e45c6d54', 19),
('02d6f238-b73d-4b99-aad0-8e117fcd27b9', '8eb80784-dd54-400b-a477-69e9c1685287', 'b2361fc2-4484-492f-b62a-4372b7391a10', 8),
('e954f88e-9dd5-43d6-b567-8e7768f410e8', '814d2b1e-7256-4603-a0ad-cb05fd28e509', '227206b4-44a4-42b3-87f1-0b7528ef12ce', 14),
('f9e76987-5217-4ab6-b027-8f00b1e8874d', 'f51627d4-449b-45ae-ada5-92a2f16b8794', 'b778a492-0b34-428c-bc6e-8ffff11448d5', 8),
('1f934752-514a-4f66-96de-90c2e17668f4', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'b74f4bf5-edbf-43e8-ad49-3a3347f1f8cc', 4),
('755e3b45-90c6-46e8-a7f6-921b56a74291', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', '47dd5502-6d81-4a7e-a99c-37bdb898472d', 13),
('44346a22-805d-4361-a95b-92edc530f04d', '8eb80784-dd54-400b-a477-69e9c1685287', 'f68bdf74-6845-4d60-aa09-4f0d149a600c', 10),
('f453125c-afae-4649-b955-948640536265', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', 'e2868b5d-97d6-4556-8f5f-a586dc6a8c91', 3),
('a45d69be-66ed-4972-859f-971b5680ea50', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', '8df15dce-8267-430f-b1f5-b2103e51eb6a', 7),
('c24c4838-f154-48d3-ab2a-97346b833017', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', '552e0ef2-8dd7-40da-a1d9-d4960c715cec', 14),
('c7f55543-b02f-4e8d-b8a8-9785e97d4633', 'dd88abba-061c-4363-8255-58a5e79bf0a1', 'c95ed783-d391-4c55-b046-1c71925157be', 9),
('d888fa03-5b6d-45db-adb8-98d4ba9a7907', '8eb80784-dd54-400b-a477-69e9c1685287', 'e2868b5d-97d6-4556-8f5f-a586dc6a8c91', 2),
('0eddc250-c1ac-4bfb-82f9-9974b8389dd0', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', 'b1c840fe-4c2a-49ea-b541-50387052524e', 6),
('515b5b64-34ef-4613-8fdf-9c9186f4c20a', '814d2b1e-7256-4603-a0ad-cb05fd28e509', 'f68bdf74-6845-4d60-aa09-4f0d149a600c', 13),
('122b35b3-4b8b-4ee2-9d5f-9d5d583974e4', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '49f3f30a-9daf-450f-b6a6-8959e45c6d54', 11),
('f76b0eb7-3d32-4a92-98e7-9e78c2b0b624', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'f918d709-7452-4945-b27d-2db06c7a8315', 17),
('9e2405d9-f34d-4156-896b-9f87109fc4fb', 'f51627d4-449b-45ae-ada5-92a2f16b8794', 'dbc31c97-a63d-453c-ac2a-ca85dc432deb', 3),
('0e92b164-0960-4b11-850c-a004721088b7', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'f68bdf74-6845-4d60-aa09-4f0d149a600c', 13),
('b5959ae7-ff5b-4258-907c-a02cd6786fc5', '814d2b1e-7256-4603-a0ad-cb05fd28e509', '23e706a8-8c15-4464-9243-015730036121', 11),
('a722ba8e-9a92-4026-bdd3-a060ab6049c7', 'dd88abba-061c-4363-8255-58a5e79bf0a1', 'b1c840fe-4c2a-49ea-b541-50387052524e', 12),
('2de370fd-500b-427d-a347-a27a88677b55', 'f51627d4-449b-45ae-ada5-92a2f16b8794', 'daf31fd1-0f62-4e2b-9013-cc001c305fce', 0),
('4a0183bb-f8bf-4d0a-aa50-a2d7fff53430', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', '49f3f30a-9daf-450f-b6a6-8959e45c6d54', 19),
('8ab707f1-1b3f-42b3-a044-a4608d7e1f04', '7523c9ed-86d8-4932-bc0c-5aea50b39319', 'bbcf0f8b-93b9-437a-a9f5-248899a774d3', 17),
('c41d7c1e-9b61-4998-ab96-a4897bf24da5', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', '23c326fa-1ad5-44a5-a028-fbd91fdc4e71', 10),
('ca005842-9711-4867-9bcf-a4d6f5831fb9', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '2d330da5-b291-4b36-81f7-2ed26ac87a10', 12),
('b114177a-728a-49e3-9140-a5271d776a0e', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', '23e706a8-8c15-4464-9243-015730036121', 11),
('56f595d9-d26c-433e-aa64-a6040ae676b9', '7523c9ed-86d8-4932-bc0c-5aea50b39319', 'e2868b5d-97d6-4556-8f5f-a586dc6a8c91', 16),
('97311c3d-ad30-4297-b536-a884ec743ded', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '8df15dce-8267-430f-b1f5-b2103e51eb6a', 7),
('e7d391c8-1701-4e2f-9ae0-a93148530766', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', 'dbc31c97-a63d-453c-ac2a-ca85dc432deb', 9),
('0eb1e6d9-6bc1-4b56-9f54-ac2fc2cb0392', 'dd88abba-061c-4363-8255-58a5e79bf0a1', 'fe0c8701-95d6-4c83-a8ae-66fcee8f7342', 19),
('f429c173-ecac-498e-8dcd-ac3b41e2b00c', 'dd88abba-061c-4363-8255-58a5e79bf0a1', '8df15dce-8267-430f-b1f5-b2103e51eb6a', 10),
('e276e504-dd5a-4445-bbe7-ac9b049e56ba', 'f51627d4-449b-45ae-ada5-92a2f16b8794', 'c95ed783-d391-4c55-b046-1c71925157be', 11),
('c078fbbc-3df9-446e-bc47-ad8a8cae2cd1', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'b74f4bf5-edbf-43e8-ad49-3a3347f1f8cc', 4),
('facf7538-b75c-413f-b073-adcd878b7a59', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '5d9f55fe-bd88-422b-b8e0-acddca6707ab', 2),
('f612550b-3af5-4a6f-a2cd-adedef038260', '7523c9ed-86d8-4932-bc0c-5aea50b39319', 'daf31fd1-0f62-4e2b-9013-cc001c305fce', 18),
('1558db99-0d28-4110-a1a2-af622803df6f', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', '2ea576d5-44d3-42a8-b2c0-b1319942b64b', 18),
('8becb021-6a25-45f1-8b2c-b176f8215602', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '552e0ef2-8dd7-40da-a1d9-d4960c715cec', 8),
('49ee53af-88dc-4278-b674-b38eecc1a713', 'bc92a979-3236-403b-a3ed-c7ac645051c5', 'bbcf0f8b-93b9-437a-a9f5-248899a774d3', 3),
('4fc492fa-30de-4f8f-ae75-b3a2bf571b90', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', '552e0ef2-8dd7-40da-a1d9-d4960c715cec', 10),
('80e9b31b-d17d-49f8-899e-b3f0ac087c83', 'dd88abba-061c-4363-8255-58a5e79bf0a1', '2d330da5-b291-4b36-81f7-2ed26ac87a10', 1),
('ae3d2a59-7853-4643-8548-b4e8976aff73', '7523c9ed-86d8-4932-bc0c-5aea50b39319', '2d330da5-b291-4b36-81f7-2ed26ac87a10', 0),
('d7c13857-b836-40cd-98ab-b531c4b41b97', '8eb80784-dd54-400b-a477-69e9c1685287', '23e706a8-8c15-4464-9243-015730036121', 3),
('2cf41a11-38ef-43d9-a1f8-b557af4e0ee4', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'b74f4bf5-edbf-43e8-ad49-3a3347f1f8cc', 11),
('ab5c626d-878e-4032-aad6-b680d6e1c825', 'dd88abba-061c-4363-8255-58a5e79bf0a1', '6430f088-e016-4fde-a938-9c15ccecae90', 14),
('44521791-c272-4d50-849d-b6db265a8c70', 'dd88abba-061c-4363-8255-58a5e79bf0a1', 'fc2596c3-0dc4-4bf0-ac99-aebe184070bd', 17),
('097775f1-f5b8-4c1b-a429-b6f613d7f72a', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', 'fe0c8701-95d6-4c83-a8ae-66fcee8f7342', 10),
('493c6816-0a9c-4d9f-ab74-b7892217ab1c', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '237b275b-9bc5-41d8-b70f-2c3d49032abe', 5),
('f957da40-93ab-4498-9c7e-ba48f67df7a2', '814d2b1e-7256-4603-a0ad-cb05fd28e509', 'e2868b5d-97d6-4556-8f5f-a586dc6a8c91', 0),
('ffd666cf-1e89-44b5-b41c-ba9d3e1209d6', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'fc2596c3-0dc4-4bf0-ac99-aebe184070bd', 17),
('c5aba3e0-c567-44c0-9737-bf3bba09fce7', 'bc92a979-3236-403b-a3ed-c7ac645051c5', '2ea576d5-44d3-42a8-b2c0-b1319942b64b', 8),
('543694a6-1460-4dee-9a1a-bfe2bea1a981', 'dd88abba-061c-4363-8255-58a5e79bf0a1', '23e706a8-8c15-4464-9243-015730036121', 0),
('f56d7384-901f-4b5d-9658-bfea551d8981', 'dd88abba-061c-4363-8255-58a5e79bf0a1', 'f04d0a6b-99de-480d-b01e-79cb6ab11620', 2),
('d1523ede-dcf4-4b14-90c1-c42d1c8830c1', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', '5e5187bc-859b-4c5d-a45f-6c37df1bead6', 9),
('78158e5a-2afa-4cda-a4af-c65781e2fc8e', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'fe0c8701-95d6-4c83-a8ae-66fcee8f7342', 20),
('9940e636-8040-4572-b9b9-c6b957374004', '7523c9ed-86d8-4932-bc0c-5aea50b39319', '23c326fa-1ad5-44a5-a028-fbd91fdc4e71', 19),
('2c1e14f4-2f5e-4ee1-90ea-c7481c785ab9', '814d2b1e-7256-4603-a0ad-cb05fd28e509', 'daf31fd1-0f62-4e2b-9013-cc001c305fce', 12),
('ce394d23-57bb-44e5-8fe3-c88c542d7218', 'dd88abba-061c-4363-8255-58a5e79bf0a1', 'b778a492-0b34-428c-bc6e-8ffff11448d5', 4),
('7b571a8d-f1e2-408e-8989-c8d292aa211c', 'bc92a979-3236-403b-a3ed-c7ac645051c5', '9337513c-374c-486c-b683-8adf03fb9463', 11),
('885e0f84-f66f-4c8c-9e7e-cac0d349f826', '8eb80784-dd54-400b-a477-69e9c1685287', '49f3f30a-9daf-450f-b6a6-8959e45c6d54', 7),
('cc3e157c-cff5-4570-9b55-cae1614cbe58', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'c95ed783-d391-4c55-b046-1c71925157be', 12),
('fa4857b4-4d4c-4e67-bed6-cbeb6fb71469', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '227206b4-44a4-42b3-87f1-0b7528ef12ce', 14),
('05a1325e-8137-4bc2-8b5a-cca1f540a191', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'b1c840fe-4c2a-49ea-b541-50387052524e', 1),
('e2bb44b4-794c-439d-9a5b-cdb8695fee63', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', '2ea576d5-44d3-42a8-b2c0-b1319942b64b', 10),
('fd871e20-81af-4412-9de7-ce0694812bfc', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'daf31fd1-0f62-4e2b-9013-cc001c305fce', 12),
('456d86d2-beeb-4b02-b6e2-cf36493fc553', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', '49f3f30a-9daf-450f-b6a6-8959e45c6d54', 11),
('2380edff-d32f-460f-be79-cf7e5f3cdf13', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', 'daf31fd1-0f62-4e2b-9013-cc001c305fce', 8),
('f5e89940-3b1a-4cd1-b60b-d0a67aafa2a9', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', '8478cb13-008c-44eb-8380-5364632bffce', 3),
('6adcb3d0-9440-4998-8b32-d0ea21dc8c38', 'f51627d4-449b-45ae-ada5-92a2f16b8794', '2ea576d5-44d3-42a8-b2c0-b1319942b64b', 4),
('8b82c05f-d3ac-4940-9226-d1752ff1361c', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', '49f3f30a-9daf-450f-b6a6-8959e45c6d54', 12),
('b49ed3cd-c7e1-4c80-8170-d1861bf19d73', '7523c9ed-86d8-4932-bc0c-5aea50b39319', '2ea576d5-44d3-42a8-b2c0-b1319942b64b', 15),
('ecde862a-4182-4d97-9b33-d49b489e68e3', '814d2b1e-7256-4603-a0ad-cb05fd28e509', '8262a153-e75f-4685-b7df-2398dff69d43', 15),
('7c522a12-8d38-4867-80ed-d6eb9f32e2a0', '8eb80784-dd54-400b-a477-69e9c1685287', '20361c79-a798-41d1-a9f6-f808e78ea4b2', 1),
('b3717eee-dc58-47b8-af7c-d78c85f86fd8', 'bc92a979-3236-403b-a3ed-c7ac645051c5', '54a32bea-07ae-4e67-900f-b34d883ca5d3', 13),
('143571ad-f50a-49a7-8b78-d84fc793a36a', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'dbc31c97-a63d-453c-ac2a-ca85dc432deb', 8),
('9adcf398-c49a-489e-9e18-d87ae505b379', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '23e706a8-8c15-4464-9243-015730036121', 4),
('678181ff-7c18-4963-8601-d8cc654e26bf', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', 'e2868b5d-97d6-4556-8f5f-a586dc6a8c91', 0),
('36a34935-2c46-44ff-8ff1-da68c75d8028', '7523c9ed-86d8-4932-bc0c-5aea50b39319', 'dbc31c97-a63d-453c-ac2a-ca85dc432deb', 12),
('22254981-a950-41d4-bd2d-db9f13346888', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', '2d330da5-b291-4b36-81f7-2ed26ac87a10', 12),
('70fd80f5-ae64-4549-a66c-dbf1df8307e0', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', '23e706a8-8c15-4464-9243-015730036121', 4),
('5f511ed4-4734-45a1-82c4-dcabc115b6f9', '7523c9ed-86d8-4932-bc0c-5aea50b39319', 'b74f4bf5-edbf-43e8-ad49-3a3347f1f8cc', 8),
('ec300f48-51ec-49f3-8ea1-dcc948ef9c96', '7523c9ed-86d8-4932-bc0c-5aea50b39319', '227206b4-44a4-42b3-87f1-0b7528ef12ce', 4),
('c87d4c18-39a8-4f6d-9e12-dcd5decfcf8a', '2ed79f89-dc41-4ee4-a7b4-e8b32147819f', '2d330da5-b291-4b36-81f7-2ed26ac87a10', 1),
('9da860bb-87db-4fc6-b697-dd6daf83241f', '7523c9ed-86d8-4932-bc0c-5aea50b39319', 'f68bdf74-6845-4d60-aa09-4f0d149a600c', 11),
('ae033d33-f903-4963-9f07-dfddb9adc254', '7523c9ed-86d8-4932-bc0c-5aea50b39319', 'b2361fc2-4484-492f-b62a-4372b7391a10', 13),
('5c879045-2306-431d-b7eb-e0ea55c814bb', '8eb80784-dd54-400b-a477-69e9c1685287', 'b74f4bf5-edbf-43e8-ad49-3a3347f1f8cc', 13),
('8330d9ce-61c2-450f-b483-e196f644e614', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'b778a492-0b34-428c-bc6e-8ffff11448d5', 8),
('87eedeec-65a1-45f5-86dc-e52726a3d818', 'f51627d4-449b-45ae-ada5-92a2f16b8794', 'b1c840fe-4c2a-49ea-b541-50387052524e', 1),
('910d8306-f445-4a87-9651-e5e964fe6304', '7523c9ed-86d8-4932-bc0c-5aea50b39319', 'f04d0a6b-99de-480d-b01e-79cb6ab11620', 1),
('027a2d77-b241-42b0-b6c2-e63c80fb3d15', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', '552e0ef2-8dd7-40da-a1d9-d4960c715cec', 14),
('c8b3f980-1db5-4be3-9898-ea6bb7fb6613', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', 'fc2596c3-0dc4-4bf0-ac99-aebe184070bd', 11),
('7b7be8ec-4843-4a28-838a-eb932278565a', 'd9be75ef-b6da-48bc-a672-17db1d1c1316', 'dbc31c97-a63d-453c-ac2a-ca85dc432deb', 8),
('23f8f73e-210d-4995-84b1-ec5c520d38b8', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', '8262a153-e75f-4685-b7df-2398dff69d43', 15),
('64dd0d2b-a103-4aad-9496-ed7194bd2d1a', '8eb80784-dd54-400b-a477-69e9c1685287', 'fc2596c3-0dc4-4bf0-ac99-aebe184070bd', 6),
('1ad444f5-c5f7-4a40-88f2-ee3348a56259', 'a74e7a39-e352-4a48-8414-bcd2f89f31c5', 'b2361fc2-4484-492f-b62a-4372b7391a10', 6),
('1b5a8f08-074a-457b-a57e-ee7f9b5128d3', '8eb80784-dd54-400b-a477-69e9c1685287', '64140dce-ddd9-4b46-a385-e0b4c35e2374', 16),
('483d60f7-7b20-40e3-8414-eea6b602ae6c', '8eb80784-dd54-400b-a477-69e9c1685287', 'f918d709-7452-4945-b27d-2db06c7a8315', 15),
('6cf9f004-6c9d-4f02-943a-ef8da95f1f3d', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'c95ed783-d391-4c55-b046-1c71925157be', 6),
('dd6fc9b0-19a0-41b9-b6d8-f0446e0a8b77', 'f51627d4-449b-45ae-ada5-92a2f16b8794', '49f3f30a-9daf-450f-b6a6-8959e45c6d54', 5),
('4ca08d01-5d71-4bdf-b7ba-f1b0a2770683', 'dd88abba-061c-4363-8255-58a5e79bf0a1', '20361c79-a798-41d1-a9f6-f808e78ea4b2', 7),
('64527263-de7b-4ebb-8bf2-f4b785fd433f', 'dd88abba-061c-4363-8255-58a5e79bf0a1', 'bbcf0f8b-93b9-437a-a9f5-248899a774d3', 8),
('b083daf7-8fc4-4633-9be5-f4e9dc3e7bc1', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'f918d709-7452-4945-b27d-2db06c7a8315', 3),
('c8e48a1f-c35a-4f22-b617-f73dec270bda', '8c6d7c37-07a1-4578-91a8-6ebb0a09548b', 'c95ed783-d391-4c55-b046-1c71925157be', 16),
('a6052462-ec98-4edc-bf78-f7400b6e84a9', 'b169aa86-f12f-4689-ada1-92dd5c59e26a', '7544b2b9-2d87-4039-bf8a-2de11e35dc44', 2),
('66eba819-2855-4b21-8b32-f7a0370b9456', '0b7abd38-08a5-42a2-bd6f-1943e7dda836', 'bbcf0f8b-93b9-437a-a9f5-248899a774d3', 7),
('dd59d05a-de53-4ec2-8571-f7ab7486169d', 'bc92a979-3236-403b-a3ed-c7ac645051c5', 'dbc31c97-a63d-453c-ac2a-ca85dc432deb', 7),
('dea03ce6-9275-4783-87d5-f9256a2b88e7', 'bc92a979-3236-403b-a3ed-c7ac645051c5', '23e706a8-8c15-4464-9243-015730036121', 5),
('f077dc48-cc55-42f6-baf9-faec695bbdc6', '7523c9ed-86d8-4932-bc0c-5aea50b39319', 'c95ed783-d391-4c55-b046-1c71925157be', 10),
('54dbaaa0-27bf-4289-91ca-fb8662dc8c3f', 'f51627d4-449b-45ae-ada5-92a2f16b8794', '8df15dce-8267-430f-b1f5-b2103e51eb6a', 2);

-- --------------------------------------------------------

--
-- Table structure for table `education`
--

CREATE TABLE `education` (
  `id` uuid NOT NULL,
  `title` varchar(255) NOT NULL,
  `school` varchar(255) DEFAULT NULL,
  `startDate` varchar(255) DEFAULT NULL,
  `endDate` varchar(255) DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `order` int(11) NOT NULL DEFAULT 0,
  `createdAt` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tags`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `education`
--

INSERT INTO `education` (`id`, `title`, `school`, `startDate`, `endDate`, `date`, `description`, `order`, `createdAt`, `updatedAt`, `tags`) VALUES
('629811f5-5f8f-484d-9b1d-bd1dc4945a05', 'Baccalauréat en Science', 'Lycée Paul Sabatier', '2021-09', '2024-07', NULL, 'Specializing in physics - chemical and Mathematics. I was developping in paralel my skills in IT and infrastructure through personal projects and online courses.', 1, '2026-06-03 16:53:12.000000', '2026-06-05 09:06:16.000000', NULL),
('6c367130-ee60-4d71-81ff-ffcd2bd217b4', 'Bachelor en Informatique', 'Montpellier Ynov Campus - France', '2024-09', '2027-08', NULL, 'I learn the good practices I have been missing in my projects, and I am deepening my knowledge in infrastructure, networking, security and DevOps.', 0, '2026-06-03 16:53:12.000000', '2026-09-02 16:26:39.000000', '[]');

-- --------------------------------------------------------

--
-- Table structure for table `experiences`
--

CREATE TABLE `experiences` (
  `id` uuid NOT NULL,
  `title` varchar(255) NOT NULL,
  `company` varchar(255) NOT NULL,
  `companyUrl` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `startDate` varchar(255) DEFAULT NULL,
  `endDate` varchar(255) DEFAULT NULL,
  `imageId` uuid DEFAULT NULL,
  `order` int(11) NOT NULL DEFAULT 0,
  `createdAt` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tags`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `experiences`
--

INSERT INTO `experiences` (`id`, `title`, `company`, `companyUrl`, `location`, `description`, `startDate`, `endDate`, `imageId`, `order`, `createdAt`, `updatedAt`, `tags`) VALUES
('41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1', 'Assistant Administratif', 'SAD - France', NULL, 'Saint Georges D\'orques', NULL, '2025-06', '2025-09', NULL, 1, '2026-06-03 16:53:12.000000', '2026-06-26 13:30:42.000000', '[]'),
('00b2aafd-d82c-497e-b563-df4b0eb82b64', 'Developpeur full-stack - STAGE', 'NEEFT.fr - France', NULL, 'Full remote', NULL, '2025-11', '2026-04', NULL, 0, '2026-06-03 16:53:12.000000', '2026-08-16 19:01:36.000000', '[]');

-- --------------------------------------------------------

--
-- Table structure for table `experience_points`
--

CREATE TABLE `experience_points` (
  `id` uuid NOT NULL,
  `text` text NOT NULL,
  `order` int(11) NOT NULL DEFAULT 0,
  `skillIds` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`skillIds`)),
  `experienceId` uuid NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `experience_points`
--

INSERT INTO `experience_points` (`id`, `text`, `order`, `skillIds`, `experienceId`) VALUES
('101690cb-261f-487a-aa66-05fc006a7e79', 'Développement de plugins et refonte complète des logiciels métier', 0, '[\"fc2596c3-0dc4-4bf0-ac99-aebe184070bd\",\"6902e148-cd49-4eda-8f2f-b86aa4d0d4ea\",\"49f3f30a-9daf-450f-b6a6-8959e45c6d54\"]', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('447c01fd-d47b-46b8-8ee4-2e872b423469', 'Creation et consommation d\'API RESTFULL', 0, '[\"6902e148-cd49-4eda-8f2f-b86aa4d0d4ea\",\"49f3f30a-9daf-450f-b6a6-8959e45c6d54\"]', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('030ecb8a-947f-454b-8884-3ae0cb064f57', 'Support téléphonique et assistance utilisateur', 0, '[\"3ce98505-438e-4383-bc70-8eda7810d11a\",\"fc2596c3-0dc4-4bf0-ac99-aebe184070bd\"]', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('30485060-c997-41cd-814e-417c16adc73c', 'Gestion de la sécurité réseau et administration système Windows Server', 0, '[]', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('3c74b534-47d7-4a70-8a75-477de0b21607', 'Utilisation de Git pour le suivi du code et le travail en équipe', 0, '[\"49f3f30a-9daf-450f-b6a6-8959e45c6d54\",\"2ea576d5-44d3-42a8-b2c0-b1319942b64b\"]', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('5d0ddbd5-8673-4e48-86b3-5559233b9597', 'Comptabilité et suivi administratif', 0, '[\"2ea576d5-44d3-42a8-b2c0-b1319942b64b\",\"dbc31c97-a63d-453c-ac2a-ca85dc432deb\",\"fc2596c3-0dc4-4bf0-ac99-aebe184070bd\",\"49f3f30a-9daf-450f-b6a6-8959e45c6d54\"]', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('323ca604-1953-4ad9-ac1e-71d96cdd0ccf', 'Corrections de bugs et améliorations des performances sur certaines features', 0, '[\"b2361fc2-4484-492f-b62a-4372b7391a10\"]', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('0f4f9a30-0e3d-4c9c-9414-8753e3fd3b99', 'Mise en place d’un serveur sécurisé pour remplacer le prestataire de données.', 0, '[\"fc2596c3-0dc4-4bf0-ac99-aebe184070bd\"]', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('3a57593b-8651-4032-8fbe-bad64613c57b', 'Développement d\'interfaces responsive en HTML, CSS, Javascript, Vue.JS', 0, '[\"49f3f30a-9daf-450f-b6a6-8959e45c6d54\"]', '00b2aafd-d82c-497e-b563-df4b0eb82b64'),
('23c8a93e-8239-4f4f-b77b-d0bda67dc518', 'Gestion des tournées et remplacement collaborateur', 0, '[\"fc2596c3-0dc4-4bf0-ac99-aebe184070bd\",\"49f3f30a-9daf-450f-b6a6-8959e45c6d54\"]', '41c7fe1f-d9d8-4fe5-baaa-92fc2211a7c1'),
('280115e8-ec65-4c71-9c0c-ed960626797a', 'Collaboration et gestion de projet', 0, '[\"2ea576d5-44d3-42a8-b2c0-b1319942b64b\"]', '00b2aafd-d82c-497e-b563-df4b0eb82b64');

-- --------------------------------------------------------

--
-- Table structure for table `experience_skills`
--

CREATE TABLE `experience_skills` (
  `experiencesId` uuid NOT NULL,
  `skillsId` uuid NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `images`
--

CREATE TABLE `images` (
  `id` uuid NOT NULL,
  `mimeType` varchar(255) NOT NULL,
  `originalName` varchar(255) DEFAULT NULL,
  `size` int(11) NOT NULL DEFAULT 0,
  `createdAt` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `data` longblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `images`
--

INSERT INTO `images` (`id`, `mimeType`, `originalName`, `size`, `createdAt`, `data`) VALUES
('8b3fddc1-00ae-4bbe-b4e4-19466159b47a', 'image/jpeg', 'pd.jpg', 71244, '2026-06-26 10:12:49.556350', 0xffd8ffe000104a46494600010100000100010000ffe202184943435f50524f46494c450001010000020800000000043000006d6e74725247422058595a2007e00001000100000000000061637370000000000000000000000000000000000000000000000000000000010000f6d6000100000000d32d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000964657363000000f0000000647258595a00000154000000146758595a00000168000000146258595a0000017c0000001477747074000001900000001472545243000001a40000002867545243000001a40000002862545243000001a40000002863707274000001cc0000003c6d6c756300000000000000010000000c656e5553000000460000001c0044006900730070006c00610079002000500033002000470061006d0075007400200077006900740068002000730052004700420020005400720061006e0073006600650072000058595a2000000000000083df00003dbfffffffbb58595a200000000000004abf0000b13700000ab958595a2000000000000028380000110b0000c8b958595a20000000000000f6d6000100000000d32d706172610000000000040000000266660000f2a700000d59000013d000000a5b00000000000000006d6c756300000000000000010000000c656e5553000000200000001c0047006f006f0067006c006500200049006e0063002e00200032003000310036ffdb00430006040506050406060506070706080a100a0a09090a140e0f0c1017141818171416161a1d251f1a1b231c1616202c20232627292a29191f2d302d283025282928ffdb0043010707070a080a130a0a13281a161a2828282828282828282828282828282828282828282828282828282828282828282828282828282828282828282828282828ffc000110803d3035003012200021101031101ffc4001c0000010501010100000000000000000000020001030405060708ffc40049100001040103020503020306040405000b01000203110405213112410613225161073271148123425215336291a1b1244372c1345382d108162563734492f03554e13683b2f1f2ffc4001b01010003010101010000000000000000000001020304050607ffc4002a11010002020202020300020202030000000001020311123104210532132241065123331461344271ffda000c03010002110311003f00f4f77648709d25c2b124914c84914924915249249083393351248b19c851390a124533b94e922b07ec99249162492490933926a74915249249024ce4413774009c774492100ee925dd245a49249228a91482649083942ee123d93d5808b05a9dc693d5270823ea3d92b2794e794c81249248124924812492481c21724e4c812492481276a64903b926a64903b926a649012672649024924c503a49827409249240921dd24c5038e024ee5304e812492481c28f2a38e4c670985b46ea46f34a1ceda070abd96764c76e5fc46d6bf1c186da5db0af6567428de34b7e1ee2bd567b9516581d7083477e0f65a1831be3ce10b88e87ee6bb2e5bf6e88e92eaae779b8cde937d1c8eca8c192c2c25c439e0f4ad89de65cdcb008f2a18ba7a8ae6b12195d08e96005c4b8577dd4d50d2c8fe3e9b2baa8c6e0a869e24c8d439a0ca256968cd76469596656fa9cfa0b1f45c88e0cfca6b8db81a2ad28a76e875793a8750141adab5e57e2789d1e4464ee1d66d7a0ebb922286121f6d79fb7dd703e2b94493c61a76df6f65e9fc4539f9156f4fd715a5cc4a4071f75565360ab191b3c8559ebf4e99f510f96b4fb995751b9487951b973d9108cf2927726545a4ed523546d52356b4ed458069aa48cd8509fb54d17dabb2acac07fdea395487951b9677ed350034423c965e2b901e07e54c5bd70b9bf0b9b246e1bd59e385b9e0f80cdaaed54cf51b584770d2b6fc13951c3abcc2404f54440a5f2df2def14bd1f13b7778cf9cbdc2321d138f5103b2b5878c27f12e0c9d5eb3c0597a64cf664d80e0d2d5b3a5c9e5eab8329bfbeb75f1d1f67a2e87c520b35ad165144365f2f75cf78b2427559232e0074f01753e328dc34b66433eec7ca6cbfeab86f19ce25d725747f690d03f75b5fa529dbaaf0b9ea8a06b7601a77f758b9509193aa43863d78e7cd1f20f2b5f4269c5860eae036d43a001979fad4cd6d020b6ff65145195a4e5fea35d8268f733c2633f1b2a1e1dc938d959b0bbf9a470567c1b4ed76361165ae75058f971bb1f50c835d24caedbf74969fe9daea54ef093013403abfd56278b481a862c4d36042dff6569d2993c08f2f36464342aba930646af0bdff00698c7fb258ab9785c1b96fb354fe3dd755e21df1b1dcd3ff00286cb9cc8c5bc9c96dd08dd7fb2dfd401caf23a4d86c402ca3fabef4f5a49324badcc72992490249249024924903390a34ce40292492124924922b049249c22c4d4ee43dd2409249242492492454ce49a9d33903a6724d49c8187748725324811e532749083249ca64589384827ba40c98725393699009e5322721409249240924924093393a4819a939272640924e3ba1ee81d3b532481dc9353248093393248124926281d24c12281d24c13a0492629040e85dd9155a622902ec88f0a33d910e103a70992424bb955f3c96b6c715bab2d16506a05acd3c35cd03cc758256593d42d48db99d422de391b7fb2b5a513066b9f35fdb62fdd6764e409732a3fb22d881dd586e7fe9b362739a6425b401ecb8ed67471f4d1b73b42ca77fcc95fd27f72a6d52387171e0fd3ffe553ff202a72663a4d0e5f4794d6ca094dab4825d2722485f6f747b7f92d6277a5657f417b62d13aba4383c976eb966b58dd4f2256308748ba5f0e44e3e14c22efb830db9666235b365ce633d4c85a493f2acb5237ea10ea6ef374e81bb0959dcae37c4c4374ef3080647483a5c3d97459fa93198adeb65927672e275a99cec60c27d25e5c02fa1ff001fc3cbc887ad9b0c78fe0da67b961cf763e7755653415890f538fc28241457e817eb4f8398feabd6d682aca27f29d9f6ae7b10070a0a31dd13b928470b19ed61354ac51354ac5b5149ed30e0a9e1feed40d5330d6deebb69d32b01fdd467ed2a59451509e4acb226a00ac43f69fc2ae54b09adbdd653d368e99cf1d1b7b1a57fc3a7a75b8fe5a77f655325bfc693f2aff87e32ec82f6f2d6daf97f94aeb1cbd0f19d5feb847970c277ebb1d4ba1c471e9c42cdfa2668bfdd7199d3b5b91837c1e575da6b0bb0b25bdd92b1c17c4e58e36dbd5af4ef3c4ad32785b5060fbda0b87edbaf34d5a29259b0a53ff3d8c257a86a3d3278772e52eea0f840af9e179f6a92361ced3311debe88c007dbe16bcb75675edd2e65e9f8824ab223ff00b29bc2d088b449b21c29d335cf516b8c0fc78c3892de8ec8ff0054cc5f0a4f3b1e09109601f957afa57fac0f0447e6eb2666b6ba1c4dfeeaaf89e26b35095c7932157740924d372c748f4be26b9c3f2833d8337c47142ca7366dc3cff29559b2f3fc478f281e1b74520b6093aa93e2640c8c8c3798bd321e90d41ad93060e6e3077ae37f48aeeade9b86d8b57d118d71a0039d7eea2132cfccc20357d4a1e9e9fe1d80abc3387b18ddfa8340d96c32176478975375d83d402c1d1203365c4c88f53593d3c7b6ea968561ed49272982ea624927490326722285c819a8902480d3390a481249248124924815d25d4924815da498a36a066a7724e4374812495da484924926722a74ce4292049249204924520841245248a2c64924e1032498729d03840794499c80524924092492409339272640924924092493140e92609140e92609d024924c503a11ca49c2064909e53b503a4924812709919e103271dd324818f29939169aa90483843dca14ae9241b46fc58eeb13c41aa3260dd38b4b2468eb0e0b62ef65cbebb88c7ebb1cb27f79e5d35659ba6b8c3a4b4fe81fd58cf0f7bafaddc151ca19374b83ba8b0d7eead37327971d8c73d8e743b067b2a3a63e4ca766c93b437a0ec02e08edb2f664ccff00e5e9e371a739c00516182ed0b3fac001adab2abe759d1dae009065a34acc07a744d44387430802cae8a227a5dc5d47f49e18c2c78a9dd6c3d4e1d82ab8cf8f4cf0b6ab94da73e51d02fdcaa0d85d062623446f25cca15f3dd69f8d62189e093101545b6b5a76d7046f2561e752e549237aa471eb000a5999c4b98d2e364ab0fbe82d1dcaa79f281211dc0a5f63fe398ff79b3bff00c972f1c15a47fb509c86ee5517bcbdc4f653c8e06fab9503aab65f4f92dedf0e1ab4ce3b5228f8285ea8223ca629cf292ca3b0ed523507646d5bd14b268d4ace544c5247caeca74cac79540ee42b2f559fcaadd3067728e1fbd46514469e1734f6d2a8b35a1933eff9b7526859071f5300341f35bd22d2cf1618e545dd88fbc1b695e0fc9629c959887678d7e32e875aeb70c622ba98780bb5d3cb9f92de8dbadad2e6ae09f93266c10bcfa88e4fe1771a23dd33b18b7d2f7b36fd97c37974e31a97af8e7955dd66ea108f0d4af6f00f4167b95c0e54afc9ccc7c8736bd41a3f0b6751c893fb2e1c1e9a8e290b9cef72550d3b1ce56a5850756c64bfd973d2deb4bc574eaf5c708f4d6380bf4d1ff25cb999f3e0fe9fa7d1d4176be218bab4f85807a5a6895c444e6549d1f6b645d73f5671db5357021d4f1a61b838fd349b4a8dd26bd80e23a5fe51710abf8be531e5e0106bf86168c2461e7692e23d4f89cdbfcace12c7f17c4fc6d7f2ddd25d8f286bc52d1d2e5ebd7f4fe9ae9f2f6f7e14de336492ea4fc78f97625ff92caf094924d9d83e77dcd6f428feadfc5cd2a473b5fcf0e340756eb0f40ce660bdcc02c4b3bbd5fbad29246e3ea3a8b9bf736dbfe6b230f1cb25c668008f32cdaadd587b714c9d22ba989924924093393a6720609bba76a77201493146d40290e1139335026a77274900276a7721404e42924815d240da499c819c99244d424292272145492493840c922770109408a4120921049149228b19249240924e101e503b90a492049249c2017264ee42501353a63c2640ddd13526a7424907728d01e51583a629048a2c64e1327081d314e98a064ce4e507740e9da992407741334d8429da80d24c13a0498a74900a49ca4103248908e5242e08fcac5f104523b27125887a98e216d591b8506744c9312473b620583ecb2bfd56acea58f9519c6679b2639648eee3bacf8a52f748d887403f775775a7aabf225d19af85fd6f03d2b3f4ec5cd9f1cbf219d321ee05ae7ae2b4cedb735d701fd931b616f4863ba893c1543c4533dda33600ea9326468dbd81b547364c982430b8e43c0dfa48a0b3b44cd9b54f12b71e6731b1e3b6c33b8256bc260fc90e8f33264ebc38e270644d735bd3eff2ae7d4127ff00959ff320412c0db6fa45b4d8a43e3e793e158ec57f102be1fb3a3c4b7fcb5799fdb27e2d6364c9d4f2b5f20d757c0b58537dc4fbafbbf80c7c71cca3fc9b26f2571ffa42f376a2ab08de81dc2f6acf979e8d7d946e4e12770aaa42177289a8644ec59d5691291aa352356d4ed4491f254b1f2a16f2a667de175519d86fe5412a9a5e540f4b950a6ba20a4539174b0b343e57af16fe553681b83c2bcf3fc078f854470bcef2eae8c73a69f87e58d91490bcd49d56d5dd7871a67c56960f5e3bfd3f2179ac2ee895ae1c8217a478532591413b47f7af6978ff0025f09f2b8b8db6f63c7b6eadad561e9c695cc92a17381e94fe10883f5f797ec236d80a0c2c9fd5e9ec738592ea57bc1f1bbfb6b268ec06e17938e372dadea1d3eb4d0fd36407ed6af339247412640f63d617a86a0deac69587ed2d2bcbfc4b1f950c4e1cbda6371f65db68fd5856ded7bc42f191958523f8744d2b4b52976d19e1d4dbe91fe6b0f55983b4dd19d1ef208bcb73bf0af62bc6a595a463936d81dd6e3f2b3af6bdba6e788b25b8faec8e782e0dc7e8dbbae77c3d98d835884bda5a03ae8ad9f1c3258f508c46d21d90e6f55770b335c862c0ca8d8640eb6ec3d94cd7da2b651d4727ccccc837d22596efe2d694f84efd5e3c51fa039a0dfbac4c40dc9d4a18c70e780bad91cc97c59d0dfb31d819fbd28ad56e4f442992292d98924924819c851a672014924ce40e9da85a9d01a485a9ca074ce407946d4029273ca6409249240924924249249245493393a6720144d4c13bb8081d0774924092492420922914c8b1249248124924819c851390a049249206726449c2016a74ce4c80924cd49c84939355a4922a55498a45321049270987251624912628193393a48053b527264049266a7409249240e122992409249240e1229933902726201041160a4955a08c31ad6f486eca58c00361484b513452067c60825c01fc8b5464d3317cff003d98ec12d6ef68a2b41249106262b1a4b9cdea7958df50d83ff9759f1305d1c7cae7bea10bf0e0ff00f204a76ecf07feeabcab2496e34c7b1002c2979a5bda9bab1ba3dcae7e4e7f0bf40f89af1f1e187cfe4e7e56bfd4223ca1770517642efb97a53d3e7e51264ee4cefb5668846ee51350236aceab49d1b50236ada8a268d484d38208d4bd97653a6763936a17a91c81dc2ad9087b949291202c2c2cd23a4ecdd847b85406e3f0695f88dd054656f4bdc3d8ae2f32ada9d1d9665681dcaee34ac47b32319b19a2e6ee5708d34e07bf65d0b3265825c59db27ac80005f1df2d5f6f5bc7fabb2d2e48dbe744d35e5bcf52e9fc258ce6e6653dc6faaa9717a046f972b2a370b739bd5fbaf48f0dc71b34c85ec152387aff002be7e95d59d393a5ecd03c975f60570daa69326a785e5405ad787f27b2ef327d6c23b77581862b22668e3a975c74c5c6ea3a6cda6e8f8d1e48f5b1e5b7eeba9f0968afc3804f3b6e570b6fc05b79d810ea50c4dc86d861b1f95758d0c000ec287e1578fb4cdb6e7fc418b34be23d2a73bc6d692e5cdf8be0c97492644f092f90f4c54bd11d5dc5a83231a3c90d6cfea683607cab71444e9e6ba1e8d9b1654597911f970447a9ce3d974de1c819931cfa9beef2257169f70365d1e463c5345d0e8eda7ee07829dad6b1ad600de868a0070122a9e4da4924915249249024cee13a672088226a4e4280d24cd4e8124d4ae92bb40bba67274e100047d909e517640c924920485fc224ce408709d0b4d272e40e92606d22849d3391040e454c9c774c9c7740dfcc9ddca6ee91420c9c729924584ee50a488f0100a492481249270805c8510e53a00491a6720072644920149126720129912480524e5320492492049249204926724d40e99c9d24005101693926a07aa49249024924903848a649038407944955a011c846535524812492481245249130269aa5cff8f8df87c0ff00ee05be39585e3700e8acbffcd56af70ebf07fee87916aeeddadf62b164fbcad8d7406e6748fe90563c9f72fd1bc1af1c15799f2b939795783379513fee52b79513fee2baa5e5ca27f2851390acac98e8ce49a93b842156091a36a16a93b2daaa246299aa06a9635d74e99c9390bb82a49146ee14588ed1148277265cf668962ecab4ede999e3e6d4d1f2a3cc17235dfd4d5cbe4d7f56b5407b1f65ad1b1d2c382dfea750ff0035925743e1fe995d89ff00da7eebe4be56355897a3e33a7d23af0f2a7906ee8dc091ee3baf4bd258d6e3b8c5bc2fa7b3e2d79b69c5d266e535dcbc90d5dff852573f4c31bfee85dd0be5eb6ff91e85bead59365898d1f467641f772db71eeb1afa734fc9a5d8c5ad171fb237206f61f08919cf648fb205237853090390b91b90395869b8d14dd492672a07bb4ed42d44d40492499c81390393a4819a9d24ed40d5699c294899c82229d9ca722d20290228bb2649024924903390a222d3814d4023ba63ca2724d408709d24903840e449201ba4aed31e532127492091456092299384588245248a0649249024924903390a34ce402924920492492067264499c819249240c53231dd09e50324924812499c9903b932492076a4e4c9da81aad2e94ee49a8134527492409249240924924092ba49240aed24933903a480a7ec80924cd4f7481fb1587e3721ba2309feb0b71a6cd2e67ea0495a231b75eb0b4c51bbc43a7c49e37dbca3c40e2fd49e7b74858e7957f52775e43dd77bd2ce1cafd2b046b1561e1f977e79ad71281dca95dc285ddd692e64679091e523c848f2b0920cee13313bb84a3485a52353a7ec996d551237852c5d9443b29635d15672393ee412229146e569e88ed1b90f7089c99613dae269a7fec9b2c5c71bbd8d24dfb91e433ab149fe936b1cb1bacb4aca93eaa8f0b47c3b31664987f9e476cb33b94ec73a29a2958ee931383ff60be5fcfc5cf1cbd0f1edee1e85965d88e12c7f747b95def8732e39402c77fe2230ee9f672e1647b32a212b6aa58bcc04fcad6f05b9d164e355d0b5f1b7aeaef4bf8f442039a08fdd63658e9cab5b3643482b2351da56fc95d91d30b76bd8e7a9b6a66aad0ba801f2ac17708848d49c99ae1dd279046c819c86e92423941aae428d240a3e4a3409da808213ca772140924924092ba493390134da20a20a46a063ca644e4374816fd92dfba70e489b40c92492049c0b4c920727b264ae92bb40ce42a4081c819244d49c804a412490248a4921264e124915249248a104532499c8b1d24cd4e819c851a672014924e100b9322ee92066a74ce4c81dc99249024aad24e3ba06aa4c523ca64093393a48052ab4ee49a81aa924ee49a81924499c81353a66a740924ce4c8092429207724d4c9da81d3393a4805244507740e794924ed530130d15c6fd4a93a34e60f9057647b05e7df52e6eab8ff00a5b6bb7e3e9cf3d6adb14eab32f36c877539c7e5551c953c8abbf95fa35635110f02f3b9931e544ee4a9146eeea96501dd2724532ce4833926729d250b4a5ec9042384c0d15a56ca24068ab0d3615760ee889a75adeaacf49d44f5303d4cb509fb95e7a563b0393239102c2ddae4a50deb81e3e146deea6877701eeab6e9a55983ed6fc6c89c016d1e384eee5c3d8a15e07931dc3b314e9db7855ffacd1e089a69f0bcc77f0b634cc8769fe2185939fe1f047fdd62f805ed8b132cbdbd40db96d4d1b269d99005b4b2e97c37951ac932f5b1cee1e9914bd710f6edf859da9b4996223dd2f0d4a66d318f73facf63ec3d93ea64ff000c8eee56c76dc32b769f1c12f3d5c12af1681b37855b15ade7bab609baecb58e94016a1aa5238584cd1410014c05a272641a89da993b5012490427940499c8524092492ba40ce4289c6d26a0144d4e92049276a772014ce4e988b4029220d4fd2819a9ec0e52aa4ce40cf208d93f60935272021c1409da9d03353a6721ba408f290420d9441092492491524924902299394c841249248b19c9353a48126727283ba049c264902ee924920499c9d3390324924812629d3140c924920499c93932049da993b503a4924819c993b92081ae92bb4ddd3a076a4e49a939026a7ab43749c390222926a44da64049214901151934a43f6a8dc815da91a80709d0de8645d05e47f50325cfd6b3587865357aeb477f65e23e2d9bccd673cfff007297adf0b5e5e4c4ff00a69be18e65ccbb801447ba9643c051b8585fa04f6f02407ed518eea5076a41dd656ed08ca644e51b8d2cade8883b8d04cd7d05193652ab55e5b5b494c89337285ad52b052d28246291c2da85aa568b0baaacac78cfa3a5467ee53014d511e4abcf4406440a472072e7b2c60a680f4907d942148ddc52a769559c74cf2b7dcdaaef2434d2b99cdac80efea6aaaee0fe1789e557532ecc2dcd30b8624658e702451e95dbe9bd13e9987e61f4b6dae2b8bd2803040d3c74aec3440d9b0dac1c34af87f33fec97ad8fa875be11958c8a6823361a76577387a37e43960f865ffa5d4e68c712834ba2cc6ffc38279345658fa56fdacc06dad56daa9621d80571bcade194f6726910361324a526ee81ca42a3720d34e0d26aa49015da4e4292076a7721490249249024924903b53b93353b900a492481276a4d4eee103a48588903390d5a272140ba52e9492ba40aa924aed242494645946e428a980a4e924812492481148245321072992491633784e9248124924819c851390a0492492067264499c8193b526a740ce4251390940c92709d00a484f29da8139327726409249240ed4e85240ee4c926281d2429202490a480aad2aa4c13a0492498a074c784d7495da04c3411747521461dd2813764e9c6e9140bb1fc2f06f11c9d7abe51f7793feabdda7774634cef6615f3feb2eebd4673eef2be8bfc7e9bc932a67b6b0e99d272a37f0a4720770bec9e3d91842f4fdd0f72a96540e51b9487ba00b0baf1d040b5206a4d1651d5051524cd6eea4028204ed5b55448de54ad34a21c2999c2e9a7489e844d841dd19e0a16f7579e9983b951b948f3481c6d73d9ac7416f2a68f9a5105234d2aa51e6eec89df34a9dd38fb1e568658eac527fa7759ef20137dd78fe747b75629d3734e91ac931fa5d62b70babd1a73198c385b1eeafdd79ee2db72e223dd76b8ee7371e01f36be23e469c2fb7af82db87a26162b32f1a09a3da4c7790f5af98d0d6104d8587e1a940cc9a26c9e991a1d5f2b733b685bb55ae4c36f49bf67c3ae914ae054313ed6ababa2194f6309d0351052801e533939e533906a390a49204924921249249c0b4560d7495da6277a45d91632492481da890b51206287f992938099a849d24ce49a8a9d24ce49a841d33927214589249135026a4e4e99c80524924249249245609229248b1048a49140c95d2492017bb84e06d699fd93b503a67274ce402924920499c9d339032492481249248124924812629d3140c92495d20673fb2126c23e9bdd2aa40cdfb53a499c81cf084709c2128082129fb24805384e98a07490a2ec818a413a4812629d3140c9c264e1023c26068224aad038780374fd41dc202d443d214c12afaabfcbd2731fed115f3f64bfae47bbdcaf71f18e4fe93c339afee5b4bc29fc6fc9dd7d77f8f63d566ce2f2edaf48944f533944ee57d23cf4650b91142e59cf605dc140cee8ddc140ceeb3b2f1d0c203ca2492bd125d91b5376496b551237bab317daab345a9318f21745513d267f081bc237a61c1579668a4e545dd1c9ca02b9addb58e84d16881de930341381dd244928eac791bee1663c5b41f75ad16e2be0ac903a5847caf3bcda6fdba71353c3b0332f3d91c8ea0c6177e5750c2d38709e3a9fb05cbf86dce1aa4a195d4d849dd75b9b1b70f1f1a115d7d21e6be57c2fc97ed7d3d6c3d3731f28636a38f30d834004fc2edb29dd7881c0f535df69f85c16344f931e37f776d7ecba9d2652fc138a7730f257938e753a745fa69e2ed100ae338547168c6c23bab817655cd6ed2b53dd28da895d0726d324920d149249024ce4e920108c264902ee9249204924920492499c813926a149013930ee99240bba49248124987253a026a2085a88201ba280bb744e34800ded03dda7090490249229903a499240e926490394c924819c9353a67204e4c1324817749229fb2064ce4e92014915d2106ca055695523ec85c804a644920149394c81249267207493353a0499c9d240290449140238493774e8124926281d24c12281d3b50270809c99314c81ca405a64ae90155276a106d22808f64e78099a8872a62744fa727f52a4f2fc32e1eef0bc6dfc95eb7f559fd1a242dfea7d2f2379b2beebe069af176f33cbb6f223eea379a46eeea372f5e5cc126d0b92ee9cfdc1567a00ee0a08fba27fdc856165a3a127085a8825491351016502261a2b6aa8907a5c99c4b5e1c135d944e16c2b68e84c1e1e2fba72682830b76b87b291e77a578b7a53fa89fea29da28255652277a594f6b99c937ba2084f2a26742c4068dace99a44f2347636af45b9a5066b6f20d1a2fe170799f5996d8fb84da58f2b1326775b3abd008f95b3861d405971e91b9f85839f3b9b84cc78c6fd40dae8f1dae69eaff000007f2be0fce8dde65ece1fabadd2486e991cd27da0d15b5a647e5e4e4169d9f1920ae3303267874d971d80481c6cb4fb2eb7c2ee64f1b9cc2486c7447607d979531ab3a63a6fe9f43162176695c0a9619eac58cd74d58a57635d54735fb483848a7ec92d15222ca5549248345249240924933903a48113503a499c8501a6721490244d4292034ce49a93900a4924815d2026ca92ad2aa2921319dd15527081cab00933926a75600509ec8bba11ca07ec92495d20492626d0a02724d437495da0349024809c8533930348246a4e4d761320445a4e140257499c6d032574924817525d49271dd03176c99aed933d3339412036939324812629d24029224c502098729248124924812492481267274ce40c92492049249206299394c812492481249c2740c130e51262819249240e11379bf64089bf77ec50979ff00d5e9ab1f061feab72f2e7fdc7e177bf55323ccd4f1e3fe88d702ee57e85f135e1e343c8cff00f6487b951b94a546e5e84f4c8091ec84f290e56605ff0072028dff00728ddcac6cb47436a751b795276535244784ed4dd93b56d5506ce548c009a2a26f2a569a5b474062223eaa4e4979b09a41bda6672a41b8003e50a277286e952c1211f722bb4ce5491247f7041987f8b0b8f1c14cc34f08f38ffc2877f4b82e5f2237496d8fb536d3f28177f348085d660496e7026838ae4a163df9f8fd3fcafb2ba563c3f2587b97ecbe13e4abfb4bd8c36f4dc0034bdd11f5014ba6f08ccdc60dc711d9941b72e722e88f22564aeab1b2b5a46598b2638ddcdfa4af12ceaaf4efb0837ca2d1cb5d4aeb4ec02cfc0943d8e78d8dd1f95a510ba2bb71fd5cb3d888ba4aa9ca527b213c2ba11934e424db9338d1481b41aa92499c81390a4920489a8513503a67274ce40292492049226a4e4029245209212495d202e5580689aa361b44ac09c85248a049ee90a76f740f76a33ca31c28ddca0907080f29764c81249267204e4253a4805138d00926281ba93b5c992ab40576921aa520e100a49dc9903b52726ba4c4da07ba4aed10e101e5009e6917029202d3f45a060693dda622b6482045209d08e4a024c53a62819384c92072992490249249024924903393277264092492409314e920609d31482074c5229040c926ba29eed024924902489a04f1f2928b31fe561e43fb88cffb2be3af2b44226751b78c78d325b93af653987a9ad340ae65dcabd9afeb9a42792e2551772bf48f17f5c510f1ef3bb4c84f083b227265a4f6a01c987291e52ba55b100939518fb913cda66ac6561b53a14ed568e891f6492ec9dab5aa836231ca03c2769a2ba2a894956e08cb5278aa29872b4564ce14142e524868a8ab7b5cf7ed35209d31482aca44dbbd94d3303b0e4e7617b283b856402e8240de4858e5fa4b5a2ae2810e1cb96e696caef4b41ff7575b23d8313faec38a875275e361c0df8255fc401fa9b03da5cc680282f84f3bb97b383a875995134e2b329801ea039f74b118c664b6795a6f641a5bdf95a7b9a4b5d1b242d17d95889d6d747b9311ba5e0dbb975bb9d359e5e3503e613bb8fb2d2656d5c52e4b072f23027c76cd2d33247d9f0baa69240edec174e2b7a617ed3024709ac93ba4384cf3416ccc0f43749aeca741b099c9353a004913926a014f7489339020e49c6d0a26a01491390a049249204520924502ba420d94f561308e85a020926fb6d3076c808a64aed2409249240e0d20237b44507740e13774ce49a81d249240ce4d7453b909409cedd206d32481ca4111e1320492498a0749304e3940c520939f669034d9280ca13d9104e81d95dd4a2ab651353a0770b5191451a6720102d10149353a067264ee4c812629d24029224903048a749001ec8bb24532067264ee4c8124924818a413a4818a64e5320492672640499c992408729ddca6494c04b4344c0c6d5a7970b2dbd51cb1b9b7fd27dd5068bd9616b5e236f87b59d3482f01eeb739bd85eeb4c74b5fe9dc13afebcafc6be1fcaf0d6bf93a7e58f4b5dd513ffa9beeb9d7af7afae5a63756f0fe0ebb860bcc40755725a7716bc1de7dbf3f85f67f15e67e6c31fee1e667c7c2db8fea34921c942f5ea45b6c242794c9c21729b74ac01e851774ce592c4d4485a89091b549d945d91b56d5506784923c24ba2a2563fd148d9b0b50354ccbad9599ca29adced9465d4e1d4ac484003dd42f6970ea0b2b2d509209d931ec86c03f289a6d632bc081a0acc04102d555620e5567a5a14325cefd5bdcf34633b7e1743a64dd1257403e60077fc2c1ce61134a072edd743e1b77562574fad809eaf75f19f2d4e17dbd4f1adb8741e1f2061cd19aa749d95bc281f0eb2f80bac3fb7c2e6f0e47c587e60345d2d95dc3ba64d4b11d1b777c608fcaf9ac91a977c74ddc58d92b18e9216b9f09a04f65b5112580959783e9690453ae8ad366cdb5be2e985fb1b944459477680f2b654d549da8bb2483482499240e89a98f09da81d24ce4280ca67261dd37740924938ee810ee98f29dbc263ca064e1327080982c94ef3b52048a011dd01356a502d46f752010ed9317272dea4fd14103836124c052740933927264092ba4c5320726d36fd924e1036fdd31ec98f29203ec993f64c81249270819244920609c77492f8f740ed1613f4a1b2d20046493ca0002894ede13a67204e4c924103b52722ec9903353a672640ee4c92481044ee0266a4e409a9d3353a067264ddd3a06299124805242794901267264902492490314c8908e5033932772640924ed49c805c851390d5a90edfb87b72bcabea8e497f88638d848f2982abe57abc6d05d4578878a32bf5de25cb90f01fd3fe4bd8f87c517c9332e7cf6988d43d93e9fe40d63e9b4accb7f51607425ae17b2f0acfd232f1f509e06e24e4b1e430363bb1f0bd93e94f50f056a05868196f8b5b83c5f8fa745faacc862820805193a2dce3f0b963cdb7859ad148db7b628cb58dbe719e2742ee891af6bfb878a215672dcf19eb4df10788f3350642d85923bd2d1edee561b97d6f8597264a45ed1adbcdcd4889d4190bf8440d1b42e1e63ad774db6c348dc9949c6c81cab241351216a36f2a21610e13a146d5b5594887089a84270b68e9123dfb2312b40a72102e90cb1f552d211072eb3b2761a2800e9081c6c859cf6b0a66b7ac91ca888a289dca4d595924d46c34eb428982caaa627521d4379987ddb4b4340c86c5336375d3d846ca9675ba06b87bd20c092b22363b6adafd97ccfcd62dfb7a3e2d9d5f90e6787e19c805a25a77c6eba8f31c71daf8985ce8435e1c3b05ca4465762c98ee77a1d45a3e6f95d760650303e267787a4af8dcd1af4f4eaeab4f22484482cf500eb3f2afb7d4c0b1bc3ee2ed3d9d5f70dbf65acdecb6c3d32bf63aa4ed4e13d5ad999263d91d5042ee38b41a29249c2073c264924091350a4824081c99240924cdee9d0248a45320492498f081d11e0266f09c7740285c2dc8cf299038141222d3223c20102909e51a03ca017264ee4c8128cf2a4ab4e1a8236a74e451427b2074cebec887080f281591ca769b4c92024933394450209d0a7081d08e5155a5d28133944980a4405a064ce46e69ec87a4f74029045d2974a07ec992aa4ac0e524ec908fb91753533a46b42aa62a2fe54c3851899b7c81f24d2ab95ad69f8fb3f2a3b1c81b9b4da78af2672c71e25d28f394d1ffa5473789b4965d6503f86a1c5b77495dae49fe2dc7f3408f1b2a58efef0282bacf13e2968ea87218df96da1c5d024b1e2f11e9afbeac92c6ff898ae41a9e1e40fe064c4f1ed7bff00929838ae271dd0b5ed22dbfe69eed4aa63ca64e532067264499c8192492409249240c5327298df640922837bdd3a06ee9d249242ba6bbf0bc073a4eacecb23974cfaff0035eebab4be4e9b3c9fd2c3fecbc0667074b23cff00338b97d3fc163dd6f2e3f26f116887b0685e2083c3de0ac7675465dd25ce69fea5e5de24f1064eb998e96734cfe563780a9e5eaf99361fe8a491aec4e7cb0da37f959f767fdc7b2dbc6f8988bce4c9dad93c8dd7505ca03dd11504848b22b6df75eaded5c75fff001c94fda47560220282d0c7d07539f0599b8b8cd9a0905b431f67fc9517b5cc7963daf63c72d7ec47ecb97c7f90c796dc7fad3261e31b44e51b94ee1615770a2bb66771b61c7449dbca146d53544f4907089a847089ab7ab33a498f646d5a42246c528e146d520e16f55651cad738fa547d0473cab0e240b0a007a9d6e59dfb4d4dd2808a2a573c5d0404dace5621c27068a60915548e701f8ceb54e23590c6f16763ecaeb47544f6fb8a5571e3ff008868aba5e2fcafd5d9e2f6eb345709246b5e7aba7bae83449fab529e269a68695cd78765eb33fa771b05a1a7c8fc792796f722a97c166fb4bd9c6f40d09a5ac958f36f1ea6ada8892ddd731a3e63dcfc378fb9ede92baa8dbd0daee14e06797b1339449920ba191ee93f526299068a66f088226a063c2644e349abba0649249013539e10245021c2490490229048a640ddca0268a371206ca1f53904c1db27ead8a85ad3dd3d520900dad0f7429203ba445db28da9cf0502bb299c9982d3b8f6402520987292024ae90a481c9b4c9245024ce43dd3a049da99314069260693dda0709d3041339ac612e200f944f6913b562e5eb98f09e96c72caefe962cecaf1067823f4f811c40f7924ff00b24ad15759d41bc9a40721a2f7b5c3646afabca08134517e05d2c9cccdd51b57a8bbe4b452aad157a24dab410db65247bd2a8ef1160b1a48738d2f387e6ccc6dfeadf249cefdd67e56a19045c85b5ec3956e29e3587a3bfc5d0f510c61f6dd30f1548766c71d2f2bfd7c87861af709c4d9937f77239ad4fc76222af507f8a65683e63230df7f640dd7f2678bab15d1907baf302ec9ddb24ce70f6534334f1b3a58d751ed749c256e31fc7a2e4ebbaa331dcf83f4cee91c1f75cd6778a3c4223ea68c561bbaf74f87a945890b58e6991a45b8937fb2bb016e6c8d9ff461d1b4d8b3491525972ebfae65c6dbc463c11ea2c755a063b5070bfd3b223dc2dd973b1438976348cbecd36a1fed3d3490d717b49fea578e2af1963b9b9af045460f6b5133175026e48e223e0d2df7cd0bbfbbb2dfea0a8e4e4016db23dad4ee088566c590d161af6387b1b5620cece819d27d4dbb5426d4a489d5e66c823d5bcc79ea2ffcf650b4c347235991b1ff00158d03bf50b58b26a11493192091d1bffc3b52b72ea0c70f51611f2819918cfa0238ca8d2ba6a693e28d4e0735afc864d1fb3c72bb3d33c4f85925b1cb288653fca4d05e7a191bcd470b7f65235c22203a1d824d5131b7ad32563c5b5cd70f706d1b483c2f271abc98c7aa073db5fe41588fc699b051786bc7771e553528e2f5208472b93d13c71a66696c33bce2ce7facd03f85d535c0b439a6da78377690a4c09c992ea4aed4a09314e98a064923d923ca0492499c81393049313414c0c9f1649e57877507fb445786bcd0057b2fd409bcaf0c4edffcc21abc6720f486afb2ff001eaffc332f3bc9fb2ac86de51345a8a3ddc4a949e96daf62675b600949dda15730c9912458b8f6669a46b1b5ee4a90fa893747dd7a27d1ed01a720ebf9b087c2db6e2b4f73ddcbc6f92f26b8a93fedd7e363f7b76987a60c5c7c78a0c60cf2230cbf90372a96a5e1b835773a4cbc18e475579911a7aeb6485cf82dae1d4e3c0eff002a67426385ad85ae321fe46f257c3c64b56dcebdbd3b444c7b787f89bc199ba60764e34667c33b92d365bf95c64956bda7c75e26c2d35b91839333e4cd2de910c7dbfea5e2cf3766aac9343b2faef8af27366aeb2bcef231569ee02a4628d48d34bddab86c99a84f2809b44d16b6aa8746dec95ed493795bd513d245231467852b3ed0b7aa9267f0a070b214efe145dd52c9aa3aa71491b94639584f6b9d26f09270a04d01adbdd0624644b90f7368336053c3b3c153ce4b1ae68fe73d4bc6f968d6275f8ddaee8191e4ea018efb5ed2b7b1714c4d735fd5d7212e17c52e4e190c13f9e4d742ee7cc395060cad77a1f1db57c2f935e32f631b5bc3cc324425fe689d4bb6007a48eedb2b8ff0fb4c6d7126c0e5753a73cbf1c0736a8d02b9f0f6665909d24e0d6ebae1819311610c8ebdd3b4d8561a6d6d9b440524d4e802ac94f548933900a492481203ca329900a31c24124092295d2026ca0770b099ad4c899ca04e1450a95dca07200726455699c2903243ba498a026f084f29bafb2576812491ec9fba064939e10834103a495da4819c993b891c26b714093b459af74873f28d869c10956ce8dccc791cc34e68ea0a3d37286561c535d878a3f956f2c8304b7c7495c463f8859a3e8a5a436499cf706341aafca769ababd473e0d3e174b33a80d87c95cdcd9b959fd6f74be4e30161d75416061c8fd57518e6ca97cc91c6ec9b6b07c2c8f166b324b96ec3c57818916c0b7f9ca98afb6911a58cfd52373df131cfb06bcc6bb9551d1b5ed064cc27beee5801e6470a6b9b4aec1190e6c869c0721cafc53b6b63fe91a69f9920fc1b0af3a26cf101819f0178dc31fc95460c6c2988f35fd01dfcbd95b9342c4c9674f50db82d34e1fba711532ffb5714de462c46bb8ee9a2d498e918723478261de8d15622d2f2b1bd316a731846de5ca7ccafc1514fa5075bc66c8d77f854c5746da58f36892b81934e7e3df3bd80ace6e9188f809c379f56e2fd9719911e642e3e599a503f9aad40cd4f2a077519656b8762d559e4bc455d4374fc3c66813caf07f162d4cc7e9788df59b27d852c6c1d6339cefe27972308d83852d16cd04f1bbfb431d8c776318b2147edfd4ea0a4ccd3a5907e8cc61ffe2f74d1e5e4b5f5239a77e2e92c8d2bc35386ba4972b1e4afb9a2bf754f2340c7119769da9ba6ae3a8d153daad48e6f3a52d13c303ab87bb943998523a225cd8df7fccd72e63274fcf8453e1738fb837687073f274d9a9b03cb3f9d845a9e237e3d2f3447d78f2b4d6fd21db8503b3f323b87261120ff0010f57f9a366b60b04ecc32e603b88ddb85623d630b3f86b9aef6906e9032ded872c7f0c98de37e8772abccc9f1da5ee8ba9a79215ccbc5639e4b00dcf23b2ad13f2711e7a5dd6dadc3c582ac4aa333b0dd5d704837dcb4590a42cc29c138f961aefe89362ac48fd3b35953631c79c8fbe33b15524d2434fa720b9b562d1540f86688f532420fbb1ca78350ce61a33f581c091bb9513706466ed9de3fd946f8f2d8ef44ac3f245a7136d13aa35db64c65a7e0524d74138fe04ac3f056599f25a432563653f02ad33c3acb8c059f013892b733630e2d7b6dcaf695aeea7a2bc1d3328f943730cceb61fcfb2c56641028dfe0a95afeadfd938aaf50d03c7fa7ea25b16a4cfecfcb3b12f3713bf0e5d935dd4d0f690e63bed783d408f82be7f7f93233fbb17f9ab5a7e1bf11ea1e1a980864764e9e4faf164dc7ec7b154b535ece1b7b70368fb2c9d075bc2d73104f80f1b7dd1b8fad9f047fdd6b0aaf954526347ec99c9d2ab4420712384fea7047d3ba4ef4d208e9c384e3e79444d942fbadb953d93edc6fd4b92b43c68ffaa521791e73b7af6b0bd43eac49e5e360c7fcc5ce715e5194e0e988ef6bedbe1e3f1f8b0f3b34ef20a2d99691f51a4ec16d4514724f3b31f1d8649a43d2c68e49f65e866c918ebca59e3af29d347c37a2bb5ed760c06b49807ae723b302f74c482363228715a190463a58cf6038599e0ed00787b456e348d63b3a6f5644adf7fe91f0175ba7e23447e649e98dbfeabe03e43ca9f232cc474f5f1d38d4f0b0b19bd511dd731f50bc4edf0ce8e63c7703aae48e98c0e583dd745adea98ba469191a9e71031e016c8fbc8eecd1f95f38ebfabe5eb9a9cda86a0efe2c87d2c1c31bd9bf909f1de1cf917f7d423264e30ce7973dcf9657ba495e7a9ef772e3eeabbf953976ca090ddafb4a62ae3a4443cebdb94851b546385205a63c916f4c6f54ade13148708472ba6b6653091a8d9ca8d1b7b2de8a48d48d41d9491f0ba6aac948a2ba28a6e028d52e9a8aed01e5135272c560249ca4135b0ec3d249ed4a4cbea766e2c718b0f6206f28a791d07e9e660b734f48f85e7f9f8bf26396f86dfb425968c64553aa9767a13fafc37a7971af289612b87c673a73283cb792babd0325916966199f409ea0be07cca7ad3dcc53babaad3670cea86acb9c0f57c2ecb19cd2d007202e0e3737f80e8c7f782babd975fa36479f86c047aa33d17eebcdc53ab696cbd35124213aef87384f2991390a91aa9221c24e4029249204924920492491408a4132672063ca648f0946809a8821721412142e4299c811349aeca49eadc819dca49170ea3685e411b20122ca768a49a9d024933926a074924aad024938149d003926a63ca76a0722f61ca8a4791951443970b77e14c059f855f199d5ac64caf34c64605fb298157c49a8c5a56959124c4798f610c0782578c60c92e665bf2727a8b596006fda177fe2bcc1ab09fa497c3082d6347fbae0b1622dc5798ac35b65cd2a57ab5584887a21701d63f75419a6b72663165ca71661bb7af872c19721c5e5c1d5bf6e568e1eaf9058d8721a3262ff0019a23f0af0b4ace5e9f2e06479592df5116d737872b385262b1bd337dc4eeaeb658b54c33893d35d56c2e3647c2c566899cfeaf232e27069d9af3454c221b4e9b09cd31b1fc6e0278190ce3a5ba83617701a4d2c1fececd85f73f4b6bfa4dda79727a879791a6b5e7b48de55a566f6669fa9431f563e5c72b47f8965caece8b796361b1b9bb59ed2f36dc592615bf9681f267308ea6b80f6ab55e21ce5e5b1cee89e48f7e1aab3f3fcf7ff00c4c85ef1fd42d4b26a333390cbff0013544358943b7c7c677fe9533522cd4c6d5a17f4325f2ba1bc537757e0cdd30bba849901ff00d2d6ecb9f3a9c92eff00a5847fd22930d5678db61ad6851c76b7275acd531591167973ced3fe1e1549f50d3c01d38f92d793b56cb9783549bcc7754ee17daad5fc6ca8e4638ba7e993b122ad386bd9c9aeed427c421d1b4d558bdcaa32e4febb23cd99beb3b1da9589e589d8c1b60922ac2cd84f947a7af6f65304ae40d69792d045734aaea78fd12f98360edec7211098324eb67a9decac453332637759a3ddbeca1553c5d5b270da631d1346eecefb82b6725cf8fccc63e634fdcd3c85953b1b1dbdbf6daaec99d13fae17efcd2b7136d33938f200256f96fb52324a243652f68f6458b363e7c5d2e630bebd47baaf91a63a2378ef247b764e26d3bf2a1e9e91e9777050cc2d81c28fe1664cc9a204cd09fc851c720737f87211f0522a2cba5707714a6fd67f0fa1c2c2cd926711d0ff00b51ba563d8d0c774d2b7144a5c87c02ab629a2c88360e7b5a3e556774381f75526b68bab09c50d97915713dae6fc288480ece593139cd3e8d8f2a56cff00c41e66c4774e243634ecfc9d2f3999581318a669e7f94fc15ecfe0ef1463788f1ec5c19910a9623c7e42f0e7bba996d36ace89a8cfa5ea116562bcb6661eddc7b2c6d55b5bf4fa1cdd9ec3d932ced07578359d3999101024e24677695a06bf759b298d7a3a67264ed441016916ff009274b92a62373a1e57f56a7ebd631e31c471af371ebc925761f53327ccf124cdeed68685c863b69ae71e57de783111e3d625e6dbed29f81cd01baf4afa4de1f67932788336273b7e8c50783eee5c0e85a5cdaeeb987a5e2b5c6499e3ac8e0307dd7fb2fa423c58607458988d6c7898918600de1d4bc5f9df3751f8a3faebf1b1ebda4c5c62f6b4b597fd4ade4c665e8863d86c4fc2b584d76369fd720a326ec0b80faa1e2b9343c038582fe9d4325bea3fd2c3caf98c78e725a2b5edd7bd7b709f557c48358d51ba6e13ef03089693fd6fee570525936456db046e20ec0551ff00fda86534beefc0f0a3c7c7131dbcccd7e76039432227390076eb7cb6fe338ec58ad8df970326bf29cf01c01a5d06778733e19dfe4e23dd00dd841bd953f0ae9c353f10e242f04c31bbcd781f1c2f52c9c19269848277c2d69a03dd7cdf91e6df0e698abb631c5a3dbc88b69ce6f041a23e5011457a9ebfa562eac23c2ca6b617378c985b4f1fbae13c43e1fc8d0e60c9099b1ddbb26feafcfcaf47c1f938cbeaddb9f2e098f70c86728c2168daea93afa1c37e4e2b574987d811c5c289aa41c2eb8527a29541dd4cee144ee52e8a9276a109d66b093149a9d1026f64d90dbc47ed75ba6ba53c47aa3734f05ab0cd5e5598694f4834a69f2a5783f70e15e0ff002ff4c1ddf65918197e43089458ea202bd932b5a207b4f24505f05e6e29ae497b586faac3b6d2e4718309a3ff0030b5771a0b7ca3910f76bed705a2bfccfd14679f33ad777e1f93ce932e4fea790bc29aeaee8b4eebb6ea499bb0a4e1777f21ce67214e794c836d33900724e3681d0774924092492408a1722285c80524f568af6a4009257452bb4091350a4809c81c9d2402111be9d901e536fd9009680ebee8ff0095215fba47840cde11216bba4213bee811e53834992405769559099b5bda47ab7e9405d544a12edd30e374902bb4ed4c9db7d901034573baf6a78fa59d41d2c9d12b981b18fea71e02e88024eeb84f1eb3af52c16116c2f0e72261c66ad3e4e065e3c9d65b206d968f9e5549f20cb0bff4ee75c9bb9bf2ac78a9fe66a05e0ee4ee162f5b98ebbaf957ab5e3e9347a7ba414486bb90d77754728cb8d218dcc2c77c775bd8ba987c2209d8d747fd63b22cc8f1f2a1f2b2585cc23d328ecb6aaae6239e5f301eb735c0ddadf76a50e6e3b0485d1e533ef375d4b2333025c56f22484ecd7aaac3e5b83987a94f189f706dac73b2180863ddd238176abbb557023cef31c6f868b51f9ed9b1c86303651bd9eea2c4d42784ff001236480f63c2711763d5c35d78f3169eec22918d59ee92ccf57fcb5684cba566348cfc796190f12422ebf655f3bc3fa8e262bb3b188d434c68b3911731ff00d4dec9c49b2fc59736535c4411cc07f8566cb9f3b1ce6478f8d1d1e4b784b44d51fa7c85cc02681fcb40ab0aeea1891e663bb334d26400fa98796abc57d2b36643f36679224977ff0000a50b9e24d9d238dfbaab3b3d57fe7f0546011b853a445975b1751b6ef4b4206bb2233d8814164432491bbcc6b8923b05bf10c7c8c3fd5e9d62b69e23fc852636999d33d9264e33cb6ee8f0afb26fd43689e977b2a994585c1eddec72a1f30348a559aa22deda51beb91bf169cc8e8ddd4ce5568a4ea0a4128e0aaf1d2fc8f927f52df49a77fdd66485cc71121e9adafdd5f32b41b412f4482dcdb0a50a70ce58e0e8de5ae1fcc16f636abe7c604c431cdefeeb9ac8c71b98f81c2831f25d1bba64533522ced1b96c99be5b240e07905432e36338d7486bbe1738e93a87531dd2e1dd28f53962352384a07baaeb5ed3bdb5b270c0f4b4120fb2cc9311e5d74e14aec3aac12802c31c7f95ca7f3413b31cf1fe15316926ac82c919ef5f285ae0490e34b65f2437f6869f950be0865f546017fc298babc74ce26b768fdd220483e54f262ce017745fef4ab74ccdd9d1503f36adbda12c7d71b68fda8d92873abb850b2400f49e1198493d4cfb544c2793b4f016b674ad47a83ae19080f0bd9e27073439aeb6b87503ee3dd7cdb89218e5041a7f62bd93e9beb4752d3dd8592fbc8c7fb3e5ab92f5e32bdff68dbb14921eab3d35bee12aa55646726eae904dd56e9dca9ead38c6d2f2e63cb232e1fe4b4c75e578845ba782f8bf23f53aee73eeff0088551c7e01df6f6504d23b2329cf3fcce2eff32b4b4cc09752d47174fc60e334ef0c007b775f697c9f830c4ffe9c55af2be9ebbf44b41f234ccad6a78c0972898e00efe81c9ff35e998386d9f24c5d551c74e90aafa74434fd2a0c485bd0218c44d1f215b8e17c18cdc181c04f2bbae579f65f0fe4e6fcd9265e8d69a88843e2bd5b1f4fc39352cd2d663c0da898efe77765f31788b56c9d63549f3735fd52c8e3fb0ec1757f55fc52fd775e760623c8d370098c0ed23fb95c23891b9efb8f85f47f09f1fa8fcf7feb93cacbafd51fda14129b2548e364a81fcafa5c9fad5c3bdfa01e521cee6877298004d9debb2d5f0de9726adab32103fe1e2f5ccfff00b2f23cccdf86bb7561a6e5dd7d39d2db8d80fce91b734ff68fe96aea26716bfa8f3eca4c26b2285ac8dbd0daa0df60a3cd2238dce3b06826fd97c864c9392f330ef88e31edcf7883568f4767ea1ed74af26844159d0753d3fc4b8f2e0658f2ddda39383f23e579cf883543aa6739ccda0612d62a58b3cb8d2b2581e59234d823feebd5c3f1b7b539d7b676cd58fd65da78cbc0b97a1639cf85c67c027770fb99ff0052e340a1b7dbd97b4f843c6ba7ebda70d335a019296741ea16c9bd9709f50bc2b91e15d519e735a70b2c7998cf69eddc11ee17a1f1bf237adbf0e6edc99f044fed0e51a88729882394872beb71db7579b78d1dfdd4254cfeea12ad745492ab493b7954589ad4429a6ca6268a89fea513d0373c3c9214b8dcd28d8298a583ee0b298dc69a4331edfe23c7b3969b22032226bbb8b59fa834c792f03dc15ade434e5e3ca5d67a385f1bf2b1ac8f4fc7e9d2787276e2e619a4162369e9fcaec3c19922764a2fa7d45c3fcf75c3e983cc82690f01a42d6f0a65be1ce16fe986c5af97cb3a9dbd0ac6e34f511c0ff74ea389e2401cc36d22c29174d27946dcb31a93390a27215a0d5492490248a49140d749aed3a67201ba29752672405a07eba4c5f681cddd0f45b904a0da217d900f484ed76c80e89e5222944642d3b22eb246e81d01bbd93d774900efdd38e522901681ddca702c148353f556c802a90b8d2226ca17f0805cfa4dcee927080aac222ea6a8cbba53f22d026106ed11aa34853140ed176983803451b782a1923bb5300e790321738765c178ab2bcec88e467f78c0ba8c979e975b83636f36b8df101fd46a2e7b5a5b10155eff002acbd5c8eb0ff324638f279593272b7b371dce8dee776e16448df45fb235fe2887b98fb6dfecade2e73e1b6d75c07ee8cf3fb2ac581c6ca468021ab485571ef125bb15fe8ef1bb90aabe285ceea731cc7289a68820d1533a7790038d80ad13a9078b8b86660f9a72dae01176acbb034f9e423cf732f8a14a97a4ee3944c2d6baddd926c714f3e8d9b8c3ab109c88bfd691e99a867693921f8d2c98e0fdec22c387707e10332dde634c72969076a34b7e1cf8f3a111cad66db1b1caacda4e2cad734e8f500ed4f4682186322e6c78cfa7abb90b0b03324c4c9058f7b0fb76fc2eace30c6797e35b5b5b80b1355c03354b8c7d5cb9ae5ad2cca6157596b72261990b435af15235bc757bac77b034d03cf65a70cae6830cad2d69d8aab34419250e3b2d0840d696ec39ecb43429dd87a935cdde29479720f70aa16fa82962b64ad238bdd44f4995ad4a2fd3e43e16eecbb0a9f2e03d96a6b401f29e38229641049b1c0e5447488580fe92a46c8d7eddd5534ee384d44510a2616492b8b5dd23ba765ec0a62448cf909e2a028a880d2b4905a1529212dbb57260e6fa8203275467a95a112a6d8f642e1d9580d7749aeea00ea774b959542f8de37edf8b498648cdb247b0fbb5cae868e9d942f6b77ae5260de9343a964b1bd2650e6ff5382b70e692db9210f6ff00531d4b18b8755116159c3ea919206ecd60b55e2459aadccc3ea02432c44f770b0a6774b9bd514ec919fe114173de639d7d32023d8a4257c6db6b803dc04985b9365de538905965142c7466cfd8a943985c1bd4cbf9575994ca3d42f655123da090e62d5d0755934dcf8b220710f69debb8ee16335c4eed3e9f6465fb02363eea968dc69a5674fa1346d4b1f57c08b330dc0c6f1bb7fa5ddc2beeecbc5fc01af9d275218f3c8061641a783fcaef75eccdfb41b0e1d9c3b85cf68d7a6778d1c72b9ff1d64791e14ce7ff0058e8ff0035d0016b89fab723a1f0a00dfe79405d5e246f24431b74f1ac6da568bab5eb5f4330223a9e76a390c25f13036073b81eebca61686db9defbafa1be9669f2e91e0fc674e2e5c82653f8ecbd9f98cdc314555f1a9b9dbbec5f2e693aba09e8dc2e77ea76be3c37e19c89e3db3f33f8513bfa6f9ff45d0e987cc6ba5948646d049257cf1f52fc4eef14789667c0e234ec3262847f511cb97cf7c7f893e4658acf50e8cb7e1599720f712f739fbb89b73bdcaa73c85c4d7dbd95898b41346caa4f36e5fa2531c61ac561e4ccf39d9756c809b293937fa0f7f658e4b7adca623d8ba5f2be3860617cd21e96347baf55f0a68add130043d41f90ff005cd27727d972be00d34c93bf539a30e8da7a20bec7b95e930454d1d4013cecbe43e47c99cb7e30f47153504e9c32a8d85c2f8f75f748069d8925970b98ff00d9743e2ccf669da649293d2f3e960f72bc99ee748f7be477548e36e3f29f1de27e5b6e539afa835eff001ee8c1a0812ba5f598e95ac443cebcee769a395d1b816b883f0697ae78732e1f1f68b93a46a52b9d9589075e3f986ea876f95e3cd3656e78473e6d3bc45833c0f731de6006b820fbaf37e4bc39b57f363ee1d1832c4fe92ab3e3bf1f2248651524669d7cda8aa8af5bf1ff0083dfa8e349aae9918fd481d5240ce5c3b90bc948a34474b9bb16f76fc15e87c5f9f5cf8fdf70e7f2714d277067a8fba9102f62d3bf6e33249c737ec85dbbad56521ee914e92a84780a584d3871fba881ab4509b703ec8984f93a5e46665364638371ebd442bb0c6d644035dd41a2ba95fd3dc1f86e045821538e2267e802996be37e5e3f797abe374d3d2e268d3e6a34e3c2d2f0ec2c7dba41e91b7e4acc6bbf4d23055b09a2b43158e8722480bbeff5b57cb677a347a1e863ab18c64f51671f01685d95ce6873bce4c45afa65539746f14f2070384f1edfc6597b3774931349ba975b26c0ee9bba3e94ba500262694954955d208ebba67291e290200491390a067264ee42503a4982740c45a604f0139348da587f2819a481ba7ab210be420d764c24406e6594c056c9bcc3d92dcf280901e51345a7aa411a67291c81bf72014dbf6523cd151936500904b8da70ead915023740000764077612429c2492702c85572a70c796b8f481dd5a0b93f12ea02274ed7703b7ba88ed31d16a7a8b32dc228bd11b4ff9959b96df3400780a9615cb11965f4b4ee02d1c3689bd25df85a35ab132b1ff0086f005b6960e4e36d5554bb69e21b80de3bacacbc12f0e703bfb22ce2df153945247badc9f10b5c7ab955a4c75309ed8c5841d9339a7bad17c3d2547e4f5156e49e2a205272dea575d011c21305fe55b96d5e2a61946d5a8262d340d14bc9e94bcab4922ad3c2cab04486ca698fafa82ce11c8d20b55a96dd1efeca2113534ac6ce69cd00f62553923699831c013c0a52756e3dd4790c739be637fbc6ee15b68e219f0cb4df93bfbaa4e6b83ba6a96de36579d0b5cf16e1b14d36309017014a796d135f4a1964c9811df6594d759737e56a4c2985a7858d9cd745235edfb6f7578e94e3a1d7448a470bf57ba9a263656b4b7b845d05aee977054a54ecb4d853368d1ee9f221e816d16abb642d364eddc289171ca191868d0b52b0b658edaa36bc6e0a8844a9899ac774b8552095ad91dd4c52e463091db774f0c1e4fa55a15906213441f7527960cbba279647b7728c48c6c7d45595527633a493a5a6acf2a5cc95b8b89fa3805b8eef72961c8b93a46d7dd67e5c7263e43cbfd6d76e0a98151ad73242e1d95cc6c863ac48cdbdd2c7679e79fd9018dac796b8d7b2917c63750ea81dfb257d3b3db6e1dd568649203d4d363dbdd5c8278b29a4380638fbf759d83c72f4d749fd95a0f0e67caaae80c3edd278214f0d553b82a8bc5871b8b1c085eabf4e3c4c1f1b34dce92effb993fecbcadcd0cd9bf6956b4f9cc3282d3446e0fcaa64a6e36d2279469f4701b8f8ff55e7bf5a4b8f87f14378fd436d743e08d686afa48121ff888474bc2e7feb4349f0ec0e02cb676adbc0d7e588973e58d3cc70315d9b990e1b01265786d0fcafa77171fc9c18623e88628db1007f14bc57e8e694cd43c5acc87ed16237cc3f257bacd94dc98fc9e8e9e975ff9951f339e6f962b0d70d78c6dcc7d54d78e87e15fd2e2c80e6e70f2c01fcacee7fc97826474c2c11378adcfbaeb3ea56aff00dabe2fc96c4eeac7c30226fe7bae3325fd4fafdd7d27c178518b1fe49feb87cccdca78a0ee542ee54af34142e3657b191cb421cedca9b070b2354ce8b0711972c87d47fa5bdd425c18db3fb0f73d82f49f00e8ced3711d93942b37277ffa1bd82f13e4fcb8c549ac76eac18f73b7438b811e169d8f8d11f4c4da6ffdd68c4e11619127f78ed82af14723dfb37d37bb973fe2fcf9f1a37e3e1bbaa52d367d82f928ddedbb7f5ddc7d38bf1ae7bf3b5d7c7d57063fa40ff12e7c922cf649f21ea3d5bbcfdc7e509df75f5ff1f8ab4c7e9c396db92bb4aac149bca91abd3ab9a6c685bcab58ee77eab1dac203cc8da27f2abf70a7c5a1998e5dda469ff54cd1bc565f17da1f45ff006abb1e380481a5cce9b776e375e23e2bc8c6cbf126a13e206863e427d3c12ba7f156ab345a7bded93d6f3d207c52e023693bf73dd7cdfc461b5725b2cffb777956fd6204e511e54ae001f95115f6549dc6de2cc7b320eea4085cac93249c10394cd6973be3ba06a2766feea78c065573dd464f41a6a665975959d930e93c3644a6669174ad66e3c6278c9d9ddd67f866510e596917d41696af23669e304500375f2bf2f5d4bd2f1d16a15e6b4077a436efd95a74cdff008499aebbdad529221d05b566b60afe898ac9b1fa24753da096b57c9e67a549d43a9d224744d963736c48e05aff0060bab1fca3d87f9ae131a570c5c691aea958fe9e8f70bb988f53438704023e16783b57246fd9de98233c266d56ebad8b6fa92ea50f5240da0949b4c813840e45a6aa4ee340240da007709016d4e794ee774b500814a23ca901dad20db0823487752f48ee9891c01682bf729d89cfde76a44ce502ab4ba51226a006b794e05046481ca560f08053934d49c682889b280c0dad46ee519e1091681060ab29e9a3bd210ea3499c6ca027556c6d4574937ee4a4ec81c1b48a10693dd9424edaea1d5f6f25703a9be29b52c87bfed2ea0bb9c93d304ceab218682f309a53248e2ff49b3b2985aab72b9b137d3f62d5d3e31fa605cd23ab82162e2064ae26536d0282d6c4cd7458e21ab1d9567b6f55ef2dad651aa50c9861cc2f68b695630407ca0bcedecba1c6c432b7d02e32ad0b385974c32d90295197477dec6d7a54ba3c57c9fc0503b478bb5feeaf03cd5fa2c837abb517f62c80d865af4f7694ce9d94234b61d8ab48f327e9720d9cc23f0a17e98472d3fbaf507690c2a9e5e8d191c595581e7234d3d9a89d81b01d3baee0e92c6b4db770abbf4c6558047e15a53c5c6ff675edd2a4660003a5c001ded74efc02382e080e270d7127f2abbd2d3579fea588ec6c82c2d21a7769418a1cf690391caedb5ad28666139acfef19bb47b95c6b3aa17878d9c0d382d62db85788218463e57ff6e4dff75a6dc70e6baf93c2932b1bfe1db231bd513f7fdd0e9b3c72b0877f78d347f2b39946989aa4262907b2cc95a1ed2d70bb5d86a386d9a1783f75585c8168737f0775bd2db8676ae95f0af167f2a4f546ee1decb50b1af616bb73fcae51fe93f598ae31bba5cdff00550b669310346431fd3c7576532a1e76be2219d3d57dd53983413efdd69b32b1661fdfb4da872e183a6e299b6a210cf63cb0823ec2a68dec75df0a2f2c32dce20b47b20fd6400d03415912b5d6ceaa0825367d2a8be52640631e9f74714f669dee90acac3581e2bba872217c719f646e7f760b280e5bba4b646eeacaab5b680fe6ecad349c88ba24edc2ab4d71eabfd926ca63713d9059c484c336ca56e2472cef7e4bfa18c1ca8f132217cad2f3454f95299ad8d610df71dd0965e407891dd983ed1f1eeaabe5b0003442d6f298f70680491cda1cad358e8ee2f4c9d95e2370aa2c1ce2ca8e5f530f27d9683a2d83e1775c7fecb03a4c669c3d636b5770a59a0907967aa33c8513539359843cb5ae3bf60a720070f71b21c40c9aa5ae92d365aa3cf98b724cc768c6d4b2986b5b3a2f0b6af268dac41925c4457d2f1d885dcfd577372fc2d1490bbaa39246b98e1c10bcab164fd4461bd9c765dce5e43b2bc2506945c5d3f98d0c014609fc7939272c6e1d57d17c3fd3e979f9f237cb8c911b0fbaeb75ece669ba06766977496c6483ee7b2a9a54034fd130f06835cc00b87cf75c5fd57d4592c385851bfa9a6dd2b7dc765962a7fe6799c5699fc78f6f3a00f4b9cf36e792f3f93baa53bf7a57721dd03e6b8f659af759df95fa3d31c61c714878733ced320bb29c804efc2715df85369d8193aaea90e9d867f8b2fdcfed1b3bb9707939ab86936b37c54dce9b5e04d1bfb5b537e5e432f030ddc7fe649d87fdd7a6c51ba597fea3ba1d2b4fc7d334d83070c010c228fb93dc9f92b43022e82e95c6983fdd7c2f939e7c8c9336e9e9d6bc60f9e63c4d3a43d5d14db2ef65e2b97ade53b567ced78747d55bf047caebfea66b7230b74e89ed01e2e4ae579cb87a8f4ee7b7caf4bc1f07f246ecc6f9a6b3e9b5ad60432c0cd474ceb7e3c82e58ff00f2ddff00b2c403d20fbad5d03537e9d920821d13b67b0f0b6b57d1b173d87274e1e44e77e9fe593f0baf0e79f12fc3274ae4a4648dd5c8b51b568c9a06a8c2df330a4f5766772a2d474ecbd29f1b350c77e3c9237a831fcd7baf4f1f9d8ed3a89725b14c76a88c1e9a70d88360fb20dff652345ecbd3ac45a3dff5856dc6cb7919f959bd3fa87f5860a0b5bc37a4cdab8c88b19ad3247197f49e5df8584d757a576ff4adee835f130e1addd79be7ebc4c3caaecc1339a752e4e6610e21c3a5c36734f20aae41174bb7fa95a3c7a3eb425c677562e6b7ce69ff001770b8b75d91d977f819ff003638b38b25385a611ed5f280903729cf25335bd4ff008eebba7d333c6c2ff5764a5936e91c2795e000c628434757caacdbd244d6ed489a28a670a44d59c90bfa5bfa32d8efd97553c1d301d813ceeb8fc43d33b08e415d761e58963f2e4e485e0fcbd5dde3f487f53e680c2c0d207211e1b8479f8bd27a49357f95148cf265758b6a29a099b0325c768b14eb3d97c5678fda5ead3a6c7e95d1cd7d55e549d55eebb9c193cec66c8e1f7775c93e4fd4331676104bdbeb23dd749a449e662edc30d2e7c5f64e5e9a1bfec98a61bee93bb2ee8e9ced54ae933909407d49fa9449209eec248070920326a9338d9429204924920499c939320622d20291353a066a20992ba4090774fd5ba5768126269226935da062e440d842ee1034d5a094a6e9ea43d495da023b0a503f9530aee81c01e1046d4e52aa369db44d9427a4594ee9c594ff0084af29cbc8ac893f257a67886718fa5cf23b80365e4934b6f757054c35c6d1c59eec772b63145460bb90b9ec1774bda470b74bfa1a09177bd2996ce8744864cbcb63182c775e9d89891c50b18c6ec06ff95cbf8074b7b7086464369f29b03e177b8d08e00aa510297e85af1f68fdd30d39806ed6adb0dad94729de95c606462305d347ecaa0c5df768af95b1904071b545f2b6e940a33c4c07800fc2cd9a01d6485a93b8b9df0a9ce68a26199244c1f95524c71d96a16592a27b291663498d7dad579200c1b8a5b0f6eeaae545d607c22ccdf25ae0005c7f8bb4b6e2cc33a21fc379a947b1f75dc88e82ab9d8d1e4c3243336d8f14509707a34e18f761e41b89fbb154d6f01fa667c790cbf2a43eaaf74b55c7934fcc3138fa987aa377f505d2e23a2d4b49ea9776b851f82a510a2d2c7c4c76d755fb2e235387f4fa84edfe506c2eaf0496be7c3987f16336c3f0b235fc373e4eafea0af552d0cbd324a9fa4f0e0b4a58bd1d25a0b7e45ac28c98240e374d3d9777a5bd992c8dec6b1d196d107dd5f7a67c5c849a744e36074fe05281da6444ee5c57a04f851807a60633f0b33370c741a601b764e4717212e2b446580123e5636560ba3b731bb2eb32e0e93c52a12b07045abc5994d5cfe387ef6294b8d01739ce2695e9600090052ab92e74303ba3953b566be95a5959138b41b2140e91d26fdd55e923d520b24dab0d9dbd20552d63a504c93a49ea520e9937503dc08b08439d7e94167cb16294ec9256d027a9beca06bb617ca943c01eae5448d1c67c7b97000d7746e22436d91a2bb2ca337537a49a1d948d8c86dd7eeabffe0d07e1c59119ea73449d8a1874f6b23e991e093eca946c739f64d355d873e28898a53648a1f09eff00a7a4d99713591621a68dcbbdd0822688c72f27951ba4743274ce7d0edc15239ad3440dfb14d6c41a71763e498090d3fca4af5af06c0dd664c324013631b35de97944ad069eefb815dbf80f5f3a4e407b5bd4eeff0001636a4cf4d627d3dae3d3e5cb99ec6b5ac731bdd788f8c2774de25ceb37e4911feebe83d232717334c1ab3721ae863617be8d16b472be6ed6b263ccd4f3f2f1ff00b9c99dd2377bb0785dff0005e3cc791caccbcab7fc4c79cf51b3caace5348e0091dd42f1dfbafb4cd922b1ede5e28dce8ce774b3dc92001ee57ab781fc33fd8fa77ea72b7cfcb1d527f84760b94fa77e1ffed4cc3aa6533fe0b19d510ffcc77baf50c995e232e79f8fcaf87f95f3e72da690f570e1e3003d21e19d24927b2835fd5e0d1b4d925948ea00f433fa8abb0ba3c3c674f391f6f559ec178d78bb5b76b5aa3a56b8f911fa583feeb87c1f1ade45e3fd2d92dc61939995365e4c99192fea9647591ec3d9404774b9dd272fb6c3862948ac3ceb5f73b176e2ef65d7782247e6ca34f95dbb075077fd971c1e7b765b7e0e9bc9d5c48dbea2da14bccf97c55be2dff5af896f6eee5c8186d91d34fd11c7bd83476f65e7baeeab2eb5a8bb2667c8e60f4c61e6fa5ab47c559ac8dffa26c85f33bd5213dbe173e393ecb97e27c39b7fcb75fcac9fc110070881a1680729486b6f75f5511c61e74f6269ea248e57a17d3b6471401eefef253e9fc2e0b0e074d2b2067dd21e9fd97a26801b178919851ff7504419fbaf9df9ccfbc5c1e9f874fe9fea9079669ce7badad05ad1f0bcfa43dd7a47d536560e0df673a979b1dcd7caeaff001fb72c0e6f33ec8eba8fc0e533e423d2de0a9642d03a472a16d0dcaf7e7a7107a48e5384fbb8fc257d92a892ba4aed0bbb226aacf6b552c669c0ae93101918de9d8d72b9a1eddfb2eabc355240f0ee415e4fc9d7962dbabc7b7b5885ae12b7cca7fe7babb9b2b9a69f4cf4901a3b28f28fe9a463983d4383eca091ae9e5eb99dd4f70e7d97c27975d4bd6c766868ce23059bd8695d668f2c6d0e87bbb75c868c00c6753baa9f4ba7d07d798f1ec170d7ed0d2dd371bb0207629d10d85263f685e8474e59eda83840794e80f2893d5a5d55b27ec904060d849015237840c925dd33903a672649024924ed40c9da9d22682485740a0bb4bab642e3615602726ba42d3569c9b560f7695d214c7b20226d0b91764c8052627726ba4049c20ea4ec3654c03ab4ed65945d93591c1a27653276e4fea2ce22d3e28daea321ff0035e652b807fb7c2ec3ea4e575ea90c4c77a6367faae1267974bb9b510e8a47a6ee9aeea730765d5787703fb5758822ab8dae0485cb68ec23d43d97ab7d2cc2123b2735edaf2c8683f2a6567a161e33628c3583a436852bcd21a3750b4d34171a50cb94d048bb510bc74be660d6d85467c8b75aa7265b8702d40f9ef914ac4c26c87752a87ee4fd5d4546f34884721a255394d9562536a07a10ace1654331de95922d43235165593ed555caf4ad3d3b2a6e0472842bc8ab4801b07856e5e0aab568b313c47a6b752c3736ba666eed72e4bc3396fc1cf974eca0e617eedbe095e87233bf75caf8a343933d8c9f149664407a9bd3cbbe1045ade138491e6e392268fee03f987b2a59d1333310cb101445d770569e91a8b351c525db4ecf44b1bb96b954cdc7383297c43aa276e47b29de95d38f9e005efd80079b5523ccc8d3b204b048e01a7ecec56bea8cea2e923fcd2c8948780d79a72d6277e99da35edb6df18e4b834e469fd6cf78cd253ebb2e60031b4f7807fadf54b0d9e6c22983a82b50ea0e8a83c16fe14cd74af25d6413be9d280d3ec1433b1a1e3dc277ea71101ad133de760128a295eeea702d27b1511d8a5950ddb9ab3668ec53974b245d03d5dd64e6422c90aea4d5872e2820d2adfa6a2b4deeadaad41d6d6bbd42ad6b56768533050b4a3887dc55d91bd4d242a81fd959433eff00642091ca326d3b802ddd01b59d6d0ef64c321f1922ac2189e5a6bb2b0e6870dfba08cc85ccb6bbf215771639a41d9dee8ebcb79be149e40947503450063e416b7c994754678f85a78f3465a18791c059ae8dcd14e1fba189dd26946886c3bb81c2b9a6cae8a56b99b396744fb8c2b9823f8cd2b6f1eb1f92368c93aaccc36a7ca9ded31f9f308ddf700ea07f2aabc9633bd703d938fb9c3dd0e4d08a8ff92fbaa78b4c54e70f2672cdeda547c64f1fccb43c27a1cbafea663e93fa188ff1e4fe53fe10a7d034e66a1927cd79f2f8318e4af58d222c2830a3c5c61161c518fb01ab3f3f2be4be57e4e6b338e1e9f8fe3ebf61e263c3878f1e3e344228a314d68ec10cc5a2cbc0206fbab32cb1b185a1cd77b106d73de29d562d274693f5041cc99bfc28dbcfe57cc456d96dafecbae6351edcef8f7c441903b031de1d2cbbbdc3f942f3ea038e0707dd1c8f739c5d2126426c93dd40e36becfe3bc48c18e263b79b9f2729d41dcfde944f368d25e8f4c11b7956b13225c599b340e2c947dae1d942955ac72e08c9daf5bf1e921717bcbde4ba471b738f7288f0100f484ba96b8a9148d432bda6c9010d1650805ee07b260db36a76801a4935416d37d46ca46dd178271db26a8f96416dc789d2ff0092d8f014cecbf134f338fdc1cea54b4d63b49f036467483a723527f4443fc3eeadfd3467ff005b3f1195f21e5dff003f3c8f5691c350d7faa4f1fa4c107dcaf396d00f2efd97a3fd511783887b7515e6b31d9a070bd6ff001ff581c7e646e5113d449ee807a9d689e37a4ec613c72bdac967352a771ec99755e03f0f47e228b533240c78c7a6b67749d1d0ef8f7fc283c4de13d47c3a18fc91fa881c2c4f0b2da07caf32bf294e7c25bdfc6d46dcd94822751e2c57f9212bd6ade2d5dc3966353a134f49bf65d3f84a5ff88959fd4172c0d2dbf0d3cfeb5a0770b93cf8de2986f8bb75d9cdeac7ae3b5a8061188c70b1dd4e78b1f2ac4d6e8eddb81dbdd401f279b149cd1d8fb2f83f2a36f571743c069c786714074cbea0576ba261982274e5c099b7a0b8d87200ccca825658947507aed74595b260c4e029a1a000bcfc7f76d93eab8ee52ec9ec38d8488b5d8e66894ca478b43d2805384f5492049262990124982740239520e14639520e103393224ce402518e0a1480b052436f5b288df56ea60ea14a270ded56010e1094827560e0584245144101e420499c9cf2955a0029eac22e945d3b29811f4a76fa4a3aa4c45a990e5dba8a4790091ca3aa41247e9bf6dd564794f8e89fed995eee682e3cbaa41f9b5d5f8e1f79f23bfa9720d3fc4054c3a29d3add2de1a2caf73fa7d01c5f0c404b69d238bc95e0ba553c31a782405f44e82d10e8d87137811857fe2f1db4dd2d34aa1338deca595c402d1dd557070d9521735927748871ed61490c4e72bac80340156ac4a83612791499d152d5918c0daaa2a84c00ba4554deca50bd96ac916a3732ca0a8f8d0399415c9194a378a6a10a12b5529852d07f2a9641a72895a142416542e6ab4e1b92a078a2a2165479e42848246c6abbab0f16544e69ecac39ed57488dd9273f15a63cb0371d9e3e5536ea00d33218629bbb5dc1fc2e9e5040b22d65e6e33720d3e30efca91cee6e0c32b9d242fe9756e0ae6354d3a6a2e38d23f7e5a2d77cdd29a2e811fec9bf48633d3640f857afa676f6f33641332808656fe452b51e2bde3d4d70fcaf42763edc93f95564c50e3b8b57e5b67c5cb61e3f967e42b956b4a5c4e9dda2a95673430d77414decb05529a206ed6b385854f25be9524b9fcac6ab2d5992445c4d9a5bd90df490b2dec1d4415a558dd4bcfb696ddd2839b4791174c84b5451d977495a33338906c295b4e17dd1188006cd2ace34ef49b28277376498fe9210c721228a77ee29094ef0d95b63955439d0482f84e016ee14d4dc88fa0f25154cfe99a30f1caa32368fdb5f2a583af1a4f2dff62b72318e75ff00295021c597aa9ab634d7565c6d580f8dd8d36df61dd6e696e2ecb88f6a5d5e246f2d59e4facb5dcdf52ad946c52b2f3455298db8afd037ac710f13ff00b4a3c5cc9f0e76c90b8b5ed360f65d7e9de2c66535accd022c9e0483ed2b8b3f7246eb6ff2f75f3fe7fc562f23f6d7b7a7e3f9534f52f62c2cb93c8123581cd1b82c17d47e1798f8a32727335b9e6d46392294ecc8de2ba42d5f0a7894e1f4e0e5c9d38ce3b3cf0d2b77c69a43f5d8229e22d39ac6d4523787b7d97cbe0c53e167e395e85e672d370f35209bf7519007e54d244f8a47c53b3a2661a7b7d8a0aa5f5b866b6aeeaf2ef1313a94698a272656b2904ce53bcd04d74a371b2a26cb0ba94ac1dd44d52b14d51236824ecae69f8526a5a962e040d2e7cd2069f603bdaa8c3bfedc2f48fa7d830693a66a3e22cef4be388b22eaed63b2f3fe4fcafc74e15ee5d5e362e53ca587f50b3e39b598f4cc6db174e6081b5c39ddcad8fa5b0f56a19129e04642e06698cf34d3bfef9097127936bd23e93b7a99947f0bccf2b0fe0f0a223b974e3bf3cb311fc3fd527818d82d1ee4af39a1767d977ff565fd393871fb3495e7ce3d5417a1f07eb0397c9fb040739c48e14d1b249258a1c68dd2e44ae0c631bc9283d31b4f56c0775eb7f4bfc30ed3f106b399135d9f922b1d87fe537dd6ff0025e6460a6a3b57c7c5b9dcb6bc31a469de13d0b1716563f335c9ddd72c2cfb58e3d8aa7e2ef1e8d1636e1c32e3e4663efcd87a6c477d8ac6fa91af1d2a5381a64dd39ee179130fe4bec17943b7739c4b9ce71b2e772ef95f37e37c7dfcabfe4977df3d71c6924cf33cf24a6adee2e207037edf0a327b21292facc54fc748a7fa79b79dcec718b34b7bc2b8eec8d55ac6ecd6b4b9cef60b131219b2666438cc7493487a5ad6f249f65efdf4efc18342d2f2199f189b51cd68eb0788c0edf95cde6f915c749aff00657a57dedc8363ea05c0d01c1f75048d2217381ba7ad0d4dce19b3421bd3e5b8b69507e443147d356f71a5f1fe5f7b7a389433da64ca0e61a702bb8d0678e5c08030db99e92b92c4675cb2b65140f0b73c2d208b325c63fcfb85e653ece8b7d5d381b9289a2d28da48b3ca368a5d90e569a4524c7b2903dd3394840277425a3b2004aad3b85264037bd23e9ea0993b50202b64e9c0b49c7b2064ce4e989a4087743dd3fdc988a400794912480524ee4c81255698a7ec8188a482453202ba4aed0a480924c13a048283ac1ee11a702cd20f1ffa83008b2ec772b8e61a785de7d517359991c5fcdc95c103b81ecb4ab6a3a5d08d960ff105f4569cf23031da0d7f0dbfecbe72f0e3ba9f1b7b1705f44e9a6b161038f2da3fd1459aad069eadcda99b1f514cd6dbad5b63456ea89289bb293ed4c1c06c109209dcd29811ccfa255195dd4559c8905d036a9b8ef6ac2292f6a42cbbdd273bd55ee887a021069bb2acfeea49e405b64d2a0f9dbb8bb458d21009b55652d2129661c8ecaabe4eb3681dd5d2694245849efa2983d87f2821737743d16a67386f4a30fa5222743d5b55a85f057f2ab80dee81ff0070dc0fca0a261ed556aacb0d122acad67bd81d45e011eca091be61ea0784818ee6d0a228aacf68bdd6c3a3eabdbf75565840b055b90cc7b1a7b5d2a13400bc90296a3d8458ecaaccd568b2263d3232212c6db5674a7620f2b7a58c39bbf0b272a13bd7daaca71634e2c9593920879a5b53b7759d94ddd694656ab26417f72cf9ba98fb69a5acf144aa534776b5632a6d9deee4da73645947e477425bd288346694f190480542d440d1b4816ded04504d0c66370737945175483d2b421c37ba3b269567b11b83258eddf7289e7a4868e02b2620c1576544f8fa95a2741e689b2c1639014da46d951b4f213c229a158c463465b48e57a1f1d5e59aac33fd657e4eea9c9c9569e7d54ab49c95f7531a878ffd42eeea2523909e17359a543d3d5b2e9fc23e2138b3370b39e7f4e7fbb93b37f2b97ba29cd3853aebe1793e77855f26b31d4bb3c6cf35edea3e29f0ec3ace10cac5e88f516b6c16f1205e5cf06399f0cacf2e58cd399ec5747e19f114ba7cac8b2e57cb8fc34ff4ae9fc4da5626b580c918d6b32aae395bc9f82be7f0f9397c0bfe3c9d7fb76e4c74cd5e54ede60f00f0849ecaee669d9d8ce027c77bbfc4c160aa663941af266bff00a57aff00f9b8a637c9c738ad12070b4354ac371e624543313edd3b233893f94e97c99044dfba4aa01447994df67e3b200a58eaf7e7b051023eedabfd55cd3f0e7d4b51830316dd3cc6ac7f237bb95ef9eb4a4da5318b73a743e00f0f3b5fd45ef91a46140772ee1cefe95a5f52f516c396dd0309e0418e019c0fe6791b0fd9760e9b17c25e1b271408e2c58c86fbc927f57ee578e4b3cd952bf2324f54b2b8bdc7e4eebc9f12b6f37c89bdba875e49fc54d103e8208dfbaf4cfa46d231724f6b5e64e34db5eb3f4b20e9d19eef791767ce6a9e3c4432f12773b617d5775ea98a3fc0b8802c9e0eddd76ff5541feda800ecc5c7e3e34f9f950e161465f933b831a0722fba7c6e5ae1f17959196bcafa74bf4d7c2cef12eb4fc8c907fb2b0dc0c8eecf78e1abd57c6fe28c6f0b69fe5e3b98ed526654109e216fb941993e9ff4e3c118989110fca0cf430fdd2c87977ecbc3f57cec8cecc972b365f332653d4e3edf0bcdc75bfc8e69c96e9b4cd71575fd55cc99f919124d3c8649e425d23ddc92a9c9ca279ded464d95f494a462ac561c3b9b498ab1818597a9e5c789a7c126464c869ac8c593ff00f252687a3e7ebfa9c781a5e3ba69de791fc83fa8fc2f7bf09787f03c1da7fe9a07b26d4a5f564e493449f61f0b8fcbf3ab86351db4a62dfb53f0378362f0ae3b72330b25d664165d7b443d80f75e83a5d3a46389b71d813c958ad02678319f30f720dad6c5708402f6904772be7b2669bdb94ba22351a79e78c30bf4dade503cbddd4b92ce606c8c2790765e83f50c7ff57120dfae306d709a88f4937446e172e5af2acb7c61127945c5df056ee84c0e9fcf93ee3b05cb4b375bd85c6c90babf0db9871c492fdc1d41791ad59d3fc752d1d22bb840e481b27e774ddd76d7a737f65b079480b48f28870ac8003eaa44ee521c94c7940c50774699c80501241d91d5a62d40e1c6b74aed0d5276a04e4c89339026a7429da804f2994880f2805c2d355223d933b95301924ed4ea640a628cf64cf3442a8438425393652729803bf64ac8e5249582bb489aef5f29267556ea079afd5b6b04f86e2cea2e611d4bce07a78dfe57b17d45c68a7f0dbe5736e663c57c05e3723aa873bf2b5af4bd5d17860de5c5ff0058ff0075f47605fe9e2afe90be6ef0a8ff008a84ff008c7fbafa6b4883aa089dfe10b3b36aaec2c1d37dd4c69adb2a40d0c6eea8cf3171e90680545e04fc8637955dd3b7727855f2256b4513642cf97279038530b42f49902cfb281f30770a83b2056ea17e4d7daacb69a064f9a4c660451770b224ca7289d90e70a438b47267696d752a123dad1cdaa926491e92aac994eefc21c56df287590a174dd2154335dfcacad5f578f0c5117f0a6096acd3173b634a074dd3bb9e00f95c5677896591de83e4b02c2cdd7f2326c7984307b7756d2b33a7a77f6ae3b0d195a0a8a6d6714733b7fce97953b50da8dbbf2a076539e76d82715793d2b2bc490403a9b2f57c036a97ff0035c44ecd79bf634b81eb1cdd95236435b2b7139bb777896124f4c0eeaf72e5674cf1135f306bdb77deed7110871014e699bd907e144d4e4f491a9e307d19032fdd4c4325a746e0e6fc2f37c6cc2080fb2df95ad85ab884d075354693c9d464631bb0b3658c804153e2e68c920b5f67b85264b01702763ec9099633c387a4f0aa4b1582b632231d9519594af0ab0b260bb5913c74485d3e445b5ac6cc8f72ad0a59cfccca255278a2b5b2194165cadf515b5585d5dc6815074deea73b9a51b9bbab330f4a41b66d48c8faa9111d2504d15b05853b326570e806957601dfba8e7eb8dbd51f080cb256b9c49bb2ace3baf63d957c32e999fc4e1596c6e8c80385122e42dea700af63c123272e7fda46caac1543dd5f83abcadf85eafc47ff00221cde57d0245055dfca9a5501e57dbdbeaf22a8e4e542e5349ca84f2b9a5a47414e1229ae9617aaf59d083ba4df3f0ba1f0e6bcfc390433d3e17717fca57380da6756d77fb2f27cff00123c8acc476ecf1f2cd3b7a88958f3d477277040b4985ee6914e07fe95c8f8775c640d6e36513cfa5e7b7c2daccd6b171e3717e402dedd3c95f1b93c7c94bf07ab16a5a372d47bb4f8a3233350e979d8c6d6ee171be2ed5e2cf11e9ba5f5c7a6447a9db5199fee7e1646a1a84f993ba424341d9bf21566022ba8feebd5f13c0b53f7cce7c9963aa9a477430d0b7120068e2fb05ea9e03f0f9d2f4c391301fda1922dc4ff00237fa5721e08d1c67e71cfc9697458eefe1b07f33975fe38d60e93a40c5824233f346c5bcb59efff00659f9396d9af18a856b158e52e73c79ae8d4b346061381c4c534f70ff9afff00f92e543ba85fbffa210d6c6d6c6dedbdff0057b948afa5f03c68c18f51dcb832df9c88835617b67d2d86bc32d20592fb2bc55bf68de97bafd2d8fa3c271b89b0e7595e5ff905bfe38875785fd719f56cdebd0802aa3b2ad7d2dd3a1c413ebda810c6b01e8b174d1b9ff3e155fa9f04b9de31c7c582bcd9406b6fb051f8d73ff43830e8784e1e5c4c1e711dddecbcba5ad9b157143688d6ecc2f16ebf3788f5fc8d42505b1fd90c77b3183858321ea249e5139dd364edf93407e575be13fa7dad788a36e4318dc3c2277c8c8f483ff4b7bfe57d162e1e1e288970da39cedc43b9a00927602aeff65dbf84be9b6a5ac88f2b553fd9ba71dcba4352387c357ab787bc0da1f86435d1839fa87ffc44ade0fc0ecb37c4faa49919afd3f0a42687f1a6be3e005e7793f29adc55a5316e59ced4a2d2617e87e07c66e0e20da7ce70b96677baab1692f9a3232b2f29e4eee25e4751fd95dc6c36e386b58373cdf2ac65c8d860375fb9a5f3f973daf6dbb2b4e30c9fecd871c13832646313cf44a4127df75721cfcfd2cb19fad9b3e077de2576ed0b1d9919ba964fe9f49c1c8cb7f0648dbe86fe4a3cbd27c43a2b3f559b8c5d8cff00b830f574fe476535adfb926d5e9d7f8a8e3e5e99a6c98a3ed6169b3647c2e3b2e3e936ee005a9a64e27d1ddd24b981f764f1f0b3b52e96c5213c0e15a7a21cdcf283981ade09a5d0683398a66c61dd42f76ae4f15a4ea4db6f5073b65b901fd378818c3c3870bcacb1a9dbaf1fbabd2a2a318737769ff444aae99289b0212dfb9a4b5cad9beeba71db75725abab3693393a4b44013d5a772668b4083509145497d946e165024e12028245001e53234ce40292489a8052469208dc9aad4c05a02d41196a2e9d93d5267764061acadf9405bbec91fb918e1047545278b28aaca0aa28048a4254845a6aa411a5569ca653015525b77492524b13c47a61ced232b1e2fbdcdea1f34bc1f26274333d8fd9c0d10be927bba587604115baf0bf1860498bace4f58003dd6295eb6fe2d54fe0a8c4da8e2c677b95bb7beebea5c78d908363a69a057ecbe72fa430366f11b7aeba61064dfe17b44dadf49b73dbb72152ddb786f64e486b4ef4162cf9c1a4d3b95cfeabe2ac66b5cd6480bbd82e3b2bc630c2f735cedd4b5abd067c96f2e72a3365b47da6d708cf1763ca7a4ca3f04d2b116b91be4686480dfb1b459d499edc866c8e90b20e6906bab64864f59e6d130bffaa42fc9b0b3df2db90993645934991ea504b21e42af23c13b9a504928a20394c22419d9cf8e225a6885c6eb19ae7925e6dc574196ebb176b94d459fc772b2936664f339dcf0a202c5a9e4889341588708f4827bad618ccefd33fa2eb6b53c78d24b4d6b56b41a7827716b670f05ada1549cb4455cec5a3c95ea76decadc5a586ff2eeba6fd3b422f2456ca39a78b0598440d8528a4c337bae85cd006eaacad1d9391c74c4763f4851398780b4a58e8daaef6eca6126c69a481c1ed77490ba7c1cf6e5c403fefae57281aae619746e0e6aacf6974c407d9ec141231a1438f9b6df956bac3db6540a72461c282cfcac5f495b2003c28a586c29844b8bcec6ab589911d12bb5d471b625735990538adab6db1b39f9105d2b5931f4bcaad5455a18c934927644d89c5e9e3e4a95869c37a564246444116acfe983e3b770a22edbee5331c4b36368207b3a1ede9fb54e69fe96fec89a0169be50e3b3a6424f054483617423d6b5715ed7e2b48e6940c8e39074bff653c3188a22d1c5af5be17ff90e6f2fe88a450f752bc592a071f552fb6b74f202f51bfb237207f65859ac740407952040e585d264924972d97a96fd9351245a574527124d05c797153ed2de96b7472483b7215fd1b4d9b57cb10c4d73631bbe43c00834fd31b98d2f74ae60eed68b5e8ba4371b0b4a8817b71b1a31d4f70145cbc0f33ce989e147a18b0c446e56721989a0f877cd0446c887f0e33ff30fbaf2ecdcc9f51cd932f2dc4ccfe07f48f65afe2fd74eb398d6c23a70e1f4c5f3f2b07b2eef8af0b5ff0025bb973f95977ea06df9e53fc201ca21cafa2ac71708dc36e95efbf4f7d1e0fc4afe95e06eb3b0f65ee9e187bb17c3985147c18812be5bfc866678c3d2f17eae5f5791cef19656a6efeeb162e91ff52e172659f3728531f3e5643cf4c518b738ded43baedbc6134585a74ee36c924b7123b8f65ddfd13f0c43a568116b7990b5faae68eb617b6fc96760179fe1658c51ca7f8db2c6e34cbfa77f4abf4bd1ab78ba26be414e8b09dc34f62fff00d97a5654d4de8680d68d835bb36be02d196573853493636b59b347d3bbbee57cb9ef9adfbb28aea34e5bc5fab9d1b469b258dea9dffc3887f88ae7346c2763e1b7cc3d72bbd523bddc772a4f1fe4993c47a46183d51b1ae908470cce6338a0e1fe8bcef22752de95149234121877f6594c84ebbafc1a5827f4cc1e64ee02cf4fb7f9ad364267781741c691f807189d5b5bca0de641134fc059618dced6b74eeb4bc76e2e3b21c36361840a6b582a87cfcab9369af9a3775bc9691441ee15bd3b11c007c86fe11ea7991e3c6e8dbf71057a2e49ede31a8e8edf0eea399811cee9639dde7b49e07c2a3234399677056ef8ecbffb4b4e97a2cbc39bd4b15df6f493f34b9a7b6f5e9cde50f27516f40a0df514524bd7af63e41fb4d2935361191e60efb28db135cc0f2688e179f9fb74e3773a1b8b24c8807dad775ff9ad922c2e6fc3337564ccd71ba8c2e94127f0983a6597b6da49752576ba5992495d257681249da9cf640283ba95dca8dc818a64e92064910ee9bba06493a481049248a00728fba95c808b4024d2306c202293209124c784d7480903bba606c94556822ee9134a5e9405bba00bb4e3f349ea93140e45f7b2bcafea8e3187516ccdfb1ccb3f95ea7d971bf53b17f51a13a468b7b5c2d5ab3a95abdb8cf064c7030b2721c4b7af60f1cabd3eaf34d61a5e00dbd7c954315863c16440535adff5551e1ed36af31bf6db63d4f36502b8f95cf4d2191c7a8dad699b24bfcb6ab9d3e73b88f656ad7472db25e69598242c00b4d1ec55b934b9dcdeaf2d576e1cd193d4ca57f444cb6747d7658e56c7907ad84d13ecbae8725af60730db4f0579d371e427823f0b7f48c9971fa58ebe9f959da21b5676ebd8eb0a4ab552393adad2deeae46c710a8bc2ae48201a5972970b3754b6a78ada6d61e60736e94c2654a5949dc9b599380f7d956a579176a9bbee255a1590790dd8a9e20d69fc288cbd2153cace735a43393dfd9595d69ab36a58b82019e4209e0016ab9f16e18d990ceff9029737203212e7eeef7470300692f16af5c5b636cbc5d0ff00f37637ff00c3e40fdad147e2fc171a7c590dff00d2b9e8c79ed258ce9683cab581a6cd9704cf880259b9b56fc2affe43a28bc41a7cdb09246fe5aac372f1e61fc295aefda97119516463c6d25a3d5eca0833e489dea691ee476559c4bc64e4ef681ba20fe140f68eeb0b0f3fae8b5e4fc95a4c9dcfdeed46b4d22db48584937c271b10120411f28e361276eea2132b507216ac2e059d2565318f68002d0c614d16ab2aad3180034974023744ce13950296544d73485c9ea5098deedac2ed5e0169b581acc3bd9e16b56768721950f537aaa964be3f515d14eda06bed5912fa5e56d5616852e97379e14ad8dfcf652b9a0f281fd4c16d532a064ea05498448bb40cf50b2a68c52aaf11b4ec3d44844e223bb51b184b810b423c6196d6c25dd2f770513350b6ba1af0aee3bbaa0eaf954b2315f83fc179eaaeeade18ff008407e57bbf095de5997079bff5c2295563cab331a5034775f5f6e9e5d40fe1447ed561dc281dc2c6cd118e52724394eb0b260cd49c9390396365a0e4d26bbed74992585e36bc4ea770d0d2734e248039dfc2277f85d3f883aa5d21b92c91dfa770f4f4f72b8908d9933322742d9a4f21dcc65d6d27e02f0fcaf8ce5922f476d3c8fd7524d364f6f84e99a361ff00ed49d7bf829158d4b8af3b9d9236a11c852d590ba7f8ac76388754f0b3fa9e1abdca18862e9f8f11e1ac0d2bc4f4c8ccbac60b1a2ff8cd3feabda755cd8b1f16695e49e80761caf8ff009eb72bc43d6f17eae7a1d11de31f16c3a653860e3912e63bf94341d9bfbaf75c7898d858c819d11b006347c0d82e57e9ae93fd9fe1d134a01cbcf779d238fdd5d82ecba43182bb05e657ea9bdbd81dd3136dc2cf759d95217f6a69d82bed89d2925dc051e774c6d1eeb48525e41e29f578fe21da38375a6c67506802c1543c54c2efa82e1741d085a1147bf374b8fcafbba3174b5a7318336104553aca9fe93b84f0eaef90d06e6bc0506984373e3b163a9378367930752d7f0a36ecec8f32fdad57c6ecbf4f43cbd4e2c7696c66df54b02495f912173fee29dd15905c6ca2e900ecbd087331bc758ad97c3904c3efc79da4fefb2e35b10b77b916bd1755c57e769b362c7bc8f6fa47c8e179eb58f8d9d120e97b3d2e1f3dd63921a5583af90d7c2d71ab552034d2c06c72ae7891a0c4d71e5a6c2c98dee2ff00f110bcef223dbab1f4ebb40903753c7eae1cce95d66e00bfd970ba2c962073bee6b9772c36d69f70a985199b8d48bba5576b9ded69bcce970ea14ba582cb7729ff009942f7b68271331a37207e5048e4284cf19fe61fb2074ac3c1b4129e4222a012351b6ba6c2024eee50a40d1405749750eea37105dba44b41412583c264160f08bb2074ce1749c2191fb0080da762144fe53f56c9abba061dd0f74699c819249314027946cfb50a44d2072fec9ba905d94e794061c84b909349bee404477599afe2333349ca8e4e03095a1d55b207b04914b1bb87b4b548f27c686ba5b5600d82bb160473824b3a6bb2b31e118f509f1dff00f2cffa2d18220c14de16dcbd35afb66374d8857a52970dac069db2bd99951c00f51000e495c86abe2b6753e3c58fac8dba8f0a37bf50da2b1fd6acd0b18d24b9512e8c1aea1fbae4e7d53332ddeb936be07651b24964b2e99e6bb05318ec9e74abad2e65ec5a51002b6205fb2e7208a52c0ff5f49e09561ae9182edc126931098c9133a74b8d906123a8d85d9e04425c7648d161c179b634fe63002493f2bd53c2111974985ce16070a8babe6e29737615b2e7f3f0afee5e89930b7ca3e95cc6ab13476a5781e799b1398f2070b3dcd7752e975480f984f6596e82c1568258b905dd602a79a43595dd6ec985d47634530d1a295e1d31b237e695949e9ce42cea7b43aacfbab8c8246120069695d0b74ac51550dfcddab71e9f8c1bf6ab45b4c6716e76e6998f2701adb53c71e4430be3808687734ba36e363340f4a3e989b5d2d53f911189c83f4fcb9b770bf75565d1663b821a3e45aede46f56cd6a8bf4c5c773fb2ace45ff1b886e8d921de995a0fe2968e369f9ad2019411f0bab6e00e904ab0cc2681c5aa4d93c5cfb316715d5fe6afe36396fdcb6e2c4601bb7947fa468d9a29566cb4335915295ac238568c5d29552858cc040dd21ca3f64c5090b858fc2cdd4621246eb5a2ee557c8160a989525c3e546639085973c7ebb5d46a905f515cf64ecf016d5b31b5557cbd9230f5348533bb271c2bf2538b39adf2de5aac061205292588916de5289b4d1d7c8495e23709218cd8b565a7a4ec688e148c00c3611451191a4816072aad22adac69a1cec5f2258c7984575959f241fa42e82c1e9f6418cf0c7d0d82398db8ef6bdfff001fff00b65e7fc87d214a51bda8472a697ba842fae9ede3489df62aaee158770a0770b2b26a06f099c88a172e7b2f0642e45569552ce7a5a0092772659cac49dbca4d44aa9824e78093794eb6aab6135138d12987098559bf657b749ab63c251799e24c4f706d7a7c910cfd5f4fc2e7cf9839e3dda395e7de03c67499f3e5934d85bd0dfc95e9fe0cc07e6f8a7f5521b8b0e2e93ff515f11f2b7e7e469ebe0af1a3d5a20c6ba982d8dd9a3d80e15c2deb0091402e5b3b50c9835dd2b0e17343321ee328777002ea5cff005103ed3c05c959d7a56c8e5774b69ab3a76f5b5dd4b50b41167854b35c0c65ade1691da92f2af1c3463f8c3489c1af3632d567afbd7eeab7d4b6166abe1fc8ec277029753a495a0fbffa2e2f2bb74e2e977124ff00880e47a1c8c8fc639ac7ff00fa540d78fdb651e334195f5c5d28dec6e1f8bf47ca7bad996d74407c80b3f1fb4dfa76e438b4d7daa3631c4a923a79701c83bfe54ed1d23f2bd3ab967b57b2d7b6fb15c8f8d626c1ac39c1b51ceceabf95d74db02473d972de3e01cec1776784b46e16af6e1359f5e1cb5fcab9e809f3011dd751aa463f432576e57365946c71b2f2fc98d4bab174d5d1e5226e91efb2f41c4717e346e77354bcdf4b2cfd53bcc7500bd174ddf1233f1b2c7176b65e9bbd7548c74116459510488b5d2e5117b2e832d37533bc63f74cd1d3ba72eeadd0838747ff0096d4fd319f6fd946922c93a223ca542c069a42c168c35033a21765c98445c6c3b64668ec5017386cde103ba1175d5ca11131a689b295df295d2032ca1e94d4e00ed687a8d8a52751bdd0424b870d4c5d27b52295dba0bb40e1f5f71a49d90d68a2ed90fed687f9bec07f28246cec2df49b09fadbca13c76fd9465a1c77404646da5d60f0a37b1a06e6941d3b6ce416fa92eb039553a88d81b4ba8f71682df98d4c5e0f0aa137da90d3c914a605cbb4d754aa973da774ce9483b827f0ac2dbc75fe470a36bbdf91ba884fd34688fca1f3da5c5c2efe1073fad31b1eb58f2ff2c83a5c8a56889a41e472a5d522f3e373f7b638385fc21d42fc873eafd167f750df1bcf7c559ce739d134d595c64afde89b2ba6f129f3250f1b9f65850614d2bac3091f0b7c7afeb4b831981ddc0fcab91c2df29cc610e7bb634b47134990f4ff00c33efdc765a98fa50692636d7b95af2aff001870dcac63be38b4c820651e96d1bec566e407eed6c61df216c478ad845486872945d3644436268959dadb6d4c7a9db2f4ec7700d696fadeee9017b9f87703f45a44108145addd707e17c1f3f506bfcbb8a21bbbe57a6401d1e3b5a793cacdb4a0c88dbd05737a9c408752dfcf7f4c4eae7bae7333203b644d5cd6a18fd4fe2d66bb17e296f4c0751255495a1dc26f49963bf109069546452365e83c2df6462b749f8cd78b56e4a4d5522c6240055a6610ab22d59c7c7019fe253b1af07e144db68e2a6dc207814a56e0b3b8b2aeb6fb8b47575b5289f471536e1463f954831221cb55ae9d92e955e44555bf4d18e5bb25e43470282b35485c6822dc557cb0d3b28de2959739559cd9082271a50c9b0b4a6e4212ff004d24226a4d7ed6886e6d440d829d8695a112090d3946ff00535148fa72027bab28c4d4c502b99cb1722eb3536fa095caccdf5957856e80378565b17a2d4429a77e168b63bc60e1f6f652a29c71d155b5084c7f6f7dd69770141940705216e2af84ef400ee4adad099d59ac63bec71a2a8e0c2d905157f1ae0ca8cb7b15166d582d6f0bf4b9ef01b4c3b82aab8ec07c2e9fc5b1b66c48278f80d1d4b97db72382be97fc77ef2f2fe4e3558569059517269492f750b395f5b2f167a3bc53557770ac4aa07ac2dda6a02991262b1bae64924964419c81c8dc81cb395a0c9049202d42c3463842d14882bc4e8d6ce864774b09efdbf28abab62682e87c09a645a96b6d339688a03e6007f9885c3e77913869330e8c54dfa74fe18d3dda4e8026ca1d0f78f39cdf61ecbd3be9b6308fc32cc8907f1736432b8fc5ecb8ff0014095f80236ff79932b6107d838ffecbd4f4ec78b030b1f1a26d450441a3f60be3394e4c93697a378f510e7f539babc7fa437f96389c42ee6325efb1c2f2fc4c97e5f8d70a671da9e005ea18f663b2ad4ed4b749a57002bbacfc91d4d27db7571e091b2cfc826dd6b4521e6df55c17e9b813b5a4f979238fca7820b8db21af7a5a5e3e83abc399b42dcc1e60fd962695279da5e33af773012173797fc6f89a78cde86bb6b24ecb3fc5ad7b70b4ccc68a930b2db27faad18e324b5ad34aa78b6378f0ec9d26cb5ed27e375cf8fd4b497698f2078f33b38023f75339f46cf0a8e984fe8600edfd0ddff6534a697a559f50e39ecd2c96eb3f6accf1562bf2344748c16f84878fc2be1b649f65658c1262cec770e610ae3c8f5301d0bf6a690b93cf91cd7c34699c2ecb5669632569fe5ba5c9cd19958dae5799e5f6ecc5d2de035af99dbd83192bd07c3d389b49c778ecde95e77a334bb2a263b9208ff45dc7849c469d1443f90b87faae5a7d96bf4eabaefbda5d74b977f8b748646e7333627d6db1bb55e0f19e9d23a864b231f26974ed8cd5d889693f5deeb9dc6f1169cfb2750c517fe2575bac61385b73719df8726d5e2d42e4dd4b30eaf8805feaa03f8724cd571a423a658c9f8724d88ab5d8fa45d76b3c663380e6bbff00527fd643fcd2307e5cabc96e2bfd43ba62e6acd3a8c00d79d1ff00fac824cd686f50360f1bdab6d56a7535387b42c76e59777a0a4fd40addca606af98d4bcd68596260ee1c9faeff009948be5c1c764c4d2a825daba93f987b1b4166c9e12dfbaae2570ef49fce1dcd94133bb263ca8bcd0784bcc40ee16a1905291d26ca17bed4c060483b242471711eca32edd3752913f98e6a0f35c4940d3653b9482f30f74fe63bf96bf7518e53bb95120bcc156eadbd92eb0e6d851a6770aa2beaa49c198b790d250b2133697048c17d518ea50ebd2f95a365bae8f4505d269584d768d841aed8c2d27fc91b6279f64787866e579ae6fa42b18fa4c7842a3a24f622d77cec06358411bfbacf974c0e249343dd5e2cda1ca4ad154f7b587daa9509a66bcf4b7d446db2eb64d1314bbcc7b03c8ee51c3830446e38da14c2ce362d3e59b77b4b07b15720c068a631bea3dd6f4915b9d4d1fb2b58b881a03aa8ab109340c3fd2c0e65faa43b85d5c8c018c1dc3567e990f5169aba5a5984318413db8459cf6a6f706c83fc97393751bbe5741a996969f958b346ee0708bc74c99cb802aa173b75a33c4e20aa2e681768946c94ec1ca764803c00aabba6d142e697d7b24a1a98cdeb2559aa54f1e521c15cbb2aa8d0c0b488a08c1a6a4483ca838a369a4ee72692af640a12673e8a8a47d94f2f0a02af1d0191db2809b08e451b8d0510894720b559cedd4ef36a17ab2b210fa426520ec85c69465dba42a97a9c7751bdf5f721eba42fdc5ab4a255721a5e0fb2c1ccc63d56174556aae54160a989d2b31b600c625bbad3c2a7613a33d94831f71f85362639eb34a796d59ab38c7d1cfecb09d2bdf9525f00d2e872c4827730c7251eeb02688b322407dd597a46d3e3c8e65957e19cbc8be16644ddc2d1c200728de29a874d8b38c9d225c697ee0db0b98249651ecbaff0d431d485edb05857273001f206fdbd47fdd7d2ff008f7da5e3fcaff14dfc15137952bfba8dbdd7d64f4f101272a2eea57a88f2b194c01dca146e4cb0bac149394cb24c1151b91b9039672b404a31c266a250b1276a6ba52340e48b5133111eda5636701ce2d6c6d2f91c435ac6f2e278017d09e05fa7b89a468709d523f335698091ce06bc9be1bf95c1fd18f0c0d4755fedbce8ff00e0f10ff05bff00992762bde617136e79b738ddaf9df92f2bf24f1875e38d3c9bc5b8f9f83afe918c606bb10cdd62569bbf83f2bd175acd6e2787659789a7fe137e2d59d4a18323a5b2c6d7f4b8100f62b8ff0013ea5892788b0703cc718fa6df1b7b3978bc78ee5d113b9d29e8ae643e26c28587a9d540af560698d1dfbaf2ed4e1c6d3b59d1a7c6144cdd2e3ff65e90d373377bdd463b2d92ba5f0d246dcaa79dd10b0bdff72bd2110c65c7d9739aa4e667df65b3273de2b95f93a566b7f97ca77fb2e53c17119b49c67dd35ad5d966c1e6e0e4b4726370ff0045c87d3e9849e1c8ff00c2e730fec561e574db13a98cc7e65936141e2a85a3c399be48b2e8c909fec22b8bd945aec9e5685992c9f645192b8abdb46af86243278774f91c7d6616f50f95a05bd47a963f8577d17080e3c90e1fbadb680395ea53a724f64d8ae8295acf5747b846d200d9039dbdfb2b227a795f89232ccacd8c7f292b91c577f0c3bd8d15d978ebf87ad657ff0075b7fe8b83824731a437b9b5e7f95dbab0f4bf822b568dc3ed2576be1c706b48edd447faae02194fea62174eea5e87a03031a76fbbd57f2b8a3ecd2fd3c0ba8fb504e1f5dad45d60f041fc270e1dd7a1a6699b27f851094b4d8b1f834a0ea1d92ea4d09bcd25c5c5ee1ffa938c991a7d32bc7e1ca0bb4e2bba89817a3d4b2db41b3c83ff005294ea79446f2bcfe5cb376ec9c2af1a8d166a4f045825dee5caf47e24cf6b4744d4d1b0176b0525315881d3c7e2cd55945b3ffa5abd0f8fb598c579d11fcb2d7149da68f7fd9493577b17d43d401fe332379f86d29c7d449eb7c361fc9a5e79d5f9fdd2ea5135578e9e867ea2e48e30a2fddcac47f505ee68f3311ad77fd4bcd43917528e2b3d4b1fc750c8fe9c967962b906d6a45e2ac2780192b6bdd78d070ee2d3871ec29388f6c7788b02a9d96c6fe5337c49a6b4fab3a30178c099c364fe73926b2717b847ade04dbc59b111f2694c336190753258ddf872f0964c7ba99997234fa5ce6fe0d2afec717b94793191f70fd8da3f31a7769b5e2b16af9ccfb2778af7dd5c87c51aa45b09633ffa522b643d7bcc461f61791bbc5daa7fe6b07e1a899e30d5582c4b1b8fb1156adc647ae34d952765e6783e3a78e83970106fd459d82d9778eb4e04163a6703fe0ffba4a1d995138d15cac7e36d35eefba569f914a6ff00e67c39768e566fee6a954e3a49e2f92b4795bfd4e68ff55ea9870b22c0c467710b7fd82f13d6f516e686318f6bdbd6ddc1beebdc01a8a0ae3ca6ff00b0578e9ad55b25a3a76545d4d06fbab93bc03bacbca93d54deea1b563689ee02c054a571bd9492071d81a2a48b1b6eb71b70dd4c2fc4106374b7adddf75231ae924aeca5ebb16a4c28ec972b261b5a7421918ae2945a8b4904856a07b04407754b3dce75d765a42cc9cb00337e564cb55b2bf9cfec795973bb750955cabf2cd2e6f2e47025749903f804f65cd66fae6e96f089e3a546e400482a78a404d85532315ed6921558a5730d3bb225d34191b00afc6fb0160e149d40396cc03d21ca93da17a376c8eed44de149d910602c9511144a94f0a02689402f50b948f7281ee530844f20136a2738764ef76ea27395a04723b955dced91c8edd42e36acce40e72026ed279a51176e8894ac341226ed083b5248a9dbc2315dd0b7952b7845651794d714f1465aff0085346dea47237a63240b3d9131ee11451f53eaaf75caeb7135bac6508c5336ff0035bd99a8c780ca23ae63c3573e3ae7c87b882e9643b002ff0065786b5aabc715ab78ccf5f4fbab234ace1bfe867be78a0ace1e99901e1f230b2bb152db9c4469b9a39f22097ffc4eff0065c6b0df51f75d93dc31749c895c6c96f485c5fdad23b85f57fe3d8ff599785f2b6f70865d8d28872511364a0ee57d23c633bba89c8dca33cace53017264499fc2c6cb04a62924b19483ba74ee4cb2b4e9ac1249276fdc3827e5566d0d22be89a2eecd0f75d0f843c359be28d49b8f8ac231d847ea27fe58dbdc0557c31e1ecdf136a4dc3d3c16b47f7939e236f75f45f86b46c3d034a8b4fd3a36b6260f5bc72f77725795e779d148e357463c7fd5fd2f0b1b4ec1c7c2c18c331a0606b00efee56875f4b542ca0da1c2302caf9eb5a6d3b96e38839cfeb375fe9fbae475bf03b73737275b664187362f5441a2db417690c7d4ac3630dea6b85b5cd20a898dc69313a9dbcbf52f3df87819794e6bfa666d39a287b2f4dd1e3f31fe6b9d600d82e232b05ced035bd2fa7f898c4cd0fe395daf851ec7e8783283bbe16b9c3e6b75cf8a356986979dc6d775293a63007b2e6a463a4792782b7352904b2f4050c18824702780baa19335b8bd38b90e93ed31bbfd979c7d36633fb1a51dff005327fbaf40f1d6ab1693e1ecfc97bfa5b1c440f927601711f4ff0005f8de1bc6338a9a4b95c3dbab75cfe4d9a62748d2d63c8ba597e372c3e13ca82375cd965b031bef67756b203dce708793b1fc2c5d28bf57f17c50c9ebc4d287ea2477bca7ed0b971d7959a5a750ed34ec518585063b457971b59f8202b60f4b69463ffd87b2457a711a8d39a637ed207d2174899aa194d387ca981c2fd4265ead1bff00fb6579cbfa8444b05baf65e9bf5263e8c7c6c867dd4e0bcd304f5637acd12e2170797dba7074689af6331657ece0edff000bd17c2ee324739bb6823a7f0b866b981d1c2d1d5d2edfe1753a7e6361cd6b62fee5c05fe579fbd4edb5ba7cc2c7c8d1e97b87ef48c4f303b48eff003b4285cbdce2e54edcbc807690feea4fed0c903fbc1fb8b551a9ca71822db5d66a3923f99a7ff4a36ead94d3b061fcb5516b6b747d9269559a03589ff998c3f814a51ac3ab7847ecb2b6ee96dd95631d49b3546b2073152959ac42efb891f816b0dfc271c2b4e3aabc9d0b356c7eef70ff00d28bfb5714f32b87fe95ce55d27228aace1a9c9d33751c43ff003bfcc5291b970bbec91a572cd4fd3d5dc8fc1a559c3072759d763620fe11876cb931606cf70ffd489b2ca0ed2b87ef6abf848b3ab06d3934b97fd564edd33387ed6a4667658ff9c4fe5a9f856e4e99a6c275cdb752cb69fbc7eed528d57247dcc691f8a5138ac459d00349fa96247ab3bf9e31fb231ab37f99840f851f8ecb726c5da76aca1aac079ea0a46ea78e79791f94e16393449238461c6b7541ba8e39e241fba3fd7e3902e46a4d6c2e7525d64706957664c27891a8bf511767b4aac4489bcc3dcda232d055fcc61e1cd4848df707f0af151b9a0bc99e38c7f33c7fbafa6cc81b0c63b88da3fd17ca18b9dfa37b721bff002c877faafa7f17204fa661cbde4818ff00f30a96ae9a50f3cb7d4b2a5937aabb57326dc7655d8c079e566e98817931f4b5ce3eaf64e5d4dbec99c0d7c0503880da289e295b203b1e4f0af63f4c718079594e70b691c85663ca67f31a239530b455b8c998d8ac9a5979797b3a9cb3f23511d6435de9595979dd57ea57e4b7159cbc80e717176cb1f23508c388eae3954b52cb27872c39261d477b2ad1d2dc5bf93aa07b4c710d88e557c58bcd25c7b2ca89ddd5d8e72d1b20bb90d6b5a455ae7750608e6d855ad4c8cea6ec2cac7d4a71247d754e0889e9a3a7ed182b7319de95cee884cb002ee17410b434eca93da90b8c7273ea518345481db226443d2140f3653bc920d2881201b4419c6940e76e9deedd412b8ed4a50099dbaacff5295e493ba85c695e19ca27ba810a12ed8a390d940ad0890020f280d5ec9dfdd08e15941f64ede5376463b28904d449c721222c85512440176ea4ca21915a503417007baafacccd8a99eea6135ed847459a5ca9263941c09d81fe55d0e87a5c586e0f0e7194ff0032ce81fd6d05a6a969e3cae686ef62f7533d3474068e3d7538ed64ae7a49e38dce6920efc775af238cf100c774ecb399a5013798eefdd5aaad7b676a73499180f263e889ab97756e5767e20062d1e56f574b17124580becbe07fe9978bf27689c9e90bf94c51385151b97baf2c2eeea27294a8dcb2b260085fd91940fecb9ecbc11e10a2ec98aa4ac1726449746c7e56366d508abdff0065a9e1fd1f37c41aac581a6c7d533cfa9e7ed8dbdc94bc3fa2e5ebdaac781a7460c8e16f91df6c4dfea2bdf7c2fa06278734d662603475733641fba677b95e479be5c62f55edd78ebfd4fe18d070fc3ba64781806c732ca7ee91dded6ec64014381dd5761bfc7bab1137a8af9ebde6d6dcb54b1b7cc752bac65b7f1b28236f4d2bb170a01c4ca01586b6c57ba08d4d742d073b910371f5b63db5e5e430b1d7f2b3bc2594ed3b273747cb0e73f164258ff78ddbb4ad8f10c2e9310cb1fdf19eb0b9ff001043953cda7eb7a374cb3860664631e666fb8f90b2b4719db48fda1d8c4c74b202e0289d8a6cec86e2b5d04762422efb05cfbfc73a3e0e300e396266b7788c36fbf62571bacea7ad78943e3c488e97a73fee7b8ff15cdfc2bc5fd1c360f16cc7c55a9c3818c7cdc1c6903a770fb5cf1d97439063c3c5656ceafb47029676878d8d858cc83159d30c7b7555979f72b27c4ba8c7a7cc048e93235198d41890eee77b5fc2e4c969c93e9ad3f585bd6f5d8b4bd2f61e7ea594f11e363b3973cf0b7fc29a19d1b4a114c7af3a5779b9327bbcf61f03859be0df0a64419a35af1036376a95fc28587d38e0fb8fea5da98e974e1c515f72c6f7daa7496f287b956246eca94a790ba199492f4ecabb883202539e0a06723f2839efa9147c3ac70fe47d2f21c297a5f5645389dbbaf67f1ec224f07e6b8ff23815e238ee26771ecb93cc74606b605bb55f3b7a7b4800addc6352b62208e9209a59d80432189ce6d743b9575cfe9cc95cd35d5baf2ace987cf4efb4215316eca32d5ef438c29da974a70ddd5a53036a744d6ec9ba4decaab193391f49ee974a42251a489e28266ab2a4d49c693a556807a6f746d6a4d6eeac35bb2491547d26b645d23a47ba91ad45d2ab12b715678aa44c46455a4d1614cd8e264e0d27e94ed6a8d9352bb49174a6229215e242bba7dbb21ab49ad56441e81e45a7f2daeed49c0a4e89306b476b4fd23b0a4924252c6e23852b242d76ea16236f28985fc491ae043c5b3bafa3fe9cea5fda9e0cd3e671fe2c20c0f1ff004f1fe8be6980fac0ba5ecff43339afc1d4f0c9a92178774fc1eeb0bf4df1bd3e4345435bda95e6da1015cb3dba6a8de69ca279b7291e682a8f97d44295c42bce1d5c2cdc9c86b267b5defb29dcf264db958be20c6cd6c2e9b1585ee1d80b53040b3b28edd26963cf946cfab759ff00da593180ccec49a127f98b7651ba66bb761b07e7fecacb0f22671fe65959398d85c7a8dd76f756e63e92563654624712569544dbd2ae5eb79a5d5881b13471d42d0616a5a9b9dd52e477e2a93bb19a5c9fc9a03a55e548bb619984c7d4f97a9ddd559e7394e6c311b7388b54e281d23aae96ee8b851c7900d6f5caaf1d26723a1d3a11040d637b017f95ab170a8630b0296835bb2ca7b4724a586ac28cb883ba20ead946f1b82893f5289ee4f21a51756e512670eea179a46e7286472b476a590bddba85e6d48f7282536b485240e4285c955ab2813ca41155264449226f29e3e4a3454c784710b42a684595122cc6280239ecb0b51ff88cc2d1c3362b75c447139e7868b590ca701237879b510d288f121209e9e169c4db143940c66df27857218fa4071009f63c24f4d26749b198e157c7752e664e36145e667cc238fb7bbbe02e7357f138d3e574181d32cedd9f29fb587e17159b99366e599f2e474f29ee780a694dfb656be9bfa9eab36a794e2ea6e3b7fbb6378af7fcace3c9516012e712762a477257de7c3d75821f3fe6ceefb46f5138d291ca27f0bd59e9c71d809b519e51043dd6366864ce4c7949636492629d258cd9ad6a602cab3a7e1646a7a84185a7c664c995dd23d9bee4aaed8dd2b9b1b1a5cf73835ad1c93d97bc7d3bf07b3c3787fa8ca7325d52717238f1103c342f2fcef2e30c6a3b7563c7fd6a784fc378be19d21b8986d06670ea9e777dd23bff0065b0d1b593678475400f6e7e5202d7ccdef379e52ea8e86c16ad462941137756e314a884cce02b317655d8ac45ca0bd18b0a42dd94717653948ed12ad2461ec735dc3b63f85c40cd678635138ba987b706479306496d817d89ecbbd70046ea86a1a643a842e872e36c913b969eea2d1bf4bd674e4b5097499e6eb3aae15f37d7ff0075cfeb7aaf87f0e07176af8ce907f2444b89fd82e9f23e9be86f3d431230eecaee9de05d1f0dcd10e9f034f3d5e5eea9f8616fc9a799e9fabf88f5f91b8de1ed30e3c0761973b08681efd2577be14f08c1a217e4643dd9daaca7f899936ee1f0df61f0bb46e3478f1b58d686b46c004ce68adb85a5295aa96b4d948465a4826c8e49144a4e6fa4ab0f14ab4ce24505ac2aa139eca9c8580fcabd2444f2ab98ba4da915ba1cee3848461bbf7564390b872506278b99e67853556fff006d7836330365793c05f416becf37c39aa33df1dcbe7b0ef4387b2e3f33f8db03670e56cd139a241437a2b5e293af0c3dd45cd15b7b2e674101f3cb62e9745a737adee635c2fd8af26fdbade0fd3b2554a402c267357bce64286adc14ce6eca3029c105868a09aaca76a21ca89483a52aa523b942e510842f1698354845a4052b423b074a5540a32888b6ab49c748e35619c28636ee55860a549492672272602ca884a13ca9182d278a29daa643f4a554a46f098a88402ad338523282acab0602d48d1486a918e12106ab4ba5124ac90d55273ca202d35514904d46dee99bd94ace0aa49076920021765f4c7566691e30c5748ee9c7cb1fa77fe4f1feab8f6f0a505c583a2c491912348f706c2acf4d21f5681efcf7299dc2c2f04eb8dd7b40c6cc0e05fd218f6ff4b872b75fea6ae7b574deaad2807959f3bb9e9562726cd76551e439d5dd525bd438a1cf90ad689ae6827e155d3e2a04ad095dd3101576a23b566ded89e202f934e99af734b48e0af341096bf9a23fd977de207020b5a77ee171d9a3a38164ad040e0d70f51b54e68e306bba9ba4f4ee2901603cf6530284acae1035808f95a4ec72e8cbbb2a7d14ea568656361d0c86dadbc573639ba7dd62553c1f65ad148ca61eead2ac4ba08246b5c37a561d282e146d62b7205734110cc68dba87eeab2b726df9b49755ac76ea0c028b9a9dba847b7a9aa8b459ace1b5aacf7749514795d7c1047c219dddd171b9f74a290d9299aef4a02edd5a3b4481e6946f36d464da89cb4865600ee9392721565248a21c214ed4546d4485aa402d44866f2ad422c85001455dc760144aaca51e734fe91e07714aa431b591b18e354168e690612d0b2c0ea37ecaad2abd0b19605f09f54c9661604f90f35e5b0968f73d93e2b49008581e3e9c33121c5ef2b81530ad9c4f597fadc29ce25c7f2774bee42fddc7f34a485bd4ea5d311d39ecd3c18ea3b472b2ca689dd0c0d49ff6afbcf89aebc78785e5fd90bfd3b285c6d1bbee4122eeb30aa3721289c99612d0299c8d00e565669064ba88e363efd9173b00493d872baefa73e0f6788f2dd93a81747a4c0ef51673338766fc2e1f233530d666ce8c54db73e92f84bf512335fd462ac68cff00c2c4efba477f57e17ac971b3d47d5dd331ac8e38e2858d8e160e9631bc347b217f2be4bc8cd396fb976446a3491a6ca95aa18cd1b5698dea16b084a58f853345aae3d2695b8c6d6ac0a314559c5eeabc7f711eeae44de95122ec7d94a50408a4e028003952363eadd034595680a68401d1b522e9e908d82ca273774814e5fb946ee15899d44aaf45fb056842b4a09ba5136126c957db19bdd4331ab561425140acf7f255d9ddcaa0f376a6001e531169ae8151177a94a251ea203b4ccd0e16df29d6be79d44b5b239b18a6afa03567746919c7de2705f3d6a2ef586f676eb9bc8fab6c1daff849a246e53dcee90d5d1e8cd8c6a0086f50e82572ba3588a72de005b70ccf8da1cd1d3600bf75e45fb763c623e11166d69984d0014a6bf75ebda58c202df4a89cddd5a73685fba8fcbb75ab44ed12668a09d82dc51b86d49a36a944116a6aa521dcd25d1690b4ab916520d53ba34c594aca22229277da938514405840d177522602913544a4c92342e51004f0a48b84157b29583a76533d104e4c8c8b480a555a519169aa91390d5a9850bb852200291016ac0920935a9c8a40908e53a702ca8940d88c2668a44aabc7443ba961774d1baeca21c146d203774ed2f42fa47acb3035a9b4e9a47360ccf531c780f1c2f6b69b8ec8a3c11ecbe598325f8b3c19307f7903c4807bd2fa4b43d49ba9e958d9719b64ac0efc1eeb2cb56d594b3725578e3ea72b320f5da18bee2562db7e96183a1a02afaae70822a67df5b2873f516e3c4e22ac7bae7e5cd7e5bfa8d576a4566748e573a5791bdbb9a5467c279712013f916b73130c589242001befdd5a9b3e36fa1b1b2c772af11e9358e4e1e5c670929c2bf6a53c180647003f75d2bf51a36f8227fe546fd7dd18a66344df90a66ad231b2869351925d4d5424d2f1dd259e7dee95accd41f93297bcedecaa3f207734ad5aa7f1c13b4dc668d85fef68a3c28ba37dab850bb300140da80e73ecfb2b329a693498a2ec38d7c2cec981ec76ce3fbab1fae366d46fc90e06d34acc6944b1e0d9724d6b89beb23f09e6cc8e3bea3549b132999928643bbbba89afa442f6379cd20890d7cad36c8f737d4a1c781f5b8aecacf96d69dd5161b1c7a45a7ea431820fc2271a250038da8cf2938d94c56b56563390a2721565093b53276a1236f214a0590a26a95aa25584cc14e57602072ab43cab24d52acaf08b30824d2a4d66f6ace41b71411004efc2aaeb78edf42e2bea0bef51c16fb30aee6168dba785c3fd426f46a1847dd855b176ceee555dc401a438aab0b6dc15fae9a1d86e574c76c53021d642377d8a2c77753df5c5a965e17dff00c77fd30f0fc9fbabb944549eea33c85d56650670b4354113b940e5859a47413ca575b9d87ba702fdcfe395b5e12f0e6778975418b843a2361b9f23f9236ffeeb8b3e68c513366d4a6d2f82fc3393e26d544003a3c18cde44e3868fe91f95ef78b8906162438d871b62c785bd2c637b0f9f945a469783a2e9b0e0e991864118dddde477771f9533d7c9797e54e6b4efa76d29c6001ddd3036531759a46de1714344918b53b4528a216ad0141583345bd5b69b6d2acde55a89bd54922681b441571a2c85599e934adc2cb215605c885352723670a3772ac180b214fd554142d44a2459886f68e4410a95c2ca8842a3986434113600c1bab01aa295d4295a05598d7daa94ce147dd5c78d8954720d02ac33e6360aa4474f5156de6c955a4415dce5116d9b5398ef751d6f4889667885c23d0b39e7ff002885e119cc639ac25b5b72bdbbc6eff27c2b9eef8a5e19925ce644d3c2c3c8e9ae05ac4788d8c6f62b5439d242c2e175c2c523a618c5d6eb7f4f6b658fa4eee0bcabf6ed8e9e2e29a7652c5ea6950f73b5a38f93b52f5d8c0fa774cd3b908908fb822d24fe13305a37f289bcee92a8da285f35daad4d83859ba8bbfe0315d280779386b55ff0fe923543e74fd4311a786ffcd3f3f0bba6b19146d8981ac8da29ad6f007c2d698fd6d8df26a750e471fc2991e5b8e4e742c96ac3032c13ecb06485c0c81ede97b1dd2e1ec57a6189e5c1c3d4d06c85cd78c3018cc9197033a6299beb1fe25392aa52f333a972063f9a47141248436289d23cf0d68b25339a1c7a7e765d1f84403a9c65bb3c0f49f62ab0d65cdb184b9c08736469a2c70a2122d2d3baecbc59a275cdfda31b7a1ed153b7dfe572936ef047046cab35d26b2ac531168cf29942e66b54a050518e54c3ed5019a9c8b40794638400e6a70dd94805a45a823e94fd28c35135a9d0102821ab2ac8603ca711b54458e2a754538becacb9801d9006ee55e2db3428aba7e51385a789bb23e9559210f4a62294e452128b142e0d759e17adfd1ad4dd26065e9b2badf0bfcc8c7f84af23dfb72ba2f036a474bf1660e417f4b25779327b51e3fd545ba4c4bdfdcdbb03dbfd550cbc818b192e167d9693fd3d401b17db8587ae42e9984b795cd3db68b6dcbeb1a8bb2c9601d201e15bd1dd75641e9f759b9707947a88b728465c9011201429212e9f3733a6136401f0b125cd613bba87758d99ab09246c5197493c869ad6736babd1bc27198593eba4be670b6e334d068f62b685ebe984fd4319e7a5b38db9becb2b2754fe33a381ce7d7711af4e1a5e035bd3161c2d60e006f08db8d0442a38a21f86ab4368b3cba1767ce07978f90eff00fb7b29ff00b33569c8031cc60ff33cd00bd3bae9b40d7ed4b3e77db9dbda94cb853e18cde8b7ea50b0ff0081aa99f0fced26f5173cfbf4aec6720ddf0aa12c06fb052ca6ae464d0727b67bbffd55525f0fe53ac3750901f814bb19e4639db283671d94f2676ab9383c2a4bfab272659077b5d4e8fa445850d6346083c92ae411871a2b4583a18035636b2910aadc77f7afd933984136ac39ee05432c8e59ac80821a69406f7b533ec8dd42785a549077427908bba13cabc32b13fb21467841dd591249c2644de51591b05b54d0b546d16acc4d512aa789a3ba799e40f844d3e9af65527937a5595ea17bc13f2a588d80ab0dcdab31765559a107d8171ff5162a7e049fd36176107b7bae6fea247ffd3b165f6900535ed13d38b8231d567b29f22ba6c251c75ba8a69a896adabdc3094b83c3ff002a772ad80298effa94efe57e8be07fd15787e47dd0bb92a23ca9645195ae467583141b5ef7fb728cad6f09786f3bc53abb30b0da5b1377967fe5859debe571e6cd5c7599b74de94dfa17843c379de28d57f49804451b379e7ba6c4dffdd7bee8ba2e1e87a74783a633a208fee791ea91dddc54fa168b87a069b1e9fa5462381a2dce3f7487b92ae486816d6c3baf91f33cbb67b4c7f1dd4a7140401c1b50bcf53abd91c86815106deebcf96870d46d6ee935aa568a500da282943f6a50a90709024636cabd08a0aac3c2b3172a644ec1655e80510a9c4aee3f2a05a1c2128fb20281249276f741671f9565ca0c6ecad240aee340a8760092a77f2a9e54b4d2ac84533dad04aca9e4321d94b3bdef200e145d35b1e520537b0dd951b9aae3c52ab2775615e42ab3b9533b92a27d6d7eea512e77ea09af08e66f5b8ff75e2194dda3376bd8fea36534e8e3085ba592e5247f281dd78f67b9ae8a31b58ff35867e9ae00b64b880f636ba8d11a439ae009ebf65c8400970fe90771eebafd05c5e1f2802e31c1f65e465eddbfc78b74a768a56437643d3baf5f933440d266fade3e14dd3f16974591b526f406524114a4c68ff51332302ec8b1da92919415fd3ba31715d39fbf857ac6fdb1c93a874395abc1a635b1431890b5b4d6ff0028f95424f13e748d247e9e33dab85cfcf3ba6797bbba8d86ff0065bdba6158dfb7a0683a9bb3b01c32ba3f52c3bf47042b1af42cc8d2a46cadb01b6dfcae47c3393fa7d45aeecf1d25776d004618e1766bf629dc235a9dbcb226bba5a5fcf75a1a34c63cc1d2ee92dee87528062ea3363bf6b7931fe15cc7c57c4c6978d8f0563c7db69b7a774d3fda1a7b3addd00b7cb77c85e699f8e71b326c726fcb750fc765da68595d465c29b68de3d27d8ac3f1ae2f95958d96d14c94743be4857c9531d9ce114535d22f81c203cac5b080eea6ab6a89aa76f0a48425bba3aa088f299527b58aac04ce750a49c690389354ac4a588db138345440803e510722b09ac91b22ea0457750877c5a669b7714a164c508e50bb94829813351f651b4d27ea559ec19513911726bb480ed161138bbca263fbd9ea69f6210236d8a5323e88f09ea0dd53c3d8394cdc3a3009ff0010e55eca8c3a237dd79c7d1dd55c3f53a338d0bf3621efeebd35c4169da8f0b9efdb4a394cbc41e7d016a376971cc3a1cc3bfb2d9963fe2d29e28ba4dacdac20d1b43d3b04b5f1e334647fe67b2d6c8642d04823a8f348222780b373cc8242586a96b5b2d1dfb5997218d340d2af2e536bef03f2b073649dc4db8fecb324949243893f957e4bf28fe3a49b3a21cc8d54e6d422dc07837ecb9e73ba8a122d391f91a33678b2d61b54df2b9e5035aa56b539296b180baae54c18d6807b94cd69da9481a7ab74995070f3bf0acb652011741570ea1484926e954148edf9b41f724daadf9426ec7b24126077a5149f7295dca81ff71568564c10b91042e57850e3843dd22682518eeac893b51b79084f652462c8512aa468b2acb1bc2880a214c4d0b554c1e5774b55391c5c364f3cb629576ee5164ec240dd5988d80aab15961aa494342075ecb27c710f9be1d7bbfa1ed3feab521770875c8fcfd0f2dbdc32d549e9e63338b6334a91276255c7b83a305fcb80549e7a761eeba7130b2ee9e6d8ff00ca9dea0c21e871f952b97dff00816ff861e1e7f7746e41dd48795261e2cf9d970e2e1c4e9b266774471b7924ab66cb148e52b63a6fd25d0f47ccf106ad069da7c65f2c877755860fea2be92f0af86713c31a4b3030875bf99e7228c8ef7fc287e9f782e0f08e91d2f7365d4f240764483fff0011f0ba279e9690be43e43cd9cf7d57a76e3a71855928591c70a8ccedd589cddaa845af3a5aa23ea28ba7645d35ba437dd552268a48f64fd925121da8c7010345b8053d74d0500dbc2b10f2a060b566114505b845abd00a2aa47d95e87b20990147270102049dbdd32767282de376565dc2871f8523ddd212041249c859b903a8ab928b2abbdaac2b363a1681e294cfb3b3548c80100b9210cf9d9fc325664e7b2d6d48863080b1a4df75615dc682a995911e3c134f33fa2289a5ee77b00a796f806af65c1f8e277ea7abe2e818efe9818d1919a7dc0fb59fba8b4ea36988dce9472669756d3f50d4a60e632615046780c1dff7e579c66b7665f2365ea9a8b845a3cc070d6d0f81edfb2f2dcfd9cd3d8ae499dee5bd635e94e13b91dad747e1999fe74cc1f67495cd460f53ba782b67429dd1e4f47f53485e7e5edd11d3ce86663d6d3307e52f3e3771232bdc28bfb2311c486b1dfe6a393458bf95ee1fbdaf63f1b9bf32db66847fcc603f2695989f13c5f9d1ff00facb9cc8d33ca269ce34a8f93cf3fba8fc67e675d92f88ec25613da8da1943a7c78c402fa79a5cd6343eb0ba0d3e638e2c0eaae42bd3f544db940e2c2c87ecd8dee3de949261c90b419627b1bee574b89189d8c92024df207bfb2dbc0c512b6dd6e68d9cc22d744c44fb61cf53a79fe239bfa96343adf7e90395e8b860cd85179c5c1c1bcab3162c18c09c68a2889e4f4ee987517f513d47dea922116befd22c7d1f172f5085f950b657b4ec55cf156931c1133203436368aa0a4c790c533257748683b92b4f5981b9ba796b49731e2f6eeab7e8abcb86408f518efed256af8c3186468ce92075bb1c89297339bfc2d465a05a1aea00aea74599b3603e190750734dbbd952ff0055e3b71040ab1c3b71fba0e0d2b1991791298c0f4349a2abac5d91d1c72a7670ab15623fb144a60ee4d74888b41d401a2aa99452bb6b4310bf527c868ad90404551578e994f69c34756ea40d15b28ba837845e66c891969ec9ba4f74cc9d97451f9b1945a43d28fa764db3b8eea56b6b6512ac07a764dd2a42d441bb2aaf087a4f64834d6ea7e82784bcb3dd3925111402268b1f28fa292aab48b12d0d0b53934ad6b13528c90e81c0b80ee3bafa0e19e3c9c68b260a314cd0f69fceebe6d67045917dc2f53fa55e2166460bb46cb786e5406f1fabf9da7b2adebfd4c4ea1dc483d44a7670a57341af73dbd9579adc057658cb4adb6b17d22d50cbdedcacc84f4007d956c816d558f4b430f245b8acb99bbade7e3b9e4ed6a0fecd99eef4b2d5a2cb301f1d6e9e36efc5ae81da3cc1b6e601f94ccd3ba7968bf856e5b476c96c543ed4fe513c356d0c67b47dbb28df1b9bbf4a938b3844f0dd8525d25bcab6e2ee2a946e04f284abb8d2122d4af6a66b54aa0e9d920d53914146e356520944e14542f5317750b50bcd2b42b28ee8a1aded0977a93936559430e54838408da809a2ca9a314a3ec8d86904a0d151cb3721273b655dc6c9408bac5a761b2500e13841334d15623374aab5588cd0417e1ecae48d2fc49d839746e1fe8a963fa80f85a30ef42ac0559ed13d3c62425ac746ee58e23fd5404d90b5bc4b8bfa4d6b3a1aa6f5f537f056438eed0ba31b9ecd0c4350feea626d57c4fee94c4d7723f0beefc29d6189791963f62e92e7318c0e73dc7a5ac6f2e3d805f40fd26f021f0de2ff0068ea8d69d6721b6187ff00d1d9edf95cafd0df08feb729de23d4222fc784f4e1b4ff0033bbb97b9f4d6e4d93bdfbaf03e57cdfc96fc7474e1c7c636aaf15ff00b9e4aa932b537dc55494d2f15baa4cab16d0b569e37255595c48a0922bbdfbd25760271193b948eca9291b51f650872269b50258f90a768b7050354d19a282c3451533142d3654f1f2105c8380afc4a9422e95e8c50080cf280a27a8cf7404a4885850b3bab70b69a4fba0b308a6da694758b4f17da51016d28293dbd254122b720a2aacc2f64800c44ed9b6800e9349a779aa0ad0852ca02426d63e490d79685a99cf0d6904d6dbac2ebf39e7a07a47255912af952478f04d9133c3238d8e7b9c78143baf3df0a0398c9f51cbbfd567c86575f6670d03e2a96c7d52cc7b347c4d2e077f135199b13cfb47c9ff00659a0b6101900e80d01807b01c2c73dbd69a6236ac1d263644311bdbfc979b6a8d23a9a77ad89f95ebda2e0fea9eebddd767f0bcd3c6b8870359c9c72299d5d4dfc159457f569fd7398fe98c85a1a501e7464aa0fd9a47c2b7a5c803d809037eeb8b2d5bd5ceb6025d405a4fc400fadab6f4e644c07cc6ee16acf009b15c65635b7c11caf6b8bce9701a863546e209a1d82e71cca7122ba5775971011c8d1db65c7e547e5cae09c5359578996f15c2d7c7690c142c90b321fb82d786ba45ac6de9d58e1b7e1a99d8794ca23cb71dc15dfcf1187a7a1cd0c90595e5f038b246bf7a6ef41758ed5a07f8798cc77bdf9bd62c3b80d5ae3b6d865afb6bb26b791e637cb0b3f52d771f1416c63cc77b017fe6b9acfd42573008dc595b6ddd6af86b47832c7eaa6ea708cee0f04fcad58ef5e95e276afac65b5f1b666639da9a29a17a7e1c061d2a0c771692c1f705531b78c53591b00d9ade113f21ac0407503b10a26531db80f1e62c6ec88b2e0674f512d7fc959f819eec4e901d4cadd6f6b7978f930e5e34e7a58df530fbb9713148e7bbd7cf7549e9a2eeace64c5ae89d6d596760adc8ff004968e155a1c95cd3dbb2bf544795623be9d95792ab653c3fdd85648cd77e546f241e2c23770a178b501a436d3b526c6ee99cea042688d9a578e959ed67ca73bed201f94bfb3a77ee1cd1f28e1d9c02d361a01447b677f4ca1a5651fe66387b94e74dca00d08c9fcd2d9ead91802acab7163cd80dc1ce1c47191ff529063e701bc4d1f836b6e81e05a95b0bff00a2c29e3fecfc9fe9cdc98f9dfcac23f083a335bc823f22d753e4baf8fd94790ce81ea14a38c1192ce68499adff00fe537eb331a778c9fc356d534a7a0384e3b5bf2598433b2baa8c6e1fb52b2c9e422ded3fbad3a61e794ce8d8e1b27e3d11925404e41b2295bc3cd9b0f2a0cec6244d8ef0f6d77f84bc96da36461ae042715e323e80d13518f59d331f50848e99dbd4e6ff004bbb856dd1d6f56bcbbe97eb1fd9f9b2e9990f0cc69ddd6c27f95decbd6437d23603dc0ecb966ba974d2cae5bb714a2923ea571ecb40633d9652d2152282cd2d16c4d8e309e20d60dd0643c81e9485d5b21c2a82a7d37dad14ae21d6547d77de94b48e89f1db78a50968734b5c8e49ba40ded56924b77e54c2a83223631c2942f16474a395dd2e518700492ac8922c04eea3750d826321eaf851be4dd4ab27ee8243499cfb0a273b6290aca37b85eea2790784e4da07f0ad0aa33ca76729ead15552b2082306922987080ba922edd0842e406e7289ce4cebec876fdd4c091aed91466d07644ce54c89472a78b950354cc34ab285e8168406bf75971bb857f1dc3baa8e3bea56249166e166b3fba918637fe5714ed891ecbd5bc6182dd4b409e33f7c23cd67e42f27ebf318d77f9fe56f8d9597a1da21eddd6c786f43c9f11ebd89a5628f54ae05eefe98fbff00a2c7c416d00f0795f40fff000fba09834aced6268c19321e191b8ff485f4f93ca9c3e2c443ce8afefb7a6699a7e3e9ba7e3e16237a20c6608dad453b89b3d95c7fa450b3ee4aa7236dcbe6a666d69b4b7542392abcbc157241455598d029028ca69aab06d953bc973880931819f95322170a50385b959c834ab347754949ba09e13b1a5a37520169fa5404d16a468aa4ec68eea5000e1201b385344a16f2ad42a645fc6ecaf37b2ab8df6ab4d51005dca8dca59385001614c89231602bf10a8d538051577fe5950133ba998695788582a6fb5890209df44aa7c92ac4c6ec2aaf1d22d58290d35567c81ac24a4f9459b543372408cd1a3d9210cfd672baddd0deea3c38bcb80977ecab47119a72e90d81bab13cf7e969a68dbf2af089e9e65f507204fe2cd3591f18b1993f77152e234b9e6577f76c05ee2a8eb113e5f1ce679a47a636000ad7d471cbb031f4e8684b9b206923b3792b9b3fbbb6a7a875be0ec6ff00e863264653b2497d7b341d82f31fac38e61f11c723053258ac2f64c12c10c6c66d1b1a1adf90052f34fad58e0c9a74c3bb4b55e6bfa294b7ecf257b49dcab1a70a3fba67c69f059d5935ec2d79d95d9558c4c60d7b9c0ddf2b45ad2f688ff95522e74337e55d664b5a5ae6fdc17b4f3618bac40d843806d13dd7059d1797339befbaf53cf7c12c6f3b591bdfbaf3cd6630325e4557c22d0c58c5396a41f6acf68a2af402c05cd91d54e93b5e2e88b56649cb61abe91feeaacad517ac8aec15b199ba4cda7c8d24aed3c2da8b31b1e4c623726c15c4b1c7822fd96be9b40b4b9dbaebac3865e81167376eaecab6a13503d1f6b964e2cc6b9b569c1d2345a898d7b431753c3f32dce34d2b9b7c46291c09bf65d56b1950c5018df234c97b302e5a694bdee2ed8fb2cad6874d29c83d56c215772981b6941dcae689f6ed88d42277051c3f6a17a922fb158939513d1b907ba844217709e0aeadd0bb9450fde15bf8acb4e3e9d96a63c45cc1ecb2e22c047bad5c46b8c7e91698bb679ba5dc6c212bc349ab4a7c6f2e47348d87752e3c527ea223d5fb2d5cf87cf600c1ea0372b77230e189a0dd5ad18e3716821961520da774f71b2d7d39a4454ee144f49843e5bef66d2a7a841fc124f2b5dce01fd205aa3aa8a88ed4a911b94cb9b7c7d2e4c1aa793eff00dd3d5abc5559552cb29ba08e14ee68bdd4d135962c58569aa23b53e97236b09e56c1c585f10706ee5517c618fe969fd9575a5c2d639ede924b7b870e42f67f01eb4357d21b1c847eb31bd1203f711d8af2089a791c85b1a16665695a947998ae00dd48d3fccdf65964a6e1be3bf17b739a0807ba1229361654793890cd0b8398f6f56ddbe148f20936b8e638ce9d559e5ed5e47ffa2ab24f5b29659075ba96664cb4e2a25b5413cbea2544d96c2a9249d4e2a36c9d24ef4a6ab2e48013655599e5a538999bd9b2abcd2dab0173ecf528a5968a8a493750b9fd4eb53089e963cfa4ce9ec2ae4d850f99ea5666b2e96d44e7752027605206d2159ec9c851a70ac8035126ee9d03390a5dd3dd2040d207b9139db285c493b2980576928f7eea46ab03ec8da85bd948809aa66285aa56f65122c30d2b703c03baa2c34ac446caa8d6e91242e6817d408ff35e33abe33b0b51c881c2835e7a7f0bd7e27d8002e0bea2618666c79510b0e1d2569823766578db134e697b1c00b2f3d03f75f6278234cfec7f086998754e11073bf242f98be9968eed6bc4fa6e1865c65e1eff00c0dd7d75331ac606b3ed0037fcb60bd0f2f2f288affa7271f6a9234b8ec81ed0d6fca99acf4da8723d2c2b8a12a72727d96764beddd23856f2492dd9556b1bd365488047d26d3ba9dcf64f21078503924413d975760a1077a52bf929982c2a831f6a4d34144e751520f535244e3d4148d14a16bbd08da6c055812b45956e0dcd2aacecaf6333705585f8474b694ed5083c046385121e4048d9031a7ba344ce540288539587701423ee521348248fb296534c51c06c852ce011ba40a4edb7597973974943b2bfa8ca22650e56207dd93cab027ca03be565e5bfcc93a6aed58c971e9f4f3d959c0d3dad8fcc945bcee886598a56b435add8a9e4898c880737d4452d392265d91442cdcb707123b2d2a8796f8c1a31bc5ec946c678a87ec569e8710ccd571fcd1d5e4b091f954fea8b4c0ed2f5002e38e5f2de7dad6978165191952b9c6dc1b4b9ef5fddad7a76b8aca23e69707f59997a6e149ecf5dec6e1b01f2b88fab74ed0e3245d3c15b7f197ff678dcddfe4a1c1a664751fc22712e20d50b4d0f2e5e5e4fb3bebd3433a16920446d471b4c71d38595b7fa56b3d4de163e592cc82d1dd7b0f325432dceea7d8a0b94d723687b9ddd75b9cc73b61c816b94d5e37005cfe6d4223b60107a81ecb471bec0a93c10e14af639019f2b1bc6e1d98c52717edf16a4d39d13c38383cdff0085135a1fd3d4d0412365db68b2386148c0c88c3fd35655b1d4cd6d7a713910745b984f48de88a4d8731f31b6ea03fd56bf88a3742c967823a8dc371554b9689ee34f69e7bae88727f5d98d47171a10f95ee2470c68b254197e21c9c88cb2087f4b0915d4e3ea3fb2e721123ecf55fcab018f03771af858e4be9d38f172175df57777771e4a8a436d4e1a3ab924fca173762b9e6770e9ad389c7f763f2a17a369da9048a8d00ee14acfb4284f0a48b85ac74a4f6527281dc295dc289ddd673da113b84f03ba5c133b84d1f236b5a5496945bbc15bda63ae277c2e7613d6e0daa5d1e8ec32c4f03b14c7da99beada8435cd61eeb4e37b5be60f858e0b9ace8f65a18b900c1eafb9ab7971334c458f71ec5d75eeb431c7a01e2fb2ad9753b7a87bab58d1b8377e154911733aba6e8854f522d101ded5e7359676b2154d4630f88902b657855cdbc1b07b2722d59f22ca90c2c6b6c72a4548a02e75056ff004e081efc2503cf5869e5598cdbcb49a29042cc0c0c818d71a24acdcec330cf7760eeb52031be321cef50452c0c97148ebaa512b3221d9ed0af36ee8772a00cf288038f756776b1af1d9075fe08d6862657f674e7f84f3713bfa4fb2eedf25386d5ff0075e33947a226f4ecff00b81f62bb4f0bf8906ab8bfa699ce6674229d7c3c7bae4cb8fdedd98b27f1b8e3d190f1efbaa939a7b8fc29279363dc8eeb3e59ac107958f175c5904b3538a8dd2823734a0994438564f258f305ec6d433bc9e126b483610ca1c520440923743dd17412ddd26b7a42b12602d464515386774fd04f08aca1e9ea0a46b2918889e5396f4d22a170a281c9deee97a4fdf748401c8513aeb650979e0ab021ca4e51f56e9c1b44493909ec8d0775308811ec8daa30a68d5963f608d323ec81354adec811765122452c46942d52b390ab242fc0edd6478d3024cbd2c795b163ba89f65a4c354afc90b72b1440ee242187f0762a696e36da9674dffc3b787e3874dc9d6dedbf34f970ff00dcaf6270b3eff2a8f87b49c6d1742c2d3f063e88228c50f72569d505b5afc9c73dabc8df4acfc83b10afcfc159f29a05440a320b0a2737d0559736d4323803bab0a6ef4aad2394d2925e7d947d3d452441d36533fd2148ed8d289fc2a885c6c852b7840de51f740e14d10b2a368b56626a0b1037757a33b00a9b1d5415a8cda0b2ce55a8c5a82116adb0504902451437451bcd38a8cbb95504d3654cc16abb07756a3e10207a08f95664701b935b2acf3412ca3d41a3e108646a8f25e77b0b3d8d74be9672af498cfc8c83b580b471f15b081b51484ca8616961a44928b2ad4f43ed14aee44a191505925fd44ab42aa794fa59b37757f2bee545e2cab6f439bf16e99fdafa166e1816f7465cdfc8dc2e1fc0fa83b16581ed23acb7a1c0fb8d8af5594102dbcaf26cfc47681e309f1dc3fe1334f9f03bd9ddc2ae48dfb5a8f5385cf21a1f5477d9727f55585de1bea1fcaf0ba5d2729b9b851c80d960a2b13ea54664f0b4a5bcf5056af4acf6f0e7751a1fba9a08dce75290c25b45df7529a160e9b2bcbcbf676d3a6ebb218212c63ff6597931b6221cf377b84f1173657b4b772765365c65cd6878a2bd7796cd7025c4ff002914b95f12340737d86cbaec8608c8f61cae6bc49d1c8fb4f0843929880e14ad639b680ab647de2bd95ac5fb165776e2e93f9de4b76e42bbe1dca9d9ac413755c6e3d258a8385b485b1e0ec63267f9b2b1de5b3827857c3d2b9dbbaac41ed91aefb4d9a5c0c8d31c8f8d8cf4876e57a2ea318f2dce0793b0f85c0f883f839a05d58b5d3fc7342fc11b3c8b02b65096000909f479bcf6f37411cbe92efcaf3f346a5dfe34ee15da6dc50bf8e2d203d7694aa90da7b443bed481c9dbf7142e5219dc27c716f427828b1fee3f8578e9032772146eee8dedea43c6ca9fd250b9330d3913d0b45b95d56a6301e51256ff0085a473729d10e0eeb9ec37d0a5b9a1b7fe3237dd007755a768cdf574ecc60092e6f52188b1af7023f65a59c29cc31bb91bace7e3b9cf2e0edcecbaa3a79f2164cc69200aa52b5c2420816a0fd0906deed8ab1144c8994d77a9420edc7a24dfec9b2435b03bdd3ba27b9e3a9dc21c88fad9d2d36524604ee3e60f64e5c64a60e4ab8ec090d93c20641d0e1d5d94c741b0f0cbe66879af72accb8de53dc187a81eea589a5e7634aeb309dd21dc8eea606135af8e5b02a94933a479ea57357a8a5680dd88a59ee90b46dbfc2b4fb13be3f4b4b8d295cf6f96074aabd6e7c75554ae44d1e5027b0559820391ea6341142967c533f132db240f2d91a6c577fcad6c82e307a38ad960bfafacf5729adc69789d7b779a678822ce6b59927ca9cedf0e2b48b0bac9a3f2179a45d563fd976fe0b924972a1872dde63643e9174b9b2535edd78b2ed71f19bd9406337baef9fa3604cd3d50107e1ca9cda061b5a7a4387ef6b0e4e8e4e37a292e95d1cba4e3b761d4a96460b5965b7b7ba458e4c9e8b4bcb565cda51389076561188c7749a435db24e24bb74c921e476e147239271e9dd44f94725560ecc5c81eed94724ad2abc937f4f65638a795c7a7655fadc10125c3a8a388750052107165d654ac4d7bd226abc339ecf74955a76a252905522672880b441aa426f2a4ec800a4638405d91b7b206a93b0512981236f642d4f74ab2b2788d382dad023fd46a98b17f548161c6edc2ddf0b4859afe091ff9815513d3e8488550f6007fa291ff00620683767beea43f6ada3f8e29ed524fb4aa2f176afcc2d5395aad08547b7759f3bbd442d09bd36b3a4f53958562db29c537952b852864e0a4882620f0a1ab254bbf64c480d3eeaa21028a445a44da922e10130505663e1463b290209870aee3f0a83780b47123d81417e05328d9f6a206ad003d4639288fa9c95528904cfb82b6decabb05a99a76a50406604f08a1679df71d9bdbdd0bbbed6aec21b063dd55ee516942d89b144e92ba1a39555d21901756dd8a59990647803edeca0926e96f4a42a1c875901557f054c3d5ba67b4f49a568433e46f5155641bd2bb35b45954cb6dc4ab0aef603b1e1739e32d04eb5a53843633213e644e1deb90ba82d42e1b7b1437a791f863c412e14e63c8fb03ba5e0ff2aec3c572c597e12c99227073080452c6fa8de1a7899fade9e08674d4f00f7fea5c8606af2e3e999188d707c13f2c77f2aa4cf05a237ed8f3b40883bbb9a9a26d42c3ee13e41fe1555908319c1b8ed077bda970668dcedd38fa6d63c7d4db7398076b55a7c888cc4075b9bc27769123db667dbd917e821c380caf77a872bd5879acec981f338bbfe591b9f65caebd0f480c76e06e0ae9b235032bbcb60f4f20ae775f797024fe144f698edc864001f615ac5fb02a93b7f88ace18a59d9d9897e01d2ebe7e3dd75be1b6b4bdcc60e969debe5726d1642ea3c34e687bc3b923656c48ced4d4c7a1edeeb84f12613f2660595d60775dd6a2e0f8c5f2173d98c6972e98e9c73ea587a0e24b8f6e9abab8d959cb1d4fbf956a300135d957ccdc31df0b8fc8eddde2d946aa44d3233b9b4ce160ac61d33dab0ee81ca52ddd038512a5284f74f8df7149e9406a42ad1d293da577285c8a4d9d682ed2508dc85a2de0277a06df58a48e868404034780b7f457359d4f02c10b0627755b5decb77c3f0097299038d0770a23ec5beb2eab0c1f25a653b91e909d91cb67a7dd4d8d10f2c53b60691097a65aadc775d51d3cdb76011bff009946c998cb686db89a4ef98ca4c63ee29f0b15ad7174aee9e9e5471d2b052365764b29dd2da4c0546f20f5006ca2967f3f2008c5c6364c47497876cdaff352b102241d437006e1527b5e6c96f7d95bc722221c25ea6df1ec8b3a463656d9b2e424d89d2d8adc7f65761c960040e7b2c6eaf5103f653c66c0de9fd94ab03ce6f9afb78badd568d9139d47d242d09c931070d88144aa5163b58ef349bef48b1cc2dbd9b77dd07435960bb73d95e6085b1995c3a7e15088992674aefb78080ac36221bb95527858e20bc5395f6348b03ec2a9f513292efe53b2263b5611b5a7d268f65ade1fc9762e6e3cae37d32054a58c9363ba58af11e434c9f68dd52dd35af6f7a6ee03bfa802a198d12ab787e7765e8b8b3bfee2de92ae3dbd40ae09eddd5e99d2b038eea94f8db9278ecb4cb2aca8cb0bda4852b397c9c7759a16b325639a4ed4babc884d9b591978fd4e284308bcf55151be7a2ae4d8e5a490a94ac3c152b217ce4f0a17b8906cd2b2231bda88c66cfb20aa5b609bb51d176c3b2b9e5ee9796902bb184116ac7556c918d13486ec481f95ac5594f68a695b146e924d9ad164a58395165e389603d4c3dd0e6e233322742f77a5dc81dd4b878acc581b0c2008da365642402c276b5391488708101493b84e95176c0f289808963040eb6d9ec39535577b2b2a3d288d59d986573bab60c3c05b1d803cd2264bb231c20089aa251036a47b24d4f74aab1c3ba42dcf0b8bd6b07ffca161b40ea04adff07b049e20c068ef28513d2b6e9f45c42a309dfc2513ba99fba670b5ac74e29ed5e4e55394d12ae3c5159f92fdc8531d8a739b2ab39b56559701c950cb77f0ae2a9e4a826e15970b2aae47a4a4886e9b6a079ea36a43ea2988a055405580a460a42de112099a8c765135dd2d0a58c59442cc2cdc15ab037d21508052d184d20b2d1402170b349756c888e1120ae9d923d913cd1425db28904deca56aaf19b2158504080b34ace438888347b281a688289e7a9d68b4a89889b25472c25ee0076dd5f31d0bf749b1d3494555191068f944f14c2a70362e54f2e4f4157843332dd648559bc152cbbb9011414881dca64e7928472a6039687b1cc2d0e0e145a7baf27f1e7849da7c926a5a6873e027f8b07b7caf5c87eefd952d5a0f3719ec22daf69691f90a66363e7b73491b1247ca81b6dd8f636b533e110e4cac23a435c5b5f8545dd25c081617066aba31d9a8fc897a4d1a59b9f23e434f3615d2d2785572232e1baf4a3b79f3d325ecda963eac391f0ba27c3e9587aa37d641e292c9ab8c9c54855cc316d50e6b0798e0de159c0d9a02c2eebc4bb13785b9a4c9d12b563b55a81e5a36ab3dcf014e19dfa5b374e832e7063f5380fcac5ca9a3feb695daf813e9deb5e31c7932b11f8f162b1dd27cf7125df803b2f4167d107458fe667666334b790c693feebaab311ea5c36ffd3e7f6bdbfcae3f29b25bd50d83602f5ef167d26fd1e9b26769da8472793cc45b4e2bcb753c7762c72432b7a2507769e563e4d634dbc6b4efdb15df7929cb4b9bb2779a7f4a63cae27a9fc4047aa9c99e00e11bbef4e45da2549dca18fee52c8ddca6859655eaa58efec854936c6946965611b907f323770a1ba04ab474acf6d4c66f53dbf85bba6cefc6999244d2e78340058f814f6b0b96de058c88a8d0eadcac6ddb5eeae9e3932dccaf2fa3ab721caee3e303465eabf8e133f299fc87a88dad412643dc289a5d95e9e4cc7ed2d18db1b41e88dbd4383eca96a793d38ee8980127921470bc8bb36157cc6991ae2ce15a0943a2c85ce91b54427d5257b31a111ff79e68b1ee13e8519c77c8d22ecee96a4ea923a6ec5cab3d9fc6cb591e4be8f4c6de9dab955b27123e80e6bfa88eca2659dc386dd8ab6d792cf53457b85a474ab3636819218f01bb725687e9817c52582d1cd2866d3ff543d44d9e28d28d9a239cd21f34dd2381d4a0836a52876474b3ed500c694ff76cea1fecb4069906286b9e49af736abbb51f596e3b680eeaf155918d3f21d56e03e0a91d845bbf980387b2b0cc97965b9fcf642eb20926d56485573447217136e0d2554c77b33e1f3a23437055b918e2e24f05a5657878be2c2e8ab06471ff005555969d0b80e6d43234b7770b68e56bf9c0d5b46deeab64c6d7bbaba46fec9da61e8bf4f32a49b49746e3e969b0175321a0bce3e9ce43a1d4ce313e87b4d05e8e4585c37aea5df4ea10b9b7baaee27a800acbdaa22d556882489ae1baa3918e2b65a84505532058418193055acc961f515d0ccde5664eddca9218f247d2546f8b6055d95bba80b77485a55bcb4ba00e558737651f459578ed5577002f6b15bae5359c83fda1344f73adad1d34baf7c7ed7fb2ac7060f33cc746c749fd456847a57d0db2374f8fcf36f22cabdb5ec87a2bff006441a8898dfb39e53b5355231c20413d5a76a73d91121e95201413b139e115335394cde112076a74cd4e8982ee174be05fff00aa74efff0022e5a525ae047bae9fe9d549e35d3e3eed27fd953fa5ba7d1317f37fd4523dd0c028bfe4a91c69a4ad61c5fd954c878634df759ae693bf657a6f592553905eca605498ef4abb85ab323540ff00482ac2bc8ea54677759b56661d761557462acf64910eed2692a3c9455677e14533c348015243f74e08176805d584fbf75100e2b7135c2b90b4deeab42ee92ad31dd45585d88ef4ae446967c5cad08858082cb0db429cfda14510a46f7ffa28901290d6d955bacb9d7d92c89cbda4350c67a1aa085b880e7ba95a4bde1a1576c9e91eeafe3b3a5a09e4a85a49d4d3d3dd491377b51bcd4aad307a4145504e77a40c1d56113dbd4f440868dd4c08323d11d2cbc93655bcc986e072a9346c4bb956151cda04a0ec8a6beb3eca3ab4842b4869e5444d952c8df5943d2ac1e3344147931f5b01ed7ba8c935414ce7de350f7dd4c0f09f1d35b0ebb99137b3973b0b800015d37d458cb3c4d9a3b6c57281d407c2e4cddb7a74e81f8addbf8dd2a29717a5bd6d7752b396d2486977014530a606f52ee70a83e23bb8f65ce6a4deb7bcaea6600e39076f9f75cb663488dedadaf9421c7e77f7ce5360a8f3f79cfc6ca5c2e02ceeebc7ed7d4f012f774b7ee3b0f92ab93415bc07f464c12ec4c6f0f009ab20f0b2c36d59b66afeafa9fe93e8d9b838d87a9e7038b19c6119c71fcc79ea5e81a84e6680b28741aa58b83acc193a0693956d63b2d8c635b77d06b70b533a0f21829c5c6b95d713b9dbcf8f5b8666b3a443a8e992c07d0e701ea5f31fd60d3df85e2f74a7ec962001f7ad97d3726718d80343a41545adecbe7bfadce1366614ec737a5af7b68720aae7e9af8fdbc99c3727e526f28e46f4b9c2ed0765c10f523f807575ee864b22fb2778248a4c58e36a61695770b0930515208cf748b7a55949e82ee0a88ab0eae9dd45bd7c22b083dd4120b2a793ba82ad5eaa59afa46f0fe16dc0f21ec70ec573fa5be9842ddc6dda0dd2c2df66b58dd5d443d46207dd3ef7ba1c516c681b9214e62703bb775df5fabcab4ead308ec876c93dc7a85f1dd1358e0f07a514cd75b5d554a551e2b58c9c01c116a2d5887ba370ec5588da6399afba6d20c82c2ffea24a89250c26c92ac179e01a40d632ac8a461c280ecadfc55199e4658ea524799338575d0514cc0d3d610363b37eea131d965e4c85a58e7d854a2a68d86c4f2a7998012d3d946d8cedecaf04adc06d4cf17de8a8a1e42949aa3f2ab2b4229778c826dcb37023e90f0790e5a533aecaa50b7a2493e4da84acb4a9070a3ab521648e60642c2f99e4318d1c971d822dd43a8fa63a5e4eafe217bf0f68b0da4cd31fb77ec17a2bd9d05c383edecb7bc25a063f847c211621204ce6f993bcfdce791b8fdb858b3bcc8f73bf949d8ae3cbdbab0ced548b0a270a539e146e593a10bf85566e0ab722a92f741993f255094595a928bb59f237d4548a12355570a2aeca29c556905a40aaf42a57b50f4ab400ab405bba97a50f4eeac23e94ba5484526530805523ab6a405a7e9560cd1413a7029122242d4e53a76a2a4d4e9c2740c10f728d46e34a003c80375d37d24265f1f63002c0695c8e43ada47bed4bbdfa13863fb567d624da373bf4f10fea3dca4555bfd5efed003b8a2a39c5a94eca27ab439555edf49549e295f9782a9c9c156814e6e4aaaf5625e5569785642b4bc1558ab0f55a4356922179ab50346e5ca493d4c23b2843886f4b785494a4dfb2963ff1206447a6c9a44056d76a204800276566265aaf0b3bab918a5613c2db701ecafe38d8fc2a90f202b9083bb471dd04b07a893ec872dc7a76356a5351b36e1509f20d901085525cc77376a5b780084d182f3655e858072a93dac3c400347577dd68b1f74d0a986b6c1f6565ae17b2041dd5907e36577f942a55fc4055eff9684abbcd1504b2748251cb77b2a93071254aaa72bbaa4b49c68152168abee1432bfd24a40a921b72009cee5202cab21049c950916ad4a28aacee55a3a0245226d7735ec90169c117445eca610f1bfa98d0dd71e6b7736ed70f2921bb2f43fab2c6b356c77555c6bcea524bb7e172e66f8dd2cfa862f4faa56f57b0e541267e1b853a4dd60752706cd2ed7135df998818e697585cdea1331ce708fed1c2be617fddd9626ae03439bdca0e7b512d3904b38ffba6c54138f55fec8b1b95964e9d985a27ed4f1bfcb21dfd3bff009201c244d57cecb9ab3a9dba6f1b8d3d67c1ba9499030b284cf11873486f558b07d97ba78bbc49261e9b81910c1264099beb6c42dd55ecbe60f00ce089b11eeae87f5307b85f50f85b1239bc3d8f94f25cf6b7a6c765e8d677112f32f1a9d3931e2f8bf4ef760b1fd544864a3a1e3f2178e7d4dc813c3a54b5d2f99cf7385775ee1e24d2b1b323944ac1d4d04b641c82bc1fea19f2dfa7e292e3e407105dc9b597913e9af8df6710ff00b9df050b51497d4ef940385c30f5209dca3628dc69131ca27b695e9211615793d2559af492ab385b92116e8046c4a81dbeeac3c100d280026ecd2bb042eeeabbb9561e28f36a03f7957aa257f4e3409ed4b731de7c8ea6f0b0f04d1f82b6316c80d69a16152dda69d4badd0ae5cbe826835a16bbdec0ea036e2d66694df2e6006c646f3eeb4fa4f247eebb6bf57996fb489c4068aaf9b48815b805a7d926b3a9b4a48a32c0694aa07e3b1d1824fa2f84ed82132b00008f956dcc0fc5214104603d84f6284965c10c56df281a15b2ae6388301e857f526f54e7a7b855ba7a2321ff00b22aa190c6399d574c084c1175303e42d246d48b328c2476250e546d39186edf6f6420591831b632f2f76dbda8198ad7b474cae0d2afe77f160958cbeb2d356abe235e6085b2fded00148591458ce63886ce4571689f1bc0b73eca26173b2a52ff00b06c12ca34185bc756eac2095aee9fb542d81cebda9694ce04170ec10442ddf90898ed4db1969a37bedb2eebe90e89fdabe3313cec271f4d6890b4ff00348efb571e187f52d03906c2f71fa33a67e8fc293e696d4b9b31793fe11b05133a85db3e30cd2203130fa8db8fc85c869d92322127bb4d2d6f13ca4c990e3db65c4787f503fdb99d84ee283dbf85c196373b7762faba8728dc2d4a2e88ec10159434579052aef16adc8ab3d58539180ddacf95a5a4fb2d422c955a565a0c69459558b772b5258d557c7ba98141ed5096eeafbe3503e356815fa5316a9fa29016eeac843d287a7753f4a0e9dd4c00aa28c0b44d6a7aa564486a938443ba61c9454c5327ee9d00a23c2492062682824772a471a55667900d20ad91d72111c43aa490f4347c95ee3f4ff1460c9a661c63d103773eee3c95e49e11c29337c45035b551032927b52f6bf0cc3e56444e6512e75921698ebe98e5b7f1e8bdca8e452378df94320b6a89ed8a94a2d5495d5b2b521d88554f25205670e4aa731ab5764eeb3e5e4ab0a92bb954de7a9d4acca2ef6b55de29a76a4911cce0d606b459410c2ebeb2282386205f6ee14efb23a59c2a88c9ea7103801268a0930d7a4a99ada16a243b380a78f90a21f6852c5ca8817a2e15c85dd3baa50f653dd15607952d30fcaa110748fa6a9a46195e1ad35babd8f0089b406feea2445163f473ca905b4eca622940e34eb5521603da07ca961b3bf6555a7aa8ab6ce022c37f215a79a637f0aa116f1f956a53c0f84255dc6c9503eb7b561c2d5595ca5557734bafd95697d95e6b6c15039bb9419e59b5a268a5396ee841f5524214e71655578a57e7fb8aa722b4085cfec86377af6e7b21772989aafcab0f39fac30ffc660bc70633fe6bcbe61bd2f5ff00ab18fd7858937c90bc8724dbff0065cf9fa6d8513792a467dc1344cf32502e9689c66b1a37b2bb21c32b38ce062e92b98f134258f32767ae96234e1b5d0d964f89216bb107987e69596879f4db6df28a0fb91e4329efff00450e3ba9d4b1bbab1355bc2735dd0b0d842795cd3dbb23a6d78525e9d6e261ba710365f5dfd3ea93c271b40269c6ed7c73a1b8335285c4d5382fb07e983c9f0c7360aecc7f579d97ec0d621bc990014297ce3f54595aac0ef605bfeabe97d607fc41f90be77fab70d6544eff00114f23ea78df679a3f93f9428e4fbdc7e5085c30f567a03fb2919d90391c5c289ed6a8dcabc82dc0fb2b078503fee484dba3487a9aaa91d361597df650b9a5d76acc559c2892a0772ac3fee50ca68ad6acecbba69a216d63db88a3456169eefe205bd8ce17baceddaf5e9af83248c90753c83da968b72a52ea32907e564440f502785af86d8dcf6d8b5d95fabcdc9f658fd64ad14d76feea787519ba0879b2abe7462334d157baaac969cdf652a3a4c674d2c17efb044cc7918f607f2d2a9e1cc64686b4d0568366374f03b6e848b51cb7b24342fe1669d49c01ea207f84ad1cc071da259003b765ce4e3adce91a2aca42ab8ed4c0aea008bec8ff00b4a2774db2da37587238d9b5134ddab0e95fa96338508883f0a3666e383b923f2b09bc2374133875796eaf73c041bffaec6afbe8f6514d3c34d77559bd973e4961a71b2a68dc5cda771d92606ff9a0b5cd1cb9035d4e1fe4ab405a2116eb3ec8fa8750a5586b54f338b5ae2cfb88a1f92be9dd071469be18d3f19a68478edbfcd595f3568b01cef10e998c0589a76b4ff9afa973406e23d8d141ace9ff0020a67dacf3ad61c7f452106fadee2bc99d96703c6304e1d4d79f2ddf82bd8f598bab4e02eadcbc27c7d13a37078b0e0fe47e572e4abb70cbd8227db05707828b8dfdd735e11d58ea3a463be521cf600c715d1f503b85cb11a96b25236c5aacf6eeacd83ca0700785642a38502ab916adb855a84f0510ce9d96e55dd1ad190582a02dd94c0a0e8ad4062a2568bdaa17355a0507b29425bbabb23795016ecac202d4d54a42d4c452984482ad316a368b09fa559508141338584645212823e9dd2e9469200aa4ce52217f082bc86952c876cae49dd51c8ea2d3d1cf289769f4d70fa61cfd45e019243e5457edde97a868ce6c59da7e135e3cf6b7cd7b4f202e43c278b1e95e1cc5c99c86c51c667793f29be96ea136b1e30d5750949ea92301a3d99d9754d7851c76fdadb7b7b0070047ff00b5a098f64d8eefe0b6fd90cee3d973ca654e53d361415b12ad16d8b72af211440510aa94bdd67cab4266970a0b365218e23babc08243415591c643d214f3c84d002eca5d01adbaa254c88cb7a22007284ecc04728c272aa216025dd4549d77681c68a8de4926924588cdab11f215386ec5abcce42ac0b718b0a41b9e950892b6ab57b1230edc8a56078b8fd26d5a7b7a4222406d0ecaacd2f6512149250a509dca677349c7655212c42dc15c06806fb28a1e11b0d3d1613f90acb85b07e15671b91aad558084a0734d1a551ed3d5bad073554c83c852aab3e5a00212fb4c5324007b6c1517daa7770554964a34ac8579cdbd4327054ee1654329ec9029bc594cd6ef7ec89e2ca288557cab0e57ea763197c1b913345ba170705e0b2ca5ee0e2772375f49f8c62f37c27aa33b794495f36650e99801c2c73f4d3176b3881c322dc2872168822c922ed700cca9d84f4643c5fb9b47fafcc1c6593f056f197d33b78f3fc77ad94c62fa7659daacad9a1707ec172acd472c1f564d84f2664cfe5dd4a2722d182caf9c3a7a85dfb2cd83ee2af4a03dc49bbf840c81c5e2986bdcaa5af130d6b8a63da78fec08c7751b016db48a46b26d1d27c2204ecbf75f5dfd24707681d23b341ff45f21406a407d8afadbe8c383fc3cf90f7686ae8a7d5c99fecddd65bebfd9780fd5d65cac3ec57d03af33f8ad078017857d5d840e92de3756cbf56787eef1d97927e546a69b92a36ae3abd69e80ee1147c277a61c0559ed6a8dff0068501fb829fb2824fb8242d3d09dc281dc953850bf95664ad22af270adca2caab28a0af56364d837e68a5af0c81b257758b826a5056b0049ea1ca4f6474e9b0a17be30f3c2d3831edec7034415434a783831f57dcb4f1ded0f1bd2ea89f4f3eff65bcf87cf60791ea68e56357ae974425681776161e580d9dce6bf627853cb6ab474d679719255deb7c9b76ecb330f22223a5c6c85704cdaf61d901e787180b4bac81c2e7e4b6ba89a5b9952c6cc7b325bcf658190eeb7f55d9410641b771fba8a3e0a392ec52b188c6d02403bf74844f48a3e2c8b017458939c8d3a38eaba76fd965380a2e0d1b7b2bb8a4f95d20f4dab49565ea30b71f21ed6fd84db556638765a9aa303e3bee164877a82af25f8b531cdb0291809d855f6b55a171a14a67f987cb8f19ae764cce11c6182dc5c761490bc47a7a2fd11d18ea9e319b5175bb134d6503d340ca7b5af7bd43ff0aebef563d8ac6f02787a1f0cf8630b4f85bebe90f95d545d21fb895b79c098765646dc7ea711384ddae9c6d796fd4ad0ff0055a2e4cd8cdfe233d47f0bd735100615772e5cce7c2d919246f16c70a3f8eeb1bd7db7a5b4f16f02ea9263b9b8d2bbf86e3b8f95ea78b90246820d8770bc5f37124d1b5ccdc5ade097ad9ff49dc2eefc3fabb32a16cbd7446c5ab96f5f6ecdee1dc8db640f59395913bb15c30ded131ddbd4ade1ccf7634666fef6a9c7e551095ddd40eeeac38d8b55ddc944207285ca67775091614c200ee14322791dba8dced95a04120b5093d94ae1bda89ddd59289c993b9208892e8ee9c0a4405843d3ba98543dd01e54d54a27ab013c266f08aaed301410251b94850916a05597826e8a9b43d227d735ac7d3f14125ee0e94f66b0724a69006b493fe6baed0587c2fe12cad4a71d3a8ea03a5beed6765ae3a729657bf1854fa9fae46d7b744d39edfd24003257338791c05abf420b9f9ba91147f86d05794e7c85d238b8f539c6dc4f2bd5bff87aa7b35893b7a5aba33cfad30ac7f5ee718a8da4fb040e1d4fb4edbe81ed4109356b9169452bbb2a921ead95979bb55a5706824a42aab3911820ac6c8712f3ecaf6438bc9be157644d26dcad0238d83a092a17125df0adc86b60a0701d24f75691138d2073e8267bba4284bc11baa4867beca2886c4aaf6492a688d05102d466829e3f51a55a3b71002d3c788000f75613e1e3807a9cb481a00055a2e294dfca81e4248d957a25dba9d868285c6de54488e436694b1c7b82840b2a768aa552125d2260f55a89e7a9fd2ac3074b691609ff00c433f2af0e16796ff1a3fcad20282128e4fb550945dab93f754dea55405bb20aa2a7ab514be90820964da95570b5349ea283a5210888a0aa4bdd5c78a5524e55a04005a768a29c72a41c2b48afa841fa9d332e0feb89c3fd17cc39edf2e670f67b9bfe457d50ca2e01dc1d97cd1e2fc3381ad67e29fe499c47ee6d5337d16c3dbceeac2622bf75ce799943891dfe7697ea729bcbc9fca8e1a6fcf6de7bebd3ec93324b4d0fdd610cc9bbee51b72e53fca91526cde64c4c836b0b561958e0006ee1722ccf9dbf6b7744751cb2ef46c428b63dad5c8ea3201eab228a881ab5938d9d9121fe2ee569c6eea009145538f15e276b788d0668ec5db87ecbeb6fa291f5f86dc48f4b4f2be4cd3c03332c5fa97d7ff46c06f8283c0aea5be3fa38f3fda1a9abfac127bdaf13fab4cb80fe17b86a83a9b5ec1789fd5321d04e4f614af93eaa62fb3c3e6d9c546a59efa8fb28d9c2e397ab50bd303411b909549eda0ab6b5049ca9c0b0a391a91da27a08e10394a1bb21e9dd5d9ab4bc2ad28b0aecad552414af4677450002404f65a8d7935cd7c2cc8ebaac902bdd6844e0e6ece6ab599c2db267b453657b47c2313e4b4db32dff00b8b55c5f620fe12f31a39549b596e356847aa6a31fff00a76dec5aa61a965c83d7331f7eed58c7245d016a46647f84fecabcac98ad1b116a3971fdbe51fc8a521d5f341fb6159227046e08fca5e683c2afe4b2ff008a966a3f56cc78a3145f9083f5f372f8987f0696787da36837613f258ffc7c6b7fda0ebf54208f83689ba986389f2486fc2a2e2e0e51973ad5eb9accede3d3f8d51adb7810380f75661f10431b69d0cab9f2e726eb23957fcb69f4cff0561d29d6e078229e2fdd5293299d44b4917eeb1fcc4e1f655eb693f155bf899209aeaecbd4be87e81fdb1e2b76a72b1c70b4ee2f874a785e39a6e3e46766c38784c749953bbcb8d83b93ff00b2fb2fe9cf86a3f0a78530f4e68fe306f5ccefea79e4ada3a6192223d3a51c0b3ceff951658b84a990657f74ad0c9c9ea4dff871ff005ac2cb658751a3eeba7cf8ee0bff0012c1cb8c77e144f6d6274f26faa5a619a287538994f847449f21717a2e71c3940bfbb80bd9f59c76cf04b0c82e290749fc2f0ad6315fa66a39103ec794fdabfa7b2c3255d58edb7a869599fa889a4fdcb7227daf34f0c6a61ae0dea3bfbaef31276bc0a36573cd5ab54bb651977285a5191b5a842078ded573c9569e3a812abf4fa8a40af23685a85ddd4f29eca0eeac22728dc2d4c794ba3ba40add3ba5d2a52ddd186ecac01acb4fe5a91adf4a900a082a3a35198d5a978555c2d4c2251114693385a7228a4aca83a53f4a302d132373dc1b1b7aa471a68f92895ad034e66a1a817e403fa2c41e64bece7760554f166a52e76579d310d601d31c638601c2ea75d7c3e1dd022d220f565cdfc6ca77b7c2f36d4667644ae3db80bb31d78c6dc76b72b33321e5cf27b15ec9ff00c3a8ac1d53ff00ca178ce41f2b702caf69ff00e1e874689a8baa9cf9c5ff0092cf24affc7b57f2851bbba999555dd42fe5610cd0c8685aa139ea56e67f654e41bfe55851922b72623a42b2e6775139a2f74815dc392ab4a68ab5916dfc2ce9a4e9b5691064bb7555ce523e4ea2540ef5154920711b565a2c28226eeadc629442d2b38e006eeaf42e245765423e55fc7e42b2ab91a9d8a16f2a406824827fda542392a477a820635541305952170037519756ca2790762a085c60681d6a48de6477c054d8f3d3d3d95cc7141163c82a58ff002b45bc2cf9ff00bd8bfea571dd9090482d557800eeadc82caa792eeca5543349c86aabb9e54ed6d827d944ef5390444594c4505604742d03dbca4214a5555ead4a2954955a0424d38a369b512918ac266fe2c775e09f56a010f8b750ec1cd6bd7be30756dd8ecbc63eb6c03fb6a29bb4b174ff00925e37595a9dbe7b662b1c45b54aec78c6d54af0601c26732c734b19b7b7545594ec365ec986201c2d1747f369847f1691638b34e3510ad4586a52de93c52b78e2c05336f48e28e1c56377eead065014a4aa44d176a9366b154b822b219f2697d91f4c22fd37813107bb6d7c7da646f7e7633182cb9e02fb47c3f07e97c35a7e3b45754609ff0025d75fab8b3c7fc80cf3fc373be1785fd507ff00c1e53be57b6eab236386671fe5692bc03ea7e59931ba7b48695734fa5317d9e5529f511fba8dbc94736cf23d8d206ae497ab1d13932527010834a8984bd9338584d76135d5a264ed6ec9fa53466c2349442091961519a122c85a6fbad940f04f2af59d2968db0256c85c45d2aef827dc87d7ef4b79f0349e2ca85f8edf6a5bc5985aac211650ff009840f872203241fef49fc9b5b3fa76a7fd135dde94f28538b1fcdc968fef0fec90c8ca6ee2472d3382e69346d46714b4ee9bac935b4297ebb2c58eb27f29e3cfcc1c3e95cfd3fc5a630576a4fd5113640350cebda4ff004b44dd573da76734fe5aa410a2105f6b513c56e560ff006c66d0ea8d87f02948cd6dfc3e203de91b305ef3b0a0ac374ddbd401fc8b51faa7f744dd62376c194a5666799c0a084e08068347ec2948dc5e9dea93d7f0f7fd1f9b6a680fab7514717aaa89fc2ed3e977849fe2cf1861e010e18b1b84b9048b1d01695ae9136d3d67ff00871f023875789f5784b64b2dc38ddc06f772fa01ddb8db9a5061e345898d1418f188e28da18d6814001c2995dc933b9d90e50ce2da422efdbf04d05c2789fea5697a64d262e234e56430d39c366b7e14c221bba8477057b39606536890b33c1be2e87c5399938590ff00d365df54319d9ae1f056966c7950ca63923a236e6d593d3173d80b1d7c7bfb2f2efa95a4196366a10b69f08e993fe95eb19b0bcb0970a0b9ad56067539b20b8a4696387c1516afa6b8efa9789e979062c81d81e577da167547d2e77a8f0b85d53025d3351971651bb5c5cc3fd4dec56be8b31696b9db1f75c57aea5d913b8dbd2f1652e3b9b34b458e05b47bae6b489fed17d57dd6fc47a852ac827c63b2ad2b295daa0a0963dc955819d237750b85156e71b52aae1415a10029aad12768b56483a52aa2149d297937ba062ebd930e54ec8abb5a2f2fb5520a920b55c8a255999bd0f215778b530207f29b6ee8cb526b775333a0cc04d8ecba0f08ba08b51fd4e40eaf25a4b07b958cc613c6c06e576de05d19ee2750c86ff01c088d9da4f92af8ebca58e49d4381f11e4cd979d913bc7adee249f8f65cbe43fa586b95e97f5034dc6d39c64899d3e6d9e91c02bcaf2de49367f65dd31a8d39e93bf6a53c85b2071e015ee9f40a8e8196f677c85e161b6e06ad7bdfd0187cbf0de4ed57916b9f32d3d3d876fde94129ab52b9d408555fea72c1445d37ba8ded5600a51c8902a48295690d29e634e2a84ee5610654976166ca6cab133b954a4f51512422772934594ba775331bb285a4f13775698cb0a3635598da90aa686356d86a9556ba95988db5585a8cda9870a2885a9c37b7ba890c87aba6d484740215394dda808beca76fa942ce54cd41346ddc2d088535548390ad33ef0a0834bfde45ff0052b9dd5497fbe8ff002adb8d045a51cbcaab28b71565c6d5697ee2a5556277a4ba6b752b59bda770a090233f6aaf2775339d761577f2ac8539f954e5e4abd372a9ca2d20573ca918987a421eadd585a63ba41fc15e53f5c21ea7e94ff70e5ea319b3fb2f3efad9039da469f920588e42d2a67ea98edf36b6f7a42fbe4f64574534a6c2e787621ebb7052920816ab8201b29dee277eca44e402dd94b01bd9424db405343b0a494f4b08a3fb907652c2d2f700059ecabadfa5e2fa8dbabfa75a73f52f1563403edeb017d83e5f92c8da3ecc78abf7a5e0dffc3be88dcad5a6cb7b3d38c012ef772f7bd54f9703b7a2ed8aecbc6b50f3ed7dcccb8ef10e5b62c32eabea695f3cfd4699dd78ecbd85ecbda3c5d375111751d8d6cbe7df1a64f9fad64b4125919e96dacb2cea34b608ddb6e74d9b250b7929ca0eeb99e94742770a3ee8cf050b1243b3ba5ee93903b8558252b51051c5c233d95a55827f0a09158268285edbdd56169e8205840e6a3aa48b6b757864840a2a5624d16e4445152155d28e765d298f0988b53d0a8634de503cab5d29165a9e5b672acd89a0a95ac684462b46c1492b40d800aa527742880ba59cb4a84f29ba40049e14cc8649656b22675bced5d9753a17873a646cb943cd946e221f685a5236c6f7d7a63685a2c99b3b257b0c78a0125eee17d3bf427c28cd07c30fcb9003939af2feb1dd9d979b606905ef804cd04cef0cf2c7005afa3f0319b87838f8f1b7a638e30d68fc2e98f51a725efb4f7b525feddd384e059af752cdc7fd4ad5e4d33453163bfa26986ee06886af9c72b21d2ccf20380e4071b217ae7d67d4fab29d8c396b7a578eb4123d5ca37c7528725f0c8d918f2c9186daf068b4fc1ecbd3bc2ff53a57c6cc5f12637ea00f4b72a23ea03fc5ff00baf2b99bb9431bc8fb4d1f7485ad57d1906768da8467f4f9ec713b8f71f958da8e8b34a5de53d92c67bb790b83f08ea185036389dff8971ddcbab66a271e504bcd767056ded8cc6a5c878ffc3b23b11998d67f160d9c7fc2b89c389d19a029bd97baff006a63e542e66442c95af146f92b9dc9f0c680fc8071dd94c95c6fcb1c059db1726f4cbc61cc68f25398d1f705d6623c93eae54d178363639b261cefbfe87a923c49b1a6e89e32c3c03eeb1be39ab5ae48b262db00a07b7d2acc715fee9e588368158b462cadf52a330a72db95801752c8c814e28216a7280226f2902460278441a6c5a4c04f0a789849dd5a505d276a461a6b75288f753b61a692ab0964ceddcaa4e6fa8ad99dbd2b3e662b0a45bba9a1659e2c23640f246e40f85d078674376a99ac6105988c3fc590f7f85a56bcbd2b6b718dacf853c3433fa73b377c361fb3ff0034af40f2c3180067480283470d53c18ec8a2645137a238c74b5bec147a864c387892cf92f11c31b7a9ce3d976e2af1879f92dca5e4df58f244736141d565cd2e21793ca7adc6b85d0f8bf5876b9adcf9ae712c3e985becd58b0c56eb3cab597a57508a1880e971f75ef9f42801a1e481ff009b6bc3dd1557baf73fa0e1bfd8395fd425dd73e65a5ea527da7f0abb59dd593bb2d45d960a87a556c914adf62b3b2dfd6e2df64815273409f6599349d56ae663a994b28bb75610c86c955dc093b2b2e36f4cf88122d448af1b093bab21bd2023644d148a4a68d94010a569a6055d8edd4b761204f11b255b8c580aa402c95a10b0168b5613c7e90acb47a6d451d0e134afde94482964da955e6d39365355a801d915d040f75251fade3d82821a38c3d00ab7172aab36aae15908b1dc6a68ff002ac486dcab345e4b7e029ddeaa4251bfee40e1614b4072a1964005052aa373a944f7d84f56e42f14520447616a290d8523d44785615a5555fcabaf556434908567a06f2a578eea30ac2562e57eacc0e9bc0d92e60b31bc39752155f1463372fc39a863385976339c14c46fd237af6f8d09a519360a27f29962ee9423929ca2ab29c354aa360b0acc62828e314d533481ca0901a0afe9d139efea1bf4eed1eeeec1538d85cef85eabf46bc28ed7fc418ed963ff0080c42279be5c0fa5bff75b78f8eb69e56ea19e7bf0abddfe91e807c3fe0fc564e3fe2f2079d31f93dbf65a9af646ef3d5e88d6a67cc31f1cb23f4bc8f48f65c078d356fd063889b6f966e4857ee79cb8bdf4e2bc59a9c6c76766cafa862047eebc1f5098cf33a43cb8975aefbea0ea821c58b4d638ba790992727b0ec179dcceeb75fecb8b35b767a3e3d35080f29927729d670ea93bbec51c62c293b05147dd5951115ba13bb4952040f40a1e14aa1894dd924831407ba370b43d2ab0b4840b0974a368a44ad0aca002894e548e4caca9870939272153da0924e39e2d4ac86479d9bb2b4559dbd2268b45d2ad8c42c6f53fd23dd68e97e1ed4f5591add33072b24f25d1c7e868f7254cd51c988d69269a0971e005b9a56859192e0fc82d8a2f6ee56fe93e1b762cae74edeb96e87f8575fa5e8e011e6b2c9ded4c63feb3b66d7a6368ba3362686e0e335bef2bfeefd9759a7696cc66fa7779dc93c957f1709b13682b25a2a8765a45750c267729b43c7ebd5706dbd47cd0bd91c3d64af29f0b8ead7f11bfe25eaf5ea27dd5e3a449d9ca4f9044c748e34c6824a4d16572df517586e9ba1be163bfe2261f6fb0508878af8ff3ce7eb39529363a881f85cac6db0aeea3217e439c7bee15568ded1d2ad3b7755c8a2ae48dea7281eca42430c8e8e46bdbb10b6b1359c88c5487ac7b7b2c76b7752b1aa55744dd5a493769a05741a0cd264c80b9db05c56380d7025759e1dc9103c3036fafbfb2bd54b3b9c39dd111bdad764b8f94c2c9ba68fbae7a23c77f953bcd0177fb2bcc6d45bd430462907a7aa23c3fd9644ef0def67fecaf3750c985a18c77546762d3dd666733ade64c7b00fdcc5cd930efdb7c7975e952577512566ce2ed5d7bc906c749f6554b475125734c6a5d513b8daa745846c8fd2ac068bd94ec8b6e2d24450c66801dd5f86068ab4f043d55b52d0863da9564411c00bb6524b1d34856c32824596156060cf0178a0abfe909ab5b8fc6b7276e30157fe6ad0865e1e0cb3e5c5040c2e7c86b6ec3b95ea1a5e9f1e9b86cc6800e91b93fd47dd51f0ce93fa284e4cdff0088946c3bb425e2df1262786b4f32cf7264b85438ed16f7ff00fc97761af1f6e3cb7e53a5ad6355c2d1f124c8d43219044d1cbb7eaf803b95e1de3cf18e578967f261ebc7d299b36226df27c9f6fc2cef146b797adea4ec8cf2d74d5e8603e98c7b058dd05fbeeba15ac69147197b8f66f61ec15d8a0a08e08760ae08a8716899b2a3d9600f95ecbf43db5a3e59f791793b612e229abd83e91c421d3676d51eab5967e915b7a97a3f608aac206728e4e1720ad90f24f4b566641e871b57e5774daccc93bdfba40cdc97f538955ba4b86cae48cea72422a0ac2988cf7442356ba2954c8790ed94486710de5577bc93f0a39a43d5ba0be4aa9091a6c956221655588d957e2e11694d137857a3750a5518ad46a6154c0d84921c24a6401e503cd04679504d25121410079b53e3f654585cf929ab4f18555a859722e54dfcc818a46f28ac137ff103f0ac8df7f95507fe21eaf46cd8145a4327daa9482cab931dc0559c694aa8c8a0a371a29dcedd0f4dee82293d4abbc502acbc52ad37090207fda556729a4e140efb4ab089ea31ca249210361ab523da2585d11161f1b9bfe8a26a901208afff006d9695ed13d3e2778b425bb2948b2974ae777f60637647d168c0a09da9c93c74668eca689967e10b4595731a2748f6b5a09be695eb1368d4226751b5ed3309f91930c5046e96591e1b1c6de5ce2760bebbfa6fe196f84fc351c33069ca78f3321e3fabd87c05c27d10f00458d1c5af6a71033d7fc3877f28f75ea7ac67889de5f50e82d36ef9f65d3b888e3579d9afce59dace731a64c995f70161e9deb65e3ba9ea8727267cbca7b862c00d59b14b63c69af1c99a3c5c4ea6c910a7d76f85e61e3dd4d906145a74320eb9087483dc2cf24f18d2d8a9b72fae6a2ed433669dfcb8fa4ff87b2c797b044f90b88ec3b0424dae2d6e76f4ab1a803539ec9d252b11fb503459529e109420dd299c28293b04cf169099e90b3952940c1568d5a5480b926a24955624920915311b4485c9351513b016a46e3bb9e9e56914da9288df6471c4e72d2d3347cacf9d9061e2cd913bcd363899d44af63f077d0ecfcd74391e26963c1c7144e3639b91df05ddbf0b6ae288ed8db2e9e39a668d95a84ed830a1932321fb08a167538ffd87eebd5fc27f44359ccf2a6d6a466998c7ee89cef32623f2361f85effe1bf0d691e1bc318da361458cce090da73be49eeb5c800fab9578988e985afc9c1786fe95785b427b268f0dd993b0db64cb775807debb2daf18670c0d2df1c01adcb9c74329b5d23e3e17446b603bae03c5b9bfa9ce9437fbb8fd1fbaada37ed5714701a1c2c5bb927dd5a8a20c14052391cc147baab939f162c2f96534c60249f8531d0b2ef4b4aaaf976aefd970f85e38c8d575966362e347fa57921af0eb7003b90ba77e4fa80bb2a08755e061d7e2d801e5ac257acb4ddaf24fa67d591e2c95e7864057ae368d03c6eadfc564ce706b493c0dcaf0ff00a95ac3b2b3b21adfeec9e96fe17aaf8c352381a639b19a9e414d3ec1780f891ee7e49ea3d5f291d2f4ab02621c6bb842d6fa53bb6b08e31611b4a37376511659e2d5b31f5236c04f02d22159558e2bed4adc58b7dad598315ce3f6ad8c1c205c3d3bab71566ccfc5c104eecb5b38b88585b5b56e02bf8f8b4dfb55d8e0afe5568ae95e5b4987905b41dcabc5c1c2caa821db8a44d73a236e16d5742fe362ba570238eeb5a0d3a3e48b50e9b93148c1d27f65a6d756e38288606ada4c66c8157b5ae666c7743296482b6d9deebd0666f5b7e1634fa7b72e5779aee98c707e5657c5b694cbaf4e59b1b41aafdd5a8a224297231a4c5c8f224177bb5dee14f1b7703d971de9c65d359d9a16060dd5d86af64f132c716a76b2bb52ca5a18b3ba6e8b565acb08db1eea20558e0f57e569e8da77eab2439edff8766e4fb940c84b886b45b8ec169ebdab62785b45ebc9a32116d899cb9cb7c34e52c73de62350ade35f12c3e1dc10f05afcc9054308edf257866a7a864ea194fcace99d3e43f7eb776f81f0a4d6f52cbd57519b373a42f95e761d9a3b01f0a9358e7c6e71fb40b5e86b4e58aebdcb3c82f9c9ab72d1c7c32402e6eea5d3b13cd75f4d17f7f85d269fa6f40a70eaf95304dbd32e0c10180914a618a0be80b5be718550149478d4aca7267c38ac637edde97a1fd3689d1459008a05c1723e50d815da7815a5a241dad73e7e978e9dcc6a39e4eca506a355e436b952ad2772a8cc2cabf27055431d9b414dcce9dfdd23f6a964d9cab4b259a4811492534854263b12acc8ead95494da99e88557387751d927e1290594ed1415564f1765799c054201656835de90109598b90ad33955a06ef6ad34ef4a6154a3842f354887099c695a44723b62a8cce2012de55899dba8453de01550786c2d6dbbee2afc3c9501a003429e13d229410b6de14b10ea752aed374ad42dadd16030de53c7cd2d13b300547085e44a7d8abee720ab29a255591caeca3d24aa445952483a6c029c8a01155263c22aaf3aac785665eeaa4977b2408655564e55b2093baaf30a2ac212a32a522c281cea34908183491781b93540ff00b2069b294a6a379f663bfd9695ed13d3e341ca709ca60b177c488295809d828d8093415a8e327d318f51ff00456ae3dce89bc4763c680cb208d80177cf017b3fd24fa68ed5a78f50cf63a3d3637036ee6623fec9be94fd2acad57cbced583a0d35c43c0ff9930f8f85f40e44d0e978b162e1441ad6b7a58c6f0c0ba23548d51cd9f2c4c6a0f99910e1c231216f49e9e9681c00bccfc69af88a1fd0634a1f237773fb8f8563c6be278f0e1931a190be77fdcf3fcabcd9f910e3c136a1a8bc478acddcfeef3ec3f2a27f58ff00db9e94e5ed5b57d499a369936738de4487a58d3c93eebcb336774f90f9a57754cf36f3ee55ff0010eb52eaf98e9e50046dda189bc46dff00dd6239e5e6dc7f65c97b4ccfb77e3a7081836538513512acafc843948f64292aac3ec9216a72692531ea520e1339334d84c79555a6de8c394e85c99691d2834c7b266a918ceb35743ba98a866827853c38ee79ec7f2a7c4c57cd911438f0c934b2383638e3165e7f3d97bc780fe89977939de29900aa70c38cff00a3cf75d34c71dcb2be68ac7fede3fe16f0b6ade23ca10e8d88f9ecd3a423a636fe4af6cf097d0dc6c773327c4b9eec893938f00e88ff0007dd7b269fa7e269d8cdc6c0c78a081829ac8c6c15c60a2afb88e9cb6c9366668da369da44021d2b0a1c5840e18373f95a4d148ca1713d9577b54cf34147d5b2cdd4b59c0c135959d046efe80eb71fd9638f160c9cbfd1e93a6e664cc45f5c8de88c7cda9881d1e54de4c1248396b4af27d4f36374f27aaec9247caebbc4597ad61e8f91933c986c601d2e8d9bd7e0fbaf309b218475339ee4a9d0b3979468749e9f85919c7cf85f13cfa1e0b4d1a28a596c172aae7da819da2e8783a359c289dd6e365ce36495acd9083cf2770aa976e9da6cd20f4afa410fff0050ce9bda36b57a97da01e2873ecbcd7e8a37ab0b539bb19437fd1767e20cc30471e244e779d91b023b04438ef19663b3e495cdda267a5bf2bccb53675b1c472365e99af6288718c6de0379f75e7d3b2e5737dd5a3a5eae45c0826d4d0c7b2b3918dd13387ca971a0b45a6de80d87a82bd898bd446d6ac63e35f6b5b7818a285b55eaa7256c4c2046e296ac38cd680ac3220de052b2c8f8564216427f656638a829e38f6533634157cab42e84d6c2d6808ad38877418924441b8dc58f1c10a68357c8c73596dea60fe71cad2931c83605aa59189d4d243775128edad83990e4b43d920735687971bfd5d20b7e5705243918321931de5adeed0af699e21958f6c72b3d04eee2a62c7174d9d8106541d123003cb5c3b2e7248dd04ee8a51ea69d8fb85d3636536768a2093c52afa8e1b725a5dd5d320e0a8cb8e2d1e9a56fc5911b8b5cb419bb42cd2d7452864a3a5e3fd55ec7248e6c2f36d5e32e9acee36b4c67752b401f7709a3bad9491063e5e991dd31b4753cfc2888e53a4ef5ed7b15f0e0e2bf51cd2032307a6fb9ecbc67c5bae64eada8c92caf25ce27a5bd983d9741e38d78e71f2e07746245e98dbeff002b8520cb212de4f2576e3af1873de773b0451193817eeb5c6118b05cf2002ea02d49a5e082f6870bb216eea58e1b95a5e33cff007d27591f0d5bd595a55f4cc1a8daca05ac1bd2da8a000534505363c4032c6c0ee02b2d650575153caa4ba7a55970a50c82d0940e8ed75fe1101965cb96e9a00aebbc3cdf2f1da7dcac33f49aba926c6dc28dc2d11dd8d44d8ecdae45d5cb4decabcd4dbf757e67740b591932759250559ddb91eea9c8ea34a595cab57aad0049405954269013415cc9e167bb950402b7b45dd049d9491b3828b27885d2bd13450b55e165d2b4d34a495a8de00d94ccdf755a21bdabace121510e14721a521e157924d88532217db8eca401a07ca06b69bd4a5637adb6a01b23377d94bd74404cd2433649ad0771ca821661e42b615584f2a51b6fec8b26c1ff00c4e47ecae3b854b00f4e4647cd156cb6ca08e46f5285e2852b4f14c558a120519eea70a178b2a5554945950165ab8f14a17102ed05693614aac82cab86dc4a81cde5205678a69550f255a79dc854a53455901ebb7523945c0fdaedaeff00651c43f896a776ed0dabea34a6bd8f8d48b498ddd4d1c61ce001b27b2ebbc0fe05d5fc5b9a31f4fc72d89bf7e4c83a6268f92373f80b4c78b7eedd37b64e2e5f131e491c03237c85c69ad60b24f6dbbafa33e917d1f183145aa789ea49e4a919895b47dc5ffecbb3fa7ff4cf46f07b064cfd39baa002f26568a67c31bfca3fd55ff14789d98f8f2478d23a2737992859fc00af3313fad5cf96fbf6d6d535ac7c4c774584f84be3f4b9a0d742f31f16f8bd90b5d1e13c999df7906d62ebbaee46aae21a44308e3cb15d7f2573599d18ec324cea6017d5dd47d5488dfb459394d97cdcbcf9432167a9e5dc7e179ff8975d935ac8611d4cc48b68a13dbe4fca7f116af3ea3216518719a7661e5df2b108e9e680f9595a77e9d38e34075975f03d9329636f9bfdd9047c299b852bfed8df21f663493fe8b39ab6e70aad44b462d0f599c818fa3e73c1eed8cffdd6ac1e0af11c95d3a2650bfea6298c7e949cb1fc733b77bfd938aec1c576d8ff004d7c53391d1a608fe5efa5a30fd1cf144a41973302169ec5e491fe4a231a3f33ce80bfe4714fd3fe023f2bd5a0fa27aa9af375cc66b7b86444ff00bad6c6fa2b1b6bcfd61ce1fe1894ce33f33c55ac26e9a7f64ce8cf769fdd7bf41f46f48f2c87ea3a8757bb6bfeeb1bc4ff00499fa6e0cb97a5e63f360636dd148d0241f208559c71098cdede2c451e2932b395088e4734021c0d1f9fcfca858cbec7f616522933d3689dc6c2d049f48b2ba1f09f8773fc49ac45a6e97099667ef2389a6c6deee71563c0fe0ed57c61aa37134b6540d70fd4640d9ac1f9f75f5c783bc23a57847496e0e93006b88065988b74aeee495d7148c71efb639b2ebd327e9d7d3dd2fc1d823ca032f519379726465b89f668ec176e36fdfdf942c6f48a3feeb335bf10e068edff008a90997b46cdc9559f6e6defdb5aef816543959b8f871f5654f1c43ddeea0bcbb57fa859b36418702366331dc1e643f80b5347f0c8d45d1e7f881f2cf3bb76c2e3b37f215a29fed2d2d53c7b89148e8f4ec5c8ce0d1ea958cf40f8f94582cd5b5d85b99a8cd369b8920fe1e24429f5eee776fc2e831b4ec38437ca823686f15c0534dbfcfca7afe0e7b48f0ce1e9d3be66b7ce95c6c3e63d4e1fbaddc3c78d8e73dad01e797014859cd2b43d3191f0a64707f53f2fa30a3697f4c5d42c7baf2e9250f738b766f60bb6faab238cb8d7c02b812eb36a241177a4a809b45764a1a249a554487b8471ec09f6dd4763aabba948ea8dcd069ce141157b1fd1dc7f27c22f79a0d9677b8da66ea91ea5e2fcc898f0e18cc0c002824cf7685e0ad3302001b3c915bc9fe56f72b82fa4fa8372fc69aeb813b340fcfcab56bfd5e3a77faf8258ebee2979e66c7d1395e83af3811b770b89ce8bd64ab4ad1d316787cc37569e087b55156bcb56b161b2156154d838a2addcad68220d2294703295b60a0af0246b54cc6a6670a6629904c14a56a891b5544ed16a46b54519a52752981274ec85d1f50e2d1c66d1ab0cec8c6f31a5a5bb2c4cad288b21a4b7d8775d6503ca02c693556a3a1c4c4ec9c193ae271733bb4f65d1e06b0c99adf329bdacab53e046eb21977caca9f49e924b5b6df6eea62c86ce563c5971d6d67878eca847d70bbca93ef6f07dc28b0e79f1806f575c6380790b61ae873a12d78e8756cef658e4c7cfdb4a5f5e8d111d20916ef658fe2ad4198b89fa66bee776f27c056659a4d3b1e4c899d659b307f52f3ed6b3649647990f548f36e77bacf162d4ed7c9936cdd4a5334a48360a974ec67137576a38222f7b6d751a5615460d5daea8afb6336f4b7a2e086343ba79d90e5c5e7f8cc3dfbb70f1436bfc4e5d1e9f07431a3a560e2974de21d665228091b1ff009057953934e269e9008aeca5737d21106a5d2aa2bb9aa191bc2b4f6aaf20a2103068dad75da7111b31da3b8b5cb40dea91a3e575500bca87e1b4b0ccbd5d242deb23f0a7737a53e30a67ec86677482b997967e5bfd54b3320f65a191dd66ce8aa949ca85c694f22aefe10569cd9545fcab931a554b6cda8200d1655963760a360a2a76a2d29a214adc5562d578f856a316a615586d58a52dd2801ec8cd50bfd9581b9f4d2542d1d66d04ee3e59631bd521e14ed1e5c0c07efadd4485d362bd937da98bbd2a306dca058ea15ba314eaa50d5952c6df505042dc4282b2ce1df855da780acc7f69fc22c6c4fefe5fd968b7859f8bf7957c9a6a128a6759a50052bcd9400592a5546e424d0533db42d5599dd40a0079bb551c2dca74c435bbb905770a0aa4f2b1a0fba972325b64339544db8d9481138936470a07466ecab9556a095590846c694cd34587e54039523b617754a63b1c6780be88e978d219fc53347993b48e8862754607c8eebd8e2930b48c48f174f858c6b1b4c8e214d0a9b6060e0522f280e16df66536616b391abe78786b435876001a01725278333325d79ba83a46837d2071f057a579697963ba98f51a55e7c7c18c7f48eb2da143a555cbfa67a6ea5d273e5ca91ad3f6b5dd2bd2fa00e12e955e2b7279ae3fd27f0c446e4c39263dbcc9785a58ff004ffc35091d1a3631aeee6daedcb5374a713939d8fc2fa4c23f85a662300f6881ff00756e1d271b1c5458f8ecbfe98c0ff65afd299c290e5b506e291f69afda91f9040166d5a48a083c915ba42268ed6a649045e58ec292e803952a48230d1d93740707b5c2da5a411fb2950c8e0c8dcf20b8345f48e4a89e931dbe3bf1063c726b5a88819bb321e036ebbae97e9b7d3dcaf17677437cc8b09a7f8d955b01fd23e57a7f82fe903f50d532f55f159e9865c87cb161c6683813b172f6ad3b071b4ec48f17060663e3b07a58c1b00ad5b4523d76ded9262350a3e15f0f69de19d222d3b4a81b142c1bff00538fbbbe56b4b23218dd24ae0c63459738d00b07c4fe2ac0f0fc44cee33641fb218f92bc97c43e26d47c4593d323e48e01f6c111a68fca56b37f72a6a6ddbb0f17f8e1ad0fc6d21e1b66bcce5ce3f0b321f0a6a1a862372f2a4746f905973cfabfc9667857c272e76b38d91987f80c3d7d20ddd765ec25a08dda38adfb2beb46f5e9e7de1df0963e16489de5d91234ece3c05dbb0169beeac3226ee680fc2731b6903c730af949eeea0a9c81cc75b7ba9a27753374051fdc3f2ad48687c52aacfef029b31dd30bcdd7a4a48f1ffa993be7c9616fdad34b8f68bbb5d478b8b9cf7026c175ae6aba490ab2183573de31d4a5d2f489a6c77063c6dd44d52e8da9a4c5c69d859910c7334ff2bc58541c2fd3b8f2269e7c89325f3c4f683b9b00aef18d1d4c7035d2411ed610636263e2b3a31608e167f4c6282983540b9ab6af95a84c24cb92ddd1d0d038a597f499e60fa95abc24dde3070534edfb56778366187f55e77b9fd3e661ff009ad2b3b44f4f5bd4dfd777cd95852c56d2b432321b30b69b55c36c1564c74c97c2a7823e9a570c3651b61e940d18a0a78d0b594a663504d170a502d44c6ab2c658401d2a560a5236352363410a91a694c23d93f968058e45d498b29268a5302406c27ba280271cab2253b1b6a56e3b5ff955c4b411326f50a454d3e9c1c7a9aab7e8ded780dee56b32768e557d633462e9934c390da1f92a530e37c55aa09731d031bd51c22ba7ddcb8c7e3ce5ce925674b49dbe174da7e9d26a73389639e1bea7b5bc92873b0dd9188fc78dde512f165dc800a42659d85a7c8c0d91cdabe1753a6c05b18713dae943044649c80e0e63006b48eeb5b0e12202d1dcab2936daee047d5117dd56eb91d1ff0089979f2ddf9992e5dc42c6438ae2e3418d2f3f80170de14fe2e099ebfbd91eebf8bd944a21d08dff00d927230282670b50b2bbb95148cded582ddd27b474eea604584dff008867e575310acb8bf0b9fd3180e6475eeba103a7398172e65eae9e23518504e6d491fd881e2d73af2a12f75466eeb47205059b39a2a55509955955894dbca81e82bbc5a85c28ab0f509e5083339523794174a589b66d16958885ab2c362942c6ecac35a285a2a31d934a687cf6465ed6b3e7b2189bd67a9c81e06502e3ca276f653ba9bc2079b6a1085eebd9147c21ec510fb5164cde14d13af655e3758af653c7c8502e47c29d9f6285aa66a02c116e72b923b6a55307ef72b6e425086da5549cf285c68295432fdb5eeaa9db65609b51d06db8f64113c358d0e70b59f95339d7b5053cef74aeb0a2745bd9e50546c648b299cde956abb219053520527f754e4e4ab8fe4aa531ab564007014bb7451eeabb0d953c683ac491390ad9818a49ca640ce4251390a10649394c8b19c81c8ca8dc819248a640c3949c9d240cd49c9d31200dff00c92009200249a5a5a5e239d534e287f2b7fee8f4cc125c27c86f1f68f657350cbc7c0c393272e56450b01739cfec144cefa5e20b2278a089f2e43d9142de5cf34179c78bfea236264b8da36fdbf50e3fecb1b5bf10e478ba773b0319e34c8c911f5f2f3ee3e154d27c1d266e6b24cef5460db9bff65a56b1fd6911af68749d233355ff008acc739cd9387bb9705d5691e1bc7c67077961e7e57431623618dac8c531a29a3d82bb0c5402bab6b0b4ec76c4cd9a1a3e15a7b83760a48dbd2c55e534555581b6500eea40e046cb39cedd1b25ec8b2d4a01041e15207cb9287da5596bec289ed06efba0958e04d951ea7296e23cf622946c25bb7655b3a4ea8dcdf7083ccbc463ad921f95cd81b90badf1042f689049cf65ca814a9604d6ec988a28daa2269caa24088337b4f1b765296ec0fb20ad38e98c9f65c56a39470fc6916534d06b003fbaecf39f5138ff009ae03c691f4ea98d28e248fa54d7b1ebfa66636688106f65af182403d8af2ef0765caef2c364d99c85eb3a6b0cec0e0b6941e387647e4ad2662ba917e95caa96636152b62a57db8ce054831cd6e8283635388f60ad360a2a511520aac6529982949d149c32d00a4a4f2d2f2d047d3d49ba294cc65147d1682b74a67355af2d2e8a5302a865a111eeacf4ee9c377528946d6dedf2b0fc57338c78d8cd7535ce2e77e174b1c05df6f25721e299449a949137989bd3fbabc74aa9f8635a8f46d5a79f2237490bf6f4ad3ccc18f3a2973db208dce7f5961ee1737898ce365f7b9ecb6a0d35ce8816b8b9bfd25471d129b18458cda6b8191fb060eeb6a38fca85ac3f77b7b2a9a6e13603d5c9ff00656e47174c3d9151eb6ef2f42ca2effca703fb85ca78759d1878f1b7ec0c14baad722f3f47ca8fde22b9ad007fc2639f66d22d1d36dadd92737644dee9ddc20acf1481dc295fc9513bba0b7a347ff1d19f95bcddb50fdd65e80ca9fafd82d885b794d77b95cb99a55bb17d8133fba668a09a4774b49582d2a592401bac9c871dfd95ec9775b8954657502a55542dbb55e4565c6d56910842e501eea770b5139a8b2260b2aec4dd9401bc2b90b76425346d1dd4bd6d6b5421c470985b8d948548173df6efb7b2b6cf4b7d2a068006ea468247c2b107738f7513cda91cea0a17b944ac671aa4776d50136548c5512b3ed0ade3f2aab3956e1e420b8ce54a7ed51339538e4a02c3fefbf6571ddd57c41729561c4ee02085e6942e7219413259ec86edc80ba872ee028267991d4c34129f903dd3b5bd2149285d1f48dcd95116eeae3944e455074a8253b90acbcd02a9cbb127dd20539bbaa13abb31b559e2d58431b685a9d8a1eaa533482d1688758e42924b661045324922c6721292481933924900390a492049149240c9249206729f4f635f9ad0e1606f4924a2531db764244800d85d2f0efae19d94fd77034f74cefd13de03a2e01dd2494d3b690ef22c3c7c5d2a08b1e26c71b5a0068edb2b5a5b5a1a480924b694cafbbee52c7cb5249421725feed67ca924a040e40de5249048119fb5249001e556c9fb5249071be2b03f4922e16edc6d24952c0c708285935b81b2492a83638d837bab0f2424920ccd449dff000b8df1aef8b80efe612000a49210d0f05ff7f19eebddb4368fd347b764925b7f159edbec02b84440f64925084742d3b4027849244c0c0038091492530b191345f2924a642700384d56924aa100027092481c2093949253000a918924ac895ec61b5fb2f3cd4cdea3924f3d6924a6154984d05edd96dc2052492b12922fb8a47fbf6a4924aabb99ff0080caff00f0bbfd971fe18fff0075e3ff00d2924aab474dd8fba33c24928109e544f49241afe1ff00ef641da96ae37fe25a924b932f6d63a6eb785567fb924965099676512b26771be524959542fe1427949244c008dd33c0f60924a2522880ae15d8c0e8e124956483f43481b041292d1e934924aab232e3d3c957801e4035bd249208c0062248b2a12074df749244a23dcf744c3b24929844f4b1172aec3ca492b28b6ce54e3ee0924894f89f7394b270924829c9ca0492400cde52a697ed092484a0eca293849252aa23c2a937dc5249205097ee55a4fb924958407ee5607da124907fffd9);

-- --------------------------------------------------------

--
-- Table structure for table `languages`
--

CREATE TABLE `languages` (
  `id` uuid NOT NULL,
  `name` varchar(255) NOT NULL,
  `level` varchar(255) NOT NULL,
  `order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `languages`
--

INSERT INTO `languages` (`id`, `name`, `level`, `order`) VALUES
('b0100012-5f98-436c-b0f8-91c48914391b', 'Français', 'Maternelle', 0),
('4bc16d08-b33b-4692-abc8-ef90225ddcdd', 'Anglais', 'TOEIC 785/990', 1);

-- --------------------------------------------------------

--
-- Table structure for table `links`
--

CREATE TABLE `links` (
  `id` uuid NOT NULL,
  `label` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `order` int(11) NOT NULL DEFAULT 0,
  `projectId` uuid DEFAULT NULL,
  `experienceId` uuid DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `links`
--

INSERT INTO `links` (`id`, `label`, `url`, `icon`, `type`, `order`, `projectId`, `experienceId`) VALUES
('06c07575-4f41-4451-8f55-5d32a04e5556', 'd3vex.fr', 'https://d3vex.fr', 'mdi:play-circle', 'demo', 0, '28e23076-b51a-43ca-ad75-97b050ee64d0', NULL),
('c51be9e8-b912-461a-8d04-941858d6f189', 'ProbaX', 'https://probax.swebystudio.fr', 'mdi:web', 'website', 0, '46559190-c45e-416a-a546-dfc6039d52de', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `passions`
--

CREATE TABLE `passions` (
  `id` uuid NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `passions`
--

INSERT INTO `passions` (`id`, `name`, `description`, `icon`, `order`) VALUES
('ccb304b5-8d21-41c4-8f3f-6cc8203a5c60', 'Engagement', 'Porte drapeau pour des anciens combattants', 'mdi:people', 2),
('18cb9b62-30b6-4b3e-997a-9afc32086a41', 'Calisthenie', 'L\'art du sport au poids du corps', 'arcticons:calisteniapp', 1),
('f8181a98-7ba7-4cce-8ab8-ebc682532766', 'Informatique', 'Veille et expérimentation technique', 'mdi:computer', 0);

-- --------------------------------------------------------

--
-- Table structure for table `profiles`
--

CREATE TABLE `profiles` (
  `id` uuid NOT NULL,
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `initials` varchar(255) DEFAULT NULL,
  `photoUrl` varchar(255) DEFAULT NULL,
  `availability` varchar(255) NOT NULL DEFAULT '',
  `about` text NOT NULL DEFAULT '',
  `specialization` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `profiles`
--

INSERT INTO `profiles` (`id`, `firstName`, `lastName`, `initials`, `photoUrl`, `availability`, `about`, `specialization`) VALUES
('b5630ad3-599b-49b6-9112-c8666ade11df', 'Loan', 'MATA', 'LM', NULL, 'Recherche d\'alternance: 1 sem ecole/ 2 semaine entreprise', 'I am a passionate Full-Stack developer and infrastructure enthusiast currently studying at Montpellier Ynov Campus. I have hands-on experience with Vue 3, TypeScript, Python, Docker, Kubernetes, and cloud technologies. I love building interactive web applications, automating workflows, and experimenting with homelab infrastructure. I am always looking for new challenges and opportunities to learn and grow in the field of IT.', 'webdev');

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `id` uuid NOT NULL,
  `title` varchar(255) NOT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `startDate` varchar(255) DEFAULT NULL,
  `endDate` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `longDescription` text DEFAULT NULL,
  `status` enum('completed','testing','in-progress','planned') NOT NULL DEFAULT 'in-progress',
  `featured` tinyint(4) NOT NULL DEFAULT 0,
  `imageUrl` varchar(255) DEFAULT NULL,
  `imageId` uuid DEFAULT NULL,
  `liveUrl` varchar(255) DEFAULT NULL,
  `sourceUrl` varchar(255) DEFAULT NULL,
  `educationId` uuid DEFAULT NULL,
  `order` int(11) NOT NULL DEFAULT 0,
  `createdAt` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `technologies` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`technologies`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`id`, `title`, `subtitle`, `url`, `startDate`, `endDate`, `description`, `longDescription`, `status`, `featured`, `imageUrl`, `imageId`, `liveUrl`, `sourceUrl`, `educationId`, `order`, `createdAt`, `updatedAt`, `technologies`) VALUES
('e86bf4ae-63a3-4bc1-9745-12dfdbdda064', 'Homelab', NULL, NULL, '2025-11', NULL, 'A personal home lab for experimenting with new technologies and hosting personal projects/tools', 'My home-lab, built with Proxmox over two linked node allow me to experiment with new technologies and host personal projects/tools. It is also a good way to learn about infrastructure and sysadmin topics, and to have fun with it by creating cool projects and automations.', 'in-progress', 0, NULL, NULL, NULL, NULL, NULL, 0, '2024-01-10 00:00:00.000000', '2026-08-16 19:16:39.000000', '[]'),
('089bae36-8066-4730-809e-960745dfa09d', 'YPlaza', NULL, NULL, '2025-12', '2026-06', NULL, NULL, 'completed', 0, NULL, NULL, NULL, NULL, '6c367130-ee60-4d71-81ff-ffcd2bd217b4', 3, '2026-06-05 08:45:22.000000', '2026-08-07 14:24:42.000000', '[{\"name\":\"Windows\",\"icon\":\"mdi:windows\"},{\"name\":\"NestJS\",\"icon\":\"file-icons:nestjs\"},{\"name\":\"TypeScript\",\"icon\":\"file-icons:typescript\"},{\"name\":\"IPSec\",\"icon\":\"carbon:ibm-cloud-ipsec-vpn\"},{\"name\":\"VPN\",\"icon\":\"mdi:vpn\"}]'),
('28e23076-b51a-43ca-ad75-97b050ee64d0', 'Portfolio Website', NULL, NULL, '2025-11', '2026-11', 'Mon portfolio interactif avec un dashboard admin pour géré mes projets et généré des CV. Il intègre également une IA.', 'Interactive portfolio built with Vue 3 featuring a terminal simulator, server animations, particle network background, and full i18n support.', 'in-progress', 1, NULL, NULL, 'https://d3vex.fr', 'https://github.com/d3vex/portfolio', '6c367130-ee60-4d71-81ff-ffcd2bd217b4', 2, '2025-11-01 00:00:00.000000', '2026-08-07 14:24:12.000000', '[{\"name\":\"VueJS\",\"icon\":\"mdi:vuejs\"},{\"name\":\"Docker\",\"icon\":\"mdi:docker\"},{\"name\":\"Typescript\",\"icon\":\"file-icons:typescript\"},{\"name\":\"NestJS\",\"icon\":\"file-icons:nestjs\"}]'),
('46559190-c45e-416a-a546-dfc6039d52de', 'ProbabilityX', NULL, NULL, '2025-10', '2026-09', 'A multi-tool project to regroup data allowing user to analyse financial market easier', 'ProbabilityX is a multi-tool project to regroup data from multi-sources such as X, Yahoo, Spotify, Youtube, and other, allowing user to analyse financial market easier.', 'in-progress', 0, NULL, NULL, 'https://probax.swebystudio.fr', NULL, '6c367130-ee60-4d71-81ff-ffcd2bd217b4', 1, '2024-10-15 00:00:00.000000', '2026-08-16 19:16:46.000000', '[]'),
('3e830952-4412-4872-9ddb-ea7dadd33bfa', 'Vinted Scrapper bot', NULL, NULL, NULL, NULL, 'Un robot qui récupère toutes les dernières annonces postées sur vinted, et les compare à des filtres utilisateurs pour leur notifier ou bien faire des actions automatiques', 'This bot allows to easily track new items on Vinted and get notified when they are available based on user filter. It also allows to connect to the Vinted Account to automatically buy items when they are available or buy in one click listed item by the bot. The bot was able to get item in realtime and buy it in less than 2 seconds after it was listed.', 'completed', 1, NULL, NULL, 'https://discord.gg/DuRMdjeT9u', NULL, '629811f5-5f8f-484d-9b1d-bd1dc4945a05', 1, '2024-06-12 00:00:00.000000', '2026-08-07 13:36:26.000000', '[{\"name\":\"NodeJS\",\"icon\":\"mdi:nodejs\"},{\"name\":\"DiscordJS\",\"icon\":\"mdi:discord\"},{\"name\":\"Websocket\",\"icon\":\"mdi:web\"}]');

-- --------------------------------------------------------

--
-- Table structure for table `project_categories`
--

CREATE TABLE `project_categories` (
  `projectsId` uuid NOT NULL,
  `categoriesId` uuid NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `project_categories`
--

INSERT INTO `project_categories` (`projectsId`, `categoriesId`) VALUES
('3e830952-4412-4872-9ddb-ea7dadd33bfa', 'e65c2bad-6638-4c09-aabb-3f893ca2aada');

-- --------------------------------------------------------

--
-- Table structure for table `project_points`
--

CREATE TABLE `project_points` (
  `id` uuid NOT NULL,
  `text` text NOT NULL,
  `order` int(11) NOT NULL DEFAULT 0,
  `skillIds` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`skillIds`)),
  `projectId` uuid NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `project_points`
--

INSERT INTO `project_points` (`id`, `text`, `order`, `skillIds`, `projectId`) VALUES
('5925ac19-5577-4c9c-b709-0562ed4fad2e', 'Intégration d\'un LLM pour générer des descriptions produit (Vinted)', 0, '[\"3ce98505-438e-4383-bc70-8eda7810d11a\",\"49f3f30a-9daf-450f-b6a6-8959e45c6d54\"]', '3e830952-4412-4872-9ddb-ea7dadd33bfa'),
('77651de7-93a5-405e-a569-08235b9bc137', 'Intégration d\'un LLM pour créer mes CV à partir d\'une fiche de poste', 12, '[]', '28e23076-b51a-43ca-ad75-97b050ee64d0'),
('95f8c5d1-aae5-4715-934e-1bba47b4ac5b', 'Refonte du DVF-CODER (JS) pour un process plus optimisé et une UX amélioré', 0, '[]', '089bae36-8066-4730-809e-960745dfa09d'),
('9b355c37-9105-4649-9d24-251b2e78b057', 'Formation des collaborateurs aux bases du trading', 0, '[\"2ea576d5-44d3-42a8-b2c0-b1319942b64b\",\"fc2596c3-0dc4-4bf0-ac99-aebe184070bd\",\"9337513c-374c-486c-b683-8adf03fb9463\"]', '46559190-c45e-416a-a546-dfc6039d52de'),
('7d724264-3460-490c-a1ab-3c07b605d3b6', 'Création d\'un MCP pour permettre à une IA de retrouver mes compétences et mes projets déjà réalisés.', 0, '[\"dbc31c97-a63d-453c-ac2a-ca85dc432deb\"]', '28e23076-b51a-43ca-ad75-97b050ee64d0'),
('e0eb4c20-0a45-4844-91b5-3c666a8a67e3', 'Création d\'application web intuitive', 0, '[\"49f3f30a-9daf-450f-b6a6-8959e45c6d54\",\"fc2596c3-0dc4-4bf0-ac99-aebe184070bd\"]', '089bae36-8066-4730-809e-960745dfa09d'),
('7f29bef8-278e-4371-9507-3d84aeb20bc7', 'Création d\'un MCP', 9, '[]', '28e23076-b51a-43ca-ad75-97b050ee64d0'),
('12e42067-81fc-488f-9297-3f221bf23af3', 'Utilisation de websocket pour un ressenti instantanée', 0, '[]', '3e830952-4412-4872-9ddb-ea7dadd33bfa'),
('cf22a06c-28f0-4d18-8765-3f501d8310da', 'Gestion infrastructures kubernetes + firewall', 0, '[\"49f3f30a-9daf-450f-b6a6-8959e45c6d54\",\"b2361fc2-4484-492f-b62a-4372b7391a10\"]', '46559190-c45e-416a-a546-dfc6039d52de'),
('360fbcbf-dc1e-4f75-8e3a-49cb7e2c9b8a', 'Développement d\'une interface avec animations', 0, '[]', '28e23076-b51a-43ca-ad75-97b050ee64d0'),
('295ab618-666d-4a0c-aff5-5822682ce025', 'Développement Full-stack (C# & angular)', 0, '[\"dbc31c97-a63d-453c-ac2a-ca85dc432deb\",\"fc2596c3-0dc4-4bf0-ac99-aebe184070bd\"]', '46559190-c45e-416a-a546-dfc6039d52de'),
('15662cfc-7358-4886-b1bf-6a71d92086d7', 'Réalisation d\'interface web dynamique en VueJS + TS', 0, '[]', '089bae36-8066-4730-809e-960745dfa09d'),
('164eebdb-3138-47a9-a93b-6fe651ac57f1', 'Intégration d\'une API pour exposition des données en temps réel', 11, '[]', '28e23076-b51a-43ca-ad75-97b050ee64d0'),
('b1056323-19b5-46bd-8f32-83147f8c306f', 'Architecture Vue 3 modulaire avec gestion d\'état et rendu optimisé', 13, '[]', '28e23076-b51a-43ca-ad75-97b050ee64d0'),
('968026a9-6937-4529-aa21-8411f4da142f', 'Connexion inter-node via VXLAN', 0, '[\"b2361fc2-4484-492f-b62a-4372b7391a10\",\"dbc31c97-a63d-453c-ac2a-ca85dc432deb\"]', 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064'),
('6402ea5e-f803-4a87-96bc-855bcd581f5d', 'Développement d\'une interface avec animations', 10, '[]', '28e23076-b51a-43ca-ad75-97b050ee64d0'),
('01fbe589-0f69-437b-9249-86b638f3ab66', 'Liaisons de multiples agences avec un siège via IPSec', 0, '[\"dbc31c97-a63d-453c-ac2a-ca85dc432deb\"]', '089bae36-8066-4730-809e-960745dfa09d'),
('834b0829-0d17-48df-bb20-8c033ed060a3', 'mise en place d\'un stockage NAS & WOL', 0, '[\"49f3f30a-9daf-450f-b6a6-8959e45c6d54\"]', 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064'),
('abb25978-bcec-474c-a7fb-9f30a80eec75', 'Gestion du réseau et sécurisation', 0, '[\"49f3f30a-9daf-450f-b6a6-8959e45c6d54\"]', 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064'),
('f4988b3e-f791-44e8-9f09-a5963901c857', 'Intégration d\'une API pour exposition des données en temps réel', 0, '[\"b2361fc2-4484-492f-b62a-4372b7391a10\"]', '28e23076-b51a-43ca-ad75-97b050ee64d0'),
('bb3bfddd-f93c-479f-8722-b82e8b4dd5a2', 'Réalisation d\'API RESTFULL en Typescript avec NestJS et TypeORM', 0, '[\"49f3f30a-9daf-450f-b6a6-8959e45c6d54\"]', '089bae36-8066-4730-809e-960745dfa09d'),
('6b29d3e7-5ff5-49fa-bfe8-bb1677f3717a', 'Déploiement de solutions open-sources', 0, '[\"dbc31c97-a63d-453c-ac2a-ca85dc432deb\"]', 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064'),
('79446532-4f01-4800-b28f-bb724da06c41', 'Reverse-engineering de l\'API de vinted', 0, '[\"b2361fc2-4484-492f-b62a-4372b7391a10\",\"54a32bea-07ae-4e67-900f-b34d883ca5d3\"]', '3e830952-4412-4872-9ddb-ea7dadd33bfa'),
('b0e065a7-960e-4e03-90d0-cbaf4ac65103', 'Création et organisation des postes clients d\'une entreprises', 0, '[\"49f3f30a-9daf-450f-b6a6-8959e45c6d54\"]', '089bae36-8066-4730-809e-960745dfa09d'),
('be4a28e2-7e4d-4b85-acd6-dce11bac1fbf', 'Chef d\'équipe, gestion et méthode agile', 0, '[\"2ea576d5-44d3-42a8-b2c0-b1319942b64b\",\"6902e148-cd49-4eda-8f2f-b86aa4d0d4ea\",\"b2361fc2-4484-492f-b62a-4372b7391a10\"]', '46559190-c45e-416a-a546-dfc6039d52de'),
('7af30189-da54-470a-84f9-f25487f94236', 'Intégration d\'un LLM pour créer mes CV à partir d\'une fiche de poste', 0, '[\"49f3f30a-9daf-450f-b6a6-8959e45c6d54\",\"b2361fc2-4484-492f-b62a-4372b7391a10\"]', '28e23076-b51a-43ca-ad75-97b050ee64d0'),
('d66ebcee-95a2-48bc-a479-fb26ff97ffc9', 'Architecture Vue 3 modulaire avec gestion d\'état et rendu optimisé', 0, '[\"dbc31c97-a63d-453c-ac2a-ca85dc432deb\"]', '28e23076-b51a-43ca-ad75-97b050ee64d0');

-- --------------------------------------------------------

--
-- Table structure for table `project_skills`
--

CREATE TABLE `project_skills` (
  `projectsId` uuid NOT NULL,
  `skillsId` uuid NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `project_timeline_entries`
--

CREATE TABLE `project_timeline_entries` (
  `id` uuid NOT NULL,
  `date` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `imageUrl` varchar(255) DEFAULT NULL,
  `order` int(11) NOT NULL DEFAULT 0,
  `projectId` uuid NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `project_timeline_entries`
--

INSERT INTO `project_timeline_entries` (`id`, `date`, `title`, `description`, `status`, `imageUrl`, `order`, `projectId`) VALUES
('36169e43-2f05-4538-8872-0400da2a9f1a', '2025-12', 'Setting first service', 'I hosted my first service on the homelab', 'done', NULL, 1, 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064'),
('e3636e23-6a89-468d-ad39-13e9da2f8daa', '2025-01', 'Role change', 'I kept the role of a Student, but now I focus on infrastructure', 'done', NULL, 2, '46559190-c45e-416a-a546-dfc6039d52de'),
('10552879-e790-4fb7-b933-21a880d3289c', '2026-02', 'Ending project', 'I stopped working on it for a while due to other commitments', 'done', NULL, 1, '28e23076-b51a-43ca-ad75-97b050ee64d0'),
('c41f2b26-2a79-4739-b255-21de2e14d46c', '2026-03', 'Improving infrastructure', 'Adding new low-power node', 'done', NULL, 4, 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064'),
('cbf1b543-9dbf-4533-9d9d-25efed9633b7', '2026-05', 'Seeding Data', 'Add all my projects, my experience and my skills', 'in-progress', NULL, 3, '28e23076-b51a-43ca-ad75-97b050ee64d0'),
('ed509469-9299-4501-8a04-305872f25492', '2026-03', 'Improving utility', 'Adding a Wake-on-LAN feature', 'done', NULL, 6, 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064'),
('bd88b561-2c77-4cd4-874a-35aeb91fca1c', '2026-06', 'Adding API', 'Adding an API to make all data accessible from the frontend and avoid mocking', 'todo', NULL, 4, '28e23076-b51a-43ca-ad75-97b050ee64d0'),
('dc160f34-b9b4-4275-9994-540c69dbed29', '2026-06', 'Adding feature', 'Adding a huge features for integrating kubernetes into the portfolio', 'todo', NULL, 5, '28e23076-b51a-43ca-ad75-97b050ee64d0'),
('f7c811d3-0185-40b8-b564-5638c42cf87c', '2026-03', 'Feature development', 'Refactored authentification system with SSO and WebAuthN', 'done', NULL, 4, '46559190-c45e-416a-a546-dfc6039d52de'),
('c6184592-e44d-4708-90c8-9f36aceb6241', '2025-12', 'Project setup', 'Setting up my first node with firewall and networking', 'done', NULL, 0, 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064'),
('17a823e8-2213-410b-8c78-b99b1d7fc673', '2026-03', 'Improving network', 'Linking my 2 nodes sub-network by a VXLAN', 'done', NULL, 5, 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064'),
('21210046-efdb-4c11-ab3a-d4fa469006a7', '2026-07', 'Expanding services', 'Implement much services and starting hosting my project for real on it', 'in-progress', NULL, 8, 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064'),
('d625f9d1-b4af-4e2d-8b78-d74212b07f69', '2026-01', 'Continued working on Frontend', 'Implement new UI components, improve UX', 'done', NULL, 3, '46559190-c45e-416a-a546-dfc6039d52de'),
('0da72fa6-9bf1-49be-b544-e1094e01d2b1', '2025-11', 'Project setup', 'Developping a first version with main idea of styling', 'done', NULL, 0, '28e23076-b51a-43ca-ad75-97b050ee64d0'),
('47d3bfac-3944-4b43-85c9-e406c325191b', '2026-05', 'More service', 'Implementing additional services', 'done', NULL, 7, 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064'),
('35a91628-b292-445b-a066-e6c75aee9bd1', '2024-10', 'Project setup', 'I joined this project as a Student', 'done', NULL, 0, '46559190-c45e-416a-a546-dfc6039d52de'),
('30f1c78b-4854-4231-bcb7-f0829cf0a241', '2026-01', 'Adding more service', 'Adding new services such as Nextcloud, Obsidian Sync Server', 'done', NULL, 2, 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064'),
('e0117994-f5fe-4433-ac64-f33a814acf0e', '2026-05', 'Restarting project', 'Not anymore in match with the first version, i started development of the current version', 'done', NULL, 2, '28e23076-b51a-43ca-ad75-97b050ee64d0'),
('f2dc7457-dc84-4364-a0a2-f9a54eb3b27c', '2026-03', 'Improving infrastructure', 'Adding a new 6TB storage array', 'done', NULL, 3, 'e86bf4ae-63a3-4bc1-9745-12dfdbdda064'),
('bf62f51f-337f-4fec-ba0e-fc2945ce84af', '2024-11', 'API development', 'Developing the API with C# and dotnet', 'done', NULL, 1, '46559190-c45e-416a-a546-dfc6039d52de');

-- --------------------------------------------------------

--
-- Table structure for table `skills`
--

CREATE TABLE `skills` (
  `id` uuid NOT NULL,
  `name` varchar(255) NOT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `categoryId` uuid DEFAULT NULL,
  `cvCategory` enum('hard','soft') NOT NULL,
  `description` text DEFAULT NULL,
  `level` int(11) NOT NULL DEFAULT 0,
  `order` int(11) NOT NULL DEFAULT 0,
  `keywords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`keywords`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `skills`
--

INSERT INTO `skills` (`id`, `name`, `icon`, `categoryId`, `cvCategory`, `description`, `level`, `order`, `keywords`) VALUES
('23e706a8-8c15-4464-9243-015730036121', 'Linux', 'mdi:linux', '9ccceb18-6dd7-4a1c-8746-04f5b06ed230', 'hard', NULL, 90, 10, NULL),
('15ff098f-c421-4d4a-b6bc-030f2bc2a6b6', 'Go', 'mdi:language-go', 'e65c2bad-6638-4c09-aabb-3f893ca2aada', 'hard', NULL, 60, 4, NULL),
('227206b4-44a4-42b3-87f1-0b7528ef12ce', 'Cisco', 'simple-icons:cisco', '1a928c01-a1f1-4486-98eb-a4d877a8b1f5', 'hard', NULL, 80, 39, '[\"Switch\",\"Router\",\"VLAN\"]'),
('c95ed783-d391-4c55-b046-1c71925157be', 'Scripting', 'mdi:script', '9ccceb18-6dd7-4a1c-8746-04f5b06ed230', 'hard', NULL, 95, 30, '[\"Bash\",\"Python\",\"Automatisation\"]'),
('8262a153-e75f-4685-b7df-2398dff69d43', 'Agentic IA', 'ri:ai', 'e65c2bad-6638-4c09-aabb-3f893ca2aada', 'hard', NULL, 75, 42, '[\"OpenAI\"]'),
('bbcf0f8b-93b9-437a-a9f5-248899a774d3', 'Docker', 'mdi:docker', '1a928c01-a1f1-4486-98eb-a4d877a8b1f5', 'hard', NULL, 90, 7, NULL),
('237b275b-9bc5-41d8-b70f-2c3d49032abe', 'CI/CD', 'cib:azure-pipelines', '1a928c01-a1f1-4486-98eb-a4d877a8b1f5', 'hard', NULL, 75, 11, NULL),
('f918d709-7452-4945-b27d-2db06c7a8315', 'VPN', 'mdi:vpn', '1a928c01-a1f1-4486-98eb-a4d877a8b1f5', 'hard', NULL, 85, 31, '[\"Wireguard\",\"OpenVPN\"]'),
('7544b2b9-2d87-4039-bf8a-2de11e35dc44', 'nestJS', 'file-icons:nestjs', 'e65c2bad-6638-4c09-aabb-3f893ca2aada', 'hard', NULL, 80, 41, '[\"TS\"]'),
('2d330da5-b291-4b36-81f7-2ed26ac87a10', 'Windows Server', 'mdi:windows', '9ccceb18-6dd7-4a1c-8746-04f5b06ed230', 'hard', 'Capable de créé des structures de A à Z', 85, 23, NULL),
('f5294185-b125-4861-8762-300971b92a9f', 'Node.js', 'mdi:nodejs', 'e65c2bad-6638-4c09-aabb-3f893ca2aada', 'hard', NULL, 75, 3, NULL),
('47dd5502-6d81-4a7e-a99c-37bdb898472d', 'MongoDB', 'cib:mongodb', 'e65c2bad-6638-4c09-aabb-3f893ca2aada', 'hard', NULL, 10, 14, NULL),
('b74f4bf5-edbf-43e8-ad49-3a3347f1f8cc', 'VXLAN', 'carbon:vlan', '9ccceb18-6dd7-4a1c-8746-04f5b06ed230', 'hard', NULL, 80, 29, '[]'),
('b2361fc2-4484-492f-b62a-4372b7391a10', 'Résolution de problèmes', 'tabler:point-filled', NULL, 'soft', 'Analyse et cherche des solutions réels', 95, 22, NULL),
('75631078-b9a2-4211-9ea9-4b66b27c3641', 'Claude AI', 'meteor-icons:claude', 'e65c2bad-6638-4c09-aabb-3f893ca2aada', 'hard', NULL, 80, 37, '[\"IA\",\"Prompting\"]'),
('f68bdf74-6845-4d60-aa09-4f0d149a600c', 'TrueNas', 'simple-icons:truenas', '9ccceb18-6dd7-4a1c-8746-04f5b06ed230', 'hard', NULL, 75, 24, NULL),
('b1c840fe-4c2a-49ea-b541-50387052524e', 'Git', 'mdi:git', 'e65c2bad-6638-4c09-aabb-3f893ca2aada', 'hard', NULL, 85, 15, '[]'),
('8478cb13-008c-44eb-8380-5364632bffce', 'Vue.js', 'mdi:vuejs', 'e65c2bad-6638-4c09-aabb-3f893ca2aada', 'hard', NULL, 85, 0, NULL),
('d0e45f72-b2b8-4217-993d-60d9f03671a2', 'API REST', 'mdi:api', 'e65c2bad-6638-4c09-aabb-3f893ca2aada', 'hard', NULL, 90, 43, '[\"RESTFULL\"]'),
('7cd2ef39-c4b6-48ac-bdd6-614675788d56', 'Rust', 'mdi:language-rust', 'e65c2bad-6638-4c09-aabb-3f893ca2aada', 'hard', NULL, 15, 6, NULL),
('fe0c8701-95d6-4c83-a8ae-66fcee8f7342', 'Esprit d\'analyse', 'bx:analyse', 'fa8d9e86-3ff2-4472-a45a-a35cc1422c92', 'soft', 'Décomposition et résolution de problèmes complexes', 90, 38, '[]'),
('5e5187bc-859b-4c5d-a45f-6c37df1bead6', 'Python', 'mdi:language-python', 'e65c2bad-6638-4c09-aabb-3f893ca2aada', 'hard', NULL, 85, 2, NULL),
('f04d0a6b-99de-480d-b01e-79cb6ab11620', 'Windows', 'mdi:windows', '9ccceb18-6dd7-4a1c-8746-04f5b06ed230', 'hard', NULL, 90, 40, '[\"Powershell\"]'),
('49f3f30a-9daf-450f-b6a6-8959e45c6d54', 'Organisation', 'tabler:point-filled', NULL, 'soft', 'Gestion des priorités et du temps', 85, 21, '[]'),
('9337513c-374c-486c-b683-8adf03fb9463', 'Pédagogie', 'mdi:learn', 'e65c2bad-6638-4c09-aabb-3f893ca2aada', 'soft', 'Capacité à expliquer et transmettre simplement', 95, 34, '[]'),
('3ce98505-438e-4383-bc70-8eda7810d11a', 'Service client', 'uil:user', NULL, 'soft', 'Accompagnement des clients', 100, 27, NULL),
('b778a492-0b34-428c-bc6e-8ffff11448d5', 'Office 365', 'mdi:office', '9ccceb18-6dd7-4a1c-8746-04f5b06ed230', 'hard', NULL, 89, 25, NULL),
('6430f088-e016-4fde-a938-9c15ccecae90', 'TypeScript', 'mdi:language-typescript', 'e65c2bad-6638-4c09-aabb-3f893ca2aada', 'hard', NULL, 80, 1, NULL),
('68b5c741-208c-49c0-8140-9c5d187789de', 'ArgoCD', 'devicon-plain:argocd', '1a928c01-a1f1-4486-98eb-a4d877a8b1f5', 'hard', NULL, 70, 32, '[\"CI/CD\",\"Pipeline\",\"K8S\"]'),
('e2868b5d-97d6-4556-8f5f-a586dc6a8c91', 'Proxmox', 'cib:proxmox', '1a928c01-a1f1-4486-98eb-a4d877a8b1f5', 'hard', NULL, 75, 9, NULL),
('5d9f55fe-bd88-422b-b8e0-acddca6707ab', 'PfSense', 'mdi:firewall', '9ccceb18-6dd7-4a1c-8746-04f5b06ed230', 'hard', NULL, 0, 44, '[\"firewall\",\"vlan\",\"dhcp\"]'),
('fc2596c3-0dc4-4bf0-ac99-aebe184070bd', 'Flexibilité', 'mingcute:flexibility-fill', NULL, 'soft', 'Adaptation rapide et compétences variés', 95, 18, NULL),
('2ea576d5-44d3-42a8-b2c0-b1319942b64b', 'Esprit d\'équipe', 'ant-design:team-outlined', NULL, 'soft', 'Collaboration, entraide et gestion d\'équipes', 100, 19, NULL),
('8df15dce-8267-430f-b1f5-b2103e51eb6a', 'Networking', 'mdi:wan', '9ccceb18-6dd7-4a1c-8746-04f5b06ed230', 'hard', NULL, 80, 16, '[]'),
('54a32bea-07ae-4e67-900f-b34d883ca5d3', 'Patience', 'simple-icons:await', 'fa8d9e86-3ff2-4472-a45a-a35cc1422c92', 'soft', 'Accompagner chacun à son propre rythme', 95, 36, '[]'),
('6902e148-cd49-4eda-8f2f-b86aa4d0d4ea', 'Méthode agile', 'tabler:point-filled', NULL, 'soft', 'Organisation par sprint', 70, 20, NULL),
('0c69d863-5e67-4205-9a30-c666f726b10e', 'Ansible', 'mdi:ansible', '1a928c01-a1f1-4486-98eb-a4d877a8b1f5', 'hard', NULL, 40, 33, '[\"Automatisation\",\"Shell\",\"Scripting\"]'),
('8ccc43e4-fe68-4cd8-9562-ca093d409040', 'Plesk', 'simple-icons:plesk', '1a928c01-a1f1-4486-98eb-a4d877a8b1f5', 'hard', NULL, 83, 26, NULL),
('dbc31c97-a63d-453c-ac2a-ca85dc432deb', 'Autodidacte', 'mdi:autonomous', NULL, 'soft', 'Capacité à apprendre en autonomie', 100, 17, NULL),
('daf31fd1-0f62-4e2b-9013-cc001c305fce', 'MariaDB', 'mdi:database', 'e65c2bad-6638-4c09-aabb-3f893ca2aada', 'hard', NULL, 80, 12, NULL),
('6d6b8647-1a9a-400b-b4fe-cf0088274904', 'React', 'mdi:react', 'e65c2bad-6638-4c09-aabb-3f893ca2aada', 'hard', NULL, 25, 5, NULL),
('552e0ef2-8dd7-40da-a1d9-d4960c715cec', 'Firewall', 'mdi:firewall', '9ccceb18-6dd7-4a1c-8746-04f5b06ed230', 'hard', NULL, 80, 28, '[\"Iptables\",\"OpnSense\",\"NAT\"]'),
('64140dce-ddd9-4b46-a385-e0b4c35e2374', 'Ecoute', 'uil:ear', 'fa8d9e86-3ff2-4472-a45a-a35cc1422c92', 'soft', 'Comprendre les blocages et besoins des élèves', 90, 35, '[]'),
('20361c79-a798-41d1-a9f6-f808e78ea4b2', 'Kubernetes', 'mdi:kubernetes', '1a928c01-a1f1-4486-98eb-a4d877a8b1f5', 'hard', NULL, 75, 8, NULL),
('23c326fa-1ad5-44a5-a028-fbd91fdc4e71', 'Redis', 'cib:redis', '1a928c01-a1f1-4486-98eb-a4d877a8b1f5', 'hard', NULL, 70, 13, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` uuid NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','editor','ai') NOT NULL DEFAULT 'editor',
  `createdAt` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `createdAt`) VALUES
('cf70c062-1be3-4381-af62-2f63c772dac2', 'ai-agent', 'a4b0433dc6510ecdc1d13e751fdbdb98e83d1997198cdeb44c1e0b36579b7702', 'ai', '2026-08-16 12:03:35.548985'),
('55ca3360-9e47-4e2b-ac37-a221c74f319b', 'loanmata4@gmail.com', 'b8da06b169862bcbece116a8223b8b3fd397768801d83b89d1aa511d8f2aa86d', 'admin', '2026-06-03 16:59:55.000000');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cvs`
--
ALTER TABLE `cvs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_8a5c2388247fe65e66d6fe2d79c` (`pictureId`);

--
-- Indexes for table `cv_contacts`
--
ALTER TABLE `cv_contacts`
  ADD PRIMARY KEY (`cvsId`,`contactsId`),
  ADD KEY `IDX_e8e1d58e516c8fdf8f5db5f0b4` (`cvsId`),
  ADD KEY `IDX_f2c85908ac4a122026378d3a4a` (`contactsId`);

--
-- Indexes for table `cv_education`
--
ALTER TABLE `cv_education`
  ADD PRIMARY KEY (`cvsId`,`educationId`),
  ADD KEY `IDX_b1da5ba29e59193d32e28f1551` (`cvsId`),
  ADD KEY `IDX_606c1c3073c3e7eb0eb263911e` (`educationId`);

--
-- Indexes for table `cv_experiences`
--
ALTER TABLE `cv_experiences`
  ADD PRIMARY KEY (`cvsId`,`experiencesId`),
  ADD KEY `IDX_121088511e2df8d7b06050f694` (`cvsId`),
  ADD KEY `IDX_2f4f56cc2c939b36243c6e6ec8` (`experiencesId`);

--
-- Indexes for table `cv_languages`
--
ALTER TABLE `cv_languages`
  ADD PRIMARY KEY (`cvsId`,`languagesId`),
  ADD KEY `IDX_0d6ca81d7579c558be47cbe653` (`cvsId`),
  ADD KEY `IDX_5ad77cdfb55ac7dc1fe9d6b2f1` (`languagesId`);

--
-- Indexes for table `cv_passions`
--
ALTER TABLE `cv_passions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_1b934d1b110a029b31814c30942` (`cvId`),
  ADD KEY `FK_42954288e04f7586547d4ea04a3` (`passionId`);

--
-- Indexes for table `cv_projects`
--
ALTER TABLE `cv_projects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_77a5bd99c3f03f1761e0741ef5a` (`cvId`),
  ADD KEY `FK_f819920f6717ec3b5ac322471d7` (`projectId`);

--
-- Indexes for table `cv_skills`
--
ALTER TABLE `cv_skills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_a0c021d6cb98298ec7045927519` (`cvId`),
  ADD KEY `FK_39ff94cbcbd4c0da1eb17771f31` (`skillId`);

--
-- Indexes for table `education`
--
ALTER TABLE `education`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `experiences`
--
ALTER TABLE `experiences`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_085fa4f79d178135e3656f62f87` (`imageId`);

--
-- Indexes for table `experience_points`
--
ALTER TABLE `experience_points`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_8019fe6e49cc4aff210bd1a2359` (`experienceId`);

--
-- Indexes for table `experience_skills`
--
ALTER TABLE `experience_skills`
  ADD PRIMARY KEY (`experiencesId`,`skillsId`),
  ADD KEY `IDX_d7b3868f654e8aa77c56fa947f` (`experiencesId`),
  ADD KEY `IDX_8cced8176c352061a222e33e45` (`skillsId`);

--
-- Indexes for table `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `languages`
--
ALTER TABLE `languages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `links`
--
ALTER TABLE `links`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_75f8a32ad6839de37c249390568` (`projectId`),
  ADD KEY `FK_b4c4f0abcafd7206c5177bdac7f` (`experienceId`);

--
-- Indexes for table `passions`
--
ALTER TABLE `passions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `profiles`
--
ALTER TABLE `profiles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_ef3ae594e51fcc648bb8656463d` (`imageId`),
  ADD KEY `FK_8580b5d7f604f1319234f100bee` (`educationId`);

--
-- Indexes for table `project_categories`
--
ALTER TABLE `project_categories`
  ADD PRIMARY KEY (`projectsId`,`categoriesId`),
  ADD KEY `IDX_8d9ae5bac24b30469a49d8ca29` (`projectsId`),
  ADD KEY `IDX_2c66352fd6ed590e04bea3c752` (`categoriesId`);

--
-- Indexes for table `project_points`
--
ALTER TABLE `project_points`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_97bb23ed2e41b283174e1979c68` (`projectId`);

--
-- Indexes for table `project_skills`
--
ALTER TABLE `project_skills`
  ADD PRIMARY KEY (`projectsId`,`skillsId`),
  ADD KEY `IDX_f7ce3e1474ca215003433d1118` (`projectsId`),
  ADD KEY `IDX_652ae37711df572b75465a520c` (`skillsId`);

--
-- Indexes for table `project_timeline_entries`
--
ALTER TABLE `project_timeline_entries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_89118e0800442508014540560c9` (`projectId`);

--
-- Indexes for table `skills`
--
ALTER TABLE `skills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_06d267f85858229c10a01a08ad7` (`categoryId`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `IDX_fe0bb3f6520ee0469504521e71` (`username`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cvs`
--
ALTER TABLE `cvs`
  ADD CONSTRAINT `FK_8a5c2388247fe65e66d6fe2d79c` FOREIGN KEY (`pictureId`) REFERENCES `images` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `cv_contacts`
--
ALTER TABLE `cv_contacts`
  ADD CONSTRAINT `FK_e8e1d58e516c8fdf8f5db5f0b47` FOREIGN KEY (`cvsId`) REFERENCES `cvs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_f2c85908ac4a122026378d3a4a6` FOREIGN KEY (`contactsId`) REFERENCES `contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cv_education`
--
ALTER TABLE `cv_education`
  ADD CONSTRAINT `FK_606c1c3073c3e7eb0eb263911e9` FOREIGN KEY (`educationId`) REFERENCES `education` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_b1da5ba29e59193d32e28f1551e` FOREIGN KEY (`cvsId`) REFERENCES `cvs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cv_experiences`
--
ALTER TABLE `cv_experiences`
  ADD CONSTRAINT `FK_121088511e2df8d7b06050f6940` FOREIGN KEY (`cvsId`) REFERENCES `cvs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_2f4f56cc2c939b36243c6e6ec82` FOREIGN KEY (`experiencesId`) REFERENCES `experiences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cv_languages`
--
ALTER TABLE `cv_languages`
  ADD CONSTRAINT `FK_0d6ca81d7579c558be47cbe653d` FOREIGN KEY (`cvsId`) REFERENCES `cvs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_5ad77cdfb55ac7dc1fe9d6b2f1a` FOREIGN KEY (`languagesId`) REFERENCES `languages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cv_passions`
--
ALTER TABLE `cv_passions`
  ADD CONSTRAINT `FK_1b934d1b110a029b31814c30942` FOREIGN KEY (`cvId`) REFERENCES `cvs` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_42954288e04f7586547d4ea04a3` FOREIGN KEY (`passionId`) REFERENCES `passions` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `cv_projects`
--
ALTER TABLE `cv_projects`
  ADD CONSTRAINT `FK_77a5bd99c3f03f1761e0741ef5a` FOREIGN KEY (`cvId`) REFERENCES `cvs` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_f819920f6717ec3b5ac322471d7` FOREIGN KEY (`projectId`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `cv_skills`
--
ALTER TABLE `cv_skills`
  ADD CONSTRAINT `FK_39ff94cbcbd4c0da1eb17771f31` FOREIGN KEY (`skillId`) REFERENCES `skills` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_a0c021d6cb98298ec7045927519` FOREIGN KEY (`cvId`) REFERENCES `cvs` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `experiences`
--
ALTER TABLE `experiences`
  ADD CONSTRAINT `FK_085fa4f79d178135e3656f62f87` FOREIGN KEY (`imageId`) REFERENCES `images` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `experience_points`
--
ALTER TABLE `experience_points`
  ADD CONSTRAINT `FK_8019fe6e49cc4aff210bd1a2359` FOREIGN KEY (`experienceId`) REFERENCES `experiences` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `experience_skills`
--
ALTER TABLE `experience_skills`
  ADD CONSTRAINT `FK_8cced8176c352061a222e33e45c` FOREIGN KEY (`skillsId`) REFERENCES `skills` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_d7b3868f654e8aa77c56fa947f5` FOREIGN KEY (`experiencesId`) REFERENCES `experiences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `links`
--
ALTER TABLE `links`
  ADD CONSTRAINT `FK_75f8a32ad6839de37c249390568` FOREIGN KEY (`projectId`) REFERENCES `projects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_b4c4f0abcafd7206c5177bdac7f` FOREIGN KEY (`experienceId`) REFERENCES `experiences` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `FK_8580b5d7f604f1319234f100bee` FOREIGN KEY (`educationId`) REFERENCES `education` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_ef3ae594e51fcc648bb8656463d` FOREIGN KEY (`imageId`) REFERENCES `images` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `project_categories`
--
ALTER TABLE `project_categories`
  ADD CONSTRAINT `FK_2c66352fd6ed590e04bea3c752c` FOREIGN KEY (`categoriesId`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_8d9ae5bac24b30469a49d8ca294` FOREIGN KEY (`projectsId`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `project_points`
--
ALTER TABLE `project_points`
  ADD CONSTRAINT `FK_97bb23ed2e41b283174e1979c68` FOREIGN KEY (`projectId`) REFERENCES `projects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `project_skills`
--
ALTER TABLE `project_skills`
  ADD CONSTRAINT `FK_652ae37711df572b75465a520c8` FOREIGN KEY (`skillsId`) REFERENCES `skills` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_f7ce3e1474ca215003433d11181` FOREIGN KEY (`projectsId`) REFERENCES `projects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `project_timeline_entries`
--
ALTER TABLE `project_timeline_entries`
  ADD CONSTRAINT `FK_89118e0800442508014540560c9` FOREIGN KEY (`projectId`) REFERENCES `projects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `skills`
--
ALTER TABLE `skills`
  ADD CONSTRAINT `FK_06d267f85858229c10a01a08ad7` FOREIGN KEY (`categoryId`) REFERENCES `categories` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
