-- RESET SEED DATA
-- This script is intended for reseeding the timetable database.
-- It clears previous seed data first, so duplicate keys from a failed/partial run do not break the next run.
DO $$
    DECLARE
        t text;
    BEGIN
        FOREACH t IN ARRAY ARRAY[
            'assignment_groups',
            'assignments',
            'subject_teachers',
            'subject_groups',
            'lessons',
            'lunch',
            'time_slot_exclusions',
            'timetables',
            'time_slots',
            'subjects',
            'teachers',
            'rooms',
            'study_groups',
            'majors',
            'departments',
            'faculties'
            ]
            LOOP
                IF to_regclass('public.' || t) IS NOT NULL THEN
                    EXECUTE format('TRUNCATE TABLE public.%I RESTART IDENTITY CASCADE', t);
                END IF;
            END LOOP;

        -- keep only superadmin@example.com in users
        IF to_regclass('public.users') IS NOT NULL THEN
            DELETE FROM public.users
            WHERE email <> 'superadmin@example.com';
        END IF;
    END $$;

-- FACULTIES
INSERT INTO faculties (name) VALUES
    ('Faculty of Engineering and Informatics');

-- DEPARTMENTS
INSERT INTO departments (name, faculty_id) VALUES
    ('Department of Computer Science', (SELECT id FROM faculties WHERE name = 'Faculty of Engineering and Informatics' LIMIT 1)),
    ('Department of Applied Mathematics and Informatics', (SELECT id FROM faculties WHERE name = 'Faculty of Engineering and Informatics' LIMIT 1));

-- MAJORS
INSERT INTO majors (name, short_name, degree, department_id) VALUES
    ('COM', 'COM', 'BACHELOR', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1)),
    ('COMCEH', 'COMCEH', 'BACHELOR', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1)),
    ('COMFCI', 'COMFCI', 'BACHELOR', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1)),
    ('COMSE', 'COMSE', 'BACHELOR', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1)),
    ('EEAIR', 'EEAIR', 'BACHELOR', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1)),
    ('IEMIT', 'IEMIT', 'BACHELOR', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1)),
    ('MATDAIS', 'MATDAIS', 'BACHELOR', (SELECT id FROM departments WHERE name = 'Department of Applied Mathematics and Informatics' LIMIT 1)),
    ('MATH', 'MATH', 'BACHELOR', (SELECT id FROM departments WHERE name = 'Department of Applied Mathematics and Informatics' LIMIT 1)),
    ('MATMIE', 'MATMIE', 'BACHELOR', (SELECT id FROM departments WHERE name = 'Department of Applied Mathematics and Informatics' LIMIT 1)),
    ('MCOM', 'MCOM', 'MASTER', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1)),
    ('PHD', 'PHD', 'PHD', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1));

-- STUDY GROUPS
INSERT INTO study_groups (name, major_id, course, student_count) VALUES
    ('COM-22', (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1), 4, 29),
    ('COMCEH-23', (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1), 3, 25),
    ('COMCEH-24', (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1), 2, 30),
    ('COMCEH-25', (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1), 1, 24),
    ('COMFCI-23', (SELECT id FROM majors WHERE short_name = 'COMFCI' LIMIT 1), 3, 20),
    ('COMFCI-24', (SELECT id FROM majors WHERE short_name = 'COMFCI' LIMIT 1), 2, 38),
    ('COMFCI-25', (SELECT id FROM majors WHERE short_name = 'COMFCI' LIMIT 1), 1, 31),
    ('COMSE-23', (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1), 3, 35),
    ('COMSE-24', (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1), 2, 30),
    ('COMSE-25', (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1), 1, 31),
    ('EEAIR-23', (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1), 3, 20),
    ('EEAIR-24', (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1), 2, 32),
    ('EEAIR-25', (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1), 1, 35),
    ('IEMIT-23', (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1), 3, 39),
    ('IEMIT-24', (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1), 2, 20),
    ('IEMIT-25', (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1), 1, 24),
    ('MATDAIS-23', (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1), 3, 40),
    ('MATDAIS-24', (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1), 2, 35),
    ('MATDAIS-25', (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1), 1, 39),
    ('MATH-22', (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1), 4, 32),
    ('MATMIE-23', (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1), 3, 26),
    ('MATMIE-24', (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1), 2, 26),
    ('MATMIE-25', (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1), 1, 22),
    ('MCOM-1', (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1), 1, 23),
    ('MCOM-2', (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1), 1, 20),
    ('MCOM-24', (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1), 1, 32),
    ('MCOM-25', (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1), 1, 37),
    ('PHD-23', (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1), 1, 35),
    ('PHD-24', (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1), 1, 25),
    ('PHD-25', (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1), 1, 36);

-- TEACHERS
INSERT INTO teachers (full_name) VALUES
    ('Alimpieva L.'),
    ('Alymbekova S.'),
    ('Chokusheva G.'),
    ('Dr. Ainuru Zholchieva'),
    ('Dr. Andrei Ermakov'),
    ('Dr. Arslan Khan'),
    ('Dr. Burul Shambetova'),
    ('Dr. Daniiar Satybaldiev'),
    ('Dr. Kunduz Zhusupbekova'),
    ('Dr. Meerim Mairykova'),
    ('Dr. Meezan Chand'),
    ('Dr. Musa Abdujabbarov'),
    ('Dr. Nurgul Erdolatova'),
    ('Dr. Remudin Mecuria'),
    ('Dr. Ruslan Isaev'),
    ('Dr. Sherali Matanov'),
    ('Dr. Tauheed Khan'), 	
    ('Mr. Ahmad Sarosh'),
    ('Mr. Alimzhan Zakirov'),
    ('Mr. Chynybekov Z.'),
    ('Mr. Emilbek'),
    ('Mr. Ermek Doszhanov'),
    ('Mr. Erustan Erkebulanov'),
    ('Mr. Haksrun Lao'),
    ('Mr. Hussein Chebsi'),
    ('Mr. Imtiyaz Gulbarga'),
    ('Mr. Murray Eldred'),
    ('Mr. Mutalip'),
    ('Mr. Nich Kawaguchi'),
    ('Mr. Niyazkhan Shabdanalov'),	
    ('Mr. Radmir Gumerov'),
    ('Mr. Ruslan Amanov'),
    ('Mr. Samat Elikbaev'),
    ('Mr. Suleyman Saparov'),
    ('Mr. Talgat Mendekov'),
    ('Ms. Abdykadyrova N.'),
    ('Ms. Aidai Atakulova'),
    ('Ms. Aigul'),
    ('Ms. Azhar Kazakbaeva'),
    ('Ms. Bopushova Asina'),
    ('Ms. Cholpon Alieva'),
    ('Ms. Duisheeva T.'),
    ('Ms. Elnura'),
    ('Ms. Erika'),
    ('Ms. Gulnarida Zhalilova'),
    ('Ms. Iskra'),
    ('Ms. Kanykei Azhikulova'),
    ('Ms. Liliya Abdieva'),
    ('Ms. Meerim Chukaeva'),
    ('Ms. Mekia Gaso'),
    ('Ms. Nargiza Zhumalieva'),
    ('Ms. Nurbek Tenirberdiev'),
    ('Ms. Orozalieva D.'),
    ('Ms. Roza'),
    ('Ms. Saidalieva A.'),
    ('Ms. Samatova G.'),
    ('Ms. Sumaiya'),
    ('Ms. Tattybubu Arap kyzy'),
    ('Ms. Tokusheva T.'),
    ('Ms. Zhamby Dzhusubalieva'),
    ('Ms. Zhazgul Alymbaeva'),
    ('Ms. Zhibek Namatova'),
    ('Tsoi A.');

-- ROOMS
INSERT INTO rooms (name, capacity, type) VALUES
    ('B101', 30, 'CLASSROOM'),
    ('B102', 30, 'CLASSROOM'),
    ('B103', 30, 'CLASSROOM'),
    ('B104', 30, 'CLASSROOM'),
    ('B105', 30, 'CLASSROOM'),
    ('B106', 30, 'CLASSROOM'),
    ('B107', 30, 'CLASSROOM'),
    ('B109', 30, 'COMPUTER_LAB'),
    ('B110', 30, 'COMPUTER_LAB'),
    ('B111', 30, 'CLASSROOM'),
    ('B112', 30, 'CLASSROOM'),
    ('B113', 30, 'CLASSROOM'),
    ('B201', 30, 'CLASSROOM'),
    ('B202', 30, 'CLASSROOM'),
    ('B203', 30, 'CLASSROOM'),
    ('B204', 30, 'CLASSROOM'),
    ('B205', 30, 'CLASSROOM'),
    ('C005', 30, 'CLASSROOM'),
    ('BIGLAB', 30, 'COMPUTER_LAB'),
    ('LAB3(B210)', 30, 'COMPUTER_LAB'),
    ('LAB4(B211)', 30, 'COMPUTER_LAB'),
    ('LAB5(B213)', 30, 'COMPUTER_LAB');

-- SUBJECTS
INSERT INTO subjects (name, code, total_hours, hours_per_week, major_id) VALUES
    ('Advanced Algorithms', 'SRC-25001', 3, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Advanced Image Processing', 'SRC-25002', 3, 3, (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1)),
    ('Algebra Geometry', 'SRC-25003', 6, 6, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Applied statistics I', 'SRC-25004', 2, 2, (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1)),
    ('Applied statistics II', 'SRC-25005', 4, 4, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Art of teaching methods in informatics', 'SRC-25006', 6, 6, (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1)),
    ('Artificial Intelligence Deep Learning', 'SRC-25007', 3, 3, (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1)),
    ('Attacts defences', 'SRC-25008', 8, 8, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Back-end', 'SRC-25009', 6, 6, (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1)),
    ('Basics of science research', 'SRC-25010', 12, 12, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Business Fundamentals Process Management', 'SRC-25011', 6, 6, (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1)),
    ('C# (Advanced C#)', 'SRC-25012', 12, 12, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Calculus III', 'SRC-25015', 6, 6, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Calculus I', 'SRC-25016', 8, 8, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Calculus II', 'SRC-25017', 6, 6, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Cloud computing', 'SRC-25018', 12, 12, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Computer Architecture Operation systems', 'SRC-25019', 12, 12, (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1)),
    ('Computational Mathematics', 'SRC-25021', 2, 2, (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1)),
    ('Computer Vision Algorithms', 'SRC-25024', 3, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Cybersecurity Foundation', 'SRC-25025', 6, 6, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Design visualization', 'SRC-25027', 4, 4, (SELECT id FROM majors WHERE short_name = 'COMFCI' LIMIT 1)),
    ('Data analysis visualization', 'SRC-25028', 6, 6, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Data engineering', 'SRC-25029', 3, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Data science specialty mathematics', 'SRC-25030', 8, 8, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Data Science storage', 'SRC-25031', 12, 12, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Data Visualization Analysis Tools', 'SRC-25032', 3, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Databases', 'SRC-25033', 8, 8, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Deep Learning', 'SRC-25034', 4, 4, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Design & Analysis of Algorithms', 'SRC-25035', 12, 12, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Design Thinking product solutions', 'SRC-25036', 6, 6, (SELECT id FROM majors WHERE short_name = 'COMFCI' LIMIT 1)),
    ('Digital Design', 'SRC-25037', 2, 2, (SELECT id FROM majors WHERE short_name = 'COMFCI' LIMIT 1)),
    ('Digital Electronics', 'SRC-25038', 6, 6, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Digital Marketing Technologies', 'SRC-25039', 4, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Discrete Mathematics', 'SRC-25041', 6, 6, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('DocuIT: Mastering', 'SRC-25042', 4, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Educational Technology Learning Systems', 'SRC-25043', 6, 6, (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1)),
    ('Electronic components circuits', 'SRC-25044', 4, 4, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Engineering Computer Graphics', 'SRC-25045', 12, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('English', 'SRC-25046', 12, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Ethical Hacking Penetration Testing', 'SRC-25047', 6, 6, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Financial Math', 'SRC-25048', 4, 4, (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1)),
    ('Foundation Maths Data Science', 'SRC-25049', 3, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('French', 'SRC-25050', 12, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Frontend', 'SRC-25051', 6, 6, (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1)),
    ('Functional analysis', 'SRC-25052', 7, 7, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Fundamentals of Scientific Research', 'SRC-25053', 3, 3, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Geography of Kyrgyzstan', 'SRC-25055', 2, 2, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('German', 'SRC-25056', 8, 8, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('History of Kyrgyzstan', 'SRC-25057', 4, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Human Computer Interaction', 'SRC-25058', 4, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Image Processing Computer Vision', 'SRC-25059', 3, 3, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Intelligent data analysis', 'SRC-25060', 7, 7, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Interpersonal Communication in IT', 'SRC-25061', 4, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Introduction to Cloud computing', 'SRC-25062', 6, 6, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Introduction to Data Analysis', 'SRC-25063', 3, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Introduction to Engineering', 'SRC-25064', 2, 2, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Korean', 'SRC-25067', 12, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Kyrgyz', 'SRC-25069', 12, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Kyrgyz language foreign students', 'SRC-25070', 4, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Kyrgyz Language Literature II', 'SRC-25072', 12, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Machine Learning', 'SRC-25073', 5, 5, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Management', 'SRC-25075', 6, 6, (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1)),
    ('Manas Studies', 'SRC-25076', 2, 2, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Mastering', 'SRC-25078', 4, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Mathematical tools signal calculation', 'SRC-25079', 4, 4, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Maths Data Science', 'SRC-25080', 3, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Methodology of teaching mathematics', 'SRC-25081', 4, 4, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Methods of Optimizations', 'SRC-25082', 9, 9, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Mobile App Development', 'SRC-25083', 12, 12, (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1)),
    ('NLP', 'SRC-25084', 3, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Number Theory', 'SRC-25085', 7, 7, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Object Oriented Programming', 'SRC-25086', 10, 10, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Optimization Methods', 'SRC-25091', 4, 4, (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1)),
    ('Pedagogy', 'SRC-25092', 3, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Psychology of Higher Education', 'SRC-25097', 3, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Philosophy', 'SRC-25093', 6, 6, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Philosophy of Technology', 'SRC-25094', 4, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Physical Education', 'SRC-25095', 12, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Probability Statistics', 'SRC-25096', 10, 10, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Programming Interface of the Microcontroller', 'SRC-25098', 4, 4, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Programming Language (Java)', 'SRC-25100', 6, 6, (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1)),
    ('Programming Language II', 'SRC-25102', 6, 6, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Programming Language I', 'SRC-25103', 6, 6, (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1)),
    ('Programming Python', 'SRC-25104', 4, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Project Product Management', 'SRC-25105', 6, 6, (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1)),
    ('Public Speaking Skills', 'SRC-25106', 4, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Research in Applied Data Science', 'SRC-25108', 9, 9, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Research Methods', 'SRC-25109', 3, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Engineering Economy', 'SRC-25110', 6, 6, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Robotics Foundation', 'SRC-25111', 4, 4, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Russian language', 'SRC-25112', 4, 4, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Scientific Industrial Practice', 'SRC-25120', 3, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Scientific Seminar', 'SRC-25121', 6, 6, (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1)),
    ('Software Engineering', 'SRC-25122', 12, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Startup: from idea to launch', 'SRC-25123', 4, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Teaching Practice', 'SRC-25125', 3, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Turkish', 'SRC-25126', 12, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Variable Part (Applied statistics)', 'SRC-25127', 4, 4, (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1)),
    ('VR Design', 'SRC-25128', 4, 4, (SELECT id FROM majors WHERE short_name = 'COMFCI' LIMIT 1));

-- EXTRA SUBJECTS FROM CORRECTED SKIPPED ROWS
-- Values inferred from corrected schedule rows: total_hours/hours_per_week = max weekly assignment hours found for that subject.
INSERT INTO subjects (name, code, total_hours, hours_per_week, major_id) VALUES
    ('Advisor hour', 'SRC-25129', 2, 2, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Computer Literacy', 'SRC-25130', 1, 1, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Pedagogical research internship', 'SRC-25131', 3, 3, (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1)),
    ('Pre qualification internship', 'SRC-25132', 1, 1, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Pre qualification practice', 'SRC-25133', 5, 5, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Pre qualificational Internship', 'SRC-25134', 1, 1, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Scientific research internship', 'SRC-25135', 3, 3, (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1)),
    ('Supervisor Review', 'SRC-25136', 1, 1, (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1));

-- SUBJECT <-> TEACHER
INSERT INTO subject_teachers (subject_id, teacher_id) VALUES
    ((SELECT id FROM subjects WHERE name = 'Advanced Image Processing' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Artificial Intelligence Deep Learning' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Musa Abdujabbarov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Attacts defences' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Back-end' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Basics of science research' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Ermek Doszhanov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'C# (Advanced C#)' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'C# (Advanced C#)' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Hussein Chebsi' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Cloud computing' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Ahmad Sarosh' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Arslan Khan' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Suleyman Saparov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Vision Algorithms' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Data Science storage' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Data Science storage' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Mekia Gaso' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Data science specialty mathematics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Gulnarida Zhalilova' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Deep Learning' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Musa Abdujabbarov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Deep Learning' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Design & Analysis of Algorithms' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Design Thinking product solutions' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Digital Design' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Digital Electronics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Liliya Abdieva' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Educational Technology Learning Systems' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Gulnarida Zhalilova' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Electronic components circuits' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'English' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'English' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'English' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'English' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Ethical Hacking Penetration Testing' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'French' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'French' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Frontend' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Niyazkhan Shabdanalov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Functional analysis' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Fundamentals of Scientific Research' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Emilbek' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Nurbek Tenirberdiev' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'German' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Nurgul Erdolatova' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Alimzhan Zakirov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Image Processing Computer Vision' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Intelligent data analysis' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Remudin Mecuria' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Nich Kawaguchi' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Aigul' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Sumaiya' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Machine Learning' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Kunduz Zhusupbekova' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Meerim Mairykova' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Roza' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Methodology of teaching mathematics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Mobile App Development' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Mutalip' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'NLP' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Musa Abdujabbarov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Number Theory' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Daniiar Satybaldiev' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Hussein Chebsi' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Optimization Methods' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Cholpon Alieva' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Bopushova Asina' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Meezan Chand' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Ahmad Sarosh' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Interface of the Microcontroller' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language (Java)' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Bopushova Asina' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Ermek Doszhanov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Bopushova Asina' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Zhazgul Alymbaeva' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Project Product Management' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Aidai Atakulova' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Psychology of Higher Education' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Ainuru Zholchieva' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Ainuru Zholchieva' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Research in Applied Data Science' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Research in Applied Data Science' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Mekia Gaso' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Robotics Foundation' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Alimpieva L.' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Chokusheva G.' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Tsoi A.' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Scientific Seminar' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Ruslan Isaev' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Niyazkhan Shabdanalov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Mekia Gaso' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Teaching Practice' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Aigul' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Elnura' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Variable Part (Applied statistics)' LIMIT 1), (SELECT id FROM teachers WHERE full_name = 'Mr. Ahmad Sarosh' LIMIT 1));
-- SUBJECT <-> GROUP
INSERT INTO subject_groups (subject_id, group_id) VALUES
    ((SELECT id FROM subjects WHERE name = 'Advanced Algorithms' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MCOM-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advanced Image Processing' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Applied statistics I' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Applied statistics II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Applied statistics II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Art of teaching methods in informatics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Artificial Intelligence Deep Learning' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Attacts defences' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Back-end' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Basics of science research' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Business Fundamentals Process Management' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'C# (Advanced C#)' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus III' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Calculus III' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Cloud computing' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computational Mathematics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computational Mathematics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computational Mathematics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Computer Vision Algorithms' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MCOM-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Data Science storage' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Data Visualization Analysis Tools' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MCOM-2' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Data analysis visualization' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Data engineering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MCOM-2' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Data engineering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MCOM-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Data science specialty mathematics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Deep Learning' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Deep Learning' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MCOM-1' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Design & Analysis of Algorithms' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Design & Analysis of Algorithms' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Design Thinking product solutions' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Design visualization' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Digital Design' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Digital Electronics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'DocuIT: Mastering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'DocuIT: Mastering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'DocuIT: Mastering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'DocuIT: Mastering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'DocuIT: Mastering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Educational Technology Learning Systems' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Electronic components circuits' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'English' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'English' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'English' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'English' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'English' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'English' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'English' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Ethical Hacking Penetration Testing' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Financial Math' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Foundation Maths Data Science' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MCOM-1' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'French' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'French' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'French' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'French' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'French' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'French' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'French' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Frontend' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Functional analysis' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Fundamentals of Scientific Research' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'German' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'German' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'German' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'German' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'German' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'German' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'German' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Image Processing Computer Vision' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Intelligent data analysis' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Introduction to Cloud computing' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Introduction to Data Analysis' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MCOM-1' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Machine Learning' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Machine Learning' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Machine Learning' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Machine Learning' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MCOM-1' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Management' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Management' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Mathematical tools signal calculation' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Maths Data Science' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MCOM-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Methodology of teaching mathematics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Methods of Optimizations' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Methods of Optimizations' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Mobile App Development' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'NLP' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MCOM-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'NLP' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Number Theory' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Optimization Methods' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Pedagogical research internship' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'PHD-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Pre qualification internship' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Pre qualification practice' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Pre qualificational Internship' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Interface of the Microcontroller' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language (Java)' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Project Product Management' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Project Product Management' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Psychology of Higher Education' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MCOM-1' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Research Methods' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MCOM-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Research Methods' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Research in Applied Data Science' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Robotics Foundation' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MCOM-2' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Scientific Seminar' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Scientific research internship' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'PHD-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Supervisor Review' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'PHD-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Supervisor Review' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'PHD-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Supervisor Review' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Teaching Practice' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MCOM-2' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'VR Design' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Variable Part (Applied statistics)' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)),
    ((SELECT id FROM subjects WHERE name = 'Variable Part (Applied statistics)' LIMIT 1), (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1));
-- TIMETABLES
INSERT INTO timetables (name, academic_year_start, academic_year_end, semester, version, created_at, status, generation_settings, conflict_report) VALUES
    ('Course Schedule FALL 2025-2026 v0', 2025, 2026, 'FALL', 0, NOW(), 'DRAFT', NULL, NULL),
    ('Course Schedule SPRING 2025-2026 v0', 2025, 2026, 'SPRING', 0, NOW(), 'DRAFT', NULL, NULL);

-- TIME SLOTS
INSERT INTO time_slots (day_of_week, slot_order, start_time, end_time, description) VALUES
    (NULL, 1,  '08:00:00', '08:40:00', 'Lesson 1'),
    (NULL, 2,  '08:45:00', '09:25:00', 'Lesson 2'),
    (NULL, 3,  '09:30:00', '10:10:00', 'Lesson 3'),
    (NULL, 4,  '10:15:00', '10:55:00', 'Lesson 4'),
    (NULL, 5,  '11:00:00', '11:40:00', 'Lesson 5'),
    (NULL, 6,  '11:45:00', '12:25:00', 'Lesson 6'),
    (NULL, 7,  '12:30:00', '13:10:00', 'Lesson 7'),
    (NULL, 8,  '13:10:00', '13:55:00', 'Lesson 8'),
    (NULL, 9,  '14:00:00', '14:40:00', 'Lesson 9'),
    (NULL, 10, '14:45:00', '15:25:00', 'Lesson 10'),
    (NULL, 11, '15:30:00', '16:10:00', 'Lesson 11'),
    (NULL, 12, '16:15:00', '16:55:00', 'Lesson 12'),
    (NULL, 13, '17:00:00', '17:40:00', 'Lesson 13'),
    (NULL, 14, '17:45:00', '18:25:00', 'Lesson 14');

-- USERS
INSERT INTO users (email, password, role) VALUES
    ('admin@university.kg', '$2a$08$a6r..ZYW.BK0UB0yJSwfc.30Alt2gSzmK/c0kkqLGqK7tIm9HVk/2', 'ADMIN'),
    ('scheduler@university.kg', '$2a$08$Iy5qn7TWG6LI.D2ATDvL5uPOftseKIhhWXUzyFHYnts1tFA1DNPNi', 'ADMIN');

-- ASSIGNMENTS + ASSIGNMENT <-> GROUP
-- assignment 1: FALL / COM-22 / Advisor hour / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 2: FALL / COM-22 / Basics of science research / teacher=Mr. Ermek Doszhanov / room=NULL / source=base_audit:4
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Basics of science research' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ermek Doszhanov' LIMIT 1),
        8, 'ANY', 'CLASSROOM', '8', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 3: FALL / COM-22 / Basics of science research / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Mr. Ermek Doszhanov (group 1), Mr. Ermek Doszhanov (group 2)
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Basics of science research' LIMIT 1),
        NULL,
        8, 'ANY', 'CLASSROOM', '8', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 4: FALL / COM-22 / Data Science storage / teacher=Dr. Tauheed Khan / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data Science storage' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 5: FALL / COM-22 / Data Science storage / teacher=Ms. Mekia Gaso / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data Science storage' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Mekia Gaso' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 6: FALL / COM-22 / Data Science storage / teacher=NULL / room=NULL / source=base_audit:3
-- original teacher text not in edited base: Dr. Mekia Gaso, Dr..Mekia Gaso
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data Science storage' LIMIT 1),
        NULL,
        10, 'ANY', 'CLASSROOM', '10', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 7: FALL / COM-22 / Machine Learning / teacher=Dr. Tauheed Khan / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Machine Learning' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 8: FALL / COM-22 / Pre qualification internship / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Pre qualification internship' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 9: FALL / COM-22 / Pre qualificational Internship / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Pre qualificational Internship' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 10: FALL / COMCEH-23 / Attacts defences / teacher=Mr. Imtiyaz Gulbarga / room=B109 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Attacts defences' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)
FROM new_assignment;

-- assignment 11: FALL / COMCEH-23 / Attacts defences / teacher=Mr. Imtiyaz Gulbarga / room=NULL / source=base_audit:2+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Attacts defences' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        9, 'ANY', 'CLASSROOM', '9', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)
FROM new_assignment;

-- assignment 12: FALL / COMCEH-23 / Computer Architecture Operation systems / teacher=Mr. Suleyman Saparov / room=B111 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Suleyman Saparov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)
FROM new_assignment;

-- assignment 13: FALL / COMCEH-23 / Computer Architecture Operation systems / teacher=Mr. Talgat Mendekov / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)
FROM new_assignment;

-- assignment 14: FALL / COMCEH-23 / Probability Statistics / teacher=NULL / room=B201 / source=base_audit:1
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)
FROM new_assignment;

-- assignment 15: FALL / COMCEH-23 / Software Engineering / teacher=NULL / room=LAB4(B211) / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        NULL,
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)
FROM new_assignment;

-- assignment 16: FALL / COMCEH-23 / Software Engineering / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. Nargiza
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)
FROM new_assignment;

-- assignment 17: FALL / COMCEH-24 / Computational Mathematics / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computational Mathematics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 18: FALL / COMCEH-24 / Computational Mathematics / teacher=NULL / room=B204 / source=base_audit:1
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computational Mathematics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 19: FALL / COMCEH-24 / Cybersecurity Foundation / teacher=Mr. Ruslan Amanov / room=LAB4(B211) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 20: FALL / COMCEH-24 / Cybersecurity Foundation / teacher=Mr. Ruslan Amanov / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 21: FALL / COMCEH-24 / Databases / teacher=Ms. Nargiza Zhumalieva / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 22: FALL / COMCEH-24 / Databases / teacher=Ms. Nargiza Zhumalieva / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 23: FALL / COMCEH-24 / Human Computer Interaction / teacher=Dr. Burul Shambetova / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 24: FALL / COMCEH-24 / Human Computer Interaction / teacher=NULL / room=C005 / source=base_audit:1
-- original teacher text not in edited base: Dr. Burul Shambetova Block
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'C005' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 25: FALL / COMCEH-24 / Interpersonal Communication in IT / teacher=Mr. Murray Eldred / room=B101 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 26: FALL / COMCEH-24 / Kyrgyz / teacher=Ms. Duisheeva T. / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 27: FALL / COMCEH-24 / Kyrgyz / teacher=Ms. Orozalieva D. / room=B102 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 28: FALL / COMCEH-24 / Kyrgyz / teacher=Ms. Saidalieva A. / room=B101 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 29: FALL / COMCEH-24 / Kyrgyz / teacher=Ms. Tokusheva T. / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 30: FALL / COMCEH-24 / Kyrgyz language foreign students / teacher=NULL / room=B103 / source=base_audit:1
-- original teacher text not in edited base: Ms. Saidalieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 31: FALL / COMCEH-24 / Mastering / teacher=NULL / room=BIGLAB / source=base_audit:1
-- original teacher text not in edited base: Prof. essional writing in IT-Mr.Murray Eldred
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1),
        NULL,
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 32: FALL / COMCEH-24 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 33: FALL / COMCEH-24 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 34: FALL / COMCEH-24 / Public Speaking Skills / teacher=NULL / room=B107 / source=base_audit:2
-- original teacher text not in edited base: Ms. Ainuuru Zhoolchieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 35: FALL / COMCEH-24 / Startup: from idea to launch / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Mr. Radmir Gumerov (Group 2)
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 36: FALL / COMCEH-25 / Advisor hour / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 37: FALL / COMCEH-25 / Algebra Geometry / teacher=Mr. Samat Elikbaev / room=B102 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 38: FALL / COMCEH-25 / Algebra Geometry / teacher=NULL / room=B102 / source=base_audit:1
-- original teacher text not in edited base: Mr. Samat.Elikbaev
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 39: FALL / COMCEH-25 / Algebra Geometry / teacher=NULL / room=B204 / source=base_audit:1
-- original teacher text not in edited base: Mr. Samat.Elikbaev
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 40: FALL / COMCEH-25 / Calculus I / teacher=NULL / room=B105 / source=base_audit:1
-- original teacher text not in edited base: Mr. Hussien Chebsi
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 41: FALL / COMCEH-25 / Calculus I / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Mr. Hussien Chebsi https
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 42: FALL / COMCEH-25 / English / teacher=NULL / room=B101 / source=base_audit:2
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 43: FALL / COMCEH-25 / French / teacher=Ms. Iskra / room=B101 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 44: FALL / COMCEH-25 / French / teacher=Ms. Iskra / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 45: FALL / COMCEH-25 / French / teacher=Ms. Iskra / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 46: FALL / COMCEH-25 / German / teacher=Ms. Erika / room=B204 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 47: FALL / COMCEH-25 / Introduction to Engineering / teacher=Mr. Ruslan Amanov / room=LAB4(B211) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 48: FALL / COMCEH-25 / Introduction to Engineering / teacher=Mr. Ruslan Amanov / room=NULL / source=base_audit:2+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 49: FALL / COMCEH-25 / Korean / teacher=Ms. Sumaiya / room=B201 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Sumaiya' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 50: FALL / COMCEH-25 / Korean / teacher=NULL / room=B102 / source=base_audit:1
-- original teacher text not in edited base: Ms. Ajar
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 51: FALL / COMCEH-25 / Korean / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. ___
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 52: FALL / COMCEH-25 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 53: FALL / COMCEH-25 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 54: FALL / COMCEH-25 / Programming Language I / teacher=NULL / room=BIGLAB / source=base_audit:1
-- original teacher text not in edited base: Ms. Imtiyaz Gulbarga
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        NULL,
        3, 'ANY', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 55: FALL / COMCEH-25 / Russian language / teacher=Alimpieva L. / room=B103 / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alimpieva L.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 56: FALL / COMCEH-25 / Russian language / teacher=Alymbekova S. / room=B101 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 57: FALL / COMCEH-25 / Russian language / teacher=Alymbekova S. / room=B104 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 58: FALL / COMCEH-25 / Russian language / teacher=Alymbekova S. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 59: FALL / COMCEH-25 / Russian language / teacher=Chokusheva G. / room=B102 / source=base_audit:1+corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Chokusheva G.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 60: FALL / COMCEH-25 / Russian language / teacher=Chokusheva G. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Chokusheva G.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 61: FALL / COMCEH-25 / Russian language / teacher=NULL / room=B105 / source=corrected_skipped:1
-- original teacher text not in edited base: Djolbulakova.Ch.A
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 62: FALL / COMCEH-25 / Russian language / teacher=NULL / room=B201 / source=corrected_skipped:1
-- original teacher text not in edited base: Djolbulakova.Ch.A
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 63: FALL / COMCEH-25 / Russian language / teacher=Tsoi A. / room=B104 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Tsoi A.' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 64: FALL / COMCEH-25 / Russian language / teacher=Tsoi A. / room=B107 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Tsoi A.' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 65: FALL / COMCEH-25 / Turkish / teacher=NULL / room=B202 / source=base_audit:2
-- original teacher text not in edited base: Ms. Elnura.U
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 66: FALL / COMFCI-23 / Advisor hour / teacher=NULL / room=B201 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

-- assignment 67: FALL / COMFCI-23 / Computer Architecture Operation systems / teacher=Mr. Erustan Erkebulanov / room=B110 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

-- assignment 68: FALL / COMFCI-23 / Design visualization / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Mr. _______
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design visualization' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

-- assignment 69: FALL / COMFCI-23 / Probability Statistics / teacher=Dr. Sherali Matanov / room=B203 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

-- assignment 70: FALL / COMFCI-23 / Probability Statistics / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. Liliya
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

-- assignment 71: FALL / COMFCI-23 / Software Engineering / teacher=Ms. Azhar Kazakbaeva / room=B110 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

-- assignment 72: FALL / COMFCI-23 / Software Engineering / teacher=Ms. Azhar Kazakbaeva / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

-- assignment 73: FALL / COMFCI-23 / Software Engineering / teacher=Ms. Azhar Kazakbaeva / room=NULL / source=base_audit:3
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

-- assignment 74: FALL / COMFCI-24 / Computational Mathematics / teacher=NULL / room=B103 / source=base_audit:1
-- original teacher text not in edited base: Dr. Ahmad Sarosh
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computational Mathematics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 75: FALL / COMFCI-24 / Computational Mathematics / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Mr. Meezan Chand, Mr. Ahmad Sarosh 101
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computational Mathematics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 76: FALL / COMFCI-24 / Databases / teacher=Ms. Nargiza Zhumalieva / room=B109 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 77: FALL / COMFCI-24 / Databases / teacher=Ms. Nargiza Zhumalieva / room=B113 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 78: FALL / COMFCI-24 / Databases / teacher=Ms. Nargiza Zhumalieva / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 79: FALL / COMFCI-24 / Digital Design / teacher=Dr. Andrei Ermakov / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Design' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 80: FALL / COMFCI-24 / Human Computer Interaction / teacher=Dr. Burul Shambetova / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 81: FALL / COMFCI-24 / Human Computer Interaction / teacher=NULL / room=C005 / source=base_audit:1
-- original teacher text not in edited base: Dr. Burul Shambetova Block
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'C005' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 82: FALL / COMFCI-24 / Interpersonal Communication in IT / teacher=Mr. Murray Eldred / room=B101 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 83: FALL / COMFCI-24 / Kyrgyz / teacher=Ms. Duisheeva T. / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 84: FALL / COMFCI-24 / Kyrgyz / teacher=Ms. Orozalieva D. / room=B102 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 85: FALL / COMFCI-24 / Kyrgyz / teacher=Ms. Saidalieva A. / room=B101 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 86: FALL / COMFCI-24 / Kyrgyz / teacher=Ms. Tokusheva T. / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 87: FALL / COMFCI-24 / Kyrgyz language foreign students / teacher=NULL / room=B103 / source=base_audit:1
-- original teacher text not in edited base: Ms. Saidalieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 88: FALL / COMFCI-24 / Mastering / teacher=NULL / room=BIGLAB / source=base_audit:1
-- original teacher text not in edited base: Prof. essional writing in IT-Mr.Murray Eldred
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1),
        NULL,
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 89: FALL / COMFCI-24 / Object Oriented Programming / teacher=Dr. Daniiar Satybaldiev / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Daniiar Satybaldiev' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 90: FALL / COMFCI-24 / Object Oriented Programming / teacher=NULL / room=B110 / source=base_audit:1
-- original teacher text not in edited base: Dr. Daniyar Satybaldiev
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        NULL,
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 91: FALL / COMFCI-24 / Object Oriented Programming / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Dr. Daniyar Satybaldiev, Mr. Haksrun Lao (Cambodia)
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        NULL,
        5, 'ANY', 'CLASSROOM', '5', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 92: FALL / COMFCI-24 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 93: FALL / COMFCI-24 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 94: FALL / COMFCI-24 / Public Speaking Skills / teacher=NULL / room=B107 / source=base_audit:2
-- original teacher text not in edited base: Ms. Ainuuru Zhoolchieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 95: FALL / COMFCI-24 / Startup: from idea to launch / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Mr. Radmir Gumerov (Group 2)
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 96: FALL / COMFCI-25 / Algebra Geometry / teacher=Mr. Samat Elikbaev / room=B102 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 97: FALL / COMFCI-25 / Algebra Geometry / teacher=NULL / room=B102 / source=base_audit:1
-- original teacher text not in edited base: Mr. Samat.Elikbaev
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 98: FALL / COMFCI-25 / Algebra Geometry / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Mr. Samat.Elikbaev В102
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 99: FALL / COMFCI-25 / Calculus I / teacher=NULL / room=B104 / source=base_audit:1
-- original teacher text not in edited base: Mr. Hussien Chebsi
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 100: FALL / COMFCI-25 / Calculus I / teacher=NULL / room=B205 / source=base_audit:1
-- original teacher text not in edited base: Mr. Hussien Chebsi
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 101: FALL / COMFCI-25 / Calculus I / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Mr. Hussien Chebsi
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 102: FALL / COMFCI-25 / English / teacher=NULL / room=B101 / source=base_audit:2
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 103: FALL / COMFCI-25 / French / teacher=Ms. Iskra / room=B101 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 104: FALL / COMFCI-25 / French / teacher=Ms. Iskra / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 105: FALL / COMFCI-25 / French / teacher=Ms. Iskra / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 106: FALL / COMFCI-25 / German / teacher=Ms. Erika / room=B204 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 107: FALL / COMFCI-25 / Introduction to Engineering / teacher=Mr. Imtiyaz Gulbarga / room=B202 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 108: FALL / COMFCI-25 / Introduction to Engineering / teacher=Mr. Imtiyaz Gulbarga / room=NULL / source=base_audit:1
-- original room text not in edited base: LAB109
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 109: FALL / COMFCI-25 / Korean / teacher=Ms. Sumaiya / room=B201 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Sumaiya' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 110: FALL / COMFCI-25 / Korean / teacher=NULL / room=B102 / source=base_audit:1
-- original teacher text not in edited base: Ms. Ajar
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 111: FALL / COMFCI-25 / Korean / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. ___
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 112: FALL / COMFCI-25 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 113: FALL / COMFCI-25 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 114: FALL / COMFCI-25 / Programming Language I / teacher=Ms. Azhar Kazakbaeva / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 115: FALL / COMFCI-25 / Russian language / teacher=Alimpieva L. / room=B103 / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alimpieva L.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 116: FALL / COMFCI-25 / Russian language / teacher=Alymbekova S. / room=B101 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 117: FALL / COMFCI-25 / Russian language / teacher=Alymbekova S. / room=B104 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 118: FALL / COMFCI-25 / Russian language / teacher=Alymbekova S. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 119: FALL / COMFCI-25 / Russian language / teacher=Chokusheva G. / room=B102 / source=base_audit:1+corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Chokusheva G.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 120: FALL / COMFCI-25 / Russian language / teacher=Chokusheva G. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Chokusheva G.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 121: FALL / COMFCI-25 / Russian language / teacher=NULL / room=B105 / source=corrected_skipped:1
-- original teacher text not in edited base: Djolbulakova.Ch.A
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 122: FALL / COMFCI-25 / Russian language / teacher=NULL / room=B201 / source=corrected_skipped:1
-- original teacher text not in edited base: Djolbulakova.Ch.A
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 123: FALL / COMFCI-25 / Russian language / teacher=Tsoi A. / room=B104 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Tsoi A.' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 124: FALL / COMFCI-25 / Russian language / teacher=Tsoi A. / room=B107 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Tsoi A.' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 125: FALL / COMFCI-25 / Turkish / teacher=NULL / room=B202 / source=base_audit:2
-- original teacher text not in edited base: Ms. Elnura.U
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 126: FALL / COMSE-23 / Advisor hour / teacher=NULL / room=B113 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 127: FALL / COMSE-23 / Computer Architecture Operation systems / teacher=Mr. Erustan Erkebulanov / room=B111 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 128: FALL / COMSE-23 / Computer Architecture Operation systems / teacher=Mr. Erustan Erkebulanov / room=LAB5(B213) / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        3, 'ANY', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 129: FALL / COMSE-23 / Computer Architecture Operation systems / teacher=Mr. Erustan Erkebulanov / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 130: FALL / COMSE-23 / Computer Architecture Operation systems / teacher=Mr. Suleyman Saparov / room=LAB4(B211) / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Suleyman Saparov' LIMIT 1),
        3, 'ANY', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 131: FALL / COMSE-23 / Computer Architecture Operation systems / teacher=Mr. Suleyman Saparov / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Suleyman Saparov' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 132: FALL / COMSE-23 / Computer Architecture Operation systems / teacher=Mr. Talgat Mendekov / room=B111 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 133: FALL / COMSE-23 / Mobile App Development / teacher=Mr. Mutalip / room=LAB4(B211) / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mobile App Development' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Mutalip' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 134: FALL / COMSE-23 / Mobile App Development / teacher=Mr. Mutalip / room=LAB5(B213) / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mobile App Development' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Mutalip' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 135: FALL / COMSE-23 / Mobile App Development / teacher=NULL / room=B111 / source=base_audit:2
-- original teacher text not in edited base: Mr. ___
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mobile App Development' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 136: FALL / COMSE-23 / Mobile App Development / teacher=NULL / room=B204 / source=base_audit:1
-- original teacher text not in edited base: Dr. Mekia Gaso
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mobile App Development' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 137: FALL / COMSE-23 / Mobile App Development / teacher=NULL / room=NULL / source=base_audit:5
-- original teacher text not in edited base: Mr. ___, Dr. Mekia Gaso
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mobile App Development' LIMIT 1),
        NULL,
        10, 'ANY', 'CLASSROOM', '10', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 138: FALL / COMSE-23 / Probability Statistics / teacher=Mr. Ahmad Sarosh / room=B113 / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ahmad Sarosh' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 139: FALL / COMSE-23 / Probability Statistics / teacher=Mr. Erustan Erkebulanov / room=B111 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 140: FALL / COMSE-23 / Probability Statistics / teacher=Mr. Talgat Mendekov / room=B111 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 141: FALL / COMSE-23 / Probability Statistics / teacher=NULL / room=B113 / source=base_audit:3
-- original teacher text not in edited base: Mr. Meezan Chand, Dr. Ahmad Sarosh
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        6, 'ANY', 'CLASSROOM', '6', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 142: FALL / COMSE-23 / Software Engineering / teacher=Ms. Mekia Gaso / room=B109 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Mekia Gaso' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 143: FALL / COMSE-23 / Software Engineering / teacher=Ms. Mekia Gaso / room=B112 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Mekia Gaso' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B112' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 144: FALL / COMSE-23 / Software Engineering / teacher=Ms. Mekia Gaso / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Mekia Gaso' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 145: FALL / COMSE-24 / Computational Mathematics / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computational Mathematics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 146: FALL / COMSE-24 / Databases / teacher=Ms. Nargiza Zhumalieva / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 147: FALL / COMSE-24 / Databases / teacher=Ms. Nargiza Zhumalieva / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 148: FALL / COMSE-24 / Frontend / teacher=Mr. Niyazkhan Shabdanalov / room=B110 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Frontend' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Niyazkhan Shabdanalov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 149: FALL / COMSE-24 / Frontend / teacher=NULL / room=B104 / source=base_audit:1
-- original teacher text not in edited base: Mr. Niyazkhan
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Frontend' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 150: FALL / COMSE-24 / Human Computer Interaction / teacher=Dr. Burul Shambetova / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 151: FALL / COMSE-24 / Human Computer Interaction / teacher=NULL / room=C005 / source=base_audit:1
-- original teacher text not in edited base: Dr. Burul Shambetova Block
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'C005' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 152: FALL / COMSE-24 / Interpersonal Communication in IT / teacher=Mr. Murray Eldred / room=B101 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 153: FALL / COMSE-24 / Kyrgyz / teacher=Ms. Duisheeva T. / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 154: FALL / COMSE-24 / Kyrgyz / teacher=Ms. Orozalieva D. / room=B102 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 155: FALL / COMSE-24 / Kyrgyz / teacher=Ms. Saidalieva A. / room=B101 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 156: FALL / COMSE-24 / Kyrgyz / teacher=Ms. Tokusheva T. / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 157: FALL / COMSE-24 / Kyrgyz language foreign students / teacher=NULL / room=B103 / source=base_audit:1
-- original teacher text not in edited base: Ms. Saidalieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 158: FALL / COMSE-24 / Mastering / teacher=NULL / room=BIGLAB / source=base_audit:1
-- original teacher text not in edited base: Prof. essional writing in IT-Mr.Murray Eldred
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1),
        NULL,
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 159: FALL / COMSE-24 / Object Oriented Programming / teacher=Dr. Daniiar Satybaldiev / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Daniiar Satybaldiev' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 160: FALL / COMSE-24 / Object Oriented Programming / teacher=NULL / room=LAB4(B211) / source=base_audit:1
-- original teacher text not in edited base: Dr. Daniyar Satybaldiev
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        NULL,
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 161: FALL / COMSE-24 / Object Oriented Programming / teacher=NULL / room=NULL / source=base_audit:3
-- original teacher text not in edited base: Dr. Daniyar Satybaldiev, Mr. Haksrun Lao (Cambodia)
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        NULL,
        7, 'ANY', 'CLASSROOM', '7', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 162: FALL / COMSE-24 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 163: FALL / COMSE-24 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 164: FALL / COMSE-24 / Public Speaking Skills / teacher=NULL / room=B107 / source=base_audit:2
-- original teacher text not in edited base: Ms. Ainuuru Zhoolchieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 165: FALL / COMSE-24 / Startup: from idea to launch / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Mr. Radmir Gumerov (Group 2)
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 166: FALL / COMSE-25 / Algebra Geometry / teacher=Mr. Samat Elikbaev / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 167: FALL / COMSE-25 / Algebra Geometry / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Mr. Samat.Elikbaev
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 168: FALL / COMSE-25 / Calculus I / teacher=NULL / room=B101 / source=base_audit:1
-- original teacher text not in edited base: Mr. Hussien Chebsi
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 169: FALL / COMSE-25 / English / teacher=NULL / room=B101 / source=base_audit:2
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 170: FALL / COMSE-25 / French / teacher=Ms. Iskra / room=B101 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 171: FALL / COMSE-25 / French / teacher=Ms. Iskra / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 172: FALL / COMSE-25 / French / teacher=Ms. Iskra / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 173: FALL / COMSE-25 / German / teacher=Ms. Erika / room=B204 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 174: FALL / COMSE-25 / Introduction to Engineering / teacher=Mr. Imtiyaz Gulbarga / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 175: FALL / COMSE-25 / Introduction to Engineering / teacher=Mr. Imtiyaz Gulbarga / room=LAB5(B213) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 176: FALL / COMSE-25 / Korean / teacher=Ms. Sumaiya / room=B201 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Sumaiya' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 177: FALL / COMSE-25 / Korean / teacher=NULL / room=B102 / source=base_audit:1
-- original teacher text not in edited base: Ms. Ajar
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 178: FALL / COMSE-25 / Korean / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. ___
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 179: FALL / COMSE-25 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 180: FALL / COMSE-25 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 181: FALL / COMSE-25 / Programming Language I / teacher=Ms. Azhar Kazakbaeva / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        3, 'ANY', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 182: FALL / COMSE-25 / Programming Language I / teacher=Ms. Azhar Kazakbaeva / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        3, 'ANY', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 183: FALL / COMSE-25 / Programming Language I / teacher=Ms. Azhar Kazakbaeva / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 184: FALL / COMSE-25 / Russian language / teacher=Alimpieva L. / room=B103 / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alimpieva L.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 185: FALL / COMSE-25 / Russian language / teacher=Alymbekova S. / room=B101 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 186: FALL / COMSE-25 / Russian language / teacher=Alymbekova S. / room=B104 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 187: FALL / COMSE-25 / Russian language / teacher=Alymbekova S. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 188: FALL / COMSE-25 / Russian language / teacher=Chokusheva G. / room=B102 / source=base_audit:1+corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Chokusheva G.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 189: FALL / COMSE-25 / Russian language / teacher=Chokusheva G. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Chokusheva G.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 190: FALL / COMSE-25 / Russian language / teacher=NULL / room=B105 / source=corrected_skipped:1
-- original teacher text not in edited base: Djolbulakova.Ch.A
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 191: FALL / COMSE-25 / Russian language / teacher=NULL / room=B201 / source=corrected_skipped:1
-- original teacher text not in edited base: Djolbulakova.Ch.A
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 192: FALL / COMSE-25 / Russian language / teacher=Tsoi A. / room=B104 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Tsoi A.' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 193: FALL / COMSE-25 / Russian language / teacher=Tsoi A. / room=B107 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Tsoi A.' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 194: FALL / COMSE-25 / Turkish / teacher=NULL / room=B202 / source=base_audit:2
-- original teacher text not in edited base: Ms. Elnura.U
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 195: FALL / EEAIR-23 / Advisor hour / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

-- assignment 196: FALL / EEAIR-23 / Design & Analysis of Algorithms / teacher=Mr. Erustan Erkebulanov / room=NULL / source=base_audit:3
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design & Analysis of Algorithms' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

-- assignment 197: FALL / EEAIR-23 / Design & Analysis of Algorithms / teacher=NULL / room=LAB5(B213) / source=base_audit:2
-- original teacher text not in edited base: Dr. Mekia Gaso
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design & Analysis of Algorithms' LIMIT 1),
        NULL,
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

-- assignment 198: FALL / EEAIR-23 / Design & Analysis of Algorithms / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Mr. Erustan Erkebulanovlink
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design & Analysis of Algorithms' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

-- assignment 199: FALL / EEAIR-23 / Machine Learning / teacher=Dr. Tauheed Khan / room=B203 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Machine Learning' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

-- assignment 200: FALL / EEAIR-23 / Machine Learning / teacher=Dr. Tauheed Khan / room=NULL / source=base_audit:3
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Machine Learning' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

-- assignment 201: FALL / EEAIR-23 / Programming Interface of the Microcontroller / teacher=Dr. Tauheed Khan / room=LAB5(B213) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Interface of the Microcontroller' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

-- assignment 202: FALL / EEAIR-23 / Programming Interface of the Microcontroller / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Dr. Ahmad Sarosh
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Interface of the Microcontroller' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

-- assignment 203: FALL / EEAIR-23 / Software Engineering / teacher=Mr. Niyazkhan Shabdanalov / room=B111 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Niyazkhan Shabdanalov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

-- assignment 204: FALL / EEAIR-23 / Software Engineering / teacher=Ms. Nargiza Zhumalieva / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

-- assignment 205: FALL / EEAIR-24 / Computer Architecture Operation systems / teacher=Dr. Arslan Khan / room=B109 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Arslan Khan' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 206: FALL / EEAIR-24 / Databases / teacher=Mr. Erustan Erkebulanov / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 207: FALL / EEAIR-24 / Electronic components circuits / teacher=Dr. Tauheed Khan / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Electronic components circuits' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 208: FALL / EEAIR-24 / Human Computer Interaction / teacher=Dr. Burul Shambetova / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 209: FALL / EEAIR-24 / Interpersonal Communication in IT / teacher=Mr. Murray Eldred / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 210: FALL / EEAIR-24 / Kyrgyz / teacher=Ms. Duisheeva T. / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 211: FALL / EEAIR-24 / Kyrgyz / teacher=Ms. Orozalieva D. / room=B102 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 212: FALL / EEAIR-24 / Mastering / teacher=NULL / room=BIGLAB / source=base_audit:1
-- original teacher text not in edited base: Prof. essional writing in IT-Mr.Murray Eldred
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1),
        NULL,
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 213: FALL / EEAIR-24 / Mathematical tools signal calculation / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mathematical tools signal calculation' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 214: FALL / EEAIR-24 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 215: FALL / EEAIR-24 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 216: FALL / EEAIR-24 / Public Speaking Skills / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Ms. Jamby Djusubalieva 4.Digital marketing technologies Ms. Meerim
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 217: FALL / EEAIR-24 / Robotics Foundation / teacher=Dr. Tauheed Khan / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Robotics Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 218: FALL / EEAIR-24 / Startup: from idea to launch / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Mr. Radmir Gumerov (Group 2)
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 219: FALL / EEAIR-25 / Advisor hour / teacher=NULL / room=B202 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 220: FALL / EEAIR-25 / Algebra Geometry / teacher=Ms. Tattybubu Arap kyzy / room=B106 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 221: FALL / EEAIR-25 / Algebra Geometry / teacher=Ms. Tattybubu Arap kyzy / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 222: FALL / EEAIR-25 / Calculus I / teacher=NULL / room=NULL / source=base_audit:3
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        6, 'ANY', 'CLASSROOM', '6', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 223: FALL / EEAIR-25 / English / teacher=Mr. Murray Eldred / room=B113 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 224: FALL / EEAIR-25 / English / teacher=NULL / room=B101 / source=base_audit:1
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 225: FALL / EEAIR-25 / English / teacher=NULL / room=B113 / source=base_audit:1
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 226: FALL / EEAIR-25 / French / teacher=Ms. Iskra / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 227: FALL / EEAIR-25 / German / teacher=Ms. Erika / room=B203 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 228: FALL / EEAIR-25 / German / teacher=Ms. Erika / room=B204 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 229: FALL / EEAIR-25 / Introduction to Engineering / teacher=Mr. Imtiyaz Gulbarga / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 230: FALL / EEAIR-25 / Introduction to Engineering / teacher=Mr. Nich Kawaguchi / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Nich Kawaguchi' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 231: FALL / EEAIR-25 / Introduction to Engineering / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Mr. Mr. Imtiyaz Gulbarga
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 232: FALL / EEAIR-25 / Korean / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Ms. ___
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 233: FALL / EEAIR-25 / Philosophy / teacher=NULL / room=B105 / source=base_audit:1
-- original teacher text not in edited base: Mr. s. Cholpon Alieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 234: FALL / EEAIR-25 / Philosophy / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Prof. Cholpon Alieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 235: FALL / EEAIR-25 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 236: FALL / EEAIR-25 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 237: FALL / EEAIR-25 / Programming Language I / teacher=Mr. Imtiyaz Gulbarga / room=NULL / source=base_audit:3
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 238: FALL / EEAIR-25 / Turkish / teacher=NULL / room=B202 / source=base_audit:1+corrected_skipped:1
-- original teacher text not in edited base: Mr. Elnura
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 239: FALL / IEMIT-23 / Advisor hour / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

-- assignment 240: FALL / IEMIT-23 / Design & Analysis of Algorithms / teacher=Mr. Erustan Erkebulanov / room=NULL / source=base_audit:3
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design & Analysis of Algorithms' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

-- assignment 241: FALL / IEMIT-23 / Design & Analysis of Algorithms / teacher=NULL / room=LAB5(B213) / source=base_audit:2
-- original teacher text not in edited base: Dr. Mekia Gaso
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design & Analysis of Algorithms' LIMIT 1),
        NULL,
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

-- assignment 242: FALL / IEMIT-23 / Design & Analysis of Algorithms / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Mr. Erustan Erkebulanovlink
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design & Analysis of Algorithms' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

-- assignment 243: FALL / IEMIT-23 / Probability Statistics / teacher=Dr. Meezan Chand / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Meezan Chand' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

-- assignment 244: FALL / IEMIT-23 / Probability Statistics / teacher=NULL / room=B101 / source=base_audit:1
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

-- assignment 245: FALL / IEMIT-23 / Project Product Management / teacher=Ms. Aidai Atakulova / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Project Product Management' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Aidai Atakulova' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

-- assignment 246: FALL / IEMIT-23 / Software Engineering / teacher=Mr. Niyazkhan Shabdanalov / room=B111 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Niyazkhan Shabdanalov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

-- assignment 247: FALL / IEMIT-23 / Software Engineering / teacher=Ms. Nargiza Zhumalieva / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

-- assignment 248: FALL / IEMIT-23 / Software Engineering / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. Nargiza
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

-- assignment 249: FALL / IEMIT-24 / Databases / teacher=Mr. Erustan Erkebulanov / room=LAB4(B211) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 250: FALL / IEMIT-24 / Databases / teacher=Mr. Erustan Erkebulanov / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 251: FALL / IEMIT-24 / Financial Math / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. Azhikulova Kanykei
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Financial Math' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 252: FALL / IEMIT-24 / Human Computer Interaction / teacher=Dr. Burul Shambetova / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 253: FALL / IEMIT-24 / Interpersonal Communication in IT / teacher=Mr. Murray Eldred / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 254: FALL / IEMIT-24 / Kyrgyz / teacher=Ms. Duisheeva T. / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 255: FALL / IEMIT-24 / Kyrgyz / teacher=Ms. Orozalieva D. / room=B102 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 256: FALL / IEMIT-24 / Management / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Ms. Azhikulova Kanykei
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Management' LIMIT 1),
        NULL,
        6, 'ANY', 'CLASSROOM', '6', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 257: FALL / IEMIT-24 / Mastering / teacher=NULL / room=BIGLAB / source=base_audit:1
-- original teacher text not in edited base: Prof. essional writing in IT-Mr.Murray Eldred
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1),
        NULL,
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 258: FALL / IEMIT-24 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 259: FALL / IEMIT-24 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 260: FALL / IEMIT-24 / Project Product Management / teacher=Ms. Aidai Atakulova / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Project Product Management' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Aidai Atakulova' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 261: FALL / IEMIT-24 / Public Speaking Skills / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Ms. Jamby Djusubalieva 4.Digital marketing technologies Ms. Meerim
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 262: FALL / IEMIT-24 / Startup: from idea to launch / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Mr. Radmir Gumerov (Group 2)
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 263: FALL / IEMIT-25 / Advisor hour / teacher=NULL / room=B101 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 264: FALL / IEMIT-25 / Algebra Geometry / teacher=Ms. Tattybubu Arap kyzy / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 265: FALL / IEMIT-25 / Calculus I / teacher=NULL / room=B103 / source=base_audit:2
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 266: FALL / IEMIT-25 / Calculus I / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 267: FALL / IEMIT-25 / English / teacher=Mr. Murray Eldred / room=B113 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 268: FALL / IEMIT-25 / English / teacher=NULL / room=B101 / source=base_audit:1
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 269: FALL / IEMIT-25 / English / teacher=NULL / room=B113 / source=base_audit:1
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 270: FALL / IEMIT-25 / French / teacher=Ms. Iskra / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 271: FALL / IEMIT-25 / German / teacher=Ms. Erika / room=B203 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 272: FALL / IEMIT-25 / German / teacher=Ms. Erika / room=B204 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 273: FALL / IEMIT-25 / Introduction to Engineering / teacher=NULL / room=B201 / source=base_audit:1
-- original teacher text not in edited base: Ms. Azhikulova Kanykei
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 274: FALL / IEMIT-25 / Introduction to Engineering / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Ms. Azhikulova Kanykei
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 275: FALL / IEMIT-25 / Korean / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Ms. ___
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 276: FALL / IEMIT-25 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 277: FALL / IEMIT-25 / Programming Language (Java) / teacher=Ms. Bopushova Asina / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language (Java)' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Bopushova Asina' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 278: FALL / IEMIT-25 / Programming Language I / teacher=Ms. Bopushova Asina / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Bopushova Asina' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 279: FALL / IEMIT-25 / Russian language / teacher=Alimpieva L. / room=B101 / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alimpieva L.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 280: FALL / IEMIT-25 / Russian language / teacher=NULL / room=B103 / source=corrected_skipped:2
-- original teacher text not in edited base: Djolbulakova.Ch.A
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 281: FALL / IEMIT-25 / Russian language / teacher=Tsoi A. / room=B102 / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Tsoi A.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 282: FALL / IEMIT-25 / Turkish / teacher=NULL / room=B202 / source=base_audit:1+corrected_skipped:1
-- original teacher text not in edited base: Mr. Elnura
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 283: FALL / MATDAIS-23 / Intelligent data analysis / teacher=Dr. Remudin Mecuria / room=NULL / source=base_audit:3
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Intelligent data analysis' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Remudin Mecuria' LIMIT 1),
        7, 'ANY', 'CLASSROOM', '7', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)
FROM new_assignment;

-- assignment 284: FALL / MATDAIS-23 / Methods of Optimizations / teacher=NULL / room=B107 / source=base_audit:1
-- original teacher text not in edited base: Ms. Liliya
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Methods of Optimizations' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)
FROM new_assignment;

-- assignment 285: FALL / MATDAIS-23 / Methods of Optimizations / teacher=NULL / room=B110 / source=base_audit:1
-- original teacher text not in edited base: Ms. Liliya
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Methods of Optimizations' LIMIT 1),
        NULL,
        3, 'ANY', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)
FROM new_assignment;

-- assignment 286: FALL / MATDAIS-23 / Methods of Optimizations / teacher=NULL / room=B113 / source=base_audit:1
-- original teacher text not in edited base: Ms. Liliya
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Methods of Optimizations' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)
FROM new_assignment;

-- assignment 287: FALL / MATDAIS-23 / Methods of Optimizations / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. Liliya
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Methods of Optimizations' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)
FROM new_assignment;

-- assignment 288: FALL / MATDAIS-23 / Probability Statistics / teacher=NULL / room=B107 / source=base_audit:1
-- original teacher text not in edited base: Dr. Remudin Mekuria
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)
FROM new_assignment;

-- assignment 289: FALL / MATDAIS-23 / Probability Statistics / teacher=NULL / room=NULL / source=base_audit:4
-- original teacher text not in edited base: Ms. Gulnarida
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        8, 'ANY', 'CLASSROOM', '8', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)
FROM new_assignment;

-- assignment 290: FALL / MATDAIS-24 / Calculus III / teacher=NULL / room=NULL / source=base_audit:3
-- original teacher text not in edited base: Mr. Hussien Chebsi
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus III' LIMIT 1),
        NULL,
        6, 'ANY', 'CLASSROOM', '6', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 291: FALL / MATDAIS-24 / Data science specialty mathematics / teacher=Ms. Gulnarida Zhalilova / room=B110 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data science specialty mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Gulnarida Zhalilova' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 292: FALL / MATDAIS-24 / Data science specialty mathematics / teacher=NULL / room=NULL / source=base_audit:3
-- original teacher text not in edited base: Ms. Gulnarida
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data science specialty mathematics' LIMIT 1),
        NULL,
        6, 'ANY', 'CLASSROOM', '6', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 293: FALL / MATDAIS-24 / Human Computer Interaction / teacher=Dr. Burul Shambetova / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 294: FALL / MATDAIS-24 / Interpersonal Communication in IT / teacher=Mr. Murray Eldred / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 295: FALL / MATDAIS-24 / Kyrgyz / teacher=Ms. Duisheeva T. / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 296: FALL / MATDAIS-24 / Kyrgyz / teacher=Ms. Orozalieva D. / room=B102 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 297: FALL / MATDAIS-24 / Kyrgyz / teacher=Ms. Saidalieva A. / room=B101 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 298: FALL / MATDAIS-24 / Kyrgyz / teacher=Ms. Tokusheva T. / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 299: FALL / MATDAIS-24 / Manas Studies / teacher=Dr. Meerim Mairykova / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Meerim Mairykova' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 300: FALL / MATDAIS-24 / Manas Studies / teacher=NULL / room=B102 / source=base_audit:1
-- original teacher text not in edited base: Dr. Zakirov Alimzhan
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 301: FALL / MATDAIS-24 / Mastering / teacher=NULL / room=BIGLAB / source=base_audit:1
-- original teacher text not in edited base: Prof. essional writing in IT-Mr.Murray Eldred
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1),
        NULL,
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 302: FALL / MATDAIS-24 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:2+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 303: FALL / MATDAIS-24 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:2+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 304: FALL / MATDAIS-24 / Public Speaking Skills / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Ms. Jamby Djusubalieva 4.Digital marketing technologies Ms. Meerim
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 305: FALL / MATDAIS-24 / Startup: from idea to launch / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Mr. Radmir Gumerov (Group 2)
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 306: FALL / MATDAIS-24 / Variable Part (Applied statistics) / teacher=Mr. Ahmad Sarosh / room=NULL / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Variable Part (Applied statistics)' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ahmad Sarosh' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 307: FALL / MATDAIS-25 / Advisor hour / teacher=NULL / room=B203 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 308: FALL / MATDAIS-25 / Algebra Geometry / teacher=Ms. Tattybubu Arap kyzy / room=B102 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 309: FALL / MATDAIS-25 / Algebra Geometry / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 310: FALL / MATDAIS-25 / Calculus I / teacher=NULL / room=B201 / source=base_audit:1
-- original teacher text not in edited base: Mr. Samat.Elikbaev
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 311: FALL / MATDAIS-25 / Calculus I / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Mr. Samat.Elikbaev
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 312: FALL / MATDAIS-25 / English / teacher=NULL / room=B101 / source=base_audit:1
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 313: FALL / MATDAIS-25 / English / teacher=NULL / room=B201 / source=base_audit:1
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 314: FALL / MATDAIS-25 / French / teacher=Ms. Iskra / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 315: FALL / MATDAIS-25 / German / teacher=Ms. Erika / room=B105 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 316: FALL / MATDAIS-25 / German / teacher=Ms. Erika / room=B204 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 317: FALL / MATDAIS-25 / Introduction to Engineering / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 318: FALL / MATDAIS-25 / Korean / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Ms. ___
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 319: FALL / MATDAIS-25 / Philosophy / teacher=NULL / room=B104 / source=base_audit:2
-- original teacher text not in edited base: Ms. Cholpon
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 320: FALL / MATDAIS-25 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 321: FALL / MATDAIS-25 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 322: FALL / MATDAIS-25 / Programming Language I / teacher=Mr. Ermek Doszhanov / room=BIGLAB / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ermek Doszhanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 323: FALL / MATDAIS-25 / Programming Language I / teacher=Mr. Ermek Doszhanov / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ermek Doszhanov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 324: FALL / MATDAIS-25 / Turkish / teacher=Ms. Aigul / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Aigul' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 325: FALL / MATDAIS-25 / Turkish / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Ms. Aigul B.
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 326: FALL / MATH-22 / Cybersecurity Foundation / teacher=Mr. Imtiyaz Gulbarga / room=LAB4(B211) / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

-- assignment 327: FALL / MATH-22 / Cybersecurity Foundation / teacher=Mr. Imtiyaz Gulbarga / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

-- assignment 328: FALL / MATH-22 / Functional analysis / teacher=Dr. Sherali Matanov / room=NULL / source=base_audit:3
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Functional analysis' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1),
        7, 'ANY', 'CLASSROOM', '7', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

-- assignment 329: FALL / MATH-22 / Fundamentals of Scientific Research / teacher=Dr. Burul Shambetova / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Fundamentals of Scientific Research' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

-- assignment 330: FALL / MATH-22 / Machine Learning / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Dr. Akhmad Sarosh
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Machine Learning' LIMIT 1),
        NULL,
        5, 'ANY', 'CLASSROOM', '5', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

-- assignment 331: FALL / MATH-22 / Number Theory / teacher=Ms. Tattybubu Arap kyzy / room=B201 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Number Theory' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

-- assignment 332: FALL / MATH-22 / Number Theory / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Ms. Tattybubu
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Number Theory' LIMIT 1),
        NULL,
        5, 'ANY', 'CLASSROOM', '5', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

-- assignment 333: FALL / MATMIE-23 / Educational Technology Learning Systems / teacher=Ms. Gulnarida Zhalilova / room=LAB4(B211) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Educational Technology Learning Systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Gulnarida Zhalilova' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

-- assignment 334: FALL / MATMIE-23 / Educational Technology Learning Systems / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Mr. ____
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Educational Technology Learning Systems' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

-- assignment 335: FALL / MATMIE-23 / Methods of Optimizations / teacher=NULL / room=B107 / source=base_audit:1
-- original teacher text not in edited base: Ms. Liliya
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Methods of Optimizations' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

-- assignment 336: FALL / MATMIE-23 / Methods of Optimizations / teacher=NULL / room=B110 / source=base_audit:1
-- original teacher text not in edited base: Ms. Liliya
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Methods of Optimizations' LIMIT 1),
        NULL,
        3, 'ANY', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

-- assignment 337: FALL / MATMIE-23 / Methods of Optimizations / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Ms. Liliya
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Methods of Optimizations' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

-- assignment 338: FALL / MATMIE-23 / Optimization Methods / teacher=Dr. Sherali Matanov / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Optimization Methods' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

-- assignment 339: FALL / MATMIE-23 / Probability Statistics / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Ms. Gulnarida Jalilova
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

-- assignment 340: FALL / MATMIE-23 / Probability Statistics / teacher=NULL / room=B112 / source=base_audit:1
-- original teacher text not in edited base: Ms. Gulnarida
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B112' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

-- assignment 341: FALL / MATMIE-23 / Probability Statistics / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Ms. Gulnarida
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

-- assignment 342: FALL / MATMIE-24 / Applied statistics I / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Dr. Remudin Mekuria B
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Applied statistics I' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 343: FALL / MATMIE-24 / Calculus III / teacher=NULL / room=NULL / source=base_audit:3
-- original teacher text not in edited base: Mr. Hussien Chebsi
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus III' LIMIT 1),
        NULL,
        6, 'ANY', 'CLASSROOM', '6', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 344: FALL / MATMIE-24 / Human Computer Interaction / teacher=Dr. Burul Shambetova / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 345: FALL / MATMIE-24 / Interpersonal Communication in IT / teacher=Mr. Murray Eldred / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 346: FALL / MATMIE-24 / Kyrgyz / teacher=Ms. Duisheeva T. / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 347: FALL / MATMIE-24 / Kyrgyz / teacher=Ms. Orozalieva D. / room=B102 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 348: FALL / MATMIE-24 / Kyrgyz / teacher=Ms. Saidalieva A. / room=B101 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 349: FALL / MATMIE-24 / Kyrgyz / teacher=Ms. Tokusheva T. / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 350: FALL / MATMIE-24 / Manas Studies / teacher=Dr. Meerim Mairykova / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Meerim Mairykova' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 351: FALL / MATMIE-24 / Manas Studies / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Dr. Zakirov Alimzhan
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 352: FALL / MATMIE-24 / Mastering / teacher=NULL / room=BIGLAB / source=base_audit:1
-- original teacher text not in edited base: Prof. essional writing in IT-Mr.Murray Eldred
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1),
        NULL,
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 353: FALL / MATMIE-24 / Object Oriented Programming / teacher=Mr. Hussein Chebsi / room=NULL / source=base_audit:2+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Hussein Chebsi' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 354: FALL / MATMIE-24 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:2+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 355: FALL / MATMIE-24 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:2+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 356: FALL / MATMIE-24 / Public Speaking Skills / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Ms. Jamby Djusubalieva 4.Digital marketing technologies Ms. Meerim
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 357: FALL / MATMIE-24 / Startup: from idea to launch / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Mr. Radmir Gumerov (Group 2)
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 358: FALL / MATMIE-24 / Variable Part (Applied statistics) / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Ms. Gulnarida
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Variable Part (Applied statistics)' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 359: FALL / MATMIE-25 / Advisor hour / teacher=NULL / room=B205 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 360: FALL / MATMIE-25 / Algebra Geometry / teacher=Ms. Tattybubu Arap kyzy / room=B102 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 361: FALL / MATMIE-25 / Algebra Geometry / teacher=Ms. Tattybubu Arap kyzy / room=B202 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 362: FALL / MATMIE-25 / Algebra Geometry / teacher=NULL / room=B102 / source=base_audit:1
-- original teacher text not in edited base: Ms. Tattybubu.A
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 363: FALL / MATMIE-25 / Calculus I / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Mr. Samat.Elikbaev
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 364: FALL / MATMIE-25 / Calculus I / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Mr. Samat.Elikbaev
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 365: FALL / MATMIE-25 / English / teacher=NULL / room=B101 / source=base_audit:1
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 366: FALL / MATMIE-25 / English / teacher=NULL / room=B201 / source=base_audit:1
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 367: FALL / MATMIE-25 / French / teacher=Ms. Iskra / room=NULL / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 368: FALL / MATMIE-25 / German / teacher=Ms. Erika / room=B105 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 369: FALL / MATMIE-25 / German / teacher=Ms. Erika / room=B204 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 370: FALL / MATMIE-25 / Introduction to Engineering / teacher=Dr. Tauheed Khan / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 371: FALL / MATMIE-25 / Korean / teacher=NULL / room=NULL / source=base_audit:2
-- original teacher text not in edited base: Ms. ___
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 372: FALL / MATMIE-25 / Philosophy / teacher=NULL / room=B104 / source=base_audit:2
-- original teacher text not in edited base: Ms. Cholpon
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 373: FALL / MATMIE-25 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:2+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 374: FALL / MATMIE-25 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:2+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 375: FALL / MATMIE-25 / Programming Language I / teacher=Mr. Ermek Doszhanov / room=BIGLAB / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ermek Doszhanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 376: FALL / MATMIE-25 / Programming Language I / teacher=Mr. Ermek Doszhanov / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ermek Doszhanov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 377: FALL / MATMIE-25 / Turkish / teacher=Ms. Aigul / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Aigul' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 378: FALL / MATMIE-25 / Turkish / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Ms. Aigul B.
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 379: FALL / MCOM-1 / Deep Learning / teacher=Dr. Musa Abdujabbarov / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Deep Learning' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Musa Abdujabbarov' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-1' LIMIT 1)
FROM new_assignment;

-- assignment 380: FALL / MCOM-1 / Foundation Maths Data Science / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Dr. Remudin Mekuria
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Foundation Maths Data Science' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-1' LIMIT 1)
FROM new_assignment;

-- assignment 381: FALL / MCOM-1 / Introduction to Data Analysis / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Dr. Remudin Mekuria
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Data Analysis' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-1' LIMIT 1)
FROM new_assignment;

-- assignment 382: FALL / MCOM-1 / Machine Learning / teacher=Dr. Tauheed Khan / room=LAB4(B211) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Machine Learning' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        3, 'ANY', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-1' LIMIT 1)
FROM new_assignment;

-- assignment 383: FALL / MCOM-1 / Psychology of Higher Education / teacher=Dr. Ainuru Zholchieva / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Psychology of Higher Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Ainuru Zholchieva' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-1' LIMIT 1)
FROM new_assignment;

-- assignment 384: FALL / MCOM-2 / Data Visualization Analysis Tools / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Dr. Mekia Gaso
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data Visualization Analysis Tools' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-2' LIMIT 1)
FROM new_assignment;

-- assignment 385: FALL / MCOM-2 / Data engineering / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data engineering' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-2' LIMIT 1)
FROM new_assignment;

-- assignment 386: FALL / MCOM-2 / Scientific Industrial Practice / teacher=Dr. Burul Shambetova / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-2' LIMIT 1)
FROM new_assignment;

-- assignment 387: FALL / MCOM-2 / Teaching Practice / teacher=Dr. Burul Shambetova / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Teaching Practice' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-2' LIMIT 1)
FROM new_assignment;

-- assignment 388: FALL / PHD-23 / Supervisor Review / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Supervisor Review' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-23' LIMIT 1)
FROM new_assignment;

-- assignment 389: FALL / PHD-24 / Scientific research internship / teacher=NULL / room=NULL / source=corrected_skipped:3
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific research internship' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-24' LIMIT 1)
FROM new_assignment;

-- assignment 390: FALL / PHD-24 / Supervisor Review / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Supervisor Review' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-24' LIMIT 1)
FROM new_assignment;

-- assignment 391: FALL / PHD-25 / Advanced Image Processing / teacher=Dr. Tauheed Khan / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advanced Image Processing' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)
FROM new_assignment;

-- assignment 392: FALL / PHD-25 / Artificial Intelligence Deep Learning / teacher=Dr. Musa Abdujabbarov / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Artificial Intelligence Deep Learning' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Musa Abdujabbarov' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)
FROM new_assignment;

-- assignment 393: FALL / PHD-25 / Research Methods / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Dr. Remudin Mekuria
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Research Methods' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)
FROM new_assignment;

-- assignment 394: FALL / PHD-25 / Scientific Seminar / teacher=Dr. Ruslan Isaev / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Seminar' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Ruslan Isaev' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)
FROM new_assignment;

-- assignment 395: FALL / PHD-25 / Supervisor Review / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Supervisor Review' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)
FROM new_assignment;

-- assignment 396: SPRING / COM-22 / C# (Advanced C#) / teacher=Mr. Talgat Mendekov / room=B111 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'C# (Advanced C#)' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 397: SPRING / COM-22 / C# (Advanced C#) / teacher=Mr. Talgat Mendekov / room=LAB4(B211) / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'C# (Advanced C#)' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        6, 'ANY', 'COMPUTER_LAB', '6', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 398: SPRING / COM-22 / C# (Advanced C#) / teacher=Ms. Zhibek Namatova / room=B111 / source=base_audit:2+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'C# (Advanced C#)' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        7, 'ANY', 'CLASSROOM', '7', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 399: SPRING / COM-22 / C# (Advanced C#) / teacher=Ms. Zhibek Namatova / room=LAB3(B210) / source=base_audit:2+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'C# (Advanced C#)' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        7, 'ANY', 'COMPUTER_LAB', '7', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 400: SPRING / COM-22 / Cloud computing / teacher=Mr. Ahmad Sarosh / room=B110 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cloud computing' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ahmad Sarosh' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 401: SPRING / COM-22 / Cloud computing / teacher=Mr. Ahmad Sarosh / room=B111 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cloud computing' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ahmad Sarosh' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 402: SPRING / COM-22 / Cloud computing / teacher=NULL / room=B110 / source=base_audit:2
-- original teacher text not in edited base: Dr. Ahmad Sarosh
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cloud computing' LIMIT 1),
        NULL,
        6, 'ANY', 'COMPUTER_LAB', '6', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 403: SPRING / COM-22 / Cloud computing / teacher=NULL / room=B111 / source=base_audit:4
-- original teacher text not in edited base: Mr. Niyazhan Shabdanaliev, Dr. Ahmad Sarosh
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cloud computing' LIMIT 1),
        NULL,
        12, 'ANY', 'CLASSROOM', '12', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 404: SPRING / COM-22 / Cloud computing / teacher=NULL / room=B203 / source=base_audit:2
-- original teacher text not in edited base: Mr. Niyazhan Shabdanaliev
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cloud computing' LIMIT 1),
        NULL,
        6, 'ANY', 'CLASSROOM', '6', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 405: SPRING / COM-22 / Image Processing Computer Vision / teacher=Dr. Tauheed Khan / room=LAB5(B213) / source=base_audit:2+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Image Processing Computer Vision' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        7, 'ANY', 'COMPUTER_LAB', '7', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 406: SPRING / COM-22 / Research in Applied Data Science / teacher=Dr. Tauheed Khan / room=LAB5(B213) / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Research in Applied Data Science' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        6, 'ANY', 'COMPUTER_LAB', '6', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 407: SPRING / COM-22 / Research in Applied Data Science / teacher=Ms. Mekia Gaso / room=B203 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Research in Applied Data Science' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Mekia Gaso' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 408: SPRING / COM-22 / Research in Applied Data Science / teacher=NULL / room=B110 / source=base_audit:2
-- original teacher text not in edited base: Dr. Mekia Gaso
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Research in Applied Data Science' LIMIT 1),
        NULL,
        6, 'ANY', 'COMPUTER_LAB', '6', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 409: SPRING / COM-22 / Research in Applied Data Science / teacher=NULL / room=B203 / source=base_audit:2
-- original teacher text not in edited base: Dr. Mekia Gaso
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Research in Applied Data Science' LIMIT 1),
        NULL,
        6, 'ANY', 'CLASSROOM', '6', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 410: SPRING / COM-22 / Software Engineering / teacher=Mr. Niyazkhan Shabdanalov / room=B111 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Niyazkhan Shabdanalov' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 411: SPRING / COM-22 / Software Engineering / teacher=Mr. Niyazkhan Shabdanalov / room=B203 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Niyazkhan Shabdanalov' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 412: SPRING / COM-22 / Software Engineering / teacher=Mr. Talgat Mendekov / room=B111 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 413: SPRING / COM-22 / Software Engineering / teacher=Mr. Talgat Mendekov / room=LAB4(B211) / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

-- assignment 414: SPRING / COMCEH-23 / Scientific Industrial Practice / teacher=NULL / room=NULL / source=corrected_skipped:10
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        NULL,
        10, 'ANY', 'CLASSROOM', '10', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)
FROM new_assignment;

-- assignment 415: SPRING / COMCEH-24 / Advisor hour / teacher=NULL / room=B101 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 416: SPRING / COMCEH-24 / Cybersecurity Foundation / teacher=Mr. Ruslan Amanov / room=LAB4(B211) / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 417: SPRING / COMCEH-24 / Digital Marketing Technologies / teacher=Ms. Meerim Chukaeva / room=B111 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 418: SPRING / COMCEH-24 / Digital Marketing Technologies / teacher=Ms. Meerim Chukaeva / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 419: SPRING / COMCEH-24 / DocuIT: Mastering / teacher=NULL / room=B101 / source=base_audit:2
-- original teacher text not in edited base: Prof. essional Writing in IT Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'DocuIT: Mastering' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 420: SPRING / COMCEH-24 / Ethical Hacking Penetration Testing / teacher=Mr. Imtiyaz Gulbarga / room=LAB4(B211) / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Ethical Hacking Penetration Testing' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        6, 'ANY', 'COMPUTER_LAB', '6', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 421: SPRING / COMCEH-24 / Geography of Kyrgyzstan / teacher=Mr. Emilbek / room=B102 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Emilbek' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 422: SPRING / COMCEH-24 / History of Kyrgyzstan / teacher=Mr. Alimzhan Zakirov / room=B101 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Alimzhan Zakirov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 423: SPRING / COMCEH-24 / History of Kyrgyzstan / teacher=Mr. Alimzhan Zakirov / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Alimzhan Zakirov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 424: SPRING / COMCEH-24 / Kyrgyz Language Literature II / teacher=Ms. Duisheeva T. / room=B202 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 425: SPRING / COMCEH-24 / Kyrgyz Language Literature II / teacher=Ms. Orozalieva D. / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 426: SPRING / COMCEH-24 / Kyrgyz Language Literature II / teacher=Ms. Saidalieva A. / room=B203 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 427: SPRING / COMCEH-24 / Kyrgyz Language Literature II / teacher=Ms. Tokusheva T. / room=B101 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 428: SPRING / COMCEH-24 / Kyrgyz Language Literature II / teacher=NULL / room=B204 / source=base_audit:1
-- original teacher text not in edited base: Ms. Samatova.G
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 429: SPRING / COMCEH-24 / Kyrgyz language foreign students / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Ms. Saidalieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 430: SPRING / COMCEH-24 / Manas Studies / teacher=Dr. Kunduz Zhusupbekova / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Kunduz Zhusupbekova' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 431: SPRING / COMCEH-24 / Philosophy of Technology / teacher=Ms. Zhamby Dzhusubalieva / room=B103 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 432: SPRING / COMCEH-24 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 433: SPRING / COMCEH-24 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 434: SPRING / COMCEH-24 / Probability Statistics / teacher=NULL / room=B101 / source=base_audit:1
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 435: SPRING / COMCEH-24 / Probability Statistics / teacher=NULL / room=B104 / source=base_audit:1
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 436: SPRING / COMCEH-24 / Programming Python / teacher=Ms. Zhibek Namatova / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 437: SPRING / COMCEH-24 / Programming Python / teacher=Ms. Zhibek Namatova / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 438: SPRING / COMCEH-24 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 439: SPRING / COMCEH-24 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B113 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

-- assignment 440: SPRING / COMCEH-25 / Advisor hour / teacher=NULL / room=B101 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 441: SPRING / COMCEH-25 / Calculus II / teacher=Mr. Hussein Chebsi / room=B203 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Hussein Chebsi' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 442: SPRING / COMCEH-25 / Computer Literacy / teacher=Ms. Nargiza Zhumalieva / room=B109 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 443: SPRING / COMCEH-25 / Discrete Mathematics / teacher=Ms. Liliya Abdieva / room=B201 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Liliya Abdieva' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 444: SPRING / COMCEH-25 / Discrete Mathematics / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. Liliya AbdievaB203
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 445: SPRING / COMCEH-25 / Engineering Computer Graphics / teacher=Dr. Andrei Ermakov / room=B111 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 446: SPRING / COMCEH-25 / Engineering Computer Graphics / teacher=Dr. Burul Shambetova / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 447: SPRING / COMCEH-25 / Engineering Computer Graphics / teacher=Mr. Radmir Gumerov / room=B113 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 448: SPRING / COMCEH-25 / Engineering Computer Graphics / teacher=Ms. Nargiza Zhumalieva / room=B109 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 449: SPRING / COMCEH-25 / Engineering Computer Graphics / teacher=Ms. Zhamby Dzhusubalieva / room=B201 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 450: SPRING / COMCEH-25 / Engineering Computer Graphics / teacher=NULL / room=B101 / source=base_audit:1
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 451: SPRING / COMCEH-25 / Engineering Computer Graphics / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Dr. Ainuuru Zhoolchieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 452: SPRING / COMCEH-25 / English / teacher=Mr. Murray Eldred / room=B101 / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 453: SPRING / COMCEH-25 / English / teacher=Ms. Erika / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 454: SPRING / COMCEH-25 / English / teacher=Ms. Iskra / room=B105 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 455: SPRING / COMCEH-25 / English / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 456: SPRING / COMCEH-25 / English / teacher=NULL / room=B101 / source=base_audit:2
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 457: SPRING / COMCEH-25 / French / teacher=Ms. Iskra / room=B101 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 458: SPRING / COMCEH-25 / French / teacher=Ms. Iskra / room=B104 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 459: SPRING / COMCEH-25 / French / teacher=Ms. Iskra / room=B105 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 460: SPRING / COMCEH-25 / French / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. IskraB104 COM
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 461: SPRING / COMCEH-25 / German / teacher=Ms. Erika / room=B103 / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 462: SPRING / COMCEH-25 / German / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. ErikaB103
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 463: SPRING / COMCEH-25 / Interpersonal Communication in IT / teacher=Mr. Murray Eldred / room=B101 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 464: SPRING / COMCEH-25 / Korean / teacher=Ms. Tattybubu Arap kyzy / room=B106 / source=base_audit:2+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 465: SPRING / COMCEH-25 / Korean / teacher=Ms. Tattybubu Arap kyzy / room=B107 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 466: SPRING / COMCEH-25 / Korean / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 467: SPRING / COMCEH-25 / Korean / teacher=Ms. Tattybubu Arap kyzy / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 468: SPRING / COMCEH-25 / Philosophy / teacher=Ms. Cholpon Alieva / room=B201 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Cholpon Alieva' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 469: SPRING / COMCEH-25 / Philosophy / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Dr. Cholpon Alieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 470: SPRING / COMCEH-25 / Philosophy of Technology / teacher=Ms. Zhamby Dzhusubalieva / room=B201 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 471: SPRING / COMCEH-25 / Physical Education / teacher=Ms. Bopushova Asina / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Bopushova Asina' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 472: SPRING / COMCEH-25 / Physical Education / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. Asina
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 473: SPRING / COMCEH-25 / Programming Language II / teacher=Ms. Zhazgul Alymbaeva / room=LAB5(B213) / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhazgul Alymbaeva' LIMIT 1),
        6, 'ANY', 'COMPUTER_LAB', '6', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 474: SPRING / COMCEH-25 / Programming Python / teacher=Dr. Burul Shambetova / room=BIGLAB / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 475: SPRING / COMCEH-25 / Public Speaking Skills / teacher=Dr. Ainuru Zholchieva / room=B202 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Ainuru Zholchieva' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 476: SPRING / COMCEH-25 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B113 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 477: SPRING / COMCEH-25 / Turkish / teacher=Ms. Elnura / room=B102 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Elnura' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 478: SPRING / COMCEH-25 / Turkish / teacher=Ms. Elnura / room=B105 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Elnura' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 479: SPRING / COMCEH-25 / Turkish / teacher=Ms. Iskra / room=B106 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 480: SPRING / COMCEH-25 / Turkish / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 481: SPRING / COMCEH-25 / Turkish / teacher=NULL / room=B105 / source=base_audit:1
-- original teacher text not in edited base: Ms. Elnura.U
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

-- assignment 482: SPRING / COMFCI-23 / Scientific Industrial Practice / teacher=NULL / room=NULL / source=corrected_skipped:10
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        NULL,
        10, 'ANY', 'CLASSROOM', '10', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

-- assignment 483: SPRING / COMFCI-23 / VR Design / teacher=NULL / room=B111 / source=base_audit:1
-- original teacher text not in edited base: Dr. Ruslan Isaev and Dr. Andrei Ermakov
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'VR Design' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

-- assignment 484: SPRING / COMFCI-24 / Advisor hour / teacher=NULL / room=B101 / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 485: SPRING / COMFCI-24 / Cybersecurity Foundation / teacher=Mr. Ruslan Amanov / room=LAB4(B211) / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 486: SPRING / COMFCI-24 / Design Thinking product solutions / teacher=Dr. Andrei Ermakov / room=B109 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design Thinking product solutions' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        3, 'ANY', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 487: SPRING / COMFCI-24 / Design Thinking product solutions / teacher=Dr. Andrei Ermakov / room=B111 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design Thinking product solutions' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 488: SPRING / COMFCI-24 / Digital Marketing Technologies / teacher=Ms. Meerim Chukaeva / room=B111 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 489: SPRING / COMFCI-24 / Digital Marketing Technologies / teacher=Ms. Meerim Chukaeva / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 490: SPRING / COMFCI-24 / DocuIT: Mastering / teacher=NULL / room=B101 / source=base_audit:2
-- original teacher text not in edited base: Prof. essional Writing in IT Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'DocuIT: Mastering' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 491: SPRING / COMFCI-24 / Geography of Kyrgyzstan / teacher=Mr. Emilbek / room=B101 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Emilbek' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 492: SPRING / COMFCI-24 / History of Kyrgyzstan / teacher=Mr. Alimzhan Zakirov / room=B101 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Alimzhan Zakirov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 493: SPRING / COMFCI-24 / Kyrgyz Language Literature II / teacher=Ms. Duisheeva T. / room=B202 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 494: SPRING / COMFCI-24 / Kyrgyz Language Literature II / teacher=Ms. Orozalieva D. / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 495: SPRING / COMFCI-24 / Kyrgyz Language Literature II / teacher=Ms. Saidalieva A. / room=B203 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 496: SPRING / COMFCI-24 / Kyrgyz Language Literature II / teacher=Ms. Tokusheva T. / room=B101 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 497: SPRING / COMFCI-24 / Kyrgyz Language Literature II / teacher=NULL / room=B204 / source=base_audit:1
-- original teacher text not in edited base: Ms. Samatova.G
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 498: SPRING / COMFCI-24 / Kyrgyz language foreign students / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Ms. Saidalieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 499: SPRING / COMFCI-24 / Manas Studies / teacher=Dr. Kunduz Zhusupbekova / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Kunduz Zhusupbekova' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 500: SPRING / COMFCI-24 / Object Oriented Programming / teacher=NULL / room=LAB3(B210) / source=base_audit:1
-- original teacher text not in edited base: Mr. Daniiar Satybaldiev
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        NULL,
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 501: SPRING / COMFCI-24 / Philosophy of Technology / teacher=Ms. Zhamby Dzhusubalieva / room=B103 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 502: SPRING / COMFCI-24 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 503: SPRING / COMFCI-24 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 504: SPRING / COMFCI-24 / Probability Statistics / teacher=NULL / room=B102 / source=base_audit:1
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 505: SPRING / COMFCI-24 / Probability Statistics / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 506: SPRING / COMFCI-24 / Programming Python / teacher=Ms. Zhibek Namatova / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 507: SPRING / COMFCI-24 / Programming Python / teacher=Ms. Zhibek Namatova / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 508: SPRING / COMFCI-24 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 509: SPRING / COMFCI-24 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B113 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

-- assignment 510: SPRING / COMFCI-25 / Advisor hour / teacher=NULL / room=B201 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 511: SPRING / COMFCI-25 / Calculus II / teacher=Mr. Hussein Chebsi / room=B105 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Hussein Chebsi' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 512: SPRING / COMFCI-25 / Calculus II / teacher=Mr. Hussein Chebsi / room=B205 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Hussein Chebsi' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 513: SPRING / COMFCI-25 / Computer Literacy / teacher=Ms. Nargiza Zhumalieva / room=B109 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 514: SPRING / COMFCI-25 / Discrete Mathematics / teacher=Ms. Liliya Abdieva / room=B201 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Liliya Abdieva' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 515: SPRING / COMFCI-25 / Engineering Computer Graphics / teacher=Dr. Andrei Ermakov / room=B111 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 516: SPRING / COMFCI-25 / Engineering Computer Graphics / teacher=Dr. Burul Shambetova / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 517: SPRING / COMFCI-25 / Engineering Computer Graphics / teacher=Mr. Radmir Gumerov / room=B113 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 518: SPRING / COMFCI-25 / Engineering Computer Graphics / teacher=Ms. Nargiza Zhumalieva / room=B109 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 519: SPRING / COMFCI-25 / Engineering Computer Graphics / teacher=Ms. Zhamby Dzhusubalieva / room=B201 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 520: SPRING / COMFCI-25 / Engineering Computer Graphics / teacher=NULL / room=B101 / source=base_audit:1
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 521: SPRING / COMFCI-25 / Engineering Computer Graphics / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Dr. Ainuuru Zhoolchieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 522: SPRING / COMFCI-25 / English / teacher=Mr. Murray Eldred / room=B101 / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 523: SPRING / COMFCI-25 / English / teacher=Ms. Erika / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 524: SPRING / COMFCI-25 / English / teacher=Ms. Iskra / room=B105 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 525: SPRING / COMFCI-25 / English / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 526: SPRING / COMFCI-25 / English / teacher=NULL / room=B101 / source=base_audit:2
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 527: SPRING / COMFCI-25 / French / teacher=Ms. Iskra / room=B101 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 528: SPRING / COMFCI-25 / French / teacher=Ms. Iskra / room=B104 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 529: SPRING / COMFCI-25 / French / teacher=Ms. Iskra / room=B105 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 530: SPRING / COMFCI-25 / French / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. IskraB104 COM
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 531: SPRING / COMFCI-25 / German / teacher=Ms. Erika / room=B103 / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 532: SPRING / COMFCI-25 / German / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. ErikaB103
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 533: SPRING / COMFCI-25 / Interpersonal Communication in IT / teacher=Mr. Murray Eldred / room=B101 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 534: SPRING / COMFCI-25 / Korean / teacher=Ms. Tattybubu Arap kyzy / room=B106 / source=base_audit:2+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 535: SPRING / COMFCI-25 / Korean / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 536: SPRING / COMFCI-25 / Korean / teacher=Ms. Tattybubu Arap kyzy / room=NULL / source=base_audit:1+corrected_skipped:1
-- original room text not in edited base: B108
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 537: SPRING / COMFCI-25 / Philosophy / teacher=Ms. Cholpon Alieva / room=B201 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Cholpon Alieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 538: SPRING / COMFCI-25 / Philosophy / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Dr. Cholpon Alieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 539: SPRING / COMFCI-25 / Philosophy of Technology / teacher=Ms. Zhamby Dzhusubalieva / room=B201 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 540: SPRING / COMFCI-25 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 541: SPRING / COMFCI-25 / Programming Language II / teacher=Ms. Azhar Kazakbaeva / room=BIGLAB / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        6, 'ANY', 'COMPUTER_LAB', '6', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 542: SPRING / COMFCI-25 / Programming Python / teacher=Dr. Burul Shambetova / room=BIGLAB / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 543: SPRING / COMFCI-25 / Public Speaking Skills / teacher=Dr. Ainuru Zholchieva / room=B202 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Ainuru Zholchieva' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 544: SPRING / COMFCI-25 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B113 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 545: SPRING / COMFCI-25 / Turkish / teacher=Ms. Elnura / room=B102 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Elnura' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 546: SPRING / COMFCI-25 / Turkish / teacher=Ms. Elnura / room=B105 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Elnura' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 547: SPRING / COMFCI-25 / Turkish / teacher=Ms. Iskra / room=B106 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 548: SPRING / COMFCI-25 / Turkish / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 549: SPRING / COMFCI-25 / Turkish / teacher=NULL / room=B105 / source=base_audit:1
-- original teacher text not in edited base: Ms. Elnura.U
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

-- assignment 550: SPRING / COMSE-23 / Scientific Industrial Practice / teacher=NULL / room=NULL / source=corrected_skipped:20
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        NULL,
        20, 'ANY', 'CLASSROOM', '20', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

-- assignment 551: SPRING / COMSE-24 / Advisor hour / teacher=NULL / room=B101 / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 552: SPRING / COMSE-24 / Back-end / teacher=Mr. Talgat Mendekov / room=B110 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Back-end' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        3, 'ANY', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 553: SPRING / COMSE-24 / Back-end / teacher=Mr. Talgat Mendekov / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Back-end' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        3, 'ANY', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 554: SPRING / COMSE-24 / Cybersecurity Foundation / teacher=Mr. Ruslan Amanov / room=LAB4(B211) / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 555: SPRING / COMSE-24 / Digital Marketing Technologies / teacher=Ms. Meerim Chukaeva / room=B111 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 556: SPRING / COMSE-24 / Digital Marketing Technologies / teacher=Ms. Meerim Chukaeva / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 557: SPRING / COMSE-24 / DocuIT: Mastering / teacher=NULL / room=B101 / source=base_audit:2
-- original teacher text not in edited base: Prof. essional Writing in IT Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'DocuIT: Mastering' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 558: SPRING / COMSE-24 / Geography of Kyrgyzstan / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Mr. Emilbek и102
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 559: SPRING / COMSE-24 / History of Kyrgyzstan / teacher=Mr. Alimzhan Zakirov / room=B101 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Alimzhan Zakirov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 560: SPRING / COMSE-24 / Kyrgyz Language Literature II / teacher=Ms. Duisheeva T. / room=B202 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 561: SPRING / COMSE-24 / Kyrgyz Language Literature II / teacher=Ms. Orozalieva D. / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 562: SPRING / COMSE-24 / Kyrgyz Language Literature II / teacher=Ms. Saidalieva A. / room=B203 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 563: SPRING / COMSE-24 / Kyrgyz Language Literature II / teacher=Ms. Tokusheva T. / room=B101 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 564: SPRING / COMSE-24 / Kyrgyz Language Literature II / teacher=NULL / room=B204 / source=base_audit:1
-- original teacher text not in edited base: Ms. Samatova.G
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 565: SPRING / COMSE-24 / Kyrgyz language foreign students / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Ms. Saidalieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 566: SPRING / COMSE-24 / Manas Studies / teacher=Dr. Kunduz Zhusupbekova / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Kunduz Zhusupbekova' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 567: SPRING / COMSE-24 / Object Oriented Programming / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Mr. Daniiar Satybaldiev
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 568: SPRING / COMSE-24 / Philosophy of Technology / teacher=Ms. Zhamby Dzhusubalieva / room=B103 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 569: SPRING / COMSE-24 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 570: SPRING / COMSE-24 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 571: SPRING / COMSE-24 / Probability Statistics / teacher=NULL / room=B102 / source=base_audit:1
-- original teacher text not in edited base: Dr. Ahmad Sarosh
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 572: SPRING / COMSE-24 / Probability Statistics / teacher=NULL / room=B103 / source=base_audit:1
-- original teacher text not in edited base: Dr. Ahmad Sarosh
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 573: SPRING / COMSE-24 / Programming Python / teacher=Ms. Zhibek Namatova / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 574: SPRING / COMSE-24 / Programming Python / teacher=Ms. Zhibek Namatova / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 575: SPRING / COMSE-24 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 576: SPRING / COMSE-24 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B113 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

-- assignment 577: SPRING / COMSE-25 / Advisor hour / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 578: SPRING / COMSE-25 / Calculus II / teacher=Mr. Hussein Chebsi / room=B113 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Hussein Chebsi' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 579: SPRING / COMSE-25 / Computer Literacy / teacher=Ms. Nargiza Zhumalieva / room=B109 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 580: SPRING / COMSE-25 / Discrete Mathematics / teacher=Dr. Sherali Matanov / room=B204 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 581: SPRING / COMSE-25 / Engineering Computer Graphics / teacher=Dr. Andrei Ermakov / room=B111 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 582: SPRING / COMSE-25 / Engineering Computer Graphics / teacher=Dr. Burul Shambetova / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 583: SPRING / COMSE-25 / Engineering Computer Graphics / teacher=Mr. Radmir Gumerov / room=B113 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 584: SPRING / COMSE-25 / Engineering Computer Graphics / teacher=Ms. Nargiza Zhumalieva / room=B109 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 585: SPRING / COMSE-25 / Engineering Computer Graphics / teacher=Ms. Zhamby Dzhusubalieva / room=B201 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 586: SPRING / COMSE-25 / Engineering Computer Graphics / teacher=NULL / room=B101 / source=base_audit:1
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 587: SPRING / COMSE-25 / Engineering Computer Graphics / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Dr. Ainuuru Zhoolchieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 588: SPRING / COMSE-25 / English / teacher=Mr. Murray Eldred / room=B101 / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 589: SPRING / COMSE-25 / English / teacher=Ms. Erika / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 590: SPRING / COMSE-25 / English / teacher=Ms. Iskra / room=B105 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 591: SPRING / COMSE-25 / English / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 592: SPRING / COMSE-25 / English / teacher=NULL / room=B101 / source=base_audit:2
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 593: SPRING / COMSE-25 / French / teacher=Ms. Iskra / room=B101 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 594: SPRING / COMSE-25 / French / teacher=Ms. Iskra / room=B104 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 595: SPRING / COMSE-25 / French / teacher=Ms. Iskra / room=B105 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 596: SPRING / COMSE-25 / French / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. IskraB104 COM
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 597: SPRING / COMSE-25 / German / teacher=Ms. Erika / room=B103 / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 598: SPRING / COMSE-25 / German / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. ErikaB103
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 599: SPRING / COMSE-25 / Interpersonal Communication in IT / teacher=Mr. Murray Eldred / room=B101 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 600: SPRING / COMSE-25 / Korean / teacher=Ms. Tattybubu Arap kyzy / room=B106 / source=base_audit:2+corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 601: SPRING / COMSE-25 / Korean / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 602: SPRING / COMSE-25 / Korean / teacher=Ms. Tattybubu Arap kyzy / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 603: SPRING / COMSE-25 / Philosophy / teacher=Ms. Cholpon Alieva / room=B106 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Cholpon Alieva' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 604: SPRING / COMSE-25 / Philosophy / teacher=Ms. Cholpon Alieva / room=B201 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Cholpon Alieva' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 605: SPRING / COMSE-25 / Philosophy / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Dr. Cholpon Alieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 606: SPRING / COMSE-25 / Philosophy of Technology / teacher=Ms. Zhamby Dzhusubalieva / room=B201 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 607: SPRING / COMSE-25 / Physical Education / teacher=Ms. Bopushova Asina / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Bopushova Asina' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 608: SPRING / COMSE-25 / Physical Education / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Ms. Asina
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 609: SPRING / COMSE-25 / Programming Language II / teacher=Ms. Azhar Kazakbaeva / room=BIGLAB / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        6, 'ANY', 'COMPUTER_LAB', '6', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 610: SPRING / COMSE-25 / Programming Python / teacher=Dr. Burul Shambetova / room=BIGLAB / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 611: SPRING / COMSE-25 / Public Speaking Skills / teacher=Dr. Ainuru Zholchieva / room=B202 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Ainuru Zholchieva' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 612: SPRING / COMSE-25 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B113 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 613: SPRING / COMSE-25 / Turkish / teacher=Ms. Elnura / room=B102 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Elnura' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 614: SPRING / COMSE-25 / Turkish / teacher=Ms. Elnura / room=B105 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Elnura' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 615: SPRING / COMSE-25 / Turkish / teacher=Ms. Iskra / room=B106 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 616: SPRING / COMSE-25 / Turkish / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 617: SPRING / COMSE-25 / Turkish / teacher=NULL / room=B105 / source=base_audit:1
-- original teacher text not in edited base: Ms. Elnura.U
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

-- assignment 618: SPRING / EEAIR-23 / Probability Statistics / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Mr. Samat Elikbaev B WEB
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

-- assignment 619: SPRING / EEAIR-23 / Scientific Industrial Practice / teacher=NULL / room=NULL / source=corrected_skipped:10
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        NULL,
        10, 'ANY', 'CLASSROOM', '10', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

-- assignment 620: SPRING / EEAIR-24 / Advisor hour / teacher=NULL / room=B101 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 621: SPRING / EEAIR-24 / Cybersecurity Foundation / teacher=Mr. Ruslan Amanov / room=LAB4(B211) / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 622: SPRING / EEAIR-24 / Digital Electronics / teacher=Dr. Tauheed Khan / room=LAB5(B213) / source=base_audit:3
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Electronics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        6, 'ANY', 'COMPUTER_LAB', '6', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 623: SPRING / EEAIR-24 / Digital Marketing Technologies / teacher=Ms. Meerim Chukaeva / room=B111 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 624: SPRING / EEAIR-24 / Digital Marketing Technologies / teacher=Ms. Meerim Chukaeva / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 625: SPRING / EEAIR-24 / DocuIT: Mastering / teacher=NULL / room=B101 / source=base_audit:2
-- original teacher text not in edited base: Prof. essional Writing in IT Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'DocuIT: Mastering' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 626: SPRING / EEAIR-24 / Geography of Kyrgyzstan / teacher=Ms. Nurbek Tenirberdiev / room=B113 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nurbek Tenirberdiev' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 627: SPRING / EEAIR-24 / History of Kyrgyzstan / teacher=Dr. Nurgul Erdolatova / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Nurgul Erdolatova' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 628: SPRING / EEAIR-24 / Kyrgyz Language Literature II / teacher=Ms. Duisheeva T. / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 629: SPRING / EEAIR-24 / Kyrgyz Language Literature II / teacher=Ms. Orozalieva D. / room=B102 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 630: SPRING / EEAIR-24 / Kyrgyz Language Literature II / teacher=Ms. Orozalieva D. / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 631: SPRING / EEAIR-24 / Kyrgyz Language Literature II / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Ms. Saidalieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 632: SPRING / EEAIR-24 / Kyrgyz language foreign students / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Ms. Saidalieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 633: SPRING / EEAIR-24 / Manas Studies / teacher=Ms. Roza / room=B105 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Roza' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 634: SPRING / EEAIR-24 / Philosophy of Technology / teacher=Ms. Zhamby Dzhusubalieva / room=B103 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 635: SPRING / EEAIR-24 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 636: SPRING / EEAIR-24 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 637: SPRING / EEAIR-24 / Probability Statistics / teacher=Mr. Samat Elikbaev / room=B105 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 638: SPRING / EEAIR-24 / Probability Statistics / teacher=Mr. Samat Elikbaev / room=LAB5(B213) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 639: SPRING / EEAIR-24 / Programming Python / teacher=Ms. Zhibek Namatova / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 640: SPRING / EEAIR-24 / Programming Python / teacher=Ms. Zhibek Namatova / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 641: SPRING / EEAIR-24 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 642: SPRING / EEAIR-24 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B113 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

-- assignment 643: SPRING / EEAIR-25 / Advisor hour / teacher=NULL / room=B103 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 644: SPRING / EEAIR-25 / Calculus II / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 645: SPRING / EEAIR-25 / Calculus II / teacher=NULL / room=B203 / source=base_audit:1
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 646: SPRING / EEAIR-25 / Calculus II / teacher=NULL / room=B205 / source=base_audit:1
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 647: SPRING / EEAIR-25 / Computer Literacy / teacher=Ms. Nargiza Zhumalieva / room=B109 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 648: SPRING / EEAIR-25 / Discrete Mathematics / teacher=NULL / room=B205 / source=base_audit:1
-- original teacher text not in edited base: Ms. Tattybubu
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 649: SPRING / EEAIR-25 / Discrete Mathematics / teacher=NULL / room=LAB4(B211) / source=base_audit:1
-- original teacher text not in edited base: Ms. Tattybubu
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        NULL,
        3, 'ANY', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 650: SPRING / EEAIR-25 / Engineering Computer Graphics / teacher=Dr. Andrei Ermakov / room=B111 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 651: SPRING / EEAIR-25 / Engineering Computer Graphics / teacher=Dr. Burul Shambetova / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 652: SPRING / EEAIR-25 / Engineering Computer Graphics / teacher=Mr. Radmir Gumerov / room=B113 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 653: SPRING / EEAIR-25 / Engineering Computer Graphics / teacher=Ms. Nargiza Zhumalieva / room=B109 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 654: SPRING / EEAIR-25 / Engineering Computer Graphics / teacher=Ms. Zhamby Dzhusubalieva / room=B201 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 655: SPRING / EEAIR-25 / Engineering Computer Graphics / teacher=NULL / room=B101 / source=base_audit:1
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 656: SPRING / EEAIR-25 / Engineering Computer Graphics / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Dr. Ainuuru Zhoolchieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 657: SPRING / EEAIR-25 / English / teacher=NULL / room=B101 / source=base_audit:2
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 658: SPRING / EEAIR-25 / French / teacher=Ms. Iskra / room=B103 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 659: SPRING / EEAIR-25 / French / teacher=Ms. Iskra / room=B106 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 660: SPRING / EEAIR-25 / French / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 661: SPRING / EEAIR-25 / German / teacher=Ms. Erika / room=B103 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 662: SPRING / EEAIR-25 / Interpersonal Communication in IT / teacher=Mr. Murray Eldred / room=B101 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 663: SPRING / EEAIR-25 / Korean / teacher=Ms. Iskra / room=B106 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 664: SPRING / EEAIR-25 / Korean / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 665: SPRING / EEAIR-25 / Philosophy of Technology / teacher=Ms. Zhamby Dzhusubalieva / room=B201 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 666: SPRING / EEAIR-25 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 667: SPRING / EEAIR-25 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 668: SPRING / EEAIR-25 / Programming Language II / teacher=Ms. Zhazgul Alymbaeva / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhazgul Alymbaeva' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 669: SPRING / EEAIR-25 / Programming Language II / teacher=Ms. Zhazgul Alymbaeva / room=LAB5(B213) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhazgul Alymbaeva' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 670: SPRING / EEAIR-25 / Programming Python / teacher=Dr. Burul Shambetova / room=BIGLAB / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 671: SPRING / EEAIR-25 / Public Speaking Skills / teacher=Dr. Ainuru Zholchieva / room=B202 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Ainuru Zholchieva' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 672: SPRING / EEAIR-25 / Russian language / teacher=Alimpieva L. / room=B102 / source=corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alimpieva L.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 673: SPRING / EEAIR-25 / Russian language / teacher=Tsoi A. / room=B103 / source=base_audit:2+corrected_skipped:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Tsoi A.' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '6', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 674: SPRING / EEAIR-25 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B113 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 675: SPRING / EEAIR-25 / Turkish / teacher=Ms. Elnura / room=B102 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Elnura' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 676: SPRING / EEAIR-25 / Turkish / teacher=NULL / room=B204 / source=base_audit:1
-- original teacher text not in edited base: Ms. Elnura В204
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

-- assignment 677: SPRING / IEMIT-23 / Scientific Industrial Practice / teacher=NULL / room=NULL / source=corrected_skipped:10
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        NULL,
        10, 'ANY', 'CLASSROOM', '10', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

-- assignment 678: SPRING / IEMIT-24 / Advisor hour / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 679: SPRING / IEMIT-24 / Business Fundamentals Process Management / teacher=NULL / room=B105 / source=base_audit:1
-- original teacher text not in edited base: Ms. Azhikulova Kanykei
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Business Fundamentals Process Management' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 680: SPRING / IEMIT-24 / Business Fundamentals Process Management / teacher=NULL / room=B109 / source=base_audit:1
-- original teacher text not in edited base: Ms. Azhikulova Kanykei
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Business Fundamentals Process Management' LIMIT 1),
        NULL,
        3, 'ANY', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 681: SPRING / IEMIT-24 / Cybersecurity Foundation / teacher=Mr. Ruslan Amanov / room=LAB4(B211) / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 682: SPRING / IEMIT-24 / Digital Marketing Technologies / teacher=Ms. Meerim Chukaeva / room=B111 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 683: SPRING / IEMIT-24 / Digital Marketing Technologies / teacher=Ms. Meerim Chukaeva / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 684: SPRING / IEMIT-24 / DocuIT: Mastering / teacher=NULL / room=B101 / source=base_audit:2
-- original teacher text not in edited base: Prof. essional Writing in IT Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'DocuIT: Mastering' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 685: SPRING / IEMIT-24 / Geography of Kyrgyzstan / teacher=Ms. Nurbek Tenirberdiev / room=B113 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nurbek Tenirberdiev' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 686: SPRING / IEMIT-24 / History of Kyrgyzstan / teacher=Dr. Nurgul Erdolatova / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Nurgul Erdolatova' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 687: SPRING / IEMIT-24 / Kyrgyz Language Literature II / teacher=Ms. Duisheeva T. / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 688: SPRING / IEMIT-24 / Kyrgyz Language Literature II / teacher=Ms. Orozalieva D. / room=B102 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 689: SPRING / IEMIT-24 / Kyrgyz Language Literature II / teacher=Ms. Orozalieva D. / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 690: SPRING / IEMIT-24 / Kyrgyz Language Literature II / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Ms. Saidalieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 691: SPRING / IEMIT-24 / Kyrgyz language foreign students / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Ms. Saidalieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 692: SPRING / IEMIT-24 / Manas Studies / teacher=Dr. Kunduz Zhusupbekova / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Kunduz Zhusupbekova' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 693: SPRING / IEMIT-24 / Philosophy of Technology / teacher=Ms. Zhamby Dzhusubalieva / room=B103 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 694: SPRING / IEMIT-24 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 695: SPRING / IEMIT-24 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 696: SPRING / IEMIT-24 / Probability Statistics / teacher=Mr. Samat Elikbaev / room=B111 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 697: SPRING / IEMIT-24 / Probability Statistics / teacher=Mr. Samat Elikbaev / room=B201 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 698: SPRING / IEMIT-24 / Programming Python / teacher=Ms. Zhibek Namatova / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 699: SPRING / IEMIT-24 / Programming Python / teacher=Ms. Zhibek Namatova / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 700: SPRING / IEMIT-24 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 701: SPRING / IEMIT-24 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B113 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

-- assignment 702: SPRING / IEMIT-25 / Advisor hour / teacher=NULL / room=B101 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 703: SPRING / IEMIT-25 / Calculus II / teacher=NULL / room=B201 / source=base_audit:1
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 704: SPRING / IEMIT-25 / Calculus II / teacher=NULL / room=B203 / source=base_audit:1
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 705: SPRING / IEMIT-25 / Calculus II / teacher=NULL / room=B205 / source=base_audit:1
-- original teacher text not in edited base: Mr. Meezan Chand
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 706: SPRING / IEMIT-25 / Discrete Mathematics / teacher=Dr. Sherali Matanov / room=B113 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 707: SPRING / IEMIT-25 / Discrete Mathematics / teacher=Dr. Sherali Matanov / room=B204 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 708: SPRING / IEMIT-25 / English / teacher=NULL / room=B101 / source=base_audit:2
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 709: SPRING / IEMIT-25 / French / teacher=Ms. Iskra / room=B103 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 710: SPRING / IEMIT-25 / French / teacher=Ms. Iskra / room=B106 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 711: SPRING / IEMIT-25 / French / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 712: SPRING / IEMIT-25 / German / teacher=Ms. Erika / room=B103 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 713: SPRING / IEMIT-25 / Korean / teacher=Ms. Iskra / room=B106 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 714: SPRING / IEMIT-25 / Korean / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 715: SPRING / IEMIT-25 / Management / teacher=NULL / room=B113 / source=base_audit:1
-- original teacher text not in edited base: Ms. Azhikulova Kanykei
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Management' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 716: SPRING / IEMIT-25 / Management / teacher=NULL / room=B205 / source=base_audit:1
-- original teacher text not in edited base: Ms. Azhikulova Kanykei
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Management' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 717: SPRING / IEMIT-25 / Philosophy / teacher=NULL / room=B102 / source=base_audit:1
-- original teacher text not in edited base: Mr. s. Cholpon Alieva WEB
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 718: SPRING / IEMIT-25 / Philosophy / teacher=NULL / room=B103 / source=base_audit:1
-- original teacher text not in edited base: Mr. s. Cholpon Alieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 719: SPRING / IEMIT-25 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 720: SPRING / IEMIT-25 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 721: SPRING / IEMIT-25 / Programming Language (Java) / teacher=Ms. Bopushova Asina / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language (Java)' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Bopushova Asina' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 722: SPRING / IEMIT-25 / Programming Language I / teacher=Ms. Bopushova Asina / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Bopushova Asina' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 723: SPRING / IEMIT-25 / Turkish / teacher=Ms. Elnura / room=B102 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Elnura' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 724: SPRING / IEMIT-25 / Turkish / teacher=NULL / room=B204 / source=base_audit:1
-- original teacher text not in edited base: Ms. Elnura В204
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

-- assignment 725: SPRING / MATDAIS-23 / Scientific Industrial Practice / teacher=NULL / room=NULL / source=corrected_skipped:10
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        NULL,
        10, 'ANY', 'CLASSROOM', '10', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)
FROM new_assignment;

-- assignment 726: SPRING / MATDAIS-24 / Advisor hour / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 727: SPRING / MATDAIS-24 / Applied statistics II / teacher=NULL / room=B110 / source=base_audit:1
-- original teacher text not in edited base: Dr. Remudin Mekuria
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Applied statistics II' LIMIT 1),
        NULL,
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 728: SPRING / MATDAIS-24 / Applied statistics II / teacher=NULL / room=B111 / source=base_audit:1
-- original teacher text not in edited base: Dr. Remudin Mekuria
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Applied statistics II' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 729: SPRING / MATDAIS-24 / Data analysis visualization / teacher=NULL / room=B109 / source=base_audit:3
-- original teacher text not in edited base: Dr. Remudin Mekuria
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data analysis visualization' LIMIT 1),
        NULL,
        6, 'ANY', 'COMPUTER_LAB', '6', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 730: SPRING / MATDAIS-24 / Geography of Kyrgyzstan / teacher=Ms. Nurbek Tenirberdiev / room=B201 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nurbek Tenirberdiev' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 731: SPRING / MATDAIS-24 / History of Kyrgyzstan / teacher=Dr. Nurgul Erdolatova / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Nurgul Erdolatova' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 732: SPRING / MATDAIS-24 / Kyrgyz Language Literature II / teacher=Ms. Duisheeva T. / room=B106 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 733: SPRING / MATDAIS-24 / Kyrgyz Language Literature II / teacher=Ms. Orozalieva D. / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 734: SPRING / MATDAIS-24 / Kyrgyz Language Literature II / teacher=Ms. Saidalieva A. / room=B105 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 735: SPRING / MATDAIS-24 / Kyrgyz Language Literature II / teacher=Ms. Tokusheva T. / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 736: SPRING / MATDAIS-24 / Kyrgyz language foreign students / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Ms. Saidalieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 737: SPRING / MATDAIS-24 / Object Oriented Programming / teacher=Dr. Daniiar Satybaldiev / room=LAB4(B211) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Daniiar Satybaldiev' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 738: SPRING / MATDAIS-24 / Object Oriented Programming / teacher=Dr. Daniiar Satybaldiev / room=LAB5(B213) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Daniiar Satybaldiev' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 739: SPRING / MATDAIS-24 / Object Oriented Programming / teacher=NULL / room=LAB4(B211) / source=base_audit:1
-- original teacher text not in edited base: Mr. Daniiar Satybaldiev
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        NULL,
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 740: SPRING / MATDAIS-24 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 741: SPRING / MATDAIS-24 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

-- assignment 742: SPRING / MATDAIS-25 / Advisor hour / teacher=NULL / room=B101 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 743: SPRING / MATDAIS-25 / Calculus II / teacher=Mr. Samat Elikbaev / room=B101 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 744: SPRING / MATDAIS-25 / Calculus II / teacher=Mr. Samat Elikbaev / room=B202 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 745: SPRING / MATDAIS-25 / Calculus II / teacher=Mr. Samat Elikbaev / room=B203 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 746: SPRING / MATDAIS-25 / Computer Literacy / teacher=Ms. Nargiza Zhumalieva / room=B109 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 747: SPRING / MATDAIS-25 / Discrete Mathematics / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 748: SPRING / MATDAIS-25 / Discrete Mathematics / teacher=Ms. Tattybubu Arap kyzy / room=LAB5(B213) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 749: SPRING / MATDAIS-25 / Discrete Mathematics / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Ms. Tattybubu
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 750: SPRING / MATDAIS-25 / Engineering Computer Graphics / teacher=Dr. Andrei Ermakov / room=B111 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 751: SPRING / MATDAIS-25 / Engineering Computer Graphics / teacher=Dr. Burul Shambetova / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 752: SPRING / MATDAIS-25 / Engineering Computer Graphics / teacher=Mr. Radmir Gumerov / room=B113 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 753: SPRING / MATDAIS-25 / Engineering Computer Graphics / teacher=Ms. Nargiza Zhumalieva / room=B109 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 754: SPRING / MATDAIS-25 / Engineering Computer Graphics / teacher=Ms. Zhamby Dzhusubalieva / room=B201 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 755: SPRING / MATDAIS-25 / Engineering Computer Graphics / teacher=NULL / room=B101 / source=base_audit:1
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 756: SPRING / MATDAIS-25 / Engineering Computer Graphics / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Dr. Ainuuru Zhoolchieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 757: SPRING / MATDAIS-25 / English / teacher=NULL / room=B101 / source=base_audit:2
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 758: SPRING / MATDAIS-25 / French / teacher=Ms. Iskra / room=B103 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 759: SPRING / MATDAIS-25 / French / teacher=NULL / room=B205 / source=base_audit:1
-- original teacher text not in edited base: Ms. Tattybubu
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 760: SPRING / MATDAIS-25 / German / teacher=Ms. Erika / room=B103 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 761: SPRING / MATDAIS-25 / Interpersonal Communication in IT / teacher=Mr. Murray Eldred / room=B101 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 762: SPRING / MATDAIS-25 / Korean / teacher=Ms. Aigul / room=B202 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Aigul' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 763: SPRING / MATDAIS-25 / Korean / teacher=Ms. Iskra / room=B106 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 764: SPRING / MATDAIS-25 / Korean / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 765: SPRING / MATDAIS-25 / Philosophy of Technology / teacher=Ms. Zhamby Dzhusubalieva / room=B201 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 766: SPRING / MATDAIS-25 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 767: SPRING / MATDAIS-25 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 768: SPRING / MATDAIS-25 / Programming Language II / teacher=Mr. Erustan Erkebulanov / room=B110 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 769: SPRING / MATDAIS-25 / Programming Language II / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Mr. Erustan Erkebulanov BIGLAВ
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 770: SPRING / MATDAIS-25 / Programming Python / teacher=Dr. Burul Shambetova / room=BIGLAB / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 771: SPRING / MATDAIS-25 / Public Speaking Skills / teacher=Dr. Ainuru Zholchieva / room=B202 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Ainuru Zholchieva' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 772: SPRING / MATDAIS-25 / Russian language / teacher=Chokusheva G. / room=B101 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Chokusheva G.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 773: SPRING / MATDAIS-25 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B113 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 774: SPRING / MATDAIS-25 / Turkish / teacher=Ms. Aigul / room=B202 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Aigul' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

-- assignment 775: SPRING / MATH-22 / Advisor hour / teacher=NULL / room=B202 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

-- assignment 776: SPRING / MATH-22 / Deep Learning / teacher=Ms. Zhibek Namatova / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Deep Learning' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

-- assignment 777: SPRING / MATH-22 / Introduction to Cloud computing / teacher=NULL / room=B103 / source=base_audit:1
-- original teacher text not in edited base: Dr. Ahmad Sarosh
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Cloud computing' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

-- assignment 778: SPRING / MATH-22 / Introduction to Cloud computing / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Dr. Ahmad Sarosh
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Cloud computing' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

-- assignment 779: SPRING / MATH-22 / Methodology of teaching mathematics / teacher=Dr. Sherali Matanov / room=B202 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Methodology of teaching mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

-- assignment 780: SPRING / MATH-22 / Pre qualification practice / teacher=NULL / room=NULL / source=corrected_skipped:5
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Pre qualification practice' LIMIT 1),
        NULL,
        5, 'ANY', 'CLASSROOM', '5', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

-- assignment 781: SPRING / MATMIE-23 / Scientific Industrial Practice / teacher=NULL / room=NULL / source=corrected_skipped:10
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        NULL,
        10, 'ANY', 'CLASSROOM', '10', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

-- assignment 782: SPRING / MATMIE-24 / Advisor hour / teacher=NULL / room=B103 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 783: SPRING / MATMIE-24 / Applied statistics II / teacher=NULL / room=B110 / source=base_audit:1
-- original teacher text not in edited base: Dr. Remudin Mekuria
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Applied statistics II' LIMIT 1),
        NULL,
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 784: SPRING / MATMIE-24 / Applied statistics II / teacher=NULL / room=BIGLAB / source=base_audit:1
-- original teacher text not in edited base: Dr. Remudin Mekuria
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Applied statistics II' LIMIT 1),
        NULL,
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 785: SPRING / MATMIE-24 / Art of teaching methods in informatics / teacher=NULL / room=B109 / source=base_audit:1
-- original teacher text not in edited base: Dr. Remudin Mekuria
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Art of teaching methods in informatics' LIMIT 1),
        NULL,
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 786: SPRING / MATMIE-24 / Art of teaching methods in informatics / teacher=NULL / room=B204 / source=base_audit:2
-- original teacher text not in edited base: Dr. Remudin Mekuria
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Art of teaching methods in informatics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 787: SPRING / MATMIE-24 / Geography of Kyrgyzstan / teacher=Ms. Nurbek Tenirberdiev / room=B201 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nurbek Tenirberdiev' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 788: SPRING / MATMIE-24 / History of Kyrgyzstan / teacher=Dr. Nurgul Erdolatova / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Nurgul Erdolatova' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 789: SPRING / MATMIE-24 / Kyrgyz Language Literature II / teacher=Ms. Duisheeva T. / room=B106 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 790: SPRING / MATMIE-24 / Kyrgyz Language Literature II / teacher=Ms. Orozalieva D. / room=B104 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 791: SPRING / MATMIE-24 / Kyrgyz Language Literature II / teacher=Ms. Saidalieva A. / room=B105 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 792: SPRING / MATMIE-24 / Kyrgyz Language Literature II / teacher=Ms. Tokusheva T. / room=B103 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 793: SPRING / MATMIE-24 / Kyrgyz language foreign students / teacher=NULL / room=B106 / source=base_audit:1
-- original teacher text not in edited base: Ms. Saidalieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 794: SPRING / MATMIE-24 / Object Oriented Programming / teacher=Dr. Daniiar Satybaldiev / room=LAB3(B210) / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Daniiar Satybaldiev' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 795: SPRING / MATMIE-24 / Object Oriented Programming / teacher=Dr. Daniiar Satybaldiev / room=LAB4(B211) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Daniiar Satybaldiev' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 796: SPRING / MATMIE-24 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 797: SPRING / MATMIE-24 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

-- assignment 798: SPRING / MATMIE-25 / Advisor hour / teacher=NULL / room=B101 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 799: SPRING / MATMIE-25 / Advisor hour / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 800: SPRING / MATMIE-25 / Calculus II / teacher=Mr. Samat Elikbaev / room=B202 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 801: SPRING / MATMIE-25 / Calculus II / teacher=Mr. Samat Elikbaev / room=B203 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 802: SPRING / MATMIE-25 / Calculus II / teacher=Mr. Samat Elikbaev / room=B205 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 803: SPRING / MATMIE-25 / Computer Literacy / teacher=Ms. Nargiza Zhumalieva / room=B109 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 804: SPRING / MATMIE-25 / Discrete Mathematics / teacher=Ms. Tattybubu Arap kyzy / room=LAB4(B211) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 805: SPRING / MATMIE-25 / Discrete Mathematics / teacher=Ms. Tattybubu Arap kyzy / room=LAB5(B213) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 806: SPRING / MATMIE-25 / Discrete Mathematics / teacher=NULL / room=B205 / source=base_audit:1
-- original teacher text not in edited base: Ms. Tattybubu
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 807: SPRING / MATMIE-25 / Engineering Computer Graphics / teacher=Dr. Andrei Ermakov / room=B111 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '5', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 808: SPRING / MATMIE-25 / Engineering Computer Graphics / teacher=Dr. Burul Shambetova / room=BIGLAB / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 809: SPRING / MATMIE-25 / Engineering Computer Graphics / teacher=Mr. Radmir Gumerov / room=B113 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 810: SPRING / MATMIE-25 / Engineering Computer Graphics / teacher=Ms. Nargiza Zhumalieva / room=B109 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 811: SPRING / MATMIE-25 / Engineering Computer Graphics / teacher=Ms. Zhamby Dzhusubalieva / room=B201 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 812: SPRING / MATMIE-25 / Engineering Computer Graphics / teacher=NULL / room=B101 / source=base_audit:1
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 813: SPRING / MATMIE-25 / Engineering Computer Graphics / teacher=NULL / room=B202 / source=base_audit:1
-- original teacher text not in edited base: Dr. Ainuuru Zhoolchieva
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 814: SPRING / MATMIE-25 / English / teacher=NULL / room=B101 / source=base_audit:2
-- original teacher text not in edited base: Mr. Murray
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 815: SPRING / MATMIE-25 / French / teacher=Ms. Iskra / room=B103 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 816: SPRING / MATMIE-25 / French / teacher=NULL / room=B205 / source=base_audit:1
-- original teacher text not in edited base: Ms. Tattybubu
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        NULL,
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 817: SPRING / MATMIE-25 / German / teacher=Ms. Erika / room=B103 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 818: SPRING / MATMIE-25 / Interpersonal Communication in IT / teacher=Mr. Murray Eldred / room=B101 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 819: SPRING / MATMIE-25 / Korean / teacher=Ms. Aigul / room=B202 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Aigul' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 820: SPRING / MATMIE-25 / Korean / teacher=Ms. Iskra / room=B106 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 821: SPRING / MATMIE-25 / Korean / teacher=Ms. Tattybubu Arap kyzy / room=B205 / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 822: SPRING / MATMIE-25 / Philosophy of Technology / teacher=Ms. Zhamby Dzhusubalieva / room=B201 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 823: SPRING / MATMIE-25 / Physical Education / teacher=Mr. Chynybekov Z. / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'ANY', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 824: SPRING / MATMIE-25 / Physical Education / teacher=Ms. Abdykadyrova N. / room=NULL / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 825: SPRING / MATMIE-25 / Programming Language II / teacher=Mr. Erustan Erkebulanov / room=BIGLAB / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '4', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 826: SPRING / MATMIE-25 / Programming Language II / teacher=Mr. Erustan Erkebulanov / room=LAB3(B210) / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        2, 'ANY', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 827: SPRING / MATMIE-25 / Programming Python / teacher=Dr. Burul Shambetova / room=BIGLAB / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        1, 'ANY', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 828: SPRING / MATMIE-25 / Public Speaking Skills / teacher=Dr. Ainuru Zholchieva / room=B202 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Ainuru Zholchieva' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 829: SPRING / MATMIE-25 / Russian language / teacher=Alimpieva L. / room=B102 / source=base_audit:2
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alimpieva L.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '4', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 830: SPRING / MATMIE-25 / Startup: from idea to launch / teacher=Mr. Radmir Gumerov / room=B113 / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        1, 'ANY', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 831: SPRING / MATMIE-25 / Turkish / teacher=Ms. Aigul / room=B202 / source=base_audit:1+corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Aigul' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

-- assignment 832: SPRING / MCOM-24 / Data engineering / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Dr. Ruslan Isaev [18:30]
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data engineering' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-24' LIMIT 1)
FROM new_assignment;

-- assignment 833: SPRING / MCOM-25 / Advanced Algorithms / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Dr. Mekia Gaso
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advanced Algorithms' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-25' LIMIT 1)
FROM new_assignment;

-- assignment 834: SPRING / MCOM-25 / Computer Vision Algorithms / teacher=Dr. Tauheed Khan / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Vision Algorithms' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-25' LIMIT 1)
FROM new_assignment;

-- assignment 835: SPRING / MCOM-25 / Maths Data Science / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Dr. Remudin Mekuria
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Maths Data Science' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-25' LIMIT 1)
FROM new_assignment;

-- assignment 836: SPRING / MCOM-25 / NLP / teacher=Dr. Musa Abdujabbarov / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'NLP' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Musa Abdujabbarov' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-25' LIMIT 1)
FROM new_assignment;

-- assignment 837: SPRING / MCOM-25 / Research Methods / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Dr. Remudin Mekuria
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Research Methods' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-25' LIMIT 1)
FROM new_assignment;

-- assignment 838: SPRING / PHD-23 / Supervisor Review / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Supervisor Review' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-23' LIMIT 1)
FROM new_assignment;

-- assignment 839: SPRING / PHD-24 / Pedagogical research internship / teacher=NULL / room=NULL / source=corrected_skipped:3
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Pedagogical research internship' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-24' LIMIT 1)
FROM new_assignment;

-- assignment 840: SPRING / PHD-24 / Supervisor Review / teacher=NULL / room=NULL / source=corrected_skipped:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Supervisor Review' LIMIT 1),
        NULL,
        1, 'ANY', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-24' LIMIT 1)
FROM new_assignment;

-- assignment 841: SPRING / PHD-25 / NLP / teacher=Dr. Musa Abdujabbarov / room=NULL / source=base_audit:1
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'NLP' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Musa Abdujabbarov' LIMIT 1),
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)
FROM new_assignment;

-- assignment 842: SPRING / PHD-25 / Scientific Seminar / teacher=NULL / room=NULL / source=base_audit:1
-- original teacher text not in edited base: Dr. Ruslan Isaev [18:30 - 20:30]
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Seminar' LIMIT 1),
        NULL,
        3, 'ANY', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)
FROM new_assignment;
