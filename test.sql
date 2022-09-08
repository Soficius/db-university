-- ---------------------------------------  QUERY CON SELECT

-- 1. Selezionare tutti gli studenti nati nel 1990 (160)
SELECT * FROM students WHERE YEAR(date_of_birth) = 1990

-- 2. Selezionare tutti i corsi che valgono più di 10 crediti (479)
SELECT * FROM courses WHERE cfu > 10;

-- 3. Selezionare tutti gli studenti che hanno più di 30 anni
SELECT * FROM students
WHERE date_of_birth < DATE_SUB(CURDATE(), INTERVAL 30 YEAR) 

-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea (286)
SELECT *
FROM courses
WHERE period = "I semestre"
AND year = 1;

-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21)
select *
FROM exams
WHERE hour > "14:00:00"
AND date = "2020-06-20";

-- 6. Selezionare tutti i corsi di laurea magistrale (38)
SELECT *
FROM degrees
WHERE level = "magistrale";

-- 7. Da quanti dipartimenti è composta l'università? (12)
SELECT COUNT(*) AS total FROM departments;

-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)
SELECT COUNT(*) AS total_no_phone
FROM teachers
WHERE phone is NULL;


-- ------------------------------------------  QUERY CON GROUP BY


-- 1. Contare quanti iscritti ci sono stati ogni anno
SELECT YEAR(enrolment_date) AS anno
, COUNT(*) as n_iscritti
FROM students
GROUP BY YEAR(enrolment_date);

-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio
SELECT office_address as ufficio, COUNT(*) as totale_insegnanti
FROM teachers
GROUP BY office_address;

-- 3. Calcolare la media dei voti di ogni appello d'esame
SELECT exam_id as appello,
AVG(vote) as media_voti
FROM exam_student
GROUP BY exam_id;

-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento
SELECT department_id as dipartimento,
COUNT(*) as n_degrees
FROM degrees
GROUP BY department_id;

-- ------------------------------------------  QUERY CON JOIN
-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
SELECT students.*
FROM students
JOIN degrees
ON degrees. id = students . degree_id
WHERE degrees. name = "Corso di Laurea in Economia";

-- 2. Selezionare tutti i Corsi di Laurea del Dipartimento di Neuroscienze
SELECT degrees.*
FROM departments
JOIN degrees
ON departments.id = degrees. department_id
WHERE departments . name = "Dipartimento di Neuroscienze";

-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)
SELECT courses.*
FROM courses
JOIN course_teacher
ON courses.id = course_teacher.course_id
WHERE course_teacher.teacher_id = 44;

-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome
SELECT *
FROM students
JOIN degrees
ON degrees.id = students.degree_id
JOIN departments
ON departments.id = degrees.department_id
ORDER BY students.surname, students.name ASC;

-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
SELECT degrees.name As corso_laurea, courses.name AS materia, teachers.name AS insegnante
FROM degrees
JOIN courses
ON degrees.id = courses.degree_id
JOIN course_teacher
ON courses.id = course_teacher.course_id
JOIN teachers
ON teachers.id = course_teacher.teacher_id;

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
SELECT DISTINCT teachers.*
FROM teachers
JOIN course_teacher
ON teachers.id = course_teacher.teacher_id
JOIN courses
ON courses.id = course_teacher.course_id
JOIN degrees
ON degrees.id = courses.degree_id
JOIN departments
ON departments.id = degrees.department_id
WHERE departments.name = "Dipartimento di Matematica";

--7. BONUS: Selezionare per ogni studente quanti tentativi d’esame ha sostenuto per superare ciascuno dei suoi esami
SELECT students.name, students.surname, courses.name, COUNT(exam_student.vote) As tentativi, MAX(exama_student.vote) AS max_voto
FROM students 
JOIN exam_student
ON students.id = exam_student.student_id
JOIN exams
ON exams.id = exam_student.exam_id
JOIN courses
ON courses.id = exams.course_id
GROUP BY students.id, courses.id
HAVING max_vote >= 18
