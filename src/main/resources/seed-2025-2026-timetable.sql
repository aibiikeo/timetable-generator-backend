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

        IF to_regclass('public.users') IS NOT NULL THEN
            ALTER TABLE public.users
                ALTER COLUMN quick_actions_auto_enabled SET DEFAULT TRUE;

            UPDATE public.users
            SET quick_actions_auto_enabled = TRUE
            WHERE quick_actions_auto_enabled IS NULL;

            DELETE FROM public.users
            WHERE email <> 'superadmin@example.com';
        END IF;
    END $$;

-- FACULTIES
INSERT INTO faculties (name) VALUES
    ('Faculty of Engineering and Informatics'),
    ('Faculty of Economics and Administrative Sciences'),
    ('Faculty of Law'),
    ('Faculty of Social Sciences / Humanities'),
    ('Faculty of Medicine');

-- DEPARTMENTS
INSERT INTO departments (name, faculty_id) VALUES
    ('Department of Computer Science', (SELECT id FROM faculties WHERE name = 'Faculty of Engineering and Informatics' LIMIT 1)),
    ('Department of Applied Mathematics and Informatics', (SELECT id FROM faculties WHERE name = 'Faculty of Engineering and Informatics' LIMIT 1)),
    ('Economics (Finance and Credit)', (SELECT id FROM faculties WHERE name = 'Faculty of Economics and Administrative Sciences' LIMIT 1)),
    ('Economics (International Economics & Business)', (SELECT id FROM faculties WHERE name = 'Faculty of Economics and Administrative Sciences' LIMIT 1)),
    ('Management', (SELECT id FROM faculties WHERE name = 'Faculty of Economics and Administrative Sciences' LIMIT 1)),
    ('DLC - Management', (SELECT id FROM faculties WHERE name = 'Faculty of Economics and Administrative Sciences' LIMIT 1)),
    ('Jurisprudence', (SELECT id FROM faculties WHERE name = 'Faculty of Law' LIMIT 1)),
    ('International and Business Law', (SELECT id FROM faculties WHERE name = 'Faculty of Law' LIMIT 1)),
    ('Public Relations and Advertising', (SELECT id FROM faculties WHERE name = 'Faculty of Social Sciences / Humanities' LIMIT 1)),
    ('Center of Foreign Languages', (SELECT id FROM faculties WHERE name = 'Faculty of Social Sciences / Humanities' LIMIT 1)),
    ('International Relations', (SELECT id FROM faculties WHERE name = 'Faculty of Social Sciences / Humanities' LIMIT 1)),
    ('Journalism', (SELECT id FROM faculties WHERE name = 'Faculty of Social Sciences / Humanities' LIMIT 1)),
    ('Linguistics (Chinese language, translation and translation studies)', (SELECT id FROM faculties WHERE name = 'Faculty of Social Sciences / Humanities' LIMIT 1)),
    ('Linguistics (Translation and translation studies)', (SELECT id FROM faculties WHERE name = 'Faculty of Social Sciences / Humanities' LIMIT 1)),
    ('Pedagogy (Elementary School Teaching)', (SELECT id FROM faculties WHERE name = 'Faculty of Social Sciences / Humanities' LIMIT 1)),
    ('Philology (Teacher of English language and literature)', (SELECT id FROM faculties WHERE name = 'Faculty of Social Sciences / Humanities' LIMIT 1)),
    ('Philology (Turkology)', (SELECT id FROM faculties WHERE name = 'Faculty of Social Sciences / Humanities' LIMIT 1)),
    ('Psychology', (SELECT id FROM faculties WHERE name = 'Faculty of Social Sciences / Humanities' LIMIT 1)),
    ('DLC - Institute of Natural and Social Sciences', (SELECT id FROM faculties WHERE name = 'Faculty of Social Sciences / Humanities' LIMIT 1)),
    ('General medicine', (SELECT id FROM faculties WHERE name = 'Faculty of Medicine' LIMIT 1));

-- MAJORS
INSERT INTO majors (name, short_name, department_id) VALUES
    ('COM', 'COM', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1)),
    ('COMCEH', 'COMCEH', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1)),
    ('COMFCI', 'COMFCI', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1)),
    ('COMSE', 'COMSE', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1)),
    ('EEAIR', 'EEAIR', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1)),
    ('IEMIT', 'IEMIT', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1)),
    ('MATDAIS', 'MATDAIS', (SELECT id FROM departments WHERE name = 'Department of Applied Mathematics and Informatics' LIMIT 1)),
    ('MATH', 'MATH', (SELECT id FROM departments WHERE name = 'Department of Applied Mathematics and Informatics' LIMIT 1)),
    ('MATMIE', 'MATMIE', (SELECT id FROM departments WHERE name = 'Department of Applied Mathematics and Informatics' LIMIT 1)),
    ('MCOM', 'MCOM', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1)),
    ('PHD', 'PHD', (SELECT id FROM departments WHERE name = 'Department of Computer Science' LIMIT 1)),
    ('Economics (Finance and Credit)', '10203', (SELECT id FROM departments WHERE name = 'Economics (Finance and Credit)' LIMIT 1)),
    ('Environmental economics', '10213', (SELECT id FROM departments WHERE name = 'Economics (International Economics & Business)' LIMIT 1)),
    ('Economics (International Economics & Business)', '10211', (SELECT id FROM departments WHERE name = 'Economics (International Economics & Business)' LIMIT 1)),
    ('Economics', '12605', (SELECT id FROM departments WHERE name = 'Economics (International Economics & Business)' LIMIT 1)),
    ('Hospitality and Tourism Industry Management', '10212', (SELECT id FROM departments WHERE name = 'Management' LIMIT 1)),
    ('Management', '10209', (SELECT id FROM departments WHERE name = 'Management' LIMIT 1)),
    ('Economics and Management', '14604', (SELECT id FROM departments WHERE name = 'Management' LIMIT 1)),
    ('Master of Business Administration', '10614', (SELECT id FROM departments WHERE name = 'Management' LIMIT 1)),
    ('Management (Master)', '12803', (SELECT id FROM departments WHERE name = 'DLC - Management' LIMIT 1)),
    ('Jurisprudence (International and Business Law)', '10207', (SELECT id FROM departments WHERE name = 'International and Business Law' LIMIT 1)),
    ('Jurisprudence', '12210', (SELECT id FROM departments WHERE name = 'International and Business Law' LIMIT 1)),
    ('Public Relations and Advertising', '10308', (SELECT id FROM departments WHERE name = 'Public Relations and Advertising' LIMIT 1)),
    ('International Relations', '10206', (SELECT id FROM departments WHERE name = 'International Relations' LIMIT 1)),
    ('Journalism', '10307', (SELECT id FROM departments WHERE name = 'Journalism' LIMIT 1)),
    ('Linguistics (Chinese language, translation and translation studies)', '10302', (SELECT id FROM departments WHERE name = 'Linguistics (Chinese language, translation and translation studies)' LIMIT 1)),
    ('Chinese Language and Literature', '10303', (SELECT id FROM departments WHERE name = 'Linguistics (Chinese language, translation and translation studies)' LIMIT 1)),
    ('Linguistics (Translation and Translation Studies)', '10311', (SELECT id FROM departments WHERE name = 'Linguistics (Translation and translation studies)' LIMIT 1)),
    ('Linguistics', '12608', (SELECT id FROM departments WHERE name = 'Linguistics (Translation and translation studies)' LIMIT 1)),
    ('Stem education', '10315', (SELECT id FROM departments WHERE name = 'Pedagogy (Elementary School Teaching)' LIMIT 1)),
    ('Pedagogy (Elementary School Teaching)', '10304', (SELECT id FROM departments WHERE name = 'Pedagogy (Elementary School Teaching)' LIMIT 1)),
    ('Pedagogy', '14625', (SELECT id FROM departments WHERE name = 'Pedagogy (Elementary School Teaching)' LIMIT 1)),
    ('General Pedagogy, History of Education and Pedagogy', '14619', (SELECT id FROM departments WHERE name = 'Pedagogy (Elementary School Teaching)' LIMIT 1)),
    ('Psychological Counseling and Guidance', '10309', (SELECT id FROM departments WHERE name = 'Pedagogy (Elementary School Teaching)' LIMIT 1)),
    ('Philology (English Language and Literature)', '10306', (SELECT id FROM departments WHERE name = 'Philology (Teacher of English language and literature)' LIMIT 1)),
    ('Philology', '14628', (SELECT id FROM departments WHERE name = 'Philology (Teacher of English language and literature)' LIMIT 1)),
    ('Philology (Turkology)', '12611', (SELECT id FROM departments WHERE name = 'Philology (Turkology)' LIMIT 1)),
    ('Turkoloji', '10313', (SELECT id FROM departments WHERE name = 'Philology (Turkology)' LIMIT 1)),
    ('Turkish languages', '14623', (SELECT id FROM departments WHERE name = 'Philology (Turkology)' LIMIT 1)),
    ('Psychology', '10314', (SELECT id FROM departments WHERE name = 'Psychology' LIMIT 1)),
    ('Pedagogy (Master)', '12804', (SELECT id FROM departments WHERE name = 'DLC - Institute of Natural and Social Sciences' LIMIT 1)),
    ('General Medicine', '10401', (SELECT id FROM departments WHERE name = 'General medicine' LIMIT 1));

-- STUDY GROUPS
INSERT INTO study_groups (name, major_id, degree, course, student_count) VALUES
    ('COM-22', (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1), 'BACHELOR', 4, 29),
    ('COMCEH-23', (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1), 'BACHELOR', 3, 25),
    ('COMCEH-24', (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1), 'BACHELOR', 2, 30),
    ('COMCEH-25', (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1), 'BACHELOR', 1, 24),
    ('COMFCI-23', (SELECT id FROM majors WHERE short_name = 'COMFCI' LIMIT 1), 'BACHELOR', 3, 20),
    ('COMFCI-24', (SELECT id FROM majors WHERE short_name = 'COMFCI' LIMIT 1), 'BACHELOR', 2, 38),
    ('COMFCI-25', (SELECT id FROM majors WHERE short_name = 'COMFCI' LIMIT 1), 'BACHELOR', 1, 31),
    ('COMSE-23', (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1), 'BACHELOR', 3, 35),
    ('COMSE-24', (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1), 'BACHELOR', 2, 30),
    ('COMSE-25', (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1), 'BACHELOR', 1, 31),
    ('EEAIR-23', (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1), 'BACHELOR', 3, 20),
    ('EEAIR-24', (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1), 'BACHELOR', 2, 32),
    ('EEAIR-25', (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1), 'BACHELOR', 1, 35),
    ('IEMIT-23', (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1), 'BACHELOR', 3, 39),
    ('IEMIT-24', (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1), 'BACHELOR', 2, 20),
    ('IEMIT-25', (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1), 'BACHELOR', 1, 24),
    ('MATDAIS-23', (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1), 'BACHELOR', 3, 40),
    ('MATDAIS-24', (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1), 'BACHELOR', 2, 35),
    ('MATDAIS-25', (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1), 'BACHELOR', 1, 39),
    ('MATH-22', (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1), 'BACHELOR', 4, 32),
    ('MATMIE-23', (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1), 'BACHELOR', 3, 26),
    ('MATMIE-24', (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1), 'BACHELOR', 2, 26),
    ('MATMIE-25', (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1), 'BACHELOR', 1, 22),
    ('MCOM-1', (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1), 'MASTER', 1, 23),
    ('MCOM-2', (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1), 'MASTER', 1, 20),
    ('MCOM-24', (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1), 'MASTER', 1, 32),
    ('MCOM-25', (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1), 'MASTER', 1, 37),
    ('PHD-23', (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1), 'PHD', 1, 35),
    ('PHD-24', (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1), 'PHD', 1, 25),
    ('PHD-25', (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1), 'PHD', 1, 36);

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
    ('Advanced Algorithms', 'SRC-25001', 45, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Advanced Image Processing', 'SRC-25002', 45, 3, (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1)),
    ('Algebra Geometry', 'SRC-25003', 90, 6, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Applied statistics I', 'SRC-25004', 30, 2, (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1)),
    ('Applied statistics II', 'SRC-25005', 60, 4, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Art of teaching methods in informatics', 'SRC-25006', 90, 6, (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1)),
    ('Artificial Intelligence Deep Learning', 'SRC-25007', 45, 3, (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1)),
    ('Attacts defences', 'SRC-25008', 120, 8, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Back-end', 'SRC-25009', 90, 6, (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1)),
    ('Basics of science research', 'SRC-25010', 180, 12, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Business Fundamentals Process Management', 'SRC-25011', 90, 6, (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1)),
    ('C# (Advanced C#)', 'SRC-25012', 180, 12, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Calculus III', 'SRC-25015', 90, 6, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Calculus I', 'SRC-25016', 120, 8, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Calculus II', 'SRC-25017', 90, 6, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Cloud computing', 'SRC-25018', 180, 12, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Computer Architecture Operation systems', 'SRC-25019', 180, 12, (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1)),
    ('Computational Mathematics', 'SRC-25021', 30, 2, (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1)),
    ('Computer Vision Algorithms', 'SRC-25024', 45, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Cybersecurity Foundation', 'SRC-25025', 90, 6, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Design visualization', 'SRC-25027', 60, 4, (SELECT id FROM majors WHERE short_name = 'COMFCI' LIMIT 1)),
    ('Data analysis visualization', 'SRC-25028', 90, 6, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Data engineering', 'SRC-25029', 45, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Data science specialty mathematics', 'SRC-25030', 120, 8, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Data Science storage', 'SRC-25031', 180, 12, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Data Visualization Analysis Tools', 'SRC-25032', 45, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Databases', 'SRC-25033', 120, 8, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Deep Learning', 'SRC-25034', 60, 4, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Design & Analysis of Algorithms', 'SRC-25035', 180, 12, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Design Thinking product solutions', 'SRC-25036', 90, 6, (SELECT id FROM majors WHERE short_name = 'COMFCI' LIMIT 1)),
    ('Digital Design', 'SRC-25037', 30, 2, (SELECT id FROM majors WHERE short_name = 'COMFCI' LIMIT 1)),
    ('Digital Electronics', 'SRC-25038', 90, 6, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Digital Marketing Technologies', 'SRC-25039', 60, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Discrete Mathematics', 'SRC-25041', 90, 6, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('DocuIT: Mastering', 'SRC-25042', 60, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Educational Technology Learning Systems', 'SRC-25043', 90, 6, (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1)),
    ('Electronic components circuits', 'SRC-25044', 60, 4, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Engineering Computer Graphics', 'SRC-25045', 180, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('English', 'SRC-25046', 180, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Ethical Hacking Penetration Testing', 'SRC-25047', 90, 6, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Financial Math', 'SRC-25048', 60, 4, (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1)),
    ('Foundation Maths Data Science', 'SRC-25049', 45, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('French', 'SRC-25050', 180, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Frontend', 'SRC-25051', 90, 6, (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1)),
    ('Functional analysis', 'SRC-25052', 105, 7, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Fundamentals of Scientific Research', 'SRC-25053', 45, 3, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Geography of Kyrgyzstan', 'SRC-25055', 30, 2, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('German', 'SRC-25056', 120, 8, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('History of Kyrgyzstan', 'SRC-25057', 60, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Human Computer Interaction', 'SRC-25058', 60, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Image Processing Computer Vision', 'SRC-25059', 45, 3, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Intelligent data analysis', 'SRC-25060', 105, 7, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Interpersonal Communication in IT', 'SRC-25061', 60, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Introduction to Cloud computing', 'SRC-25062', 90, 6, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Introduction to Data Analysis', 'SRC-25063', 45, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Introduction to Engineering', 'SRC-25064', 30, 2, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Korean', 'SRC-25067', 180, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Kyrgyz', 'SRC-25069', 180, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Kyrgyz language foreign students', 'SRC-25070', 60, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Kyrgyz Language Literature II', 'SRC-25072', 180, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Machine Learning', 'SRC-25073', 75, 5, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Management', 'SRC-25075', 90, 6, (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1)),
    ('Manas Studies', 'SRC-25076', 30, 2, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Mastering', 'SRC-25078', 60, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Mathematical tools signal calculation', 'SRC-25079', 60, 4, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Maths Data Science', 'SRC-25080', 45, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Methodology of teaching mathematics', 'SRC-25081', 60, 4, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Methods of Optimizations', 'SRC-25082', 135, 9, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Mobile App Development', 'SRC-25083', 180, 12, (SELECT id FROM majors WHERE short_name = 'COMSE' LIMIT 1)),
    ('NLP', 'SRC-25084', 45, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Number Theory', 'SRC-25085', 105, 7, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Object Oriented Programming', 'SRC-25086', 150, 10, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Optimization Methods', 'SRC-25091', 60, 4, (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1)),
    ('Pedagogy', 'SRC-25092', 45, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Psychology of Higher Education', 'SRC-25097', 45, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Philosophy', 'SRC-25093', 90, 6, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Philosophy of Technology', 'SRC-25094', 60, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Physical Education', 'SRC-25095', 180, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Probability Statistics', 'SRC-25096', 150, 10, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Programming Interface of the Microcontroller', 'SRC-25098', 60, 4, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Programming Language (Java)', 'SRC-25100', 90, 6, (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1)),
    ('Programming Language II', 'SRC-25102', 90, 6, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Programming Language I', 'SRC-25103', 90, 6, (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1)),
    ('Programming Python', 'SRC-25104', 60, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Project Product Management', 'SRC-25105', 90, 6, (SELECT id FROM majors WHERE short_name = 'IEMIT' LIMIT 1)),
    ('Public Speaking Skills', 'SRC-25106', 60, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Research in Applied Data Science', 'SRC-25108', 135, 9, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Research Methods', 'SRC-25109', 45, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Engineering Economy', 'SRC-25110', 90, 6, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Robotics Foundation', 'SRC-25111', 60, 4, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Russian language', 'SRC-25112', 60, 4, (SELECT id FROM majors WHERE short_name = 'MATDAIS' LIMIT 1)),
    ('Scientific Industrial Practice', 'SRC-25120', 45, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Scientific Seminar', 'SRC-25121', 90, 6, (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1)),
    ('Software Engineering', 'SRC-25122', 180, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Startup: from idea to launch', 'SRC-25123', 60, 4, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Teaching Practice', 'SRC-25125', 45, 3, (SELECT id FROM majors WHERE short_name = 'MCOM' LIMIT 1)),
    ('Turkish', 'SRC-25126', 180, 12, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Variable Part (Applied statistics)', 'SRC-25127', 60, 4, (SELECT id FROM majors WHERE short_name = 'MATMIE' LIMIT 1)),
    ('VR Design', 'SRC-25128', 60, 4, (SELECT id FROM majors WHERE short_name = 'COMFCI' LIMIT 1));

INSERT INTO subjects (name, code, total_hours, hours_per_week, major_id) VALUES
    ('Advisor hour', 'SRC-25129', 30, 2, (SELECT id FROM majors WHERE short_name = 'EEAIR' LIMIT 1)),
    ('Computer Literacy', 'SRC-25130', 15, 1, (SELECT id FROM majors WHERE short_name = 'COMCEH' LIMIT 1)),
    ('Pedagogical research internship', 'SRC-25131', 45, 3, (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1)),
    ('Pre qualification internship', 'SRC-25132', 15, 1, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Pre qualification practice', 'SRC-25133', 75, 5, (SELECT id FROM majors WHERE short_name = 'MATH' LIMIT 1)),
    ('Pre qualificational Internship', 'SRC-25134', 15, 1, (SELECT id FROM majors WHERE short_name = 'COM' LIMIT 1)),
    ('Scientific research internship', 'SRC-25135', 45, 3, (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1)),
    ('Supervisor Review', 'SRC-25136', 15, 1, (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1));

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
INSERT INTO timetables (name, academic_year_start, academic_year_end, semester, faculty_id, version, created_at, status, generation_settings, conflict_report) VALUES
    ('Course Schedule FALL 2025-2026 v0', 2025, 2026, 'FALL', (SELECT id FROM faculties WHERE name = 'Faculty of Engineering and Informatics' LIMIT 1), 0, NOW(), 'DRAFT', NULL, NULL),
    ('Course Schedule SPRING 2025-2026 v0', 2025, 2026, 'SPRING', (SELECT id FROM faculties WHERE name = 'Faculty of Engineering and Informatics' LIMIT 1), 0, NOW(), 'DRAFT', NULL, NULL);

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
INSERT INTO users (email, password, role, quick_actions_auto_enabled) VALUES
    ('admin@university.kg', '$2a$08$a6r..ZYW.BK0UB0yJSwfc.30Alt2gSzmK/c0kkqLGqK7tIm9HVk/2', 'ADMIN', TRUE),
    ('scheduler@university.kg', '$2a$08$Iy5qn7TWG6LI.D2ATDvL5uPOftseKIhhWXUzyFHYnts1tFA1DNPNi', 'ADMIN', TRUE);

-- ASSIGNMENTS + ASSIGNMENT <-> GROUP
WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'MORNING', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Basics of science research' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ermek Doszhanov' LIMIT 1),
        8, 'AFTERNOON', 'CLASSROOM', '2+2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Basics of science research' LIMIT 1),
        NULL,
        8, 'ANY', 'CLASSROOM', '2+2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data Science storage' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data Science storage' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Mekia Gaso' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data Science storage' LIMIT 1),
        NULL,
        10, 'ANY', 'CLASSROOM', '2+2+2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Machine Learning' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Pre qualification internship' LIMIT 1),
        NULL,
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Attacts defences' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        1, 'MORNING', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Attacts defences' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        9, 'AFTERNOON', 'CLASSROOM', '2+2+2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computational Mathematics' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        4, 'MORNING', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1),
        NULL,
        4, 'MORNING', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        3, 'MORNING', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        4, 'AFTERNOON', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Sumaiya' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alimpieva L.' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Chokusheva G.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        NULL,
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        NULL,
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Tsoi A.' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design visualization' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        4, 'AFTERNOON', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        6, 'MORNING', 'CLASSROOM', '2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computational Mathematics' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computational Mathematics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Design' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1),
        NULL,
        4, 'MORNING', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Daniiar Satybaldiev' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        NULL,
        5, 'MORNING', 'CLASSROOM', '2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Sumaiya' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alimpieva L.' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Chokusheva G.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        NULL,
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        NULL,
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Tsoi A.' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        3, 'AFTERNOON', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Suleyman Saparov' LIMIT 1),
        3, 'MORNING', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Suleyman Saparov' LIMIT 1),
        5, 'AFTERNOON', 'CLASSROOM', '2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mobile App Development' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Mutalip' LIMIT 1),
        4, 'MORNING', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mobile App Development' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Mutalip' LIMIT 1),
        2, 'AFTERNOON', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mobile App Development' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mobile App Development' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mobile App Development' LIMIT 1),
        NULL,
        10, 'AFTERNOON', 'CLASSROOM', '2+2+2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        6, 'ANY', 'CLASSROOM', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Mekia Gaso' LIMIT 1),
        4, 'MORNING', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Mekia Gaso' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B112' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computational Mathematics' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        2, 'AFTERNOON', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Frontend' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Niyazkhan Shabdanalov' LIMIT 1),
        4, 'MORNING', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Frontend' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'C005' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        NULL,
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        NULL,
        7, 'AFTERNOON', 'CLASSROOM', '2+2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Sumaiya' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        3, 'MORNING', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        3, 'AFTERNOON', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alimpieva L.' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alymbekova S.' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Chokusheva G.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        NULL,
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        NULL,
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Tsoi A.' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design & Analysis of Algorithms' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        6, 'MORNING', 'CLASSROOM', '2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design & Analysis of Algorithms' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Machine Learning' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Machine Learning' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        6, 'AFTERNOON', 'CLASSROOM', '2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Interface of the Microcontroller' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Niyazkhan Shabdanalov' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Architecture Operation systems' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Arslan Khan' LIMIT 1),
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        6, 'AFTERNOON', 'CLASSROOM', '2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Electronic components circuits' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mathematical tools signal calculation' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Robotics Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Nich Kawaguchi' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        3, 'MORNING', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design & Analysis of Algorithms' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design & Analysis of Algorithms' LIMIT 1),
        NULL,
        4, 'MORNING', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design & Analysis of Algorithms' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Project Product Management' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Aidai Atakulova' LIMIT 1),
        6, 'AFTERNOON', 'CLASSROOM', '2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Databases' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Financial Math' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Management' LIMIT 1),
        NULL,
        6, 'MORNING', 'CLASSROOM', '2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Project Product Management' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Aidai Atakulova' LIMIT 1),
        6, 'AFTERNOON', 'CLASSROOM', '2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language (Java)' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Bopushova Asina' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Bopushova Asina' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Tsoi A.' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Intelligent data analysis' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Remudin Mecuria' LIMIT 1),
        7, 'MORNING', 'CLASSROOM', '2+2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Methods of Optimizations' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Methods of Optimizations' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Methods of Optimizations' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        8, 'MORNING', 'CLASSROOM', '2+2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus III' LIMIT 1),
        NULL,
        6, 'AFTERNOON', 'CLASSROOM', '2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data science specialty mathematics' LIMIT 1),
        NULL,
        6, 'MORNING', 'CLASSROOM', '2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Meerim Mairykova' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1),
        NULL,
        4, 'MORNING', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        5, 'AFTERNOON', 'CLASSROOM', '2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        NULL,
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ermek Doszhanov' LIMIT 1),
        4, 'MORNING', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ermek Doszhanov' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        1, 'AFTERNOON', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Functional analysis' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1),
        7, 'MORNING', 'CLASSROOM', '2+2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Fundamentals of Scientific Research' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Machine Learning' LIMIT 1),
        NULL,
        5, 'ANY', 'CLASSROOM', '2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Number Theory' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Number Theory' LIMIT 1),
        NULL,
        5, 'AFTERNOON', 'CLASSROOM', '2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Educational Technology Learning Systems' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Methods of Optimizations' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B107' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Methods of Optimizations' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Optimization Methods' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B112' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus III' LIMIT 1),
        NULL,
        6, 'MORNING', 'CLASSROOM', '2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Human Computer Interaction' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Meerim Mairykova' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Mastering' LIMIT 1),
        NULL,
        4, 'MORNING', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Hussein Chebsi' LIMIT 1),
        5, 'AFTERNOON', 'CLASSROOM', '2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        5, 'MORNING', 'CLASSROOM', '2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Variable Part (Applied statistics)' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Algebra Geometry' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus I' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        5, 'MORNING', 'CLASSROOM', '2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        5, 'AFTERNOON', 'CLASSROOM', '2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ermek Doszhanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ermek Doszhanov' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Aigul' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Deep Learning' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Musa Abdujabbarov' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-1' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Foundation Maths Data Science' LIMIT 1),
        NULL,
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-1' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Machine Learning' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        3, 'MORNING', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-1' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Psychology of Higher Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Ainuru Zholchieva' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-1' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data engineering' LIMIT 1),
        NULL,
        1, 'MORNING', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-2' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-2' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Supervisor Review' LIMIT 1),
        NULL,
        1, 'MORNING', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific research internship' LIMIT 1),
        NULL,
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advanced Image Processing' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)
FROM new_assignment;

INSERT INTO subjects (name, code, total_hours, hours_per_week, major_id)
SELECT 'Research work, including the completion of a PhD dissertation', 'SRC-BF-26008', 90, 6,
       (SELECT id FROM majors WHERE short_name = 'PHD' LIMIT 1)
WHERE NOT EXISTS (
    SELECT 1 FROM subjects WHERE name = 'Research work, including the completion of a PhD dissertation'
);

-- Backfill master assignments from the 12606 curriculum and 2025-2026 master schedule.
-- This keeps every seeded group populated in both fall and spring timetables.
DO $$
    DECLARE
        rec record;
        v_assignment_id bigint;
        v_timetable_id bigint;
        v_subject_id bigint;
        v_teacher_id bigint;
        v_group_id bigint;
    BEGIN
        FOR rec IN
            SELECT *
            FROM (VALUES
                ('Course Schedule FALL 2025-2026 v0', 'MCOM-25', 'Maths Data Science', 'Dr. Remudin Mecuria', 3, 'AFTERNOON', 'CLASSROOM', '3'),
                ('Course Schedule FALL 2025-2026 v0', 'MCOM-25', 'Psychology of Higher Education', 'Dr. Ainuru Zholchieva', 3, 'AFTERNOON', 'CLASSROOM', '3'),
                ('Course Schedule FALL 2025-2026 v0', 'MCOM-25', 'Introduction to Data Analysis', 'Dr. Remudin Mecuria', 3, 'AFTERNOON', 'COMPUTER_LAB', '3'),
                ('Course Schedule FALL 2025-2026 v0', 'MCOM-25', 'Deep Learning', 'Dr. Musa Abdujabbarov', 3, 'AFTERNOON', 'COMPUTER_LAB', '3'),
                ('Course Schedule FALL 2025-2026 v0', 'MCOM-25', 'Machine Learning', 'Dr. Ruslan Isaev', 3, 'AFTERNOON', 'COMPUTER_LAB', '3'),

                ('Course Schedule FALL 2025-2026 v0', 'MCOM-24', 'Teaching Practice', 'Ms. Kanykei Azhikulova', 3, 'AFTERNOON', 'CLASSROOM', '3'),
                ('Course Schedule FALL 2025-2026 v0', 'MCOM-24', 'Startup: from idea to launch', 'Mr. Radmir Gumerov', 3, 'AFTERNOON', 'CLASSROOM', '3'),
                ('Course Schedule FALL 2025-2026 v0', 'MCOM-24', 'Introduction to Cloud computing', 'Mr. Ahmad Sarosh', 3, 'AFTERNOON', 'COMPUTER_LAB', '3'),
                ('Course Schedule FALL 2025-2026 v0', 'MCOM-24', 'Data Visualization Analysis Tools', 'Ms. Mekia Gaso', 3, 'AFTERNOON', 'COMPUTER_LAB', '3'),
                ('Course Schedule FALL 2025-2026 v0', 'MCOM-24', 'Scientific Industrial Practice', 'Dr. Ruslan Isaev', 3, 'AFTERNOON', 'CLASSROOM', '3'),

                ('Course Schedule SPRING 2025-2026 v0', 'MCOM-1', 'Research Methods', 'Dr. Remudin Mecuria', 3, 'AFTERNOON', 'CLASSROOM', '3'),
                ('Course Schedule SPRING 2025-2026 v0', 'MCOM-1', 'Computer Vision Algorithms', 'Dr. Tauheed Khan', 3, 'AFTERNOON', 'COMPUTER_LAB', '3'),
                ('Course Schedule SPRING 2025-2026 v0', 'MCOM-1', 'NLP', 'Dr. Musa Abdujabbarov', 3, 'AFTERNOON', 'COMPUTER_LAB', '3'),
                ('Course Schedule SPRING 2025-2026 v0', 'MCOM-1', 'Advanced Algorithms', 'Ms. Mekia Gaso', 3, 'AFTERNOON', 'CLASSROOM', '3'),
                ('Course Schedule SPRING 2025-2026 v0', 'MCOM-1', 'Data engineering', 'Dr. Ruslan Isaev', 3, 'AFTERNOON', 'COMPUTER_LAB', '3'),

                ('Course Schedule SPRING 2025-2026 v0', 'MCOM-2', 'Research Methods', 'Dr. Remudin Mecuria', 3, 'AFTERNOON', 'CLASSROOM', '3'),
                ('Course Schedule SPRING 2025-2026 v0', 'MCOM-2', 'Computer Vision Algorithms', 'Dr. Tauheed Khan', 3, 'AFTERNOON', 'COMPUTER_LAB', '3'),
                ('Course Schedule SPRING 2025-2026 v0', 'MCOM-2', 'NLP', 'Dr. Musa Abdujabbarov', 3, 'AFTERNOON', 'COMPUTER_LAB', '3'),
                ('Course Schedule SPRING 2025-2026 v0', 'MCOM-2', 'Advanced Algorithms', 'Ms. Mekia Gaso', 3, 'AFTERNOON', 'CLASSROOM', '3'),
                ('Course Schedule SPRING 2025-2026 v0', 'MCOM-2', 'Data engineering', 'Dr. Ruslan Isaev', 3, 'AFTERNOON', 'COMPUTER_LAB', '3'),

                ('Course Schedule FALL 2025-2026 v0', 'PHD-23', 'Research work, including the completion of a PhD dissertation', 'Dr. Ruslan Isaev', 3, 'AFTERNOON', 'CLASSROOM', '3'),

                ('Course Schedule SPRING 2025-2026 v0', 'MCOM-24', 'Research Methods', 'Dr. Remudin Mecuria', 3, 'AFTERNOON', 'CLASSROOM', '3'),
                ('Course Schedule SPRING 2025-2026 v0', 'MCOM-24', 'Computer Vision Algorithms', 'Dr. Tauheed Khan', 3, 'AFTERNOON', 'COMPUTER_LAB', '3'),
                ('Course Schedule SPRING 2025-2026 v0', 'MCOM-24', 'NLP', 'Dr. Musa Abdujabbarov', 3, 'AFTERNOON', 'COMPUTER_LAB', '3'),
                ('Course Schedule SPRING 2025-2026 v0', 'MCOM-24', 'Advanced Algorithms', 'Ms. Mekia Gaso', 3, 'AFTERNOON', 'CLASSROOM', '3')
            ) AS data(timetable_name, group_name, subject_name, teacher_name, hours_per_week, shift, room_type_required, hours_splitting)
            LOOP
                SELECT id INTO v_timetable_id FROM timetables WHERE name = rec.timetable_name LIMIT 1;
                SELECT id INTO v_subject_id FROM subjects WHERE name = rec.subject_name LIMIT 1;
                SELECT id INTO v_teacher_id FROM teachers WHERE full_name = rec.teacher_name LIMIT 1;
                SELECT id INTO v_group_id FROM study_groups WHERE name = rec.group_name LIMIT 1;

                IF v_timetable_id IS NULL OR v_subject_id IS NULL OR v_group_id IS NULL THEN
                    RAISE EXCEPTION 'Invalid master assignment seed row: timetable=%, group=%, subject=%',
                        rec.timetable_name, rec.group_name, rec.subject_name;
                END IF;

                INSERT INTO assignments (
                    timetable_id,
                    subject_id,
                    teacher_id,
                    hours_per_week,
                    shift,
                    room_type_required,
                    hours_splitting,
                    generated_lessons_count,
                    specific_room_id
                )
                VALUES (
                    v_timetable_id,
                    v_subject_id,
                    v_teacher_id,
                    rec.hours_per_week,
                    rec.shift,
                    rec.room_type_required,
                    rec.hours_splitting,
                    0,
                    NULL
                )
                RETURNING id INTO v_assignment_id;

                INSERT INTO assignment_groups (assignment_id, group_id)
                VALUES (v_assignment_id, v_group_id);
            END LOOP;
    END $$;

-- Demo backfill for 2023 bachelor/PhD spring groups whose real spring sheet is mostly internship.
DO $$
    DECLARE
        rec record;
        subj record;
        v_assignment_id bigint;
        v_timetable_id bigint;
        v_subject_id bigint;
        v_teacher_id bigint;
        v_group_id bigint;
    BEGIN
        FOR subj IN
            SELECT *
            FROM (VALUES
                ('Computer Networks and Telecommunication', 'SRC-BF-26001', 'COMSE', 90, 6),
                ('Digital and Mobile Forensics', 'SRC-BF-26002', 'COMCEH', 90, 6),
                ('Software Architecture & Design patterns', 'SRC-BF-26003', 'COMSE', 90, 6),
                ('Operational Risk Management', 'SRC-BF-26004', 'IEMIT', 90, 6),
                ('Human Resource Management', 'SRC-BF-26005', 'IEMIT', 60, 4),
                ('Numerical methods', 'SRC-BF-26006', 'MATDAIS', 90, 6),
                ('Data Analysis and Decision Making in Education', 'SRC-BF-26007', 'MATMIE', 90, 6),
                ('Research work, including the completion of a PhD dissertation', 'SRC-BF-26008', 'PHD', 90, 6)
            ) AS data(subject_name, subject_code, major_short_name, total_hours, hours_per_week)
            LOOP
                IF NOT EXISTS (SELECT 1 FROM subjects WHERE name = subj.subject_name) THEN
                    INSERT INTO subjects (name, code, total_hours, hours_per_week, major_id)
                    VALUES (
                        subj.subject_name,
                        subj.subject_code,
                        subj.total_hours,
                        subj.hours_per_week,
                        (SELECT id FROM majors WHERE short_name = subj.major_short_name LIMIT 1)
                    );
                END IF;
            END LOOP;

        FOR rec IN
            SELECT *
            FROM (VALUES
                ('COMCEH-23', 'Computer Networks and Telecommunication', 'Mr. Suleyman Saparov', 3, 'COMPUTER_LAB'),
                ('COMCEH-23', 'Digital and Mobile Forensics', 'Mr. Imtiyaz Gulbarga', 3, 'COMPUTER_LAB'),
                ('COMCEH-23', 'Ethical Hacking Penetration Testing', 'Mr. Ruslan Amanov', 3, 'COMPUTER_LAB'),

                ('COMSE-23', 'Software Architecture & Design patterns', 'Ms. Mekia Gaso', 3, 'COMPUTER_LAB'),
                ('COMSE-23', 'Computer Networks and Telecommunication', 'Mr. Suleyman Saparov', 3, 'COMPUTER_LAB'),
                ('COMSE-23', 'Back-end', 'Mr. Talgat Mendekov', 3, 'COMPUTER_LAB'),

                ('IEMIT-23', 'Computer Networks and Telecommunication', 'Mr. Suleyman Saparov', 3, 'COMPUTER_LAB'),
                ('IEMIT-23', 'Operational Risk Management', 'Dr. Andrei Ermakov', 3, 'CLASSROOM'),
                ('IEMIT-23', 'Human Resource Management', 'Dr. Andrei Ermakov', 3, 'CLASSROOM'),
                ('IEMIT-23', 'Project Product Management', 'Dr. Andrei Ermakov', 3, 'CLASSROOM'),

                ('MATDAIS-23', 'Databases', 'Ms. Nargiza Zhumalieva', 3, 'COMPUTER_LAB'),
                ('MATDAIS-23', 'Design & Analysis of Algorithms', 'Mr. Erustan Erkebulanov', 3, 'COMPUTER_LAB'),
                ('MATDAIS-23', 'Machine Learning', 'Dr. Ruslan Isaev', 3, 'COMPUTER_LAB'),
                ('MATDAIS-23', 'Numerical methods', 'Ms. Gulnarida Zhalilova', 3, 'CLASSROOM'),

                ('MATMIE-23', 'Databases', 'Ms. Nargiza Zhumalieva', 3, 'COMPUTER_LAB'),
                ('MATMIE-23', 'Design & Analysis of Algorithms', 'Mr. Erustan Erkebulanov', 3, 'COMPUTER_LAB'),
                ('MATMIE-23', 'Data Analysis and Decision Making in Education', 'Dr. Burul Shambetova', 3, 'CLASSROOM'),
                ('MATMIE-23', 'Numerical methods', 'Ms. Gulnarida Zhalilova', 3, 'CLASSROOM'),

                ('PHD-23', 'Research work, including the completion of a PhD dissertation', 'Dr. Ruslan Isaev', 3, 'CLASSROOM'),
                ('PHD-23', 'Research Methods', 'Dr. Remudin Mecuria', 3, 'CLASSROOM')
            ) AS data(group_name, subject_name, teacher_name, hours_per_week, room_type_required)
            LOOP
                SELECT id INTO v_timetable_id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1;
                SELECT id INTO v_subject_id FROM subjects WHERE name = rec.subject_name LIMIT 1;
                SELECT id INTO v_teacher_id FROM teachers WHERE full_name = rec.teacher_name LIMIT 1;
                SELECT id INTO v_group_id FROM study_groups WHERE name = rec.group_name LIMIT 1;

                IF v_timetable_id IS NULL OR v_subject_id IS NULL OR v_group_id IS NULL THEN
                    RAISE EXCEPTION 'Invalid spring backfill row: group=%, subject=%',
                        rec.group_name, rec.subject_name;
                END IF;

                INSERT INTO assignments (
                    timetable_id,
                    subject_id,
                    teacher_id,
                    hours_per_week,
                    shift,
                    room_type_required,
                    hours_splitting,
                    generated_lessons_count,
                    specific_room_id
                )
                VALUES (
                    v_timetable_id,
                    v_subject_id,
                    v_teacher_id,
                    rec.hours_per_week,
                    'AFTERNOON',
                    rec.room_type_required,
                    rec.hours_per_week::text,
                    0,
                    NULL
                )
                RETURNING id INTO v_assignment_id;

                INSERT INTO assignment_groups (assignment_id, group_id)
                VALUES (v_assignment_id, v_group_id);
            END LOOP;
    END $$;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Artificial Intelligence Deep Learning' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Musa Abdujabbarov' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Seminar' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Ruslan Isaev' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule FALL 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Supervisor Review' LIMIT 1),
        NULL,
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'C# (Advanced C#)' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'C# (Advanced C#)' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        6, 'MORNING', 'COMPUTER_LAB', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'C# (Advanced C#)' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        7, 'AFTERNOON', 'CLASSROOM', '2+2+3', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'C# (Advanced C#)' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        7, 'ANY', 'COMPUTER_LAB', '2+2+3', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cloud computing' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ahmad Sarosh' LIMIT 1),
        1, 'MORNING', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cloud computing' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ahmad Sarosh' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cloud computing' LIMIT 1),
        NULL,
        6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cloud computing' LIMIT 1),
        NULL,
        12, 'MORNING', 'CLASSROOM', '2+2+2+2+2+2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cloud computing' LIMIT 1),
        NULL,
        6, 'AFTERNOON', 'CLASSROOM', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Image Processing Computer Vision' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        7, 'ANY', 'COMPUTER_LAB', '2+2+3', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Research in Applied Data Science' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        6, 'MORNING', 'COMPUTER_LAB', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Research in Applied Data Science' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Mekia Gaso' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Research in Applied Data Science' LIMIT 1),
        NULL,
        6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Research in Applied Data Science' LIMIT 1),
        NULL,
        6, 'MORNING', 'CLASSROOM', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Niyazkhan Shabdanalov' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Software Engineering' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        1, 'AFTERNOON', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COM-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        NULL,
        10, 'ANY', 'CLASSROOM', '2+2+2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        4, 'AFTERNOON', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'DocuIT: Mastering' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Ethical Hacking Penetration Testing' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Imtiyaz Gulbarga' LIMIT 1),
        6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Emilbek' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Alimzhan Zakirov' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Kunduz Zhusupbekova' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'AFTERNOON', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Hussein Chebsi' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        1, 'MORNING', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Liliya Abdieva' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        5, 'MORNING', 'CLASSROOM', '2+3', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'AFTERNOON', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'MORNING', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        5, 'AFTERNOON', 'CLASSROOM', '2+3', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhazgul Alymbaeva' LIMIT 1),
        6, 'AFTERNOON', 'COMPUTER_LAB', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Ainuru Zholchieva' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Elnura' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMCEH-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        NULL,
        10, 'AFTERNOON', 'CLASSROOM', '2+2+2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'VR Design' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        4, 'AFTERNOON', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Design Thinking product solutions' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'DocuIT: Mastering' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Emilbek' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Alimzhan Zakirov' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Kunduz Zhusupbekova' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'AFTERNOON', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Hussein Chebsi' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Hussein Chebsi' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Liliya Abdieva' LIMIT 1),
        6, 'MORNING', 'CLASSROOM', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        5, 'AFTERNOON', 'CLASSROOM', '2+3', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'AFTERNOON', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '2+3', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Cholpon Alieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        6, 'MORNING', 'COMPUTER_LAB', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        1, 'AFTERNOON', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Elnura' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMFCI-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        NULL,
        20, 'MORNING', 'CLASSROOM', '2+2+2+2+2+2+2+2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Back-end' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Talgat Mendekov' LIMIT 1),
        3, 'MORNING', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        4, 'AFTERNOON', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'DocuIT: Mastering' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Alimzhan Zakirov' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Kunduz Zhusupbekova' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'MORNING', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Hussein Chebsi' LIMIT 1),
        6, 'AFTERNOON', 'CLASSROOM', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1),
        6, 'MORNING', 'CLASSROOM', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        5, 'AFTERNOON', 'CLASSROOM', '2+3', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'AFTERNOON', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        6, 'ANY', 'CLASSROOM', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Cholpon Alieva' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Bopushova Asina' LIMIT 1),
        1, 'MORNING', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Azhar Kazakbaeva' LIMIT 1),
        6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        1, 'MORNING', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Ainuru Zholchieva' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Elnura' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Elnura' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'COMSE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        NULL,
        10, 'MORNING', 'CLASSROOM', '2+2+2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Electronics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Tauheed Khan' LIMIT 1),
        6, 'MORNING', 'COMPUTER_LAB', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'DocuIT: Mastering' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nurbek Tenirberdiev' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'AFTERNOON', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        1, 'AFTERNOON', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        NULL,
        3, 'MORNING', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        5, 'AFTERNOON', 'CLASSROOM', '2+3', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'AFTERNOON', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhazgul Alymbaeva' LIMIT 1),
        2, 'AFTERNOON', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhazgul Alymbaeva' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        1, 'MORNING', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Public Speaking Skills' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Ainuru Zholchieva' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Tsoi A.' LIMIT 1),
        6, 'MORNING', 'CLASSROOM', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'EEAIR-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        NULL,
        10, 'AFTERNOON', 'CLASSROOM', '2+2+2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Business Fundamentals Process Management' LIMIT 1),
        NULL,
        3, 'MORNING', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Business Fundamentals Process Management' LIMIT 1),
        NULL,
        3, 'AFTERNOON', 'COMPUTER_LAB', '3', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Cybersecurity Foundation' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Ruslan Amanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Digital Marketing Technologies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Meerim Chukaeva' LIMIT 1),
        2, 'AFTERNOON', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'DocuIT: Mastering' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nurbek Tenirberdiev' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Nurgul Erdolatova' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Manas Studies' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Kunduz Zhusupbekova' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy of Technology' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Probability Statistics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        2, 'AFTERNOON', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Management' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Management' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Philosophy' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language (Java)' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Bopushova Asina' LIMIT 1),
        4, 'MORNING', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language I' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Bopushova Asina' LIMIT 1),
        2, 'AFTERNOON', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Turkish' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'IEMIT-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        NULL,
        10, 'AFTERNOON', 'CLASSROOM', '2+2+2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-23' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Applied statistics II' LIMIT 1),
        NULL,
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Applied statistics II' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data analysis visualization' LIMIT 1),
        NULL,
        6, 'ANY', 'COMPUTER_LAB', '2+2+2', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nurbek Tenirberdiev' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Nurgul Erdolatova' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Daniiar Satybaldiev' LIMIT 1),
        2, 'AFTERNOON', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        NULL,
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB4(B211)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B203' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        1, 'AFTERNOON', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '2+3', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'MORNING', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B110' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        1, 'AFTERNOON', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Chokusheva G.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATDAIS-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'MORNING', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Deep Learning' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhibek Namatova' LIMIT 1),
        4, 'AFTERNOON', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Introduction to Cloud computing' LIMIT 1),
        NULL,
        3, 'MORNING', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Methodology of teaching mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Sherali Matanov' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Pre qualification practice' LIMIT 1),
        NULL,
        5, 'ANY', 'CLASSROOM', '2+3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATH-22' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Industrial Practice' LIMIT 1),
        NULL,
        10, 'MORNING', 'CLASSROOM', '2+2+2+2+2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Applied statistics II' LIMIT 1),
        NULL,
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Art of teaching methods in informatics' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Art of teaching methods in informatics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B204' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Geography of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nurbek Tenirberdiev' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'History of Kyrgyzstan' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Nurgul Erdolatova' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Duisheeva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Orozalieva D.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B104' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Saidalieva A.' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B105' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz Language Literature II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tokusheva T.' LIMIT 1),
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Kyrgyz language foreign students' LIMIT 1),
        NULL,
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Object Oriented Programming' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Daniiar Satybaldiev' LIMIT 1),
        4, 'AFTERNOON', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advisor hour' LIMIT 1),
        NULL,
        1, 'MORNING', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Calculus II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Samat Elikbaev' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Computer Literacy' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        1, 'AFTERNOON', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB5(B213)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Discrete Mathematics' LIMIT 1),
        NULL,
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Andrei Ermakov' LIMIT 1),
        5, 'ANY', 'CLASSROOM', '2+3', 0, (SELECT id FROM rooms WHERE name = 'B111' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        4, 'MORNING', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Nargiza Zhumalieva' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B109' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Zhamby Dzhusubalieva' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B201' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'AFTERNOON', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Engineering Computer Graphics' LIMIT 1),
        NULL,
        4, 'ANY', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B202' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'English' LIMIT 1),
        NULL,
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'French' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'German' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Erika' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B103' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Interpersonal Communication in IT' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Murray Eldred' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B101' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Iskra' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B106' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Korean' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Tattybubu Arap kyzy' LIMIT 1),
        2, 'AFTERNOON', 'CLASSROOM', '2', 0, (SELECT id FROM rooms WHERE name = 'B205' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Chynybekov Z.' LIMIT 1),
        2, 'MORNING', 'CLASSROOM', '2', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Physical Education' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Ms. Abdykadyrova N.' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        4, 'ANY', 'COMPUTER_LAB', '2+2', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Language II' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Erustan Erkebulanov' LIMIT 1),
        2, 'MORNING', 'COMPUTER_LAB', '2', 0, (SELECT id FROM rooms WHERE name = 'LAB3(B210)' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Programming Python' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Burul Shambetova' LIMIT 1),
        1, 'AFTERNOON', 'COMPUTER_LAB', '1', 0, (SELECT id FROM rooms WHERE name = 'BIGLAB' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Russian language' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Alimpieva L.' LIMIT 1),
        4, 'MORNING', 'CLASSROOM', '2+2', 0, (SELECT id FROM rooms WHERE name = 'B102' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Startup: from idea to launch' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Mr. Radmir Gumerov' LIMIT 1),
        1, 'AFTERNOON', 'CLASSROOM', '1', 0, (SELECT id FROM rooms WHERE name = 'B113' LIMIT 1)
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MATMIE-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Data engineering' LIMIT 1),
        NULL,
        3, 'MORNING', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-24' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Advanced Algorithms' LIMIT 1),
        NULL,
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Maths Data Science' LIMIT 1),
        NULL,
        3, 'MORNING', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'NLP' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Musa Abdujabbarov' LIMIT 1),
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'MCOM-25' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Supervisor Review' LIMIT 1),
        NULL,
        1, 'MORNING', 'CLASSROOM', '1', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-23' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Pedagogical research internship' LIMIT 1),
        NULL,
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-24' LIMIT 1)
FROM new_assignment;

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

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'NLP' LIMIT 1),
        (SELECT id FROM teachers WHERE full_name = 'Dr. Musa Abdujabbarov' LIMIT 1),
        3, 'MORNING', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)
FROM new_assignment;

WITH new_assignment AS (
    INSERT INTO assignments (timetable_id, subject_id, teacher_id, hours_per_week, shift, room_type_required, hours_splitting, generated_lessons_count, specific_room_id)
    VALUES (
        (SELECT id FROM timetables WHERE name = 'Course Schedule SPRING 2025-2026 v0' LIMIT 1),
        (SELECT id FROM subjects WHERE name = 'Scientific Seminar' LIMIT 1),
        NULL,
        3, 'AFTERNOON', 'CLASSROOM', '3', 0, NULL
    )
    RETURNING id
)
INSERT INTO assignment_groups (assignment_id, group_id)
SELECT new_assignment.id, (SELECT id FROM study_groups WHERE name = 'PHD-25' LIMIT 1)
FROM new_assignment;
