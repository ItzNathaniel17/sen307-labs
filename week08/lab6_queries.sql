
-- =====================================================
-- VUA-SEN307 DATABASE SYSTEMS
-- WEEK 8 PRACTICAL - LAB 6
-- AGGREGATE FUNCTIONS, GROUPING AND SUBQUERIES
-- Name: Ochiga Oche Nathaniel
-- Matric Number: VUG/SEN/24/12966
-- =====================================================

USE sen307_vug_sen_24_12966;


-- =====================================================
-- TASK 1: COUNT STUDENTS ENROLLED IN EACH COURSE
-- Include courses with zero students
-- =====================================================

SELECT
    c.course_title,
    COUNT(e.student_id) AS total_students
FROM Course c
LEFT JOIN Enrolment e
    ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_title
ORDER BY total_students DESC;


-- =====================================================
-- TASK 2: FIND COURSES WITH MORE THAN A GIVEN
-- NUMBER OF STUDENTS USING HAVING
-- =====================================================

-- Threshold: More than 3 students

SELECT
    c.course_title,
    COUNT(e.student_id) AS total_students
FROM Course c
LEFT JOIN Enrolment e
    ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_title
HAVING COUNT(e.student_id) > 3
ORDER BY total_students DESC;


-- Threshold: More than 5 students

SELECT
    c.course_title,
    COUNT(e.student_id) AS total_students
FROM Course c
LEFT JOIN Enrolment e
    ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_title
HAVING COUNT(e.student_id) > 5
ORDER BY total_students DESC;


-- Threshold: More than 7 students

SELECT
    c.course_title,
    COUNT(e.student_id) AS total_students
FROM Course c
LEFT JOIN Enrolment e
    ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_title
HAVING COUNT(e.student_id) > 7
ORDER BY total_students DESC;


-- =====================================================
-- TASK 3: CALCULATE THE AVERAGE NUMBER OF COURSES
-- TAKEN PER STUDENT, INCLUDING STUDENTS WITH ZERO COURSES
-- =====================================================

SELECT
    ROUND(AVG(course_count), 2) AS average_courses
FROM (
    SELECT
        s.student_id,
        COUNT(e.course_id) AS course_count
    FROM Student s
    LEFT JOIN Enrolment e
        ON s.student_id = e.student_id
    GROUP BY s.student_id
) AS per_student;


-- =====================================================
-- TASK 4: FIND STUDENTS WHO ARE NOT ENROLLED
-- IN ANY COURSE USING A NON-CORRELATED SUBQUERY
-- =====================================================

SELECT
    student_id,
    full_name
FROM Student
WHERE student_id NOT IN (
    SELECT student_id
    FROM Enrolment
);


-- =====================================================
-- TASK 5: FIND THE STUDENT(S) WITH THE HIGHEST
-- NUMBER OF ENROLMENTS IN EACH DEPARTMENT
-- USING A CORRELATED SUBQUERY
-- =====================================================

SELECT
    d.dept_name,
    s.full_name,
    (
        SELECT COUNT(*)
        FROM Enrolment e
        WHERE e.student_id = s.student_id
    ) AS courses
FROM Student s
JOIN Department d
    ON s.dept_id = d.dept_id
WHERE (
    SELECT COUNT(*)
    FROM Enrolment e
    WHERE e.student_id = s.student_id
) = (
    SELECT MAX(course_count)
    FROM (
        SELECT
            s2.student_id,
            COUNT(e2.course_id) AS course_count
        FROM Student s2
        LEFT JOIN Enrolment e2
            ON s2.student_id = e2.student_id
        WHERE s2.dept_id = s.dept_id
        GROUP BY s2.student_id
    ) AS department_counts
)
ORDER BY d.dept_name;


-- =====================================================
-- END OF WEEK 8 PRACTICAL
-- =====================================================
