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
INSERT INTO time_slots (day_of_week, slot_order, start_time, end_time, description) VALUES
                                                                                        (NULL, 1,  '08:00:00', '08:40:00', '1st lesson'),
                                                                                        (NULL, 2,  '08:45:00', '09:25:00', '2nd lesson'),
                                                                                        (NULL, 3,  '09:30:00', '10:10:00', '3rd lesson'),
                                                                                        (NULL, 4,  '10:15:00', '10:55:00', '4th lesson'),
                                                                                        (NULL, 5,  '11:00:00', '11:40:00', '5th lesson'),
                                                                                        (NULL, 6,  '11:45:00', '12:25:00', '6th lesson'),
                                                                                        (NULL, 7,  '12:30:00', '13:10:00', '7th lesson'),
                                                                                        (NULL, 8,  '13:15:00', '13:55:00', '8th lesson'),
                                                                                        (NULL, 9,  '14:00:00', '14:40:00', '9th lesson'),
                                                                                        (NULL, 10, '14:45:00', '15:25:00', '10th lesson'),
                                                                                        (NULL, 11, '15:30:00', '16:10:00', '11th lesson'),
                                                                                        (NULL, 12, '16:15:00', '16:55:00', '12th lesson'),
                                                                                        (NULL, 13, '17:00:00', '17:40:00', '13th lesson'),
                                                                                        (NULL, 14, '17:45:00', '18:25:00', '14th lesson');

-- =========================================================
-- ASSIGNMENTS FOR TIMETABLE 1 (FALL 2025-2026)
-- =========================================================

INSERT INTO assignments (
    id,
    timetable_id,
    subject_id,
    teacher_id,
    hours_per_week,
    shift,
    room_type_required,
    hours_splitting,
    generated_lessons_count,
    specific_room_id
) VALUES
      (1001, 1, 1, 1, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1002, 1, 3, 15, 4, 'ANY', 'CLASSROOM', '2+2', 0, NULL),
      (1003, 1, 4, 2, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1004, 1, 5, 12, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1005, 1, 6, 12, 4, 'ANY', 'CLASSROOM', '2+2', 0, NULL),
      (1006, 1, 7, 17, 1, 'ANY', 'CLASSROOM', '1', 0, NULL),
      (1007, 1, 8, 14, 2, 'ANY', 'CLASSROOM', '2', 0, NULL),
      (1008, 1, 1, 1, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1009, 1, 4, 2, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1010, 1, 5, 12, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1011, 1, 6, 12, 4, 'ANY', 'CLASSROOM', '2+2', 0, NULL),
      (1012, 1, 1, 1, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1013, 1, 4, 2, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1014, 1, 5, 12, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1015, 1, 6, 12, 4, 'ANY', 'CLASSROOM', '2+2', 0, NULL),
      (1016, 1, 7, 17, 1, 'ANY', 'CLASSROOM', '1', 0, NULL),
      (1017, 1, 18, 6, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1018, 1, 19, 2, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1019, 1, 20, 12, 4, 'ANY', 'CLASSROOM', '2+2', 0, NULL),
      (1020, 1, 22, 14, 4, 'ANY', 'CLASSROOM', '2+2', 0, NULL),
      (1021, 1, 23, 17, 1, 'ANY', 'CLASSROOM', '1', 0, NULL),
      (1022, 1, 18, 6, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1023, 1, 19, 2, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1024, 1, 20, 12, 4, 'ANY', 'CLASSROOM', '2+2', 0, NULL),
      (1025, 1, 23, 17, 1, 'ANY', 'CLASSROOM', '1', 0, NULL),
      (1026, 1, 18, 6, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1027, 1, 19, 2, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1028, 1, 20, 12, 4, 'ANY', 'CLASSROOM', '2+2', 0, NULL),
      (1029, 1, 23, 17, 1, 'ANY', 'CLASSROOM', '1', 0, NULL),
      (1030, 1, 34, 9, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1031, 1, 35, 8, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1032, 1, 36, 18, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1033, 1, 34, 9, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1034, 1, 35, 8, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1035, 1, 36, 18, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1036, 1, 39, 19, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1037, 1, 34, 9, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1038, 1, 35, 8, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1039, 1, 36, 18, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1040, 1, 39, 19, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1041, 1, 34, 9, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1042, 1, 35, 8, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1043, 1, 36, 18, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1044, 1, 41, 5, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1045, 1, 42, 10, 12, 'ANY', 'ANY', '4+4+4', 0, NULL),
      (1046, 1, 43, 1, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1047, 1, 44, 18, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1048, 1, 45, 13, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1049, 1, 41, 5, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1050, 1, 42, 10, 12, 'ANY', 'ANY', '4+4+4', 0, NULL),
      (1051, 1, 43, 1, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1052, 1, 44, 18, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1053, 1, 45, 13, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1054, 1, 1, 1, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1055, 1, 3, 15, 4, 'ANY', 'CLASSROOM', '2+2', 0, NULL),
      (1056, 1, 4, 2, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1057, 1, 5, 12, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1058, 1, 6, 12, 4, 'ANY', 'CLASSROOM', '2+2', 0, NULL),
      (1059, 1, 7, 17, 1, 'ANY', 'CLASSROOM', '1', 0, NULL),
      (1060, 1, 1, 1, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1061, 1, 4, 2, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1062, 1, 5, 12, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1063, 1, 6, 12, 4, 'ANY', 'CLASSROOM', '2+2', 0, NULL),
      (1064, 1, 7, 17, 1, 'ANY', 'CLASSROOM', '1', 0, NULL),
      (1065, 1, 23, 17, 1, 'ANY', 'CLASSROOM', '1', 0, NULL),
      (1066, 1, 4, 2, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1067, 1, 36, 18, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1068, 1, 36, 18, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1069, 1, 40, 16, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1070, 1, 41, 5, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1071, 1, 43, 1, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1072, 1, 1, 1, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1073, 1, 4, 2, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1074, 1, 5, 12, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1075, 1, 6, 12, 4, 'ANY', 'CLASSROOM', '2+2', 0, NULL),
      (1076, 1, 7, 17, 1, 'ANY', 'CLASSROOM', '1', 0, NULL),
      (1077, 1, 1, 1, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1078, 1, 4, 2, 6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, NULL),
      (1079, 1, 5, 12, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1080, 1, 6, 12, 4, 'ANY', 'CLASSROOM', '2+2', 0, NULL),
      (1081, 1, 7, 17, 1, 'ANY', 'CLASSROOM', '1', 0, NULL),
      (1082, 1, 8, 14, 2, 'ANY', 'CLASSROOM', '2', 0, NULL),
      (1083, 1, 23, 17, 1, 'ANY', 'CLASSROOM', '1', 0, NULL),
      (1084, 1, 34, 9, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1085, 1, 34, 9, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1086, 1, 36, 18, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL),
      (1087, 1, 45, 13, 6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL);

-- =========================================================
-- ASSIGNMENT <-> GROUPS FOR TIMETABLE 1
-- =========================================================

INSERT INTO assignment_groups (assignment_id, group_id) VALUES
                                                            (1001, 1),
                                                            (1002, 1),
                                                            (1003, 1),
                                                            (1004, 1),
                                                            (1005, 1),
                                                            (1006, 1),
                                                            (1007, 1),
                                                            (1008, 2),
                                                            (1009, 2),
                                                            (1010, 2),
                                                            (1011, 2),
                                                            (1012, 3),
                                                            (1013, 3),
                                                            (1014, 3),
                                                            (1015, 3),
                                                            (1016, 3),
                                                            (1017, 4),
                                                            (1018, 4),
                                                            (1019, 4),
                                                            (1020, 4),
                                                            (1021, 4),
                                                            (1022, 5),
                                                            (1023, 5),
                                                            (1024, 5),
                                                            (1025, 5),
                                                            (1026, 6),
                                                            (1027, 6),
                                                            (1028, 6),
                                                            (1029, 6),
                                                            (1030, 7),
                                                            (1031, 7),
                                                            (1032, 7),
                                                            (1033, 8),
                                                            (1034, 8),
                                                            (1035, 8),
                                                            (1036, 8),
                                                            (1037, 9),
                                                            (1038, 9),
                                                            (1039, 9),
                                                            (1040, 9),
                                                            (1041, 10),
                                                            (1042, 10),
                                                            (1043, 10),
                                                            (1044, 11),
                                                            (1045, 11),
                                                            (1046, 11),
                                                            (1047, 11),
                                                            (1048, 11),
                                                            (1049, 12),
                                                            (1050, 12),
                                                            (1051, 12),
                                                            (1052, 12),
                                                            (1053, 12),
                                                            (1054, 13),
                                                            (1055, 13),
                                                            (1056, 13),
                                                            (1057, 13),
                                                            (1058, 13),
                                                            (1059, 13),
                                                            (1060, 14),
                                                            (1061, 14),
                                                            (1062, 14),
                                                            (1063, 14),
                                                            (1064, 14),
                                                            (1065, 15),
                                                            (1066, 16),
                                                            (1067, 17),
                                                            (1068, 18),
                                                            (1069, 19),
                                                            (1070, 19),
                                                            (1071, 19),
                                                            (1072, 20),
                                                            (1073, 20),
                                                            (1074, 20),
                                                            (1075, 20),
                                                            (1076, 20),
                                                            (1077, 21),
                                                            (1078, 21),
                                                            (1079, 21),
                                                            (1080, 21),
                                                            (1081, 21),
                                                            (1082, 21),
                                                            (1083, 22),
                                                            (1084, 24),
                                                            (1085, 25),
                                                            (1086, 25),
                                                            (1087, 25);

-- =========================================================
-- LUNCH
-- =========================================================
INSERT INTO lunch (id, timetable_id, group_id, day_of_week, start_time, end_time, is_manual) VALUES
                                                                                                 (1,   1, 1,  'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (2,   1, 1,  'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (3,   1, 1,  'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (4,   1, 1,  'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (5,   1, 1,  'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (6,   1, 1,  'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (7,   1, 2,  'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (8,   1, 2,  'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (9,   1, 2,  'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (10,  1, 2,  'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (11,  1, 2,  'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (12,  1, 2,  'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (13,  1, 3,  'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (14,  1, 3,  'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (15,  1, 3,  'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (16,  1, 3,  'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (17,  1, 3,  'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (18,  1, 3,  'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (19,  1, 4,  'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (20,  1, 4,  'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (21,  1, 4,  'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (22,  1, 4,  'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (23,  1, 4,  'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (24,  1, 4,  'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (25,  1, 5,  'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (26,  1, 5,  'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (27,  1, 5,  'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (28,  1, 5,  'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (29,  1, 5,  'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (30,  1, 5,  'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (31,  1, 6,  'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (32,  1, 6,  'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (33,  1, 6,  'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (34,  1, 6,  'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (35,  1, 6,  'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (36,  1, 6,  'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (37,  1, 7,  'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (38,  1, 7,  'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (39,  1, 7,  'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (40,  1, 7,  'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (41,  1, 7,  'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (42,  1, 7,  'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (43,  1, 8,  'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (44,  1, 8,  'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (45,  1, 8,  'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (46,  1, 8,  'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (47,  1, 8,  'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (48,  1, 8,  'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (49,  1, 9,  'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (50,  1, 9,  'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (51,  1, 9,  'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (52,  1, 9,  'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (53,  1, 9,  'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (54,  1, 9,  'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (55,  1, 10, 'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (56,  1, 10, 'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (57,  1, 10, 'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (58,  1, 10, 'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (59,  1, 10, 'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (60,  1, 10, 'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (61,  1, 11, 'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (62,  1, 11, 'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (63,  1, 11, 'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (64,  1, 11, 'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (65,  1, 11, 'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (66,  1, 11, 'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (67,  1, 12, 'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (68,  1, 12, 'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (69,  1, 12, 'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (70,  1, 12, 'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (71,  1, 12, 'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (72,  1, 12, 'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (73,  1, 13, 'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (74,  1, 13, 'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (75,  1, 13, 'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (76,  1, 13, 'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (77,  1, 13, 'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (78,  1, 13, 'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (79,  1, 14, 'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (80,  1, 14, 'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (81,  1, 14, 'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (82,  1, 14, 'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (83,  1, 14, 'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (84,  1, 14, 'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (85,  1, 15, 'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (86,  1, 15, 'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (87,  1, 15, 'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (88,  1, 15, 'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (89,  1, 15, 'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (90,  1, 15, 'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (91,  1, 16, 'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (92,  1, 16, 'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (93,  1, 16, 'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (94,  1, 16, 'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (95,  1, 16, 'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (96,  1, 16, 'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (97,  1, 17, 'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (98,  1, 17, 'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (99,  1, 17, 'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (100, 1, 17, 'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (101, 1, 17, 'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (102, 1, 17, 'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (103, 1, 18, 'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (104, 1, 18, 'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (105, 1, 18, 'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (106, 1, 18, 'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (107, 1, 18, 'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (108, 1, 18, 'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (109, 1, 19, 'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (110, 1, 19, 'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (111, 1, 19, 'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (112, 1, 19, 'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (113, 1, 19, 'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (114, 1, 19, 'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (115, 1, 20, 'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (116, 1, 20, 'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (117, 1, 20, 'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (118, 1, 20, 'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (119, 1, 20, 'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (120, 1, 20, 'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (121, 1, 21, 'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (122, 1, 21, 'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (123, 1, 21, 'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (124, 1, 21, 'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (125, 1, 21, 'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (126, 1, 21, 'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (127, 1, 22, 'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (128, 1, 22, 'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (129, 1, 22, 'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (130, 1, 22, 'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (131, 1, 22, 'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (132, 1, 22, 'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (133, 1, 24, 'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (134, 1, 24, 'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (135, 1, 24, 'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (136, 1, 24, 'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (137, 1, 24, 'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (138, 1, 24, 'SATURDAY',  '12:30:00', '13:10:00', false),

                                                                                                 (139, 1, 25, 'MONDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (140, 1, 25, 'TUESDAY',   '12:30:00', '13:10:00', false),
                                                                                                 (141, 1, 25, 'WEDNESDAY', '12:30:00', '13:10:00', false),
                                                                                                 (142, 1, 25, 'THURSDAY',  '12:30:00', '13:10:00', false),
                                                                                                 (143, 1, 25, 'FRIDAY',    '12:30:00', '13:10:00', false),
                                                                                                 (144, 1, 25, 'SATURDAY',  '12:30:00', '13:10:00', false);

-- =========================================================
-- USERS
-- =========================================================
INSERT INTO users (email, password, role) VALUES
                                              ('admin@university.kg', '$2a$08$a6r..ZYW.BK0UB0yJSwfc.30Alt2gSzmK/c0kkqLGqK7tIm9HVk/2', 'ADMIN'),
                                              ('scheduler@university.kg', '$2a$08$Iy5qn7TWG6LI.D2ATDvL5uPOftseKIhhWXUzyFHYnts1tFA1DNPNi', 'ADMIN');