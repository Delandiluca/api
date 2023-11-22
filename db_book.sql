CREATE DATABASE IF NOT EXISTS app_book;


INSERT INTO users (name, username, password, createdAt) VALUES ('Delandi Lucas', 'delandilucas', 'admin', NOW());
INSERT INTO users (name, username, password, createdAt) VALUES ('Agda Silva', 'agda', 'admin', NOW());

INSERT INTO books (title, author, gender, createdAt, imageUrl, sinopse, linkReference, codeUser) 
VALUES ('TituloTest', 'AutorTest', 'GeneroTest', NOW(), 'ImagemTest', 'SinopseTest', 'LinkTest', 3);
INSERT INTO books (title, author, gender, createdAt, imageUrl, sinopse, linkReference, codeUser) 
VALUES ('TituloTest2', 'AutorTest2', 'GeneroTest2', '20000210', 'ImagemTest', 'SinopseTest', 'LinkTest', 2);
INSERT INTO books (title, author, gender, createdAt, imageUrl, sinopse, linkReference, codeUser) 
VALUES ('TituloTest3', 'AutorTest3', 'GeneroTest3', '20231118', 'ImagemTest', 'SinopseTest', 'LinkTest', 1);

INSERT INTO notes (value, description, createdAt,codeUser, codeBook) 
VALUES (10, 'Descricao de teste sobre o livo tal lorem ipsum', NOW(), 2, 4);
INSERT INTO notes (value, description, createdAt,codeUser, codeBook) 
VALUES (5, 'IPSUM LOREM', NOW(), 3, 2);
INSERT INTO notes (value, description, createdAt,codeUser, codeBook) 
VALUES (3, 'LOREM IPSUM IPSUM LOREM', NOW(), 3, 5);



SELECT * FROM users WHERE username='delandilucas' AND password='admin';

CREATE TABLE IF NOT EXISTS users (
	code 			SERIAL 		  		NOT NULL,
	name 			VARCHAR(200) 	  	NOT NULL,
	username 		VARCHAR(200) 		NOT NULL,
	password 		VARCHAR(200) 		NOT NULL,
	createdAt 		VARCHAR(200)		NOT NULL,
	CONSTRAINT pk_user
		PRIMARY KEY (code)
);

CREATE TABLE IF NOT EXISTS books (
	code 			SERIAL 				NOT NULL,
	title 			VARCHAR(200) 		NOT NULL,
	author 			VARCHAR(200) 		NOT NULL,
	gender 			VARCHAR(200) 		NOT NULL,
	createdAt 		VARCHAR(200)		NOT NULL,
	imageUrl 		VARCHAR(200) 		NOT NULL,
	sinopse 		VARCHAR(200) 		NOT NULL,
	linkReference 	VARCHAR(200) 		NOT NULL,
	codeUser 		INTEGER				NOT NULL,
	CONSTRAINT pk_book
		PRIMARY KEY (code),
	
	CONSTRAINT fk_user_book
		FOREIGN KEY (codeUser)
		REFERENCES users(code)
);

CREATE TABLE IF NOT EXISTS notes (
	code 			SERIAL 		  		NOT NULL,
	value 			INTEGER 	  		NOT NULL,
	description 	VARCHAR(200) 		NOT NULL,
	createdAt 		VARCHAR(200)		NOT NULL,
	codeUser 		INTEGER 			NOT NULL,
	codeBook		INTEGER				NOT NULL,
	CONSTRAINT pk_note
		PRIMARY KEY (code),
	
	CONSTRAINT fk_user_note
		FOREIGN KEY (codeUser)
		REFERENCES users(code),
	
	CONSTRAINT fk_book_note
		FOREIGN KEY (codeBook)
		REFERENCES books(code)
);

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS notes;

SELECT * FROM users
SELECT * FROM books
SELECT * FROM notes

SELECT * FROM users WHERE username='teste' AND password='b6236845d5210c93a56fcb6ae8b78054cb5e9620d90a4f84ad81cfcad3b561d4'

DELETE FROM books WHERE code=3

UPDATE books SET
            author = 'Delandi Lucas',
            gender = 'Comedia',
          WHERE code = 2;
		  
SELECT books.* FROM books
	JOIN users ON books.codeUser = users.code
	WHERE users.code = 2;
	
SELECT books.* FROM books
	WHERE author = 'Delandi Lucas';
	
SELECT books.* FROM books
	WHERE gender = 'Comedia';
	
SELECT 
    b.code AS book_code,
    b.title AS book_title,
    b.author AS book_author,
    n.value AS note_value,
    n.description AS note_description,
    u2.name AS user_name
FROM 
    users u
JOIN 
    books b ON u.code = b.codeUser
LEFT JOIN 
    notes n ON b.code = n.codeBook
LEFT JOIN 
    users u2 ON n.codeUser = u2.code
WHERE 
    u.code = 2
    AND b.code = 5;
	
SELECT notes.*, users.name AS userName
FROM notes
JOIN books ON notes.codeBook = books.code
JOIN users ON notes.codeUser = users.code
WHERE books.code = 5;