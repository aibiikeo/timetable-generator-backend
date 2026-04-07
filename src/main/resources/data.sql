-- =========================================================
-- FACULTIES
-- =========================================================
INSERT INTO faculties (id, name) VALUES
                                     (1, 'Faculty of Engineering and Informatics'),
                                     (2, 'Faculty of Economics and Management'),
                                     (3, 'Faculty of Social Sciences'),
                                     (4, 'Medical Faculty'),
                                     (5, 'Faculty of Humanities');

-- =========================================================
-- DEPARTMENTS
-- =========================================================
INSERT INTO departments (id, name, faculty_id) VALUES
-- FEI
(1, 'Department of Computer Science', 1),
(2, 'Department of Applied Mathematics and Informatics', 1),
(3, 'Programs of Industrial and Electronic Engineering', 1),

-- FEM
(4, 'Department of Economics', 2),
(5, 'Department of Management', 2),
(6, 'Department of International and Business Law', 2),

-- FSS
(7, 'Department of Social Sciences', 3),

-- Medical
(8, 'Department of Medical Faculty', 4),

-- Humanities
(9, 'Department of Humanities', 5);

-- =========================================================
-- MAJORS
-- =========================================================
INSERT INTO majors (id, name, short_name, degree, department_id) VALUES
-- ================= FEI / Department of Computer Science =================
(1, 'Computer Science', 'COM', 'BACHELOR', 1),
(2, 'COMSE', 'COMSE', 'BACHELOR', 1),
(3, 'COMCEH', 'COMCEH', 'BACHELOR', 1),
(4, 'COMFCI', 'COMFCI', 'BACHELOR', 1),

-- ================= FEI / Department of Applied Mathematics and Informatics =================
(5, 'Applied Mathematics and Informatics', 'MATH', 'BACHELOR', 2),
(6, 'MATDAIS', 'MATDAIS', 'BACHELOR', 2),
(7, 'MATMIE', 'MATMIE', 'BACHELOR', 2),

-- ================= FEI / Programs of Industrial and Electronic Engineering =================
(8, 'EEAIR', 'EEAIR', 'BACHELOR', 3),
(9, 'IEMIT', 'IEMIT', 'BACHELOR', 3),

-- ================= Faculty of Economics and Management =================
(10, 'International Economics and Business', 'IBE', 'BACHELOR', 4),
(11, 'International Finance and Auditing', 'IFA', 'BACHELOR', 4),
(12, 'Environmental Economics', 'ENV', 'BACHELOR', 4),
(13, 'Economics', 'ECO-M', 'MASTER', 4),

(14, 'Management', 'MNG', 'BACHELOR', 5),
(15, 'Tourism Management', 'TM', 'BACHELOR', 5),
(16, 'Management', 'MNG-M', 'MASTER', 5),

(17, 'International and Business Law', 'LAW', 'BACHELOR', 6),
(18, 'International and Business Law', 'LAW-M', 'MASTER', 6),

-- ================= Faculty of Social Sciences =================
(19, 'International Relations', 'INT', 'BACHELOR', 7),
(20, 'Psychology', 'PS', 'BACHELOR', 7),
(21, 'Journalism', 'JRN', 'BACHELOR', 7),
(22, 'Advertising and Public Relations', 'ADV', 'BACHELOR', 7),
(23, 'International Relations', 'INT-M', 'MASTER', 7),
(24, 'Psychology', 'PS-M', 'MASTER', 7),
(25, 'Journalism', 'JRN-M', 'MASTER', 7),
(26, 'Advertising and Public Relations', 'ADV-M', 'MASTER', 7),

-- ================= Medical =================
(27, 'General Medicine', 'MGN', 'SPECIALIST', 8),

-- ================= Humanities =================
(28, 'Linguistics', 'LIN', 'BACHELOR', 9),
(29, 'Philology', 'PHIL', 'BACHELOR', 9),
(30, 'Education', 'PED', 'BACHELOR', 9),
(31, 'Linguistics', 'LIN-M', 'MASTER', 9),
(32, 'Philology', 'PHIL-M', 'MASTER', 9),
(33, 'Education', 'PED-M', 'MASTER', 9);

-- =========================================================
-- STUDY GROUPS
-- =========================================================
INSERT INTO study_groups (id, name, major_id, course, student_count) VALUES
-- COM
(1,  'COMSE-25', 2, 1, 25),
(2,  'COMCEH-25', 3, 1, 25),
(3,  'COMFCI-25', 4, 1, 25),

(4,  'COMCEH-24', 3, 2, 25),
(5,  'COMSE-24', 2, 2, 25),
(6,  'COMFCI-24', 4, 2, 25),

(7,  'COMCEH-23', 3, 3, 25),
(8,  'COMSE-23/  1-Group', 2, 3, 20),
(9,  'COMSE-23/  2-Group', 2, 3, 20),
(10, 'COMFCI-23', 4, 3, 25),

(11, 'COM-22 /  1-Group', 1, 4, 20),
(12, 'COM-22 /  2-Group', 1, 4, 20),

-- MAT
(13, 'MATDAIS-25', 6, 1, 25),
(14, 'MATMIE-25', 7, 1, 25),
(15, 'MATDAIS-24', 6, 2, 25),
(16, 'MATMIE-24', 7, 2, 25),
(17, 'MATDAIS-23', 6, 3, 25),
(18, 'MATMIE-23', 7, 3, 25),
(19, 'MATH-22', 5, 4, 25),

-- IND / ELT block
(20, 'EEAIR-25', 8, 1, 25),
(21, 'IEMIT-25', 9, 1, 25),
(22, 'EEAIR-24', 8, 2, 25),
(23, 'IEMIT-24', 9, 2, 25),
(24, 'EEAIR-23', 8, 3, 25),
(25, 'IEMIT-23', 9, 3, 25);

-- =========================================================
-- TEACHERS
-- =========================================================
INSERT INTO teachers (id, full_name) VALUES
                                         (1, 'Dr. Aslan Al Khan'),
                                         (2, 'Dr. Musa Abdujabbarov'),
                                         (3, 'Dr. Mekia Gaso'),
                                         (4, 'Mr. Dim Shaiakhmetov'),
                                         (5, 'Dr. Ahmad Sarosh'),
                                         (6, 'Dr. Ruslan Isaev'),
                                         (7, 'Dr. Tauheed Khan'),
                                         (8, 'Cholponbek Esenbekov'),
                                         (9, 'Dr. Remudin Mekuria'),
                                         (10, 'Mr. Tursunali Baimuradov'),
                                         (11, 'Ms. Siren Kerimbaeva'),
                                         (12, 'Dr. Sherali Matanov'),
                                         (13, 'Mr. Samat Elikbaev'),
                                         (14, 'Ms. Tattybubu Arap kyzy'),
                                         (15, 'Ms. Meerim'),
                                         (16, 'Dr. Burul Shambetova'),
                                         (17, 'Mr. Murrey Eldred'),
                                         (18, 'Ms. Ainuuru Zhoolchieva'),
                                         (19, 'Ms. Imtiyaz gulbarga');

-- =========================================================
-- ROOMS
-- =========================================================
INSERT INTO rooms (id, name, capacity, type) VALUES
                                                 (1, 'B101', 30, 'CLASSROOM'),
                                                 (2, 'B102', 30, 'CLASSROOM'),
                                                 (3, 'B103', 30, 'CLASSROOM'),
                                                 (4, 'B104', 30, 'CLASSROOM'),
                                                 (5, 'B105', 30, 'CLASSROOM'),
                                                 (6, 'B106', 30, 'CLASSROOM'),
                                                 (7, 'B109 (APPLE LAB)', 24, 'COMPUTER_LAB'),
                                                 (8, 'B110 LAB', 24, 'COMPUTER_LAB'),
                                                 (9, 'B111 LAB', 24, 'COMPUTER_LAB'),
                                                 (10, 'B113', 30, 'CLASSROOM'),
                                                 (11, 'B201', 30, 'CLASSROOM'),
                                                 (12, 'B202', 30, 'CLASSROOM'),
                                                 (13, 'B203', 30, 'CLASSROOM'),
                                                 (14, 'B204', 30, 'CLASSROOM'),
                                                 (15, 'B205', 30, 'CLASSROOM'),
                                                 (16, 'BIGLAB', 40, 'COMPUTER_LAB'),
                                                 (17, 'LAB3(210)', 24, 'COMPUTER_LAB'),
                                                 (18, 'LAB4(211)', 24, 'COMPUTER_LAB'),
                                                 (19, 'LAB5(213)', 24, 'COMPUTER_LAB');

-- =========================================================
-- SUBJECTS
-- =========================================================
INSERT INTO subjects (id, name, code, total_hours, hours_per_week, major_id) VALUES
-- 2022-2023.1
(1,  'Introduction to Engineering and Computer Science', 'COM 100', 6, 6, 1),
(2,  'Engineering Computer Graphics', 'COM 108', 4, 4, 1),
(3,  'English Language', 'COM 109', 4, 4, 1),
(4,  'Programming Languages I', 'COM 113', 6, 6, 1),
(5,  'Calculus I', 'MAT 601', 6, 6, 5),
(6,  'Algebra and Geometry I', 'MAT 607', 4, 4, 5),
(7,  'Physical Education I', 'MDE 131', 1, 1, 1),
(8,  'Russian Language', 'MDE 133', 2, 2, 1),

-- 2022-2023.2
(9,  'Programming Language II', 'COM 102', 6, 6, 1),
(10, 'Philosophy of Technologies', 'COM 410', 4, 4, 1),
(11, 'Discrete Mathematics I', 'MAT 151', 6, 6, 5),
(12, 'Calculus II', 'MAT 602', 6, 6, 5),
(13, 'Russian Language II', 'MDE 112', 2, 2, 1),
(14, 'Physical Education II', 'MDE 136', 1, 1, 1),
(15, 'German', 'MDE 154', 4, 4, 1),
(16, 'Manas Studies', 'MDE 404', 2, 2, 1),

-- 2023-2024.1
(17, 'Web Technologies', 'COM 203', 6, 6, 1),
(18, 'Database Systems', 'COM 205', 6, 6, 1),
(19, 'Object Oriented Programming (OOP)', 'COM 235', 6, 6, 1),
(20, 'Computational Mathematics', 'MAT 231', 4, 4, 5),
(21, 'Statistics with Python', 'MAT 389', 4, 4, 5),
(22, 'Kyrgyz Language and Literature I', 'MDE 201', 4, 4, 1),
(23, 'Physical Education III', 'MDE 227', 1, 1, 1),

-- 2023-2024.2
(24, 'Web Programming', 'COM 204', 6, 6, 1),
(25, 'Electronics', 'COM 224', 4, 4, 1),
(26, 'Design and Analysis of algorithms', 'COM 366', 6, 6, 1),
(27, 'Robotics', 'COM 419', 4, 4, 1),
(28, 'Kyrgyz Language and Literature IV', 'MDE 202', 4, 4, 1),
(29, 'History of Kyrgyzstan', 'MDE 208', 4, 4, 1),
(30, 'Geography of Kyrgyzstan', 'MDE 216', 2, 2, 1),
(31, 'Physical Education IV', 'MDE 220', 1, 1, 1),

-- 2024-2025.1
(32, 'Educational Interrnship', 'COM 055', 6, 6, 1),
(33, 'Computer Networks and Telecommunication', 'COM 352', 6, 6, 1),
(34, 'Software Engineering', 'COM 353', 6, 6, 1),
(35, 'Computer architecture and operating systems', 'COM 367', 6, 6, 1),
(36, 'Probability and Statistics', 'COM 535', 6, 6, 1),

-- 2024-2025.2
(37, 'Artificial Intelligence', 'COM 302', 6, 6, 1),
(38, 'Industrial Project Internship', 'COM 328', 6, 6, 1),
(39, 'Mobile Development', 'COM 363', 6, 6, 1),
(40, 'Information Security', 'COM 412', 6, 6, 1),
(41, 'Machine Learning', 'COM 416', 6, 6, 1),

-- 2025-2026.1
(42, 'Pre-qualification internship', 'COM 048', 12, 12, 1),
(43, 'Basics of science research', 'COM 470', 6, 6, 1),
(44, 'Data mining and storage', 'COM 476', 6, 6, 1),
(45, 'Engineering Economics', 'IND 100', 6, 6, 9),

-- 2025-2026.2
(46, 'Cloud Computing', 'COM 344', 6, 6, 1),
(47, 'Image Processing for Computer Vision', 'COM 482', 6, 6, 1),
(48, 'SDAT(Software Development Automation Testing)', 'COM 486', 6, 6, 1),
(49, 'Final State Certification', 'COM 910', 6, 6, 1);

-- =========================================================
-- SUBJECT <-> TEACHER
-- =========================================================
INSERT INTO subject_teachers (subject_id, teacher_id) VALUES
                                                          (1, 1), (1, 2),
                                                          (2, 4),
                                                          (3, 15),
                                                          (4, 2), (4, 7),
                                                          (5, 12),
                                                          (6, 12),
                                                          (7, 17),
                                                          (8, 14),

                                                          (9, 2), (9, 7),
                                                          (10, 1),
                                                          (11, 12),
                                                          (12, 12),
                                                          (13, 14),
                                                          (14, 17),
                                                          (15, 15),
                                                          (16, 14),

                                                          (17, 4),
                                                          (18, 6),
                                                          (19, 2), (19, 4),
                                                          (20, 12),
                                                          (21, 18),
                                                          (22, 14),
                                                          (23, 17),

                                                          (24, 4),
                                                          (25, 3),
                                                          (26, 7),
                                                          (27, 5),
                                                          (28, 14),
                                                          (29, 14),
                                                          (30, 14),
                                                          (31, 17),

                                                          (32, 10),
                                                          (33, 6),
                                                          (34, 9),
                                                          (35, 8),
                                                          (36, 18),

                                                          (37, 5),
                                                          (38, 10),
                                                          (39, 19),
                                                          (40, 16),
                                                          (41, 5),

                                                          (42, 10),
                                                          (43, 1),
                                                          (44, 18),
                                                          (45, 13),

                                                          (46, 9),
                                                          (47, 3),
                                                          (48, 11),
                                                          (49, 12);

-- =========================================================
-- SUBJECT <-> GROUP
-- =========================================================
INSERT INTO subject_groups (subject_id, group_id) VALUES
-- 1 курс COM / MAT
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 2), (2, 3),
(3, 1), (3, 2), (3, 3),
(4, 1), (4, 2), (4, 3),
(5, 13), (5, 14),
(6, 13), (6, 14),
(7, 1), (7, 2), (7, 3),
(8, 1), (8, 2), (8, 3),

-- 2 курс
(9, 4), (9, 5), (9, 6),
(10, 4), (10, 5), (10, 6),
(11, 15), (11, 16),
(12, 15), (12, 16),
(13, 4), (13, 5), (13, 6),
(14, 4), (14, 5), (14, 6),
(15, 4), (15, 5), (15, 6),
(16, 4), (16, 5), (16, 6),

-- 3 курс
(17, 7), (17, 8), (17, 9), (17, 10),
(18, 7), (18, 8), (18, 9), (18, 10),
(19, 7), (19, 8), (19, 9), (19, 10),
(20, 17), (20, 18),
(21, 17), (21, 18),
(22, 7), (22, 8), (22, 9), (22, 10),
(23, 7), (23, 8), (23, 9), (23, 10),

(24, 7), (24, 8), (24, 9), (24, 10),
(25, 7), (25, 8), (25, 9), (25, 10),
(26, 7), (26, 8), (26, 9), (26, 10),
(27, 7), (27, 8), (27, 9), (27, 10),
(28, 7), (28, 8), (28, 9), (28, 10),
(29, 7), (29, 8), (29, 9), (29, 10),
(30, 7), (30, 8), (30, 9), (30, 10),
(31, 7), (31, 8), (31, 9), (31, 10),

-- 4 курс
(32, 11), (32, 12),
(33, 11), (33, 12),
(34, 11), (34, 12),
(35, 11), (35, 12),
(36, 11), (36, 12),
(37, 11), (37, 12),
(38, 11), (38, 12),
(39, 11), (39, 12),
(40, 11), (40, 12),
(41, 11), (41, 12),
(42, 11), (42, 12),
(43, 11), (43, 12),
(44, 11), (44, 12),
(45, 25),
(46, 11), (46, 12),
(47, 11), (47, 12),
(48, 11), (48, 12),
(49, 11), (49, 12);

-- =========================================================
-- TIMETABLES
-- =========================================================
INSERT INTO timetables (
    id, name, academic_year_start, academic_year_end, semester, version,
    created_at, status, generation_settings, conflict_report
) VALUES
      (
          1,
          'Course Schedule FALL 2025-2026 v0',
          2025,
          2026,
          'FALL',
          0,
          NOW(),
          'DRAFT',
          NULL,
          NULL
      ),
      (
          2,
          'Course Schedule SPRING 2025-2026 v0',
          2025,
          2026,
          'SPRING',
          0,
          NOW(),
          'DRAFT',
          NULL,
          NULL
      );

-- =========================================================
-- TIME SLOTS
-- =========================================================
INSERT INTO time_slots (day_of_week, slot_order, start_time, end_time, is_lunch, description) VALUES
                                                                                                  (NULL, 1,  '08:00:00', '08:40:00', false, '1st lesson'),
                                                                                                  (NULL, 2,  '08:45:00', '09:25:00', false, '2nd lesson'),
                                                                                                  (NULL, 3,  '09:30:00', '10:10:00', false, '3rd lesson'),
                                                                                                  (NULL, 4,  '10:15:00', '10:55:00', false, '4th lesson'),
                                                                                                  (NULL, 5,  '11:00:00', '11:40:00', false, '5th lesson'),
                                                                                                  (NULL, 6,  '11:45:00', '12:25:00', false, '6th lesson'),
                                                                                                  (NULL, 7,  '12:30:00', '13:10:00', false, '7th lesson'),
                                                                                                  (NULL, 8,  '13:15:00', '13:55:00', false, '8th lesson'),
                                                                                                  (NULL, 9,  '14:00:00', '14:40:00', false, '9th lesson'),
                                                                                                  (NULL, 10, '14:45:00', '15:25:00', false, '10th lesson'),
                                                                                                  (NULL, 11, '15:30:00', '16:10:00', false, '11th lesson'),
                                                                                                  (NULL, 12, '16:15:00', '16:55:00', false, '12th lesson'),
                                                                                                  (NULL, 13, '17:00:00', '17:40:00', false, '13th lesson'),
                                                                                                  (NULL, 14, '17:45:00', '18:25:00', false, '14th lesson');

-- =========================================================
-- USERS
-- =========================================================
INSERT INTO users (email, password, role) VALUES
                                              ('admin@university.kg', '$2a$08$a6r..ZYW.BK0UB0yJSwfc.30Alt2gSzmK/c0kkqLGqK7tIm9HVk/2', 'ADMIN'),
                                              ('scheduler@university.kg', '$2a$08$Iy5qn7TWG6LI.D2ATDvL5uPOftseKIhhWXUzyFHYnts1tFA1DNPNi', 'ADMIN');