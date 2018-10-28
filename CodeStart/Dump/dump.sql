
-- --------------------------------------------
-- --------------------------------------------
-- ----------- MYSQL DATABASE DDL -------------
-- --------------------------------------------
-- --------------------------------------------
-- Version: MYSQL 5.7.4 -----------------------
-- Author: Lauro Oliveira----------------------
-- --------------------------------------------

-- DATABASE:

	SET GLOBAL max_allowed_packet=1073741824;
	SET NAMES UTF8;
	DROP DATABASE IF EXISTS CODESTART;
	CREATE DATABASE CODESTART;
    USE CODESTART;

-- TABLE:

	CREATE TABLE USER(

		ID INT NOT NULL,
		NAME VARCHAR(100) NOT NULL,
		USERNAME VARCHAR(100) NOT NULL,
		EMAIL VARCHAR(100) NOT NULL,
		PASSWORD VARCHAR(40) NOT NULL,
		ABOUT TEXT NOT NULL,
		BIRTH DATE NOT NULL,
		PROFILE BLOB,
		RANKING VARCHAR(50) DEFAULT "Begginer" NOT NULL

	)ENGINE=INNODB;


	CREATE TABLE QUESTION(

		ID INT NOT NULL,
		TITTLE TEXT,
		DESCRIPTION LONGTEXT NOT NULL,
		POSTDATE DATETIME NOT NULL,
		VIEW INT DEFAULT 0,

		ID_USER INT NOT NULL

	)ENGINE=INNODB;


	CREATE TABLE ANSWER(

		ID INT NOT NULL,
		DESCRIPTION LONGTEXT NOT NULL,
		POSTDATE DATETIME NOT NULL,

		ID_QUESTION INT NOT NULL,
		ID_USER INT NOT NULL

	)ENGINE=INNODB;


	CREATE TABLE COMMENT(

		ID INT NOT NULL,
		DESCRIPTION LONGTEXT NOT NULL,
		POSTDATE DATETIME NOT NULL,

		ID_ANSWER INT NOT NULL,
		ID_USER INT NOT NULL

	)ENGINE=INNODB;


	CREATE TABLE TAG(

		ID INT NOT NULL,
		DESCRIPTION LONGTEXT NOT NULL

	)ENGINE=INNODB;


	CREATE TABLE QUESTION_TAG(

		ID INT NOT NULL,
		ID_QUESTION INT NOT NULL,
		ID_TAG INT NOT NULL


	)ENGINE=INNODB;


	CREATE TABLE LIKE_QUESTION(

		ID INT NOT NULL,
		STATE BOOLEAN NOT NULL,
		ID_QUESTION INT NOT NULL,
		ID_USER INT NOT NULL


	)ENGINE=INNODB;


	CREATE TABLE LIKE_ANSWER(

		ID INT NOT NULL,
		STATE BOOLEAN NOT NULL,
		ID_ANSWER INT NOT NULL,
		ID_USER INT NOT NULL


	)ENGINE=INNODB;
	
-- PRIMARY KEY:

	ALTER TABLE USER
	ADD CONSTRAINT PK_USER
	PRIMARY KEY (ID);
	ALTER TABLE USER MODIFY COLUMN ID INT NOT NULL AUTO_INCREMENT;


	ALTER TABLE QUESTION
	ADD CONSTRAINT PK_QUESTION
	PRIMARY KEY (ID);
	ALTER TABLE QUESTION MODIFY COLUMN ID INT NOT NULL AUTO_INCREMENT;



	ALTER TABLE ANSWER
	ADD CONSTRAINT PK_ANSWER
	PRIMARY KEY (ID);
	ALTER TABLE ANSWER MODIFY COLUMN ID INT NOT NULL AUTO_INCREMENT;



	ALTER TABLE COMMENT
	ADD CONSTRAINT PK_COMMENT
	PRIMARY KEY (ID);
	ALTER TABLE COMMENT MODIFY COLUMN ID INT NOT NULL AUTO_INCREMENT;



	ALTER TABLE TAG
	ADD CONSTRAINT PK_TAG
	PRIMARY KEY (ID);
	ALTER TABLE TAG MODIFY COLUMN ID INT NOT NULL AUTO_INCREMENT;



	ALTER TABLE QUESTION_TAG
	ADD CONSTRAINT PK_QUESTION_TAG
	PRIMARY KEY (ID);
	ALTER TABLE QUESTION_TAG MODIFY COLUMN ID INT NOT NULL AUTO_INCREMENT;



	ALTER TABLE LIKE_QUESTION
	ADD CONSTRAINT PK_LIKE_QUESTION
	PRIMARY KEY (ID);
	ALTER TABLE LIKE_QUESTION MODIFY COLUMN ID INT NOT NULL AUTO_INCREMENT;



	ALTER TABLE LIKE_ANSWER
	ADD CONSTRAINT PK_LIKE_ANSWER
	PRIMARY KEY (ID);
	ALTER TABLE LIKE_ANSWER MODIFY COLUMN ID INT NOT NULL AUTO_INCREMENT;


-- FOREIGN KEY:

	ALTER TABLE QUESTION
	ADD CONSTRAINT FK_QUESTION_IDUSER
	FOREIGN KEY(ID_USER)
	REFERENCES USER(ID);


	ALTER TABLE ANSWER
	ADD CONSTRAINT FK_ANSWER_QUESTION
	FOREIGN KEY(ID_QUESTION)
	REFERENCES QUESTION(ID);


	ALTER TABLE ANSWER
	ADD CONSTRAINT FK_ANSWER_USER
	FOREIGN KEY(ID_USER)
	REFERENCES USER(ID);


	ALTER TABLE COMMENT
	ADD CONSTRAINT FK_COMMENT_ANSWER
	FOREIGN KEY(ID_ANSWER)
	REFERENCES ANSWER(ID);


	ALTER TABLE COMMENT
	ADD CONSTRAINT FK_COMMENT_USER
	FOREIGN KEY(ID_USER)
	REFERENCES USER(ID);


	ALTER TABLE QUESTION_TAG
	ADD CONSTRAINT FK_QUESTION_TAG_QUESTION
	FOREIGN KEY(ID_QUESTION)
	REFERENCES QUESTION(ID);


	ALTER TABLE QUESTION_TAG
	ADD CONSTRAINT FK_QUESTION_TAG_TAG
	FOREIGN KEY(ID_TAG)
	REFERENCES TAG(ID);


	ALTER TABLE LIKE_QUESTION
	ADD CONSTRAINT FK_LIKE_QUESTION_QUESTION
	FOREIGN KEY(ID_QUESTION)
	REFERENCES QUESTION(ID);


	ALTER TABLE LIKE_QUESTION
	ADD CONSTRAINT FK_LIKE_QUESTION_USER
	FOREIGN KEY(ID_USER)
	REFERENCES USER(ID);


	ALTER TABLE LIKE_ANSWER
	ADD CONSTRAINT FK_LIKE_ANSWER_ANSWER
	FOREIGN KEY(ID_ANSWER)
	REFERENCES ANSWER(ID);


	ALTER TABLE LIKE_ANSWER
	ADD CONSTRAINT FK_LIKE_ANSWER_USER
	FOREIGN KEY(ID_USER)
	REFERENCES USER(ID);


-- UNIQUE: 

	ALTER TABLE USER ADD CONSTRAINT UQ_USER_USERNAME UNIQUE(USERNAME);

	ALTER TABLE USER ADD CONSTRAINT UQ_USER_EMAIL UNIQUE(EMAIL);

-- VIEW:
	
	CREATE VIEW  SEE_TAGS AS 
		SELECT T.ID AS 'ID', T.DESCRIPTION AS 'DESCRIPTION' FROM TAG T;
		
-- PROCEDURES:
	DELIMITER $

	CREATE PROCEDURE ADD_USER(
		IN VAR_NAME VARCHAR(100),
		IN VAR_USERNAME VARCHAR(100),
		IN VAR_EMAIL VARCHAR(100),
		IN VAR_PASSWORD VARCHAR(40),
		IN VAR_ABOUT TEXT,
		IN VAR_BIRTH DATE,
		IN VAR_PROFILE BLOB,
		OUT VAR_ID INT
	)
	BEGIN 	
		INSERT INTO USER(
			ID,
			NAME,
			USERNAME,
			EMAIL,
			PASSWORD,
			ABOUT,
			BIRTH,
			PROFILE,
			RANKING
		) VALUES(
			NULL,
			VAR_NAME,
			VAR_USERNAME,
			VAR_EMAIL,
			VAR_PASSWORD,
			VAR_ABOUT,
			VAR_BIRTH,
			VAR_PROFILE,
			DEFAULT
		);
		SET VAR_ID = (SELECT LAST_INSERT_ID() AS 'ID'); 
    	SELECT VAR_ID;
	END $

	CREATE PROCEDURE ALTER_USER(
		IN VAR_ID INT,
		IN VAR_NAME VARCHAR(100),
		IN VAR_USERNAME VARCHAR(100),
		IN VAR_EMAIL VARCHAR(100),
		IN VAR_PASSWORD VARCHAR(40),
		IN VAR_ABOUT TEXT,
		IN VAR_BIRTH DATE,
		IN VAR_PROFILE BLOB
		
	)
	BEGIN 	
		UPDATE USER SET
			NAME = VAR_NAME,
			USERNAME = VAR_USERNAME,
			EMAIL = VAR_EMAIL,
			PASSWORD = VAR_PASSWORD,
			ABOUT = VAR_ABOUT,
			BIRTH = VAR_BIRTH,
			PROFILE = VAR_PROFILE
		WHERE ID =VAR_ID;
	END $

	CREATE PROCEDURE DROP_USER(
		IN VAR_ID INT
	)
	BEGIN 	
		DELETE FROM USER
		WHERE ID =VAR_ID;
	END $

	CREATE PROCEDURE SELECT_USER(
		IN VAR_ID INT
	)
	BEGIN 	
		SELECT 
			U.ID AS 'ID',
			U.NAME AS 'NAME',
			U.USERNAME AS 'USERNAME',
			U.EMAIL AS 'EMAIL',
			U.ABOUT AS 'ABOUT',
			U.BIRTH AS 'BIRTH',
			U.PROFILE AS 'PROFILE',
			U.RANKING AS 'RANKING'
		FROM USER U
		WHERE U.ID =VAR_ID;
	END $

	CREATE PROCEDURE LOGIN_USER(
		IN VAR_LOGIN VARCHAR(100),
		IN VAR_PASSWORD VARCHAR(40)
	)
	BEGIN 	
		SELECT 
			U.ID AS 'ID',
			U.NAME AS 'NAME',
			U.USERNAME AS 'USERNAME',
			U.EMAIL AS 'EMAIL',
			U.ABOUT AS 'ABOUT',
			U.BIRTH AS 'BIRTH',
			U.PROFILE AS 'PROFILE',
			U.RANKING AS 'RANKING'
		FROM USER U
		WHERE 
		(U.EMAIL =VAR_LOGIN OR U.USERNAME =VAR_LOGIN) 
		AND U.PASSWORD = VAR_PASSWORD;
	END $

	CREATE PROCEDURE ADD_QUESTION(
		IN VAR_TITTLE TEXT,
		IN VAR_DESCRIPTION LONGTEXT,
		IN VAR_USER_ID INT
	)
	BEGIN 	
		INSERT INTO QUESTION(
			ID,
			TITTLE,
			DESCRIPTION,
			POSTDATE,
			VIEW,
			ID_USER			
		) VALUES(
			NULL,
			VAR_TITTLE,
			VAR_DESCRIPTION,
			NOW(),
			DEFAULT,
			VAR_USER_ID
		);

    	SELECT (SELECT LAST_INSERT_ID() AS 'ID') AS 'ID';
	END $

	CREATE PROCEDURE ADD_VIEW_QUESTION(
		IN VAR_ID INT
	)
	BEGIN 	
		UPDATE QUESTION 
		SET VIEW = VIEW +1 
		WHERE ID = VAR_ID;
	END $

	CREATE PROCEDURE ALTER_QUESTION(
		IN VAR_ID INT,
		IN VAR_TITTLE TEXT,
		IN VAR_DESCRIPTION LONGTEXT
	)
	BEGIN 	
		UPDATE QUESTION SET
			TITTLE = VAR_TITTLE,
			DESCRIPTION = VAR_DESCRIPTION
		WHERE ID =VAR_ID;
	END $

	CREATE PROCEDURE DROP_QUESTION(
		IN VAR_ID INT
	)
	BEGIN 	
		DELETE FROM QUESTION
		WHERE ID =VAR_ID;
	END $

	CREATE PROCEDURE SELECT_QUESTION(
		IN VAR_ID INT
	)
	BEGIN 	
		SELECT 
			Q.ID AS 'ID',
			Q.TITTLE AS 'TITTLE',
			Q.DESCRIPTION AS 'DESCRIPTION',
			Q.POSTDATE AS 'POSTDATE',
			Q.VIEW AS 'VIEW',
			Q.ID_USER AS 'ID_USER'
			
		FROM QUESTION Q
		WHERE Q.ID =VAR_ID;
	END $

	CREATE PROCEDURE SELECT_QUESTION_USER(
		IN VAR_USERID INT
	)
	BEGIN 	
		SELECT 
			Q.ID AS 'ID',
			Q.TITTLE AS 'TITTLE',
			Q.DESCRIPTION AS 'DESCRIPTION',
			Q.POSTDATE AS 'POSTDATE',
			Q.VIEW AS 'VIEW',
			Q.ID_USER AS 'ID_USER'
			
		FROM QUESTION Q
			LEFT JOIN USER U ON U.ID_USER = Q.ID_USER
		WHERE Q.ID_USER =VAR_USERID;
	END $

	CREATE PROCEDURE SELECT_QUESTION_RECENT()
	BEGIN 	
		SELECT 
			Q.ID AS 'ID',
			Q.TITTLE AS 'TITTLE',
			Q.DESCRIPTION AS 'DESCRIPTION',
			Q.POSTDATE AS 'POSTDATE',
			Q.VIEW AS 'VIEW',
			Q.ID_USER AS 'ID_USER'
			
		FROM QUESTION Q ORDER BY Q.POSTDATE
        DESC LIMIT 20;
	END $

	CREATE PROCEDURE ADD_ANSWER(
		IN VAR_DESCRIPTION LONGTEXT,
		IN VAR_QUESTION_ID INT,
		IN VAR_USER_ID INT
	)
	BEGIN 	
		INSERT INTO ANSWER(
			ID,
			DESCRIPTION,
			POSTDATE,
			ID_QUESTION,
			ID_USER			
		) VALUES(
			NULL,
			VAR_DESCRIPTION,
			NOW(),
			VAR_QUESTION_ID,
			VAR_USER_ID
		);
		SELECT LAST_INSERT_ID() AS 'ID'; 
    
	END $

	CREATE PROCEDURE ALTER_ANSWER(
		IN VAR_ID INT,
		IN VAR_DESCRIPTION LONGTEXT
	)
	BEGIN 	
		UPDATE ANSWER SET
			DESCRIPTION = VAR_DESCRIPTION
		WHERE ID =VAR_ID;
	END $

	CREATE PROCEDURE DROP_ANSWER(
		IN VAR_ID INT
	)
	BEGIN 	
		DELETE FROM ANSWER
		WHERE ID =VAR_ID;
	END $

	CREATE PROCEDURE SELECT_ANSWER(
		IN VAR_ID INT
	)
	BEGIN 	
		SELECT 
			A.ID AS 'ID',
			A.DESCRIPTION AS 'DESCRIPTION',
			A.POSTDATE AS 'POSTDATE',
			A.ID_QUESTION AS 'ID_QUESTION',
			A.ID_USER AS 'ID_USER'

		FROM ANSWER A
		WHERE A.ID =VAR_ID;
	END $

	CREATE PROCEDURE SELECT_ANSWER_QUESTION(
		IN VAR_QUESTIONID INT
	)
	BEGIN 	
		SELECT 
			A.ID AS 'ID',
			A.DESCRIPTION AS 'DESCRIPTION',
			A.POSTDATE AS 'POSTDATE',
			A.ID_USER AS 'ID_USER'

		FROM ANSWER A
		LEFT JOIN QUESTION Q ON Q.ID = A.ID_QUESTION
		WHERE  A.ID_QUESTION =VAR_QUESTIONID
		ORDER BY POSTDATE ASC;
	END $

	CREATE PROCEDURE SELECT_ANSWER_USER(
		IN VAR_USERID INT
	)
	BEGIN 	
		SELECT 
			A.ID AS 'ID',
			A.DESCRIPTION AS 'DESCRIPTION',
			A.POSTDATE AS 'POSTDATE',
			A.ID_QUESTION AS 'ID_QUESTION',
			A.ID_USER AS 'ID_USER'

		FROM ANSWER A
		LEFT JOIN USER U ON U.ID = A.ID_USER
		WHERE  A.ID_QUESTION =VAR_USERID;
	END $

	CREATE PROCEDURE ADD_COMMENT(
		IN VAR_DESCRIPTION LONGTEXT,
		IN VAR_QUESTION_ID INT,
		IN VAR_USER_ID INT,
		OUT VAR_ID INT
	)
	BEGIN 	
		INSERT INTO COMMENT(
			ID,
			DESCRIPTION,
			POSTDATE,
			ID_QUESTION,
			ID_USER			
		) VALUES(
			NULL,
			VAR_DESCRIPTION,
			NOW(),
			VAR_QUESTION_ID,
			VAR_USER_ID
		);
		SET VAR_ID = (SELECT LAST_INSERT_ID() AS 'ID'); 
    	SELECT VAR_ID;
	END $

	CREATE PROCEDURE ALTER_COMMENT(
		IN VAR_ID INT,
		IN VAR_DESCRIPTION LONGTEXT
	)
	BEGIN 	
		UPDATE COMMENT SET
			DESCRIPTION = VAR_DESCRIPTION
		WHERE ID =VAR_ID;
	END $

	CREATE PROCEDURE DROP_COMMENT(
		IN VAR_ID INT
	)
	BEGIN 	
		DELETE FROM COMMENT
		WHERE ID =VAR_ID;
	END $

	CREATE PROCEDURE SELECT_COMMENT(
		IN VAR_ID INT
	)
	BEGIN 	
		SELECT 
			C.ID AS 'ID',
			C.DESCRIPTION AS 'DESCRIPTION',
			C.POSTDATE AS 'POSTDATE',
			C.ID_QUESTION AS 'ID_QUESTION',
			C.ID_USER AS 'ID_USER'

		FROM COMMENT C
		WHERE C.ID =VAR_ID;
	END $


	CREATE PROCEDURE SELECT_COMMENT_QUESTION(
		IN VAR_QUESTIONID INT
	)
	BEGIN 	
		SELECT 
			C.ID AS 'ID',
			C.DESCRIPTION AS 'DESCRIPTION',
			C.POSTDATE AS 'POSTDATE',
			C.ID_USER AS 'ID_USER'

		FROM COMMENT C
		LEFT JOIN ANSWER A ON A.ID = C.ID_QUESTION
		WHERE  C.ID_QUESTION =VAR_QUESTIONID;
	END $

	CREATE PROCEDURE SELECT_COMMENT_USER(
		IN VAR_USERID INT
	)
	BEGIN 	
		SELECT 
			C.ID AS 'ID',
			C.DESCRIPTION AS 'DESCRIPTION',
			C.POSTDATE AS 'POSTDATE',
			C.ID_QUESTION AS 'ID_QUESTION',
			C.ID_USER AS 'ID_USER'

		FROM COMMENT C
		LEFT JOIN USER U ON U.ID = C.ID_USER
		WHERE  C.ID_QUESTION =VAR_USERID;
	END $
	
	CREATE PROCEDURE ADD_TAG(
		IN VAR_DESCRIPTION LONGTEXT
	)
	BEGIN 	
		INSERT INTO TAG(
			ID,
			DESCRIPTION
		) VALUES(
			NULL,
			VAR_DESCRIPTION
		);
    	SELECT LAST_INSERT_ID() AS 'ID';
	END $

	CREATE PROCEDURE SELECT_TAG(
		IN VAR_ID INT
	)
	BEGIN 	
		SELECT 
			T.ID AS 'ID',
			T.DESCRIPTION AS 'DESCRIPTION'
		FROM TAG T
		WHERE T.ID =VAR_ID;
	END $

	CREATE PROCEDURE SELECT_TAG_DESCRIPTION(
		IN VAR_DESC VARCHAR(100)
	)
	BEGIN 	
		SELECT 
			T.ID AS 'ID',
			T.DESCRIPTION AS 'DESCRIPTION'
		FROM TAG T
		WHERE T.DESCRIPTION = VAR_DESC;
	END $

	CREATE PROCEDURE SELECT_TAG_QUESTION(
		IN VAR_QUESTIONID INT
	)
	BEGIN 	
		SELECT 
			T.ID AS 'ID',
			T.DESCRIPTION AS 'DESCRIPTION'
		FROM TAG T
		INNER JOIN QUESTION_TAG QT ON QT.ID_TAG =T.ID
		INNER JOIN QUESTION Q ON Q.ID = QT.ID_QUESTION
		WHERE Q.ID =VAR_QUESTIONID;
	END $

	CREATE PROCEDURE SELECT_TAG_USER(
		IN VAR_USERID INT
	)
	BEGIN 	
		SELECT 
			T.ID AS 'ID',
			T.DESCRIPTION AS 'DESCRIPTION'
		FROM TAG T
		INNER JOIN QUESTION_TAG QT ON QT.ID_TAG =T.ID
		INNER JOIN QUESTION Q ON Q.ID = QT.ID_QUESTION
		INNER JOIN USER U ON U.ID = Q.ID_USER
		WHERE U.ID =VAR_USERID;
	END $

	CREATE PROCEDURE ADD_QUESTION_TAG(
		IN VAR_ID_QUESTION INT,
		IN VAR_ID_TAG INT
	)
	BEGIN 	
		INSERT INTO QUESTION_TAG(
			ID,
			ID_QUESTION,
			ID_TAG
		) VALUES(
			NULL,
			VAR_ID_QUESTION,
			VAR_ID_TAG

		);
    	SELECT LAST_INSERT_ID() AS 'ID' ;
	END $

	CREATE PROCEDURE DROP_QUESTION_TAG(
		IN VAR_ID INT
	)
	BEGIN 	
		DELETE FROM QUESTION_TAG
		WHERE ID =VAR_ID;
	END $

	CREATE PROCEDURE ADD_LIKE_QUESTION(
		IN VAR_STATE INT,
		IN VAR_ID_QUESTION INT,
		IN VAR_ID_USER INT,
		OUT VAR_ID INT
	)
	BEGIN 	
		INSERT INTO LIKE_QUESTION(
			ID,
			STATE,
			ID_QUESTION,
			ID_USER
		) VALUES(
			NULL,
			VAR_STATE,
			VAR_ID_QUESTION,
			VAR_ID_TAG
		);
		SET VAR_ID = (SELECT LAST_INSERT_ID() AS 'ID'); 
    	SELECT VAR_ID;
	END $

	CREATE PROCEDURE DROP_LIKE_QUESTION(
		IN VAR_ID INT
	)
	BEGIN 	
		DELETE FROM LIKE_QUESTION
		WHERE ID =VAR_ID;
	END $

	CREATE PROCEDURE ADD_LIKE_ANSWER(
		IN VAR_STATE INT,
		IN VAR_ID_ANSWER INT,
		IN VAR_ID_USER INT,
		OUT VAR_ID INT
	)
	BEGIN 	
		INSERT INTO LIKE_ANSWER(
			ID,
			STATE,
			ID_ANSWER,
			ID_USER
		) VALUES(
			NULL,
			VAR_STATE,
			VAR_ID_ANSWER,
			VAR_ID_TAG
		);
		SET VAR_ID = (SELECT LAST_INSERT_ID() AS 'ID'); 
    	SELECT VAR_ID;
	END $

	CREATE PROCEDURE DROP_LIKE_ANSWER(
		IN VAR_ID INT
	)
	BEGIN 	
		DELETE FROM LIKE_ANSWER
		WHERE ID =VAR_ID;
	END $

	
-- INSERTS

	-- USER
	INSERT INTO `USER` VALUES (null,'Mr. Mitchell Feest','wallace27','adelbert.herzog@example.com','c01407669438a03c327f0e9d73e7066b4f590b06','Dolore eius id saepe temporibus porro cum. Sit molestias cumque assumenda non. Unde et nulla minus ut expedita quaerat quo. Unde est ab repellendus aut maiores sit et in.','2014-09-10',NULL,'Iniciante'),
	(null,'Mrs. Nellie Heathcote','roberts.carmelo','wiegand.alvah@example.net','3bd647288ddd6f212eae7cdfa9e746f16c58b1d0','Ratione inventore qui sint voluptatem qui molestiae. Ut cupiditate ipsam voluptas et dolore. Omnis deleniti ea quo omnis enim.','2015-02-24',NULL,'Iniciante'),
	(null,'Dudley Hilll','xtromp','demetrius.bradtke@example.net','14fc22b1d029e949ab9ffd330edd2b366c31131e','Corrupti eos ex voluptates repellat. Nisi esse est alias aut magnam. Assumenda vitae ea nisi.','1987-04-29',NULL,'Iniciante'),
	(null,'Mrs. Sophia Wolf III','schiller.kristopher','elsie20@example.com','9c9406f81d0ec4b8975738f586146956a0e837c3','Eius maxime sunt quia eius. Atque reprehenderit tempore veniam qui. Atque culpa voluptatem est tenetur quod corrupti est. Doloremque quis amet magni occaecati. Dolor soluta ratione inventore est.','1999-02-27',NULL,'Iniciante'),
	(null,'Dr. Sibyl Howell III','fbashirian','erin.hirthe@example.org','18ca4e2292456dbe276f18d1b855cde18a21a999','Ut et id placeat quae cupiditate iure similique qui. Eum quas distinctio quis fugit. Mollitia ut ipsum consectetur quo voluptas voluptatibus reiciendis ullam.','1985-01-10',NULL,'Iniciante'),
	(null,'Mrs. Yoshiko Boehm','tania95','waters.heidi@example.com','9a100728ef3ae992fa7c4306ca4da0ab12fbd499','Laborum non quas consequatur accusantium optio autem. Voluptatum totam modi nobis corporis ad cumque dignissimos. Omnis aut quia animi unde.','1995-11-29',NULL,'Iniciante'),
	(null,'Carey Kunde','lamont56','josh18@example.org','04e1c3d34d233063ac2ffd5378762c40516c0237','Nulla voluptas quia non. Sunt et quis vel ea sint at. Amet qui voluptas molestiae sed. Quia ut architecto facilis totam quasi quisquam aut in.','2000-12-06',NULL,'Iniciante'),
	(null,'Billy Fritsch','pacocha.jasmin','davis.gretchen@example.org','c038d4cc13126511147eb7ff42578cf1de15387d','Sed vel blanditiis magni dicta. Doloremque et magni enim qui est. In quam et id nisi omnis tempora.','2013-12-19',NULL,'Iniciante'),
	(null,'Jaden Nitzsche','sporer.benjamin','d\'amore.pedro@example.com','5cead6bc0f4fb58107fdc7eabc279c0b6cd29b28','Corporis molestiae ex saepe ad qui. Aperiam saepe natus sunt doloribus. Provident delectus pariatur eligendi molestiae aut culpa.','1998-01-23',NULL,'Iniciante'),
	(null,'Peter Stiedemann MD','leonardo.runte','letha.corwin@example.org','c8d40475fc28ed45c539aff9a60f410c716fdfef','Quisquam labore eos quo alias enim. Temporibus ab eaque culpa dolore qui vero. Quas similique expedita consectetur.','1977-06-14',NULL,'Iniciante'); 

	-- QUESTION
	INSERT INTO `QUESTION` VALUES (null,'Sed quam perspiciatis quidem beatae autem delectus eum.','Alice. \'It goes on, you know,\' said Alice indignantly, and she went on to himself as he wore his crown over the verses on his flappers, \'--Mystery, ancient and modern, with Seaography: then.','1982-03-14 17:16:53','43','2'),
	(null,'Eius voluptas rerum eligendi distinctio eos qui.','I fancied that kind of serpent, that\'s all I can go back and see how he did with the day of the legs of the evening, beautiful Soup! \'Beautiful Soup! Who cares for you?\' said the Cat, \'or you.','2003-08-30 08:25:12','125','3'),
	(null,'Labore est impedit sint veniam fugit sit eligendi.','King put on your shoes and stockings for you now, dears? I\'m sure I have ordered\'; and she could not think of nothing better to say anything. \'Why,\' said the Gryphon. \'We can do no more, whatever.','1983-08-10 19:33:13','51','10'),
	(null,'Nemo adipisci aut non tempora qui.','THAT direction,\' the Cat remarked. \'Don\'t be impertinent,\' said the Mock Turtle interrupted, \'if you don\'t explain it is right?\' \'In my youth,\' said his father, \'I took to the King, and the Hatter.','1976-06-10 20:36:42','101','7'),
	(null,'Ratione deleniti libero quis est.','And he got up this morning? I almost wish I\'d gone to see if there were TWO little shrieks, and more puzzled, but she knew the name of the evening, beautiful Soup! \'Beautiful Soup! Who cares for.','1980-07-08 22:52:41','117','10'),
	(null,'Quibusdam qui commodi accusantium dolorem voluptatem doloremque.','Nobody moved. \'Who cares for fish, Game, or any other dish? Who would not give all else for two reasons. First, because I\'m on the look-out for serpents night and day! Why, I wouldn\'t be so easily.','1985-06-20 12:44:46','130','10'),
	(null,'Alias dolor omnis possimus qui quaerat ut.','HERE.\' \'But then,\' thought she, \'if people had all to lie down on one knee as he spoke. \'UNimportant, of course, I meant,\' the King added in a few minutes to see you again, you dear old thing!\' said.','2013-10-13 09:50:10','24','4'),
	(null,'Et consequatur aut voluptatem odit nesciunt odio.','On various pretexts they all looked so good, that it might appear to others that what you like,\' said the Hatter. He came in sight of the soldiers shouted in reply. \'Idiot!\' said the Duchess; \'I.','1971-09-09 05:44:46','53','4'),
	(null,'Nemo in nesciunt expedita maxime qui nesciunt.','Mock Turtle to sing you a present of everything I\'ve said as yet.\' \'A cheap sort of use in talking to herself, being rather proud of it: for she was now about two feet high: even then she looked.','2015-02-06 18:18:55','7','1'),
	(null,'Et sit accusantium officiis earum numquam reiciendis accusamus et.','Footman remarked, \'till tomorrow--\' At this moment the door opened inwards, and Alice\'s first thought was that it was neither more nor less than a rat-hole: she knelt down and saying to herself.','2005-06-24 20:15:07','127','2'),
	(null,'Illo iure rerum rerum voluptate.','Footman went on just as usual. I wonder what was on the OUTSIDE.\' He unfolded the paper as he spoke, and added with a sudden burst of tears, but said nothing. \'This here young lady,\' said the Mock.','1972-08-16 17:35:22','172','9'),
	(null,'Sed quia culpa omnis occaecati nostrum sed.','March Hare and the baby was howling so much into the garden with one finger for the accident of the teacups as the March Hare. \'Yes, please do!\' but the cook and the blades of grass, but she thought.','1989-10-06 04:30:34','87','1'),
	(null,'Maxime ut fugit nobis repellat ad ullam minima.','Alice, a little irritated at the corners: next the ten courtiers; these were ornamented all over with diamonds, and walked a little glass table. \'Now, I\'ll manage better this time,\' she said to a.','1995-11-13 11:24:32','121','1'),
	(null,'Fuga corporis tempore quas eius exercitationem cum.','And when I was a queer-shaped little creature, and held out its arms and frowning at the door-- Pray, what is the use of a feather flock together.\"\' \'Only mustard isn\'t a bird,\' Alice remarked..','2016-02-02 09:01:22','155','6'),
	(null,'Consequatur laborum nihil necessitatibus iure.','WOULD go with Edgar Atheling to meet William and offer him the crown. William\'s conduct at first was moderate. But the insolence of his Normans--\" How are you getting on?\' said Alice, seriously,.','2005-01-06 14:21:10','51','2'),
	(null,'Est doloremque iste fuga et quaerat consequuntur.','Digging for apples, indeed!\' said the Duchess, it had VERY long claws and a Long Tale They were just beginning to see the Mock Turtle\'s Story \'You can\'t think how glad I am very tired of being all.','2000-06-16 04:31:54','134','6'),
	(null,'Est vel illum commodi corrupti nesciunt.','Alice panted as she had to stoop to save her neck kept getting entangled among the party. Some of the bottle was NOT marked \'poison,\' so Alice went on, half to itself, half to Alice. \'Nothing,\' said.','1991-12-30 17:13:54','135','1'),
	(null,'Voluptatem atque corporis eos sed in fuga.','I gave her answer. \'They\'re done with a pair of boots every Christmas.\' And she opened the door began sneezing all at once. The Dormouse slowly opened his eyes very wide on hearing this; but all he.','1991-12-06 15:27:48','166','4'),
	(null,'Quia aliquam ducimus corporis et tenetur quo inventore molestiae.','YOUR business, Two!\' said Seven. \'Yes, it IS his business!\' said Five, in a furious passion, and went by without noticing her. Then followed the Knave of Hearts, and I had our Dinah here, I know all.','2008-07-01 22:25:48','172','4'),
	(null,'Officia adipisci architecto rem nisi.','I vote the young man said, \'And your hair has become very white; And yet I wish you would seem to encourage the witness at all: he kept shifting from one foot up the conversation a little. \'\'Tis.','2012-11-20 06:53:48','192','6'),
	(null,'Similique quia aut sed illo consequuntur totam porro.','Why, there\'s hardly enough of it appeared. \'I don\'t much care where--\' said Alice. \'Well, I shan\'t go, at any rate he might answer questions.--How am I then? Tell me that first, and then said \'The.','1978-02-26 19:33:04','100','9'),
	(null,'Voluptatum itaque occaecati est aliquid enim et.','I want to stay in here any longer!\' She waited for some while in silence. Alice was very nearly in the after-time, be herself a grown woman; and how she would manage it. \'They were learning to draw,.','2009-06-16 09:25:53','139','3'),
	(null,'Quae qui et nostrum nam.','Alice remarked. \'Right, as usual,\' said the Hatter. He had been would have appeared to them to sell,\' the Hatter replied. \'Of course not,\' Alice replied eagerly, for she was now more than nine feet.','1996-12-30 19:31:46','15','7'),
	(null,'Nobis unde adipisci porro omnis modi.','By the use of a procession,\' thought she, \'what would become of me? They\'re dreadfully fond of beheading people here; the great hall, with the lobsters, out to be seen: she found that it was.','1973-12-31 02:25:04','87','1'),
	(null,'Harum numquam corporis officiis blanditiis aut.','The Queen turned crimson with fury, and, after waiting till she had expected: before she made out what it was: she was quite pleased to find that the way YOU manage?\' Alice asked. The Hatter was the.','1996-12-03 18:55:47','63','3'),
	(null,'Eligendi qui sed distinctio soluta.','Alice, \'as all the rats and--oh dear!\' cried Alice, jumping up in a low, trembling voice. \'There\'s more evidence to come yet, please your Majesty?\' he asked. \'Begin at the end.\' \'If you please,.','2002-11-08 13:38:22','192','2'),
	(null,'In at rem magnam enim accusantium.','Mock Turtle. \'Hold your tongue!\' added the Gryphon, and all would change to dull reality--the grass would be grand, certainly,\' said Alice, looking down with wonder at the window, and some.','1974-08-23 10:50:40','53','3'),
	(null,'Sint ut autem hic sed.','Pigeon; \'but I haven\'t been invited yet.\' \'You\'ll see me there,\' said the Caterpillar. Here was another puzzling question; and as the Lory positively refused to tell you--all I know all the.','2009-12-04 19:18:35','137','6'),
	(null,'Et maxime possimus reiciendis vel non reiciendis id occaecati.','Sir, With no jury or judge, would be only rustling in the same age as herself, to see how he did not like the name: however, it only grinned a little timidly: \'but it\'s no use in knocking,\' said the.','1987-11-02 07:53:44','25','8'),
	(null,'Sit explicabo praesentium accusantium iste voluptas quod beatae.','And so it was very provoking to find that her flamingo was gone in a hurried nervous manner, smiling at everything about her, to pass away the moment she appeared; but she stopped hastily, for the.','2016-04-11 02:08:10','198','6'),
	(null,'Repellendus illum qui deserunt vitae fugit corporis pariatur.','I was sent for.\' \'You ought to have any pepper in that poky little house, on the trumpet, and called out, \'Sit down, all of them can explain it,\' said the Cat; and this was not here before,\' said.','1998-08-13 01:47:25','180','7'),
	(null,'Et aut qui occaecati doloribus aut perferendis.','I can\'t remember,\' said the Duchess, as she couldn\'t answer either question, it didn\'t much matter which way you have to turn into a tidy little room with a yelp of delight, which changed into alarm.','1984-12-09 00:58:51','15','7'),
	(null,'Voluptates aut consequatur exercitationem id asperiores quia.','Mock Turtle. \'Hold your tongue!\' said the Caterpillar. \'Not QUITE right, I\'m afraid,\' said Alice, \'how am I to get through the air! Do you think I should understand that better,\' Alice said to.','1995-09-03 07:07:13','36','5'),
	(null,'Ratione unde cumque quis nisi possimus fugit qui.','Dodo suddenly called out to her daughter \'Ah, my dear! Let this be a footman because he was gone, and, by the Queen was silent. The Dormouse slowly opened his eyes were getting extremely small for a.','1990-09-24 16:03:01','164','7'),
	(null,'Ipsam et praesentium voluptatem ratione voluptatem quisquam tempora quia.','Dormouse went on, \'if you only kept on good terms with him, he\'d do almost anything you liked with the game,\' the Queen in a tone of great dismay, and began smoking again. This time Alice waited.','1971-11-12 23:28:17','154','5'),
	(null,'Est placeat porro asperiores repudiandae sit sit.','Gryphon. \'We can do without lobsters, you know. So you see, Miss, this here ought to be Number One,\' said Alice. \'Then it wasn\'t trouble enough hatching the eggs,\' said the Lory positively refused.','1970-10-18 06:18:47','126','9'),
	(null,'Odit non sit et voluptatibus sapiente.','Gryphon answered, very nearly getting up and rubbed its eyes: then it chuckled. \'What fun!\' said the Mock Turtle would be very likely to eat the comfits: this caused some noise and confusion, as the.','1997-08-10 18:10:55','188','2'),
	(null,'Perspiciatis sapiente ut esse.','March Hare said to the Queen. An invitation from the change: and Alice looked all round her, about four inches deep and reaching half down the chimney close above her: then, saying to herself, as.','1974-01-14 10:32:09','177','1'),
	(null,'Assumenda dolores recusandae est praesentium quam tempore.','I wish I hadn\'t to bring but one; Bill\'s got the other--Bill! fetch it back!\' \'And who is to give the hedgehog to, and, as there was no more of the right-hand bit to try the patience of an oyster!\'.','2004-08-08 18:14:45','194','7'),
	(null,'Voluptatibus omnis et ducimus eaque vel vitae.','Come and help me out of its voice. \'Back to land again, and all the jelly-fish out of it, and burning with curiosity, she ran with all speed back to the confused clamour of the officers of the.','2015-05-17 20:33:24','196','10'),
	(null,'Quibusdam quisquam magni ut est quas a.','Dinah, and saying \"Come up again, dear!\" I shall be punished for it now, I suppose, by being drowned in my own tears! That WILL be a person of authority over Alice. \'Stand up and to stand on your.','1975-05-24 09:21:16','147','3'),
	(null,'Voluptas molestias reiciendis animi illo impedit veritatis.','I know. Silence all round, if you like!\' the Duchess said after a minute or two, she made her feel very uneasy: to be sure, she had found the fan she was holding, and she went to school every day--\'.','1988-01-25 09:18:54','5','4'),
	(null,'Sit amet dolores in ut delectus provident amet.','I\'m not particular as to prevent its undoing itself,) she carried it off. * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * \'What a funny watch!\' she remarked. \'It tells the day.','1991-06-15 07:01:48','114','6'),
	(null,'Iure sequi totam veniam unde id necessitatibus.','It did so indeed, and much sooner than she had quite a conversation of it had lost something; and she jumped up in a great interest in questions of eating and drinking. \'They lived on treacle,\' said.','1973-04-08 10:59:10','53','3'),
	(null,'Doloremque quis quod placeat et.','When I used to it in with a great crowd assembled about them--all sorts of things, and she, oh! she knows such a pleasant temper, and thought to herself \'That\'s quite enough--I hope I shan\'t go, at.','1999-11-20 09:48:45','57','6'),
	(null,'Sapiente occaecati et dolorum earum illum asperiores.','Alice did not feel encouraged to ask them what the flame of a book,\' thought Alice \'without pictures or conversations?\' So she began very cautiously: \'But I don\'t put my arm round your waist,\' the.','1981-10-18 17:10:48','151','8'),
	(null,'Debitis soluta cupiditate voluptas consequatur.','EVER happen in a trembling voice:-- \'I passed by his face only, she would keep, through all her fancy, that: he hasn\'t got no business there, at any rate a book written about me, that there was not.','1979-12-17 05:25:06','193','9'),
	(null,'Necessitatibus distinctio est debitis iure sunt ab excepturi itaque.','And he got up in a large pool all round the table, but it was out of the busy farm-yard--while the lowing of the tail, and ending with the words \'DRINK ME,\' but nevertheless she uncorked it and put.','1983-01-11 02:22:48','18','5'),
	(null,'Aliquam qui occaecati quisquam accusantium sit culpa.','March Hare. \'Yes, please do!\' but the tops of the wood--(she considered him to you, Though they were trying which word sounded best. Some of the court. All this time it vanished quite slowly,.','1997-06-19 00:47:58','26','10'),
	(null,'Molestiae neque voluptate ea saepe laborum.','She soon got it out into the loveliest garden you ever saw. How she longed to change them--\' when she got to come out among the leaves, which she concluded that it might be hungry, in which the cook.','2002-07-21 12:53:15','96','6'); 


    -- TAG
	INSERT INTO `TAG` VALUES (null,'autem'),
	(null,'vel'),
	(null,'pariatur'),
	(null,'possimus'),
	(null,'enim'),
	(null,'et'),
	(null,'in'),
	(null,'tenetur'),
	(null,'harum'),
	(null,'eaque'),
	(null,'laudantium'),
	(null,'consequuntur'),
	(null,'dignissimos'),
	(null,'quos'),
	(null,'non'),
	(null,'non'),
	(null,'et'),
	(null,'et'),
	(null,'et'),
	(null,'ipsum'); 


	-- QUESTION_TAG

	INSERT INTO `QUESTION_TAG` VALUES (null,'9','8'),
	(null,'35','6'),
	(null,'22','2'),
	(null,'49','9'),
	(null,'43','1'),
	(null,'15','13'),
	(null,'33','6'),
	(null,'14','10'),
	(null,'13','15'),
	(null,'25','14'),
	(null,'26','7'),
	(null,'5','2'),
	(null,'27','14'),
	(null,'12','3'),
	(null,'7','3'),
	(null,'19','3'),
	(null,'41','11'),
	(null,'32','1'),
	(null,'47','17'),
	(null,'12','1'),
	(null,'29','2'),
	(null,'13','11'),
	(null,'44','17'),
	(null,'15','19'),
	(null,'22','19'),
	(null,'15','6'),
	(null,'50','10'),
	(null,'21','7'),
	(null,'2','2'),
	(null,'49','16'),
	(null,'8','6'),
	(null,'19','13'),
	(null,'17','10'),
	(null,'49','11'),
	(null,'23','14'),
	(null,'38','20'),
	(null,'40','16'),
	(null,'15','2'),
	(null,'4','20'),
	(null,'49','3'),
	(null,'18','16'),
	(null,'3','12'),
	(null,'29','9'),
	(null,'21','9'),
	(null,'47','10'),
	(null,'35','4'),
	(null,'30','19'),
	(null,'49','17'),
	(null,'35','4'),
	(null,'23','4'),
	(null,'6','17'),
	(null,'32','5'),
	(null,'30','1'),
	(null,'17','15'),
	(null,'16','15'),
	(null,'26','12'),
	(null,'14','12'),
	(null,'15','9'),
	(null,'11','12'),
	(null,'49','2'),
	(null,'43','4'),
	(null,'31','15'),
	(null,'5','12'),
	(null,'6','19'),
	(null,'3','3'),
	(null,'4','13'),
	(null,'34','18'),
	(null,'7','17'),
	(null,'30','5'),
	(null,'46','12'),
	(null,'28','8'),
	(null,'13','10'),
	(null,'21','7'),
	(null,'13','5'),
	(null,'12','15'),
	(null,'13','18'),
	(null,'19','13'),
	(null,'22','9'),
	(null,'49','6'),
	(null,'49','5'),
	(null,'22','11'),
	(null,'9','16'),
	(null,'47','5'),
	(null,'32','5'),
	(null,'6','18'),
	(null,'21','16'),
	(null,'42','16'),
	(null,'48','12'),
	(null,'9','18'),
	(null,'50','16'),
	(null,'39','12'),
	(null,'30','6'),
	(null,'23','4'),
	(null,'7','19'),
	(null,'38','1'),
	(null,'25','5'),
	(null,'46','18'),
	(null,'21','17'),
	(null,'46','7'),
	(null,'25','17'); 

	-- ANSWER

	INSERT INTO `ANSWER` VALUES (null,'Et blanditiis quasi et modi et. Id neque reiciendis odit vel quia tempora iusto. Sit voluptas neque ut aperiam.','1991-07-30 10:35:09','41','9'),
	(null,'Placeat exercitationem voluptatem nihil est ducimus. Quidem amet molestiae commodi sit dolorum quia et. Distinctio iure ratione suscipit rem fugiat sunt.','2002-08-23 04:06:22','34','4'),
	(null,'Quo numquam quia sapiente enim libero minima porro. Eos doloribus qui provident autem asperiores. Dolore sint rerum omnis omnis illum debitis. Facilis porro fugiat itaque quia.','2007-10-21 14:52:35','46','7'),
	(null,'Libero quos voluptatem qui odio blanditiis cum. Magnam debitis aut reiciendis commodi consequatur. Omnis maiores aut dignissimos eaque. Blanditiis reiciendis totam illum aperiam ea.','2003-03-16 19:52:24','13','5'),
	(null,'Dolorum aut aut odio. Aliquid aut aperiam in explicabo. Est quia doloremque aperiam.','1994-11-21 20:34:40','13','8'),
	(null,'Enim quae et sint officiis atque doloribus et illo. Sed totam in itaque molestiae. Quas asperiores ut qui dolorem nisi omnis. Sunt aperiam soluta distinctio rerum et expedita.','2013-03-07 06:45:15','11','5'),
	(null,'Error quia consequatur est provident est natus eos quis. Rerum inventore consequatur maxime minima nam quae quasi. Provident in nulla error quod. Qui et id consequatur in.','2004-06-26 13:28:53','43','8'),
	(null,'Fugit dolores et neque eligendi possimus mollitia. Ullam architecto facere dolorem explicabo quod vel. Voluptatem est et dolore. Excepturi dolorem eaque molestiae molestiae occaecati autem.','1999-03-12 07:39:44','12','8'),
	(null,'Enim hic pariatur fuga aspernatur voluptatibus in. Eos ut dolore est. Fugit voluptatem et omnis delectus dolorem alias aut. Enim aut in repellat.','1989-10-06 21:37:28','26','8'),
	(null,'Modi velit soluta ullam esse deserunt. Voluptatibus eveniet dolor quos quam nisi sunt. Non dolor sequi alias quae. Est nesciunt voluptas et.','2013-06-17 07:19:03','41','10'),
	(null,'Non minima et reprehenderit blanditiis. In incidunt similique qui qui. Fugit mollitia quaerat eius impedit molestiae est dolorum.','2014-03-08 12:36:54','7','7'),
	(null,'Commodi exercitationem amet ut repellat quia hic aut eveniet. Illum expedita rerum nulla modi qui ea quo.','2007-07-05 19:18:15','10','5'),
	(null,'Voluptatem nulla quia itaque fugit. Quia vel esse similique ad ut voluptatem.','2004-09-02 08:13:16','19','8'),
	(null,'Eum aut voluptatibus corrupti repellendus rerum. Qui eum excepturi debitis vitae excepturi recusandae dolores. Eum eum labore ab et cum. Ut et porro ut magni est.','1995-05-15 03:46:35','44','7'),
	(null,'Eligendi suscipit impedit quo eum eius libero. Sed beatae veniam dolorem. Aut atque qui quo tenetur error ut ipsum et. Aliquid odio repudiandae ut quis reprehenderit recusandae.','2003-09-21 02:23:44','37','4'),
	(null,'Veniam atque dolor accusamus. Praesentium explicabo ea at ut velit. Numquam nihil ut aliquam sint eum. Sit quibusdam et quis id dolor optio.','1977-07-14 03:43:24','19','4'),
	(null,'Qui est aut neque provident nobis doloremque quia. Et sapiente fugiat nemo cumque. Sed est qui quia eos assumenda.','1984-08-26 00:51:32','37','3'),
	(null,'Mollitia et aut libero quae sed et. Cumque voluptatum et eum eos aut amet. Dolorem velit ipsa aut quos ut.','1980-03-29 05:18:20','45','4'),
	(null,'Et rerum libero libero nobis odit ex. Dolores sed dicta dolor sint. Voluptatum nihil totam voluptatem nihil enim. Beatae molestias voluptate voluptatem.','1986-11-14 18:53:15','11','5'),
	(null,'Non ut soluta repellendus nulla ad. Fugiat voluptas debitis placeat doloremque et eos. Et laborum provident quis mollitia aliquam ipsa hic.','2017-03-09 11:20:03','31','5'),
	(null,'Rerum ea dignissimos sunt consequatur. Delectus debitis quis quos nesciunt magnam. Optio voluptatibus enim et eaque voluptatem. Vel vel dolore dignissimos error ut et quisquam cupiditate.','1983-04-05 20:40:27','34','10'),
	(null,'In id reprehenderit nemo dolores optio sit. Est dolor dignissimos qui animi. Beatae qui dolores aliquid quae vel excepturi voluptates.','1997-07-17 04:54:28','42','2'),
	(null,'Fugit consequuntur molestiae et placeat rerum voluptatum. Quia ut illo qui exercitationem et placeat omnis. Quo iste repudiandae nam fuga tempora dolor.','1971-09-29 18:05:55','22','9'),
	(null,'Velit possimus possimus aut. Eos est nam repudiandae neque minus amet.\nAd aut qui ipsum. Explicabo beatae qui ex ipsum quas. Sit laboriosam sed accusantium est et.','1975-08-28 13:36:02','5','7'),
	(null,'Velit sint explicabo et suscipit. Sit eaque est eum aliquid nisi sed sed. Vitae sapiente facere cupiditate eum nulla et. Incidunt labore autem recusandae.','2003-12-10 14:58:42','20','3'),
	(null,'Asperiores dolores ea ex ipsa consectetur quo. Veniam ut consequatur accusantium et illum. Deserunt consequatur voluptatem nisi fugiat.','2011-07-10 18:53:15','37','8'),
	(null,'Fugiat sed assumenda voluptatem optio doloremque quasi. Enim illum sint accusamus voluptatem est. Odio alias neque ratione quia.','2001-10-24 17:23:10','16','9'),
	(null,'Aliquid rerum nulla quidem quas cupiditate. Pariatur sunt tempore asperiores inventore dolorem. Officia reiciendis veniam ut. Similique enim hic id repellat.','2007-09-18 20:59:00','37','1'),
	(null,'Corporis voluptatum ut praesentium et omnis voluptatum voluptatem. Consequuntur non ratione et optio. Et ut soluta distinctio odio veritatis. Minus unde hic temporibus quaerat.','1971-04-02 12:25:44','48','7'),
	(null,'Natus voluptas vero temporibus consequuntur eligendi occaecati aspernatur sint. Debitis at quam et expedita rerum molestiae.','2013-03-13 11:17:40','15','4'),
	(null,'Ullam non deleniti rerum enim quo rerum. Dolor modi qui quae quia rerum eaque. Laudantium iusto quis eum rerum odio. Molestias enim laboriosam est soluta nemo molestiae.','2010-12-01 13:58:07','27','4'),
	(null,'Amet pariatur dolorum magni nobis sint consequatur dolorem. Voluptates delectus est voluptatum dolorum quae. Distinctio ipsam quia ratione.','1996-11-13 19:39:47','21','3'),
	(null,'Vel velit id voluptatem maxime. Exercitationem reprehenderit nostrum vero illum. Modi quis et provident tempore corrupti veniam dolor. Ab amet sed ullam aliquid maxime velit.','1995-07-24 08:14:51','22','9'),
	(null,'Inventore dolore quam nemo saepe quae deleniti sint. Cum aliquam non culpa quod quaerat dolorem eaque.','1974-05-20 11:47:39','21','3'),
	(null,'Numquam nihil qui necessitatibus consectetur iusto. Quasi ut voluptate vero sed aut sint sit. Et dolore laboriosam perferendis modi et amet culpa. Fuga ea repellendus deleniti iure omnis vel odio id.','1992-11-10 17:21:58','8','4'),
	(null,'Numquam voluptas ullam unde enim veniam omnis eius. Sint quae illum distinctio voluptas magnam labore quo est.','2011-01-28 15:37:45','17','3'),
	(null,'Et error optio omnis necessitatibus. Minus et et enim. Sed hic earum quia culpa ut recusandae ab.','2018-10-02 02:20:39','36','7'),
	(null,'Possimus aut voluptatem tempore consequatur placeat aspernatur aperiam. Eum quis qui optio iste fugiat et. Soluta maiores quo perspiciatis sint illum. Et reprehenderit similique maxime dolores.','2012-01-12 04:37:19','9','8'),
	(null,'Sit et nulla quas omnis. Earum iste est rerum dignissimos reprehenderit nostrum. Reiciendis et distinctio asperiores id rem expedita id. Sit rerum nemo aut.','1972-01-20 11:25:25','43','5'),
	(null,'Ut eos voluptas exercitationem porro distinctio nostrum. Nesciunt sint animi voluptatem est ea. Nam maxime repudiandae officiis iusto fugiat culpa.','1971-06-19 19:24:00','24','4'),
	(null,'Qui numquam doloribus hic dolore. Quia rem sed tempore dolores. Ad delectus aut minima. Quasi a ullam natus incidunt.','2018-02-12 16:39:11','23','6'),
	(null,'Libero accusamus esse autem nostrum sint eum natus. Numquam eveniet at omnis beatae voluptate neque quos. Vel laudantium dolor aut minus deleniti vitae. Quasi sunt incidunt quae magni.','2001-05-13 09:15:33','27','8'),
	(null,'Eum voluptatem doloribus ab hic. Sit ut dolor pariatur. Earum ut cumque aut molestiae vel reprehenderit.','2002-07-04 22:28:06','24','7'),
	(null,'Quo est dignissimos tempore ratione quisquam. Dolores assumenda soluta asperiores autem quia.\nExpedita rerum iure nulla quis ut. Quia odit facere temporibus consequatur sapiente.','1996-02-10 11:03:38','48','10'),
	(null,'Earum unde illo nobis repellendus est aliquam. Repellendus voluptas quis eos accusantium dolores. Consequatur aut est mollitia officiis.','1999-07-11 13:51:44','29','4'),
	(null,'Voluptatem culpa voluptas dolores occaecati. Fugit quod dolorum dolorem ad rerum velit aut.','2014-08-16 23:38:19','24','1'),
	(null,'Omnis ex odio inventore et tempora. Vero repellendus ipsum quia sint ut. Enim vel sunt consequuntur voluptatibus nihil fugiat. Vitae ut blanditiis officia magni est.','1976-10-21 01:01:07','11','4'),
	(null,'Sapiente nobis officiis quis occaecati. Autem qui veritatis necessitatibus consequatur. Nihil voluptatem dicta accusamus.','1987-06-19 22:09:58','10','4'),
	(null,'Commodi est ut rerum aperiam eius et culpa porro. Vero qui autem dolores et vitae. Quibusdam sit blanditiis sunt ut numquam minus. Sed exercitationem odio corrupti iusto.','1986-04-04 21:48:30','34','5'),
	(null,'Saepe harum ut velit ut. Repellat aut illum dolores enim.','1981-04-27 06:42:41','8','6'),
	(null,'Minima quas odit ipsam voluptatem veniam officia. Rerum ab non corrupti ducimus. Sapiente accusantium velit iusto eius sunt sed.','2000-08-26 03:30:55','7','7'),
	(null,'Qui dolore veritatis minus est dolor nihil soluta. Dicta explicabo fugit consequuntur. Doloribus officiis repellendus assumenda dicta velit.','1982-09-24 23:18:54','19','2'),
	(null,'Nihil deserunt repellendus et labore. Sed doloremque placeat occaecati aut. Id eveniet beatae ab voluptatem magni. Qui reprehenderit et soluta quae.','1984-02-14 02:02:16','34','2'),
	(null,'Maxime consequuntur veritatis sequi beatae explicabo saepe alias sit. Eligendi modi velit et dolorem. Quo voluptatem ea commodi omnis. Tempore ab quae est saepe nobis eius at.','2003-01-20 08:25:31','16','4'),
	(null,'Id veritatis natus voluptates ut sed ea inventore. Nostrum aut hic quaerat in. Delectus quis mollitia iure illo ea. Rerum magni eum ut aut qui magni dolorem.','2000-09-16 04:22:23','38','10'),
	(null,'Omnis sunt autem explicabo modi sit eveniet aliquid. Voluptatem tenetur deserunt eos delectus. Veritatis et eveniet consectetur explicabo veniam. Voluptatem dolorum ducimus ipsum est rerum illo et.','2011-06-27 06:17:34','29','6'),
	(null,'Provident est atque amet totam voluptatem ipsam sunt ipsa. Repudiandae laborum qui ad hic et quas quo. Iste suscipit molestias sed omnis. Quod incidunt eum cum labore.','2015-09-25 07:51:11','37','2'),
	(null,'Odio eveniet assumenda dolores est ut eos animi. Eaque aut rem qui. Maiores non et et veritatis.','1972-04-25 10:48:40','37','5'),
	(null,'Dolores voluptate nam est rerum quasi fugiat. Asperiores consequatur qui nobis. Ut veritatis suscipit suscipit exercitationem iusto illum.','1992-07-13 12:17:52','13','1'),
	(null,'Ut est necessitatibus et sequi consequuntur. Qui libero sed eveniet nihil voluptatem. Dolores error et cum alias tempora.','1991-01-21 09:17:46','46','10'),
	(null,'Dolore aut cupiditate et amet ut nobis deserunt. Quis iusto at minima ea eos maxime.\nEst fugiat magni ut qui. Natus eligendi qui veritatis ut voluptas assumenda nulla.','2010-06-07 12:56:56','49','4'),
	(null,'Ut mollitia aut et dolorem natus. Sunt accusamus suscipit voluptas et. Amet consectetur officia quidem saepe natus ipsum.','2001-10-19 11:48:16','49','8'),
	(null,'Similique ab ipsa omnis at nulla sed sint omnis. Consequuntur officia a ipsam consectetur iure totam.','2008-09-02 20:13:35','23','4'),
	(null,'Eaque sed dolores nostrum reprehenderit aut qui est. Consectetur odit necessitatibus facere modi. Quia dolor deserunt qui error. Nam id quo et nulla.','1975-06-13 06:23:28','46','5'),
	(null,'Delectus est similique saepe in quia. Voluptates dolorum non molestiae rerum asperiores ullam. Aut amet autem accusantium corrupti iusto excepturi. Blanditiis quod animi vel quo perferendis.','1993-02-24 01:54:26','23','7'),
	(null,'Minima nihil animi facilis est voluptas molestiae a quia. Ab quaerat optio dolorem ipsam non sit necessitatibus. Quod esse amet autem ipsa. Velit dolores facilis odit nisi.','2018-06-10 05:58:19','50','10'),
	(null,'Voluptatem est rerum enim consequuntur laudantium rem sed. Ab officiis voluptatem sed sapiente facere consectetur libero voluptas. Ea et omnis sint ea est.','1970-12-08 07:57:48','25','8'),
	(null,'Eos error est dolore delectus qui nesciunt vero. Sint hic consequatur molestiae adipisci.','2012-04-03 01:25:22','8','1'),
	(null,'Nihil aperiam aliquam illum nemo. Est quia vel qui magnam laboriosam. Est non quisquam asperiores et.','1984-07-21 23:24:09','18','2'),
	(null,'Dicta accusantium nulla eius qui impedit voluptas. Fuga enim voluptatem distinctio saepe. Illum dolorem in eum molestias quisquam.','1984-01-06 10:20:02','19','6'),
	(null,'Libero ipsa voluptas ex rerum aut doloribus labore. Neque eius possimus et repudiandae voluptates dolor. Quo omnis reiciendis commodi asperiores eum. Nemo sunt eius pariatur ut aut.','1981-09-25 13:09:40','35','7'),
	(null,'Voluptatem illo aliquid odio atque quam ipsa id. Distinctio id quia quia enim. Ipsa animi doloremque non. Expedita quis inventore eaque voluptas veritatis eum.','2012-02-25 02:30:35','32','8'),
	(null,'Ipsam tenetur excepturi fugiat quo eveniet omnis. Debitis quis sint vitae est. Libero temporibus ut nesciunt quaerat.','1978-10-10 16:55:29','27','10'),
	(null,'Facere non officia quos asperiores vitae repellat. Enim id qui repellendus similique accusantium et incidunt quo.','1983-12-19 01:44:00','23','10'),
	(null,'Commodi voluptatibus modi voluptatem reprehenderit cum doloribus voluptates. Explicabo provident aut illo nihil. Autem soluta voluptate quia et expedita dolor. Illo sed eveniet impedit soluta.','1973-01-05 08:59:06','14','6'),
	(null,'Qui sed dolore et est. Quas debitis et doloribus ratione quis non quisquam et. Eos et voluptatem pariatur.','2015-11-18 12:56:55','24','10'),
	(null,'Cum eum laboriosam velit asperiores. Eum et esse error quidem culpa soluta. Tempora ut corporis ut cupiditate. Ut aliquam et tenetur architecto ipsa.','2007-05-09 21:37:15','3','6'),
	(null,'Voluptatibus nihil ut culpa quod. Sequi quia facere quos alias magni facilis est aperiam.','2017-04-19 08:48:20','19','6'),
	(null,'Qui dolores temporibus quibusdam voluptatem culpa. Rerum sunt vel porro atque. Sequi porro illum fugit nobis non ea esse. Excepturi dignissimos excepturi cum magnam earum.','1994-04-14 14:08:44','42','6'),
	(null,'Qui tenetur voluptatum numquam est et debitis recusandae. Aliquid nesciunt ipsam id sit et. Minus totam repellendus rem quas. Nemo ullam blanditiis voluptatum ut delectus eius.','1971-05-17 22:40:31','40','1'),
	(null,'Magnam minus veritatis eos. Sequi tempore maiores quibusdam optio est sit et. Minima qui distinctio sint quae ratione perferendis sed. Totam nostrum doloremque omnis laboriosam praesentium deleniti.','1995-09-15 18:43:19','45','10'),
	(null,'Eos non corrupti similique alias. Harum iusto repudiandae facilis doloremque at ex.\nOdit quod ipsa eaque ea dolor sit iure. Dolorem eius nemo explicabo officia doloremque delectus.','1978-01-01 02:59:57','41','2'),
	(null,'Eos quia similique voluptatem necessitatibus. Cupiditate facilis nihil et magnam nihil possimus. Vel laborum est perspiciatis harum.','2005-06-18 04:30:07','32','5'),
	(null,'Nostrum quas ex quae qui. Facere placeat quae et minima magnam. Suscipit asperiores consequatur magnam totam voluptatem cum facere. Minima non minima debitis voluptatum rem cum quo.','2012-05-31 08:58:14','46','7'),
	(null,'Consequuntur cum eos voluptatem ipsum voluptas. Consequatur unde ex suscipit voluptatem. Ipsam quibusdam dolores sed culpa qui culpa et.','2008-11-06 11:37:42','14','5'),
	(null,'In accusantium sit quas consequatur vel illum. Rerum mollitia tempore iusto quia minima aut. Cumque at voluptatibus odio porro nihil sapiente. Libero dignissimos doloremque ipsam quia.','2015-08-30 04:41:11','23','3'),
	(null,'Aliquid repellat dicta qui. Impedit enim cum animi voluptas. Est cumque eum ducimus est.','1999-09-24 12:01:18','9','1'),
	(null,'Sit quia dolorem dolore eum voluptas. Consequatur eveniet est itaque qui. Ex corrupti nisi voluptas sed recusandae.','1984-07-08 08:05:14','29','9'),
	(null,'Labore quo sapiente iusto ut iste. Quo aut deleniti provident. Aut ipsa aperiam fuga laborum quos ab voluptatem nam. Quae fugiat dolorum iste sit debitis qui.','1992-11-06 10:16:29','4','3'),
	(null,'Repudiandae non esse maxime omnis. Quo incidunt eos corporis et harum ut quia rerum.','1977-04-08 17:28:41','11','9'),
	(null,'Cumque nesciunt aut molestias. Eum quod omnis eum nisi est consectetur rem. Sed ad quibusdam dolores maiores quas nostrum vel. Est dolores laudantium rerum eos id laboriosam.','1975-09-25 23:35:59','12','3'),
	(null,'Qui ut modi laudantium temporibus tempora sapiente unde. Officiis consequatur excepturi sapiente animi. Nihil voluptatem eum in sit. Ipsa quo incidunt maxime hic quia architecto quisquam.','2015-12-27 18:26:50','40','3'),
	(null,'Accusantium iure et occaecati. Iusto excepturi quia impedit perspiciatis vitae inventore aut. Ut quis quisquam non consectetur nobis perspiciatis.','1986-04-15 20:04:46','47','9'),
	(null,'Et sed architecto ea accusamus consectetur. Et quae ipsa pariatur rerum dolores harum. Autem quis inventore et corporis ea consequuntur quis. Et ea ipsa asperiores numquam.','2012-04-13 03:16:08','11','10'),
	(null,'Perspiciatis sunt ex quo sit hic. Reprehenderit inventore enim velit repellat fuga. Distinctio ex dolores ab qui maiores perspiciatis atque.','2015-10-24 06:02:00','37','9'),
	(null,'Nostrum ut similique numquam impedit. Deleniti tenetur unde omnis fugit enim rerum eaque. Sed sed quo inventore dolores in ut. Hic veritatis dolor molestias.','1981-06-27 10:40:14','45','6'),
	(null,'Eaque quaerat unde rerum vel fuga iste. Qui quia et quidem omnis. Provident placeat porro sapiente dolor corporis molestias. Maiores omnis porro vel id.','2004-11-14 04:21:30','10','10'),
	(null,'Sint nihil et sapiente cumque ex. Ab voluptatum aliquam sequi tempora non. Exercitationem voluptates ut repellendus mollitia aliquam omnis. Quis ut nulla ratione in.','1976-10-01 01:19:36','47','8'),
	(null,'Non rem vel ad velit optio qui dolorem. Porro eveniet ut eveniet. Repellendus et et quidem voluptatem quod. Sed fugit consequuntur sed.','1981-07-04 21:34:15','49','10'),
	(null,'Odio eaque consectetur repudiandae. Eligendi laudantium dignissimos rerum aut pariatur incidunt voluptate magni. Nulla iure culpa nesciunt enim possimus consequatur incidunt quis.','2015-12-29 04:13:02','44','8'); 

	-- COMMENT

	INSERT INTO `COMMENT` VALUES (null,'Natus non ipsum quaerat minus.','1977-06-24 01:24:06','87','10'),
	(null,'Fugiat eos dolorum suscipit perferendis possimus error dolores.','1980-10-14 07:00:14','98','7'),
	(null,'Vitae ea et est iste.','2007-12-26 12:49:59','89','7'),
	(null,'Omnis maxime qui incidunt dolorem a.','1994-02-07 12:24:36','89','7'),
	(null,'Voluptatem sunt natus pariatur fugit laboriosam perspiciatis non.','2017-10-11 17:19:26','72','7'),
	(null,'Et sequi necessitatibus temporibus voluptatem.','1994-04-21 11:21:57','15','6'),
	(null,'Amet magnam consequatur sequi praesentium et laudantium.','1999-01-31 00:47:55','21','7'),
	(null,'Molestiae error et voluptatem repudiandae aut quaerat voluptates.','1999-04-24 04:46:25','40','7'),
	(null,'Id quae voluptatibus ut totam.','2000-05-19 17:44:50','37','3'),
	(null,'Omnis aspernatur cupiditate quod et et aliquid possimus.','1982-12-02 02:15:24','37','9'),
	(null,'Illo accusamus recusandae sapiente voluptate hic.','1993-08-05 04:29:13','40','6'),
	(null,'Sed impedit at nihil aliquam.','1974-11-07 02:19:09','68','4'),
	(null,'Autem adipisci voluptatem odio dolorem a harum.','2007-10-21 09:34:27','72','10'),
	(null,'Nobis ut qui sint sapiente.','1988-08-18 14:45:07','61','8'),
	(null,'Provident et reprehenderit dolor ea delectus corporis.','1996-09-08 04:30:15','76','1'),
	(null,'Atque quae quis placeat neque.','2012-03-20 22:29:04','21','3'),
	(null,'Voluptatem eos et sit vero reiciendis ad.','1981-10-23 22:51:48','68','4'),
	(null,'Placeat natus dicta perferendis vero impedit.','1994-09-17 08:22:22','37','3'),
	(null,'Hic dignissimos eum vel et natus iusto aliquam et.','2000-04-01 08:33:42','3','9'),
	(null,'Ut consequatur nobis qui illo numquam.','1977-04-11 15:10:22','80','8'),
	(null,'Voluptate quibusdam ratione minima doloremque et.','2006-01-21 14:46:16','14','10'),
	(null,'Sed et voluptas ratione provident voluptates magnam.','1989-06-09 05:14:52','91','1'),
	(null,'Non consequatur sit ut eius.','1974-06-23 08:35:24','65','1'),
	(null,'Rem ea eum qui distinctio.','2005-05-31 22:58:43','62','5'),
	(null,'Molestiae magni libero quisquam odit libero doloremque.','1982-05-24 04:27:46','13','7'),
	(null,'Incidunt omnis doloremque quo et non veritatis.','2011-01-04 19:05:18','77','7'),
	(null,'Nemo veritatis ad fuga nisi non asperiores.','2004-11-12 17:17:18','53','10'),
	(null,'Adipisci corporis exercitationem suscipit qui eligendi adipisci quis.','1997-01-01 03:08:53','65','6'),
	(null,'Quis provident ab saepe ut at est.','2013-07-31 00:14:37','23','5'),
	(null,'Ratione natus quos praesentium sint.','2001-09-04 19:39:40','9','10'),
	(null,'Vel qui expedita odit cum aut non.','2012-09-08 08:04:53','17','10'),
	(null,'Quibusdam perspiciatis incidunt quas et incidunt dolor quos ipsa.','2012-03-20 15:04:04','21','8'),
	(null,'Omnis voluptatem qui aut ipsum.','1979-02-17 13:13:48','26','7'),
	(null,'Molestiae eum ab accusantium nesciunt eos.','1978-05-11 20:53:05','16','4'),
	(null,'Facilis eius sit aut animi sit porro.','2000-08-26 16:04:38','97','6'),
	(null,'Culpa nostrum tenetur id quod.','1990-04-30 08:00:59','90','2'),
	(null,'Magnam quidem eaque quo nam.','2009-02-28 17:51:38','48','9'),
	(null,'Consequatur perspiciatis voluptatem ut est enim necessitatibus.','1975-07-29 08:02:28','31','1'),
	(null,'Officia maiores perspiciatis minus enim quis natus.','2017-01-24 20:38:36','10','3'),
	(null,'Ratione voluptas tempora maiores quos optio.','1972-12-06 12:07:07','39','5'),
	(null,'Exercitationem voluptatem vero similique omnis.','1976-06-12 18:20:56','8','10'),
	(null,'Ut vel recusandae nisi officiis.','2004-12-11 09:36:03','28','1'),
	(null,'Molestias nihil dicta odit hic aut.','1980-02-03 23:30:51','43','4'),
	(null,'Unde accusantium consectetur odio voluptatem dolores sed veritatis.','1996-04-13 02:21:32','88','3'),
	(null,'Illum ullam quos molestias minus in.','1972-08-16 14:01:44','66','5'),
	(null,'Animi assumenda dolores quis ut molestiae sit aspernatur.','1987-01-28 01:22:46','2','8'),
	(null,'Aut et vel consequatur similique consequatur facilis rerum.','2006-02-18 23:01:50','60','5'),
	(null,'Velit et eveniet eos libero possimus quo quisquam.','1975-03-08 02:24:33','72','6'),
	(null,'Provident voluptates unde eos velit quaerat et odio vel.','2016-09-15 13:39:31','100','6'),
	(null,'Voluptas sit enim expedita.','1990-10-25 02:15:44','61','3'),
	(null,'Libero ex unde voluptatem aliquam perferendis.','1997-09-08 05:57:52','74','9'),
	(null,'Qui amet aliquid voluptatem quis cupiditate.','2011-09-19 07:29:18','97','5'),
	(null,'Dicta delectus temporibus corporis amet quas magnam veniam.','1982-11-17 01:24:57','32','9'),
	(null,'Velit occaecati debitis occaecati.','1992-04-23 17:46:10','49','7'),
	(null,'Qui fugiat facere eveniet.','2008-12-01 09:05:01','93','10'),
	(null,'Tempora laborum ea non porro beatae.','2016-07-20 06:58:41','8','1'),
	(null,'Et nostrum est est voluptas ea.','2009-03-07 11:39:28','44','10'),
	(null,'Consectetur tempora omnis dicta est sint cumque.','1982-03-25 02:41:47','96','7'),
	(null,'Cum voluptates expedita qui aut et vel exercitationem omnis.','1993-02-08 21:30:34','24','8'),
	(null,'Modi aliquid culpa in ipsam debitis officia quia.','1988-08-20 12:50:44','95','2'),
	(null,'Quas aut et quo deserunt dolore.','1986-04-01 11:29:51','23','6'),
	(null,'Nihil atque itaque repudiandae.','2006-01-13 19:34:33','83','9'),
	(null,'Officia id explicabo rerum ullam delectus.','2016-07-31 02:51:20','35','6'),
	(null,'Occaecati qui voluptatem commodi delectus sapiente tempore.','2013-04-20 23:49:17','90','7'),
	(null,'Autem ea natus nemo eligendi nemo unde quasi ipsum.','2005-04-27 16:55:56','79','8'),
	(null,'Id eveniet molestiae sunt deserunt.','2009-03-30 14:31:18','93','10'),
	(null,'Dicta repellat molestiae voluptatem est.','1984-07-21 10:14:32','37','10'),
	(null,'Harum est rerum mollitia quis aperiam qui laborum quo.','2003-05-22 12:08:23','16','4'),
	(null,'Laudantium et alias aperiam quibusdam sequi.','1970-04-17 19:46:25','89','1'),
	(null,'Sed rerum sit accusamus.','2016-01-26 02:02:04','85','7'),
	(null,'Perspiciatis vel excepturi magnam quo fuga quia et.','1980-10-03 01:45:16','58','3'),
	(null,'Sunt a deserunt dolor laudantium nihil.','1978-01-03 08:30:55','52','5'),
	(null,'Voluptatem aut inventore non accusantium aut voluptatem.','1994-12-01 00:44:56','46','8'),
	(null,'Placeat saepe exercitationem quia in laborum soluta.','1977-06-29 07:43:00','62','2'),
	(null,'Vel aut neque rerum perspiciatis dolorem.','1988-11-10 13:29:12','9','2'),
	(null,'Neque earum autem ipsum.','2005-08-30 10:49:11','7','4'),
	(null,'Deleniti quo debitis libero necessitatibus facilis quasi ut.','1998-07-01 01:04:32','32','2'),
	(null,'Asperiores omnis cupiditate ab quam at veritatis possimus.','1978-08-26 15:39:28','30','3'),
	(null,'Ratione voluptas ea incidunt quaerat possimus.','2004-07-13 21:28:31','81','5'),
	(null,'Et sed aut dicta non assumenda accusantium autem et.','1978-07-12 11:07:05','42','2'),
	(null,'Quibusdam expedita ipsa et laborum neque enim ut aut.','2011-08-22 00:11:45','54','6'),
	(null,'Aut qui saepe aspernatur et culpa velit.','2005-10-30 20:38:12','40','7'),
	(null,'Commodi illo consequatur illo nisi.','1973-11-15 04:40:02','6','4'),
	(null,'Officia et quos rem esse.','2012-11-14 15:13:34','30','2'),
	(null,'Porro illum omnis suscipit et aspernatur.','1990-09-01 01:17:36','56','10'),
	(null,'Commodi deleniti ducimus tenetur est fugit.','2012-02-24 08:04:33','40','5'),
	(null,'Fuga et odio dolores similique non.','2009-01-26 11:54:45','64','6'),
	(null,'Veritatis eos nihil optio temporibus neque laudantium.','1998-02-20 21:00:06','56','10'),
	(null,'Nulla atque magni libero magnam ut quis.','1986-01-18 17:31:00','69','5'),
	(null,'Earum voluptatem quo minus nulla.','2018-04-13 02:19:38','15','6'),
	(null,'Occaecati cum expedita soluta earum.','1972-03-13 02:03:40','91','9'),
	(null,'Aut aut velit voluptates blanditiis nemo quisquam vel.','1988-05-02 02:48:11','95','9'),
	(null,'Quia distinctio unde cum aspernatur illo dignissimos.','2012-04-01 19:13:16','61','4'),
	(null,'Eaque dolor est id illum ea soluta.','1977-10-18 15:16:42','58','10'),
	(null,'Quia accusamus non ea consequatur nihil sint.','1990-12-23 01:01:28','33','5'),
	(null,'Quia in perferendis doloremque ipsa veritatis numquam labore.','1988-01-01 16:04:40','45','1'),
	(null,'Eum inventore recusandae et velit temporibus dolor ea.','2004-01-24 13:30:27','39','6'),
	(null,'Totam neque nostrum nemo sit eum eius laboriosam.','1972-12-02 10:21:03','93','10'),
	(null,'Ut perferendis quis quod placeat id sint ut.','2011-09-17 03:00:20','58','10'),
	(null,'Et ut numquam exercitationem esse est maiores.','1992-09-25 18:47:53','30','8'); 

	-- LIKE_ANSWER

	INSERT INTO `LIKE_ANSWER` VALUES (null,'0','53','7'),
	(null,'1','43','8'),
	(null,'0','42','3'),
	(null,'1','34','10'),
	(null,'0','22','5'),
	(null,'0','18','9'),
	(null,'1','85','8'),
	(null,'0','35','5'),
	(null,'0','73','2'),
	(null,'0','100','10'),
	(null,'1','12','2'),
	(null,'1','32','4'),
	(null,'0','97','4'),
	(null,'0','99','10'),
	(null,'0','63','10'),
	(null,'0','92','6'),
	(null,'1','69','8'),
	(null,'0','69','3'),
	(null,'1','96','8'),
	(null,'0','40','8'),
	(null,'1','18','7'),
	(null,'1','85','7'),
	(null,'0','26','6'),
	(null,'0','25','1'),
	(null,'0','83','7'),
	(null,'0','13','5'),
	(null,'0','68','3'),
	(null,'0','75','4'),
	(null,'1','39','2'),
	(null,'1','86','5'),
	(null,'1','13','6'),
	(null,'1','91','10'),
	(null,'0','99','8'),
	(null,'0','37','1'),
	(null,'0','19','3'),
	(null,'0','11','7'),
	(null,'1','68','7'),
	(null,'0','64','3'),
	(null,'1','58','5'),
	(null,'1','91','4'),
	(null,'1','9','3'),
	(null,'0','44','10'),
	(null,'0','44','2'),
	(null,'0','42','10'),
	(null,'0','90','9'),
	(null,'0','35','6'),
	(null,'0','18','7'),
	(null,'0','23','10'),
	(null,'0','15','4'),
	(null,'1','15','9'),
	(null,'0','85','9'),
	(null,'1','50','5'),
	(null,'1','24','5'),
	(null,'0','83','9'),
	(null,'1','40','2'),
	(null,'0','26','6'),
	(null,'1','51','4'),
	(null,'1','13','4'),
	(null,'0','59','7'),
	(null,'0','52','6'),
	(null,'0','45','9'),
	(null,'1','46','5'),
	(null,'0','59','7'),
	(null,'1','35','4'),
	(null,'0','39','10'),
	(null,'0','57','6'),
	(null,'1','18','9'),
	(null,'0','45','7'),
	(null,'0','83','3'),
	(null,'0','88','7'),
	(null,'1','3','4'),
	(null,'0','41','9'),
	(null,'0','13','9'),
	(null,'0','21','8'),
	(null,'1','29','10'),
	(null,'1','7','6'),
	(null,'0','6','6'),
	(null,'0','56','1'),
	(null,'0','6','8'),
	(null,'0','19','3'),
	(null,'0','61','6'),
	(null,'1','76','6'),
	(null,'0','29','9'),
	(null,'1','9','4'),
	(null,'0','70','5'),
	(null,'1','67','9'),
	(null,'0','74','6'),
	(null,'0','12','10'),
	(null,'0','44','9'),
	(null,'1','63','6'),
	(null,'0','26','7'),
	(null,'0','6','5'),
	(null,'1','58','5'),
	(null,'1','16','2'),
	(null,'0','6','7'),
	(null,'0','3','1'),
	(null,'0','18','9'),
	(null,'0','50','10'),
	(null,'0','47','5'),
	(null,'0','66','3'); 

	-- LIKE_QUESTION
		
	INSERT INTO `LIKE_QUESTION` VALUES (null,'1','28','6'),
	(null,'0','15','9'),
	(null,'1','14','6'),
	(null,'0','19','4'),
	(null,'0','21','5'),
	(null,'0','12','7'),
	(null,'0','12','4'),
	(null,'0','23','10'),
	(null,'0','29','6'),
	(null,'0','12','10'),
	(null,'0','19','6'),
	(null,'1','21','4'),
	(null,'0','28','8'),
	(null,'0','11','1'),
	(null,'1','19','7'),
	(null,'1','11','1'),
	(null,'1','30','3'),
	(null,'1','28','2'),
	(null,'1','26','9'),
	(null,'0','11','8'),
	(null,'1','7','10'),
	(null,'1','20','2'),
	(null,'1','4','10'),
	(null,'1','23','9'),
	(null,'0','25','10'),
	(null,'1','23','9'),
	(null,'1','16','5'),
	(null,'0','25','5'),
	(null,'1','8','9'),
	(null,'1','5','8'),
	(null,'0','11','4'),
	(null,'1','18','4'),
	(null,'1','12','5'),
	(null,'0','5','9'),
	(null,'0','8','6'),
	(null,'1','19','3'),
	(null,'0','10','7'),
	(null,'1','25','9'),
	(null,'1','5','9'),
	(null,'0','7','1'),
	(null,'1','13','5'),
	(null,'1','29','7'),
	(null,'0','27','10'),
	(null,'0','20','8'),
	(null,'0','23','9'),
	(null,'1','6','1'),
	(null,'1','18','4'),
	(null,'0','12','9'),
	(null,'0','22','3'),
	(null,'0','15','5'),
	(null,'0','28','1'),
	(null,'1','11','10'),
	(null,'1','6','2'),
	(null,'0','17','7'),
	(null,'1','30','4'),
	(null,'0','5','3'),
	(null,'0','27','8'),
	(null,'1','29','10'),
	(null,'1','6','4'),
	(null,'0','19','9'),
	(null,'0','6','1'),
	(null,'0','13','7'),
	(null,'1','3','3'),
	(null,'0','21','10'),
	(null,'0','7','3'),
	(null,'0','3','4'),
	(null,'1','8','1'),
	(null,'0','30','10'),
	(null,'0','9','5'),
	(null,'0','14','3'),
	(null,'1','20','9'),
	(null,'0','17','2'),
	(null,'0','29','9'),
	(null,'1','25','7'),
	(null,'1','9','1'),
	(null,'0','10','6'),
	(null,'1','25','3'),
	(null,'0','28','2'),
	(null,'1','7','5'),
	(null,'0','28','5'),
	(null,'1','25','7'),
	(null,'0','11','3'),
	(null,'1','16','8'),
	(null,'0','10','2'),
	(null,'1','11','10'),
	(null,'1','3','6'),
	(null,'0','15','4'),
	(null,'1','4','3'),
	(null,'1','19','5'),
	(null,'0','17','8'),
	(null,'0','13','8'),
	(null,'1','28','1'),
	(null,'0','21','3'),
	(null,'1','28','4'),
	(null,'1','20','5'),
	(null,'1','23','2'),
	(null,'1','19','9'),
	(null,'0','14','8'),
	(null,'0','9','3'),
	(null,'0','10','6'); 


	update user set password = '123' ;
