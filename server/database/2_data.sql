SET session_replication_role = 'replica';

--
-- Dumping data for table user
--

INSERT INTO "User" VALUES
    ('calcultron',          'Approved', '7XEXyZkbKYlz7a6PJZX2dcswxcl9dfrbWz0mohokiec=', 'Dwight',     'Schrute'),
    ('calcultron2',         'Approved', 'U/rQadR9W7NIwDUve3o1XBUfGJyRr0aOepG4Ux+gNzY=', 'Jim',        'Halpert'),
    ('calcwizard',          'Approved', '6fJzzLAb5hKhO2Y5BImDeqfyxQq+9mxRn5ZOXxrLeuQ=', 'Issac',      'Newton'),
    ('clarinetbeast',       'Declined', 'vfW5VekJZIiFRhUPmVwMH2uldmTm18kBBnZCw/LO9zU=', 'Squidward',  'Tentacles'),
    ('cool_class4400',      'Approved', 'owqlWSLvzBePFJot5hmF7YpUYUGLsyItD7daw/ZiVyw=', 'A. TA',      'Washere'),
    ('DNAhelix',            'Approved', 'K9msoMPJWrDIPu7wbKMtFFdJqS/bYxhqEgX/7UhYSzA=', 'Rosalind',   'Franklin'),
    ('does2Much',           'Approved', 'UTY/lvYXafMRoAA0Wy6uWg0yCbt8oewEqjcBUA9Ay1Q=', 'Carl',       'Gauss'),
    ('eeqmcsquare',         'Approved', 'wkOHLMwhgggOeU3/HqlgMYmuQ/hOdRq2EOLL8+ROLBA=', 'Albert',     'Einstein'),
    ('entropyRox',          'Approved', 'avfqA6QRtgM4U8sPuX8QrHYluK8v0uAZuzxVi7Sm9/o=', 'Claude',     'Shannon'),
    ('fatherAI',            'Approved', 'sGnIkZ7prA4nEjVwOQs1Xs47kJCYDTr5qspcZ14MBOA=', 'Alan',       'Turing'),
    ('fullMetal',           'Approved', 'bkk0CUyii8bfp/YkalsE3a3IY/9zYgx72J72zz2Mj58=', 'Edward',     'Elric'),
    ('gdanger',             'Declined', '/zNKfG//8zVNw48vezAHLBT4n23LyEdKCyo7NsoLelQ=', 'Gary',       'Danger'),
    ('georgep',             'Approved', 'QfmLNpN0/1JGPg+2TeU+DqB81RvM3iO7sNasc9rpxlA=', 'George P.',  'Burdell'),
    ('ghcghc',              'Approved', 'OHDXKdosYE0cL80r7xZs5+0JgMA5VTUcT8LJ1+L2xYI=', 'Grace',      'Hopper'),
    ('ilikemoney$$',        'Approved', 'H2T0smUVSH/jXkMN1cwYGS2PJuveR0q7rRUnuvJIVzo=', 'Eugene',     'Krabs'),
    ('imbatman',            'Approved', 'e48o8J7t1aDMd4QaMZZjTDId++3lZAhR/qxVZYVfYRc=', 'Bruce',      'Wayne'),
    ('imready',             'Approved', 'C6o7Fjk7Rwd2iiAfbL7v6bITj/cu4x3JJh8hXis6EdE=', 'Spongebob',  'Squarepants'),
    ('isthisthekrustykrab', 'Approved', 'qYxescR4zjR5C5oo1slvaEm0BaxxchROGHtrBjBA1GI=', 'Patrick',    'Star'),
    ('manager1',            'Approved', 'gkh6cG/4rec29VR3Uzlzf8s0mJE+aQOROVPVlmvkymI=', 'Manager',    'One'),
    ('manager2',            'Approved', 'IkQfxCBj8GzKKFDFC2D9NmhigI5fPVXmLW3ao2S4HzA=', 'Manager',    'Two'),
    ('manager3',            'Approved', 'Jw49krrG7SR9PVmFoDpTr10/fHqoT1uuhokHfeyUCpE=', 'Three',      'Three'),
    ('manager4',            'Approved', 'EnGtjXQpIv66X56d0NfZET/xmd/furDEvyLnNEJa+Us=', 'Four',       'Four'),
    ('notFullMetal',        'Approved', 'oJ6edQEG1f70pGic3S/vp4vDklgVD8S33AFovOHTXgU=', 'Alphonse',   'Elric'),
    ('programerAAL',        'Approved', 'q5Y/aeiJKwwCK4bwQD9R/s1mM6FOt5dRckhfGJbhRpU=', 'Ada',        'Lovelace'),
    ('radioactivePoRa',     'Approved', 'Jfuc92ZB8Gp6yvTlTOLhGsJxULEuTF/fdyv5tUBwwB8=', 'Marie',      'Curie'),
    ('RitzLover28',         'Approved', 's7ePqNLenQT5bTeW7bLTywmQYLP99nLtZ+ZMFhrQhZw=', 'Abby',       'Normal'),
    ('smith_j',             'Pending',  '8uaP9A+W8rxiqIA7fphy72EEBPDECMjtKMPTp/Xoy2A=', 'John',       'Smith'),
    ('texasStarKarate',     'Declined', 'eXognGESzRi2pQtkFDheVvQk8amoi58ARPXpD3LnqYw=', 'Sandy',      'Cheeks'),
    ('thePiGuy3.14',        'Approved', 'fg9C6AFjhLtvE3lkWBFNwG67Zn8btBCVJqtaai+nw5Y=', 'Archimedes', 'Syracuse'),
    ('theScienceGuy',       'Approved', 'cGyM78A5JNPvHsOmESA8Tz4YTZQCceYSBIjmTUObYvE=', 'Bill',       'Nye');

--
-- Dumping data for table admin
--

INSERT INTO admin VALUES ('cool_class4400');

--
-- Dumping data for table company
--

INSERT INTO company VALUES
    ('4400 Theater Company'),
    ('AI Theater Company'),
    ('Awesome Theater Company'),
    ('EZ Theater Company');

--
-- Dumping data for table creditcard
--

INSERT INTO creditcard VALUES
    ('1111111111000000', 'calcultron'),
    ('1111111100000000', 'calcultron2'),
    ('1111111110000000', 'calcultron2'),
    ('1111111111100000', 'calcwizard'),
    ('2222222222000000', 'cool_class4400'),
    ('2220000000000000', 'DNAhelix'),
    ('2222222200000000', 'does2Much'),
    ('2222222222222200', 'eeqmcsquare'),
    ('2222222222200000', 'entropyRox'),
    ('2222222222220000', 'entropyRox'),
    ('1100000000000000', 'fullMetal'),
    ('1111111111110000', 'georgep'),
    ('1111111111111000', 'georgep'),
    ('1111111111111100', 'georgep'),
    ('1111111111111110', 'georgep'),
    ('1111111111111111', 'georgep'),
    ('2222222222222220', 'ilikemoney$$'),
    ('2222222222222222', 'ilikemoney$$'),
    ('9000000000000000', 'ilikemoney$$'),
    ('1111110000000000', 'imready'),
    ('1110000000000000', 'isthisthekrustykrab'),
    ('1111000000000000', 'isthisthekrustykrab'),
    ('1111100000000000', 'isthisthekrustykrab'),
    ('1000000000000000', 'notFullMetal'),
    ('2222222000000000', 'programerAAL'),
    ('3333333333333300', 'RitzLover28'),
    ('2222222220000000', 'thePiGuy3.14'),
    ('2222222222222000', 'theScienceGuy');

--
-- Dumping data for table customer
--

INSERT INTO customer VALUES
    ('calcultron'),
    ('calcultron2'),
    ('calcwizard'),
    ('clarinetbeast'),
    ('cool_class4400'),
    ('DNAhelix'),
    ('does2Much'),
    ('eeqmcsquare'),
    ('entropyRox'),
    ('fullMetal'),
    ('georgep'),
    ('ilikemoney$$'),
    ('imready'),
    ('isthisthekrustykrab'),
    ('notFullMetal'),
    ('programerAAL'),
    ('RitzLover28'),
    ('thePiGuy3.14'),
    ('theScienceGuy');

--
-- Dumping data for table employee
--

INSERT INTO employee VALUES
    ('calcultron'),
    ('cool_class4400'),
    ('entropyRox'),
    ('fatherAI'),
    ('georgep'),
    ('ghcghc'),
    ('imbatman'),
    ('manager1'),
    ('manager2'),
    ('manager3'),
    ('manager4'),
    ('radioactivePoRa');

--
-- Dumping data for table manager
--

INSERT INTO manager VALUES
    ('calcultron',      'GA','Atlanta',       '30308', '123 Peachtree St', 'EZ Theater Company'),
    ('entropyRox',      'CA','San Francisco', '94016', '200 Cool Place',   '4400 Theater Company'),
    ('fatherAI',        'NY','New York',      '10001', '456 Main St',      'EZ Theater Company'),
    ('georgep',         'WA','Seattle',       '98105', '10 Pearl Dr',      '4400 Theater Company'),
    ('ghcghc',          'KS','Pallet Town',   '31415', '100 Pi St',        'AI Theater Company'),
    ('imbatman',        'TX','Austin',        '78653', '800 Color Dr',     'Awesome Theater Company'),
    ('manager1',        'GA','Atlanta',       '30332', '123 Ferst Drive',  '4400 Theater Company'),
    ('manager2',        'GA','Atlanta',       '30332', '456 Ferst Drive',  'AI Theater Company'),
    ('manager3',        'GA','Atlanta',       '30332', '789 Ferst Drive',  '4400 Theater Company'),
    ('manager4',        'GA','Atlanta',       '30332', '000 Ferst Drive',  '4400 Theater Company'),
    ('radioactivePoRa', 'CA','Sunnyvale',     '94088', '100 Blu St',       '4400 Theater Company');

--
-- Dumping data for table movie
--

INSERT INTO movie VALUES
    ('4400 The Movie',                    '2019-08-12', 130),
    ('Avengers: Endgame',                 '2019-04-26', 181),
    ('Calculus Returns: A ML Story',      '2019-09-19', 314),
    ('George P Burdell''s Life Story',    '1927-08-12', 100),
    ('Georgia Tech The Movie',            '1985-08-13', 100),
    ('How to Train Your Dragon',          '2010-03-21', 98),
    ('Spaceballs',                        '1987-06-24', 96),
    ('Spider-Man: Into the Spider-Verse', '2018-12-01', 117),
    ('The First Pokemon Movie',           '1998-07-19', 75),
    ('The King''s Speech',                '2010-11-26', 119);

--
-- Dumping data for table movieplay
--

INSERT INTO movieplay VALUES
    ('2019-08-12', '4400 The Movie',                    '2019-08-12', 'Star Movies', 'EZ Theater Company'),
    ('2019-09-12', '4400 The Movie',                    '2019-08-12', 'Cinema Star', '4400 Theater Company'),
    ('2019-10-12', '4400 The Movie',                    '2019-08-12', 'ABC Theater', 'Awesome Theater Company'),
    ('2019-10-10', 'Calculus Returns: A ML Story',      '2019-09-19', 'ML Movies',   'AI Theater Company'),
    ('2019-12-30', 'Calculus Returns: A ML Story',      '2019-09-19', 'ML Movies',   'AI Theater Company'),
    ('2010-05-20', 'George P Burdell''s Life Story',    '1927-08-12', 'Cinema Star', '4400 Theater Company'),
    ('2019-07-14', 'George P Burdell''s Life Story',    '1927-08-12', 'Main Movies', 'EZ Theater Company'),
    ('2019-10-22', 'George P Burdell''s Life Story',    '1927-08-12', 'Main Movies', 'EZ Theater Company'),
    ('1985-08-13', 'Georgia Tech The Movie',            '1985-08-13', 'ABC Theater', 'Awesome Theater Company'),
    ('2019-09-30', 'Georgia Tech The Movie',            '1985-08-13', 'Cinema Star', '4400 Theater Company'),
    ('2010-03-22', 'How to Train Your Dragon',          '2010-03-21', 'Main Movies', 'EZ Theater Company'),
    ('2010-03-23', 'How to Train Your Dragon',          '2010-03-21', 'Main Movies', 'EZ Theater Company'),
    ('2010-03-25', 'How to Train Your Dragon',          '2010-03-21', 'Star Movies', 'EZ Theater Company'),
    ('2010-04-02', 'How to Train Your Dragon',          '2010-03-21', 'Cinema Star', '4400 Theater Company'),
    ('1999-06-24', 'Spaceballs',                        '1987-06-24', 'Main Movies', 'EZ Theater Company'),
    ('2000-02-02', 'Spaceballs',                        '1987-06-24', 'Cinema Star', '4400 Theater Company'),
    ('2010-04-02', 'Spaceballs',                        '1987-06-24', 'ML Movies',   'AI Theater Company'),
    ('2023-01-23', 'Spaceballs',                        '1987-06-24', 'ML Movies',   'AI Theater Company'),
    ('2019-09-30', 'Spider-Man: Into the Spider-Verse', '2018-12-01', 'ML Movies',   'AI Theater Company'),
    ('2018-07-19', 'The First Pokemon Movie',           '1998-07-19', 'ABC Theater', 'Awesome Theater Company'),
    ('2019-12-20', 'The King''s Speech',                '2010-11-26', 'Cinema Star', '4400 Theater Company'),
    ('2019-12-20', 'The King''s Speech',                '2010-11-26', 'Main Movies', 'EZ Theater Company');

--
-- Dumping data for table theater
--

INSERT INTO theater VALUES
    ('ABC Theater',        'Awesome Theater Company', 'TX', 'Austin',        '73301', 5, 'imbatman',        '880 Color Dr'),
    ('Cinema Star',        '4400 Theater Company',    'CA', 'San Francisco', '94016', 4, 'entropyRox',      '100 Cool Place'),
    ('Jonathan''s Movies', '4400 Theater Company',    'WA', 'Seattle',       '98101', 2, 'georgep',         '67 Pearl Dr'),
    ('Main Movies',        'EZ Theater Company',      'NY', 'New York',      '10001', 3, 'fatherAI',        '123 Main St'),
    ('ML Movies',          'AI Theater Company',      'KS', 'Pallet Town',   '31415', 3, 'ghcghc',          '314 Pi St'),
    ('Star Movies',        '4400 Theater Company',    'CA', 'Boulder',       '80301', 5, 'radioactivePoRa', '4400 Rocks Ave'),
    ('Star Movies',        'EZ Theater Company',      'GA', 'Atlanta',       '30332', 2, 'calcultron',      '745 GT St');

--
-- Dumping data for table used
--

INSERT INTO used VALUES
    ('1111111111111111', '2010-03-22', 'How to Train Your Dragon', '2010-03-21', 'Main Movies', 'EZ Theater Company'),
    ('1111111111111111', '2010-03-23', 'How to Train Your Dragon', '2010-03-21', 'Main Movies', 'EZ Theater Company'),
    ('1111111111111100', '2010-03-25', 'How to Train Your Dragon', '2010-03-21', 'Star Movies', 'EZ Theater Company'),
    ('1111111111111111', '2010-04-02', 'How to Train Your Dragon', '2010-03-21', 'Cinema Star', '4400 Theater Company');

--
-- Dumping data for table visit
--

INSERT INTO visit (Date, Username, TheaterName, CompanyName)
VALUES
    ('2010-03-22', 'georgep',    'Main Movies', 'EZ Theater Company'),
    ('2010-03-22', 'calcwizard', 'Main Movies', 'EZ Theater Company'),
    ('2010-03-25', 'calcwizard', 'Star Movies', 'EZ Theater Company'),
    ('2010-03-25', 'imready',    'Star Movies', 'EZ Theater Company'),
    ('2010-03-20', 'calcwizard', 'ML Movies',   'AI Theater Company');

SET session_replication_role = 'origin';
