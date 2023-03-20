INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_cockatoos', 'Cockatoos', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_cockatoos', 'Cockatoos', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_cockatoos', 'Cockatoos', 1)
;

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('cockatoos', 0, 'recrue', 'Recrue', 20, '', ''),
('cockatoos', 1, 'member', 'Employe', 40, '', ''),
('cockatoos', 2, 'leader', 'Chef de Bar', 60, '', ''),
('cockatoos', 3, 'boss', 'Patron', 80, '', '');

INSERT INTO `jobs` (name, label) VALUES
	('cockatoos','Cockatoos')
;

INSERT INTO `items` (`name`, `label`) VALUES
	('verre', 'Verre'),
	('cartons_verres', 'Cartons de verres')
;