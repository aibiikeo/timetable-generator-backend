-- =============================
-- 1. Faculties
-- =============================
INSERT INTO faculties (name, short_name) VALUES
                                             ('Information Technology', 'IT'),
                                             ('Economics and Management', 'EM'),
                                             ('Foreign Languages', 'FL');

-- =============================
-- 2. Rooms
-- =============================
INSERT INTO rooms (name, capacity, type) VALUES
                                             ('101', 35, 'CLASSROOM'),
                                             ('102', 30, 'CLASSROOM'),
                                             ('Lab-201', 25, 'COMPUTER_LAB'),
                                             ('Lab-202', 20, 'COMPUTER_LAB'),
                                             ('Auditorium 301', 80, 'CLASSROOM');

-- =============================
-- 3. Teachers
-- =============================
INSERT INTO teachers (full_name) VALUES
                                     ('Dr. Alexander Petrov'),
                                     ('Prof. Maria Ivanova'),
                                     ('John Smith'),
                                     ('Ainura Kadyrova'),
                                     ('Bektur Mamatov');

-- =============================
-- 4. Study Groups
-- =============================
INSERT INTO study_groups (name, faculty_id, course, student_count) VALUES
                                                                                 ('IT-221', 1, 2, 24),
                                                                                 ('IT-311', 1, 3, 22),
                                                                                 ('EM-201', 2, 2, 28),
                                                                                 ('FL-101', 3, 1, 20);

-- =============================
-- 5. Subjects
-- =============================
INSERT INTO subjects (name, code, total_hours, hours_per_week, faculty_id) VALUES
                                                                               ('Advanced Java Programming', 'JAVA401', 120, 4, 1),
                                                                               ('Database Design & SQL', 'DB305', 90, 3, 1),
                                                                               ('Web Development with Spring', 'WEB402', 120, 4, 1),
                                                                               ('Business English', 'ENG201', 144, 4, 3),
                                                                               ('Microeconomics', 'ECON101', 80, 3, 2);

-- =============================
-- 6. Timetable (main entity)
-- =============================
INSERT INTO timetables (name, created_at, is_current, is_published, status) VALUES
    ('Fall Semester 2025-2026', NOW(), true, false, 'DRAFT');

-- =============================
-- 7. Assignments (core scheduling unit)
-- =============================
INSERT INTO assignments (
    timetable_id, subject_id, teacher_id,
    hours_per_week, shift, room_type_required, hours_splitting
) VALUES
      (1, 1, 1, 4, 'ANY', 'COMPUTER_LAB', '2+2'),        -- Java → Petrov → Lab
      (1, 2, 2, 3, 'MORNING', 'CLASSROOM', '1+2'),       -- DB → Ivanova
      (1, 3, 5, 4, 'ANY', 'COMPUTER_LAB', '2+1+1'),      -- Web Dev → Bektur
      (1, 4, 3, 4, 'AFTERNOON', 'CLASSROOM', '2+2'),     -- English → John Smith
      (1, 5, 4, 3, 'MORNING', 'CLASSROOM', '3');         -- Microecon → Ainura

-- Link groups to assignments via assignment_groups table
INSERT INTO assignment_groups (assignment_id, group_id) VALUES
                                                            (1, 1), (1, 2),        -- Java for IT-221 and IT-311
                                                            (2, 1),                -- DB only for IT-221
                                                            (3, 2),                -- Web Dev only for IT-311
                                                            (4, 4),                -- English for FL-101
                                                            (5, 3);                -- Microecon for EM-201

-- =============================
-- 8. Generated Lessons (example after auto-generation)
-- =============================
INSERT INTO lessons (
    timetable_id, assignment_id, subject_id, teacher_id,
    room_id, day_of_week, start_time, duration_hours
) VALUES
      (1, 1, 1, 1, 3, 'MONDAY', '09:00:00', 2),
      (1, 1, 1, 1, 3, 'WEDNESDAY', '09:00:00', 2),
      (1, 2, 2, 2, 1, 'TUESDAY', '10:30:00', 2),
      (1, 2, 2, 2, 1, 'THURSDAY', '10:30:00', 1),
      (1, 3, 3, 5, 4, 'TUESDAY', '14:00:00', 2),
      (1, 3, 3, 5, 4, 'FRIDAY', '14:00:00', 2);

-- Link groups to lessons
INSERT INTO lesson_groups (lesson_id, group_id) VALUES
                                                    (1, 1), (1, 2),   -- Java lesson for both IT groups
                                                    (2, 1), (2, 2),
                                                    (3, 1),           -- DB only IT-221
                                                    (4, 1),
                                                    (5, 2),           -- Web Dev only IT-311
                                                    (6, 2);

-- =============================
-- 9. Users
-- =============================
INSERT INTO users (email, password, role) VALUES
                                              ('admin@university.kg', '$2a$08$a6r..ZYW.BK0UB0yJSwfc.30Alt2gSzmK/c0kkqLGqK7tIm9HVk/2', 'ADMIN'),
                                              ('scheduler@university.kg', '$2a$08$Iy5qn7TWG6LI.D2ATDvL5uPOftseKIhhWXUzyFHYnts1tFA1DNPNi', 'ADMIN');

-- =============================
-- 10. time slot
-- =============================
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
