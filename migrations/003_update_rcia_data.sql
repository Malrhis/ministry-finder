-- ============================================================
-- Migration 003 — RCIA app data: rename, update 44, add 6 new
-- ============================================================

-- ── 1. Rename combined RCIA entry to adult-only ──────────────
UPDATE ministries
SET name = 'Rite of Christian Initiation (RCIA)'
WHERE name = 'Rite of Christian Initiation (RCIA & RCIY)';

-- ── 2. Update 44 existing RCIA-suitable ministries ───────────
-- Sets rcia_suitable, app_categories, who_adult, who_youth
-- Contact changes are included inline per ministry.

UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'], who_adult=true,  who_youth=true  WHERE name='Seeking Surrender';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['learn','mission'], who_adult=true,  who_youth=false WHERE name='Rite of Christian Initiation (RCIA)';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['pray'],            who_adult=true,  who_youth=true  WHERE name='Generation CHRIST@I';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['learn','mission'], who_adult=true,  who_youth=false, email='csi.catechetical@catholic.org.sg' WHERE name='Catechetical';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['pray'],            who_adult=true,  who_youth=true  WHERE name='Legion of Mary';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=true,  who_youth=true  WHERE name='Lectors';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['mission'],         who_adult=true,  who_youth=true  WHERE name='Parish Emergency Resource Team (PERT)';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['pray'],            who_adult=true,  who_youth=false WHERE name='Open Studio';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['pray'],            who_adult=true,  who_youth=false WHERE name='Christian Meditation';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=true,  who_youth=true  WHERE name='Traffic Assistance';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['pray','learn'],    who_adult=false, who_youth=true  WHERE name='DVC Harbour Community';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['pray'],            who_adult=true,  who_youth=true  WHERE name='Rosary';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['mission'],         who_adult=true,  who_youth=true  WHERE name='HomeMakers';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['mission'],         who_adult=true,  who_youth=true  WHERE name='D''Fellowship';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=true,  who_youth=true  WHERE name='St Francis Xavier Choir';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=true,  who_youth=false WHERE name='Infant Baptism';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['mission'],         who_adult=true,  who_youth=true  WHERE name='Willing Hands';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['mission'],         who_adult=true,  who_youth=true,  phone='9737 3002' WHERE name='Sunday Canteen';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=true,  who_youth=true  WHERE name='Hospitality';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=true,  who_youth=true  WHERE name='Soli Deo Gloria (SDG) Choir';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=true,  who_youth=true  WHERE name='Instruments of Love Choir';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=false, who_youth=true  WHERE name='DVC Youth Choir';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=true,  who_youth=true  WHERE name='Laudate Dominum Choir';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['pray','sacrament'],who_adult=true,  who_youth=true  WHERE name='Liturgy of the Word for Children (LOWC)';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['pray'],            who_adult=true,  who_youth=true  WHERE name='Divine Mercy';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=true,  who_youth=true  WHERE name='Flower Ladies';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['learn','mission'], who_adult=false, who_youth=true  WHERE name='DVC Facilitators';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['pray'],            who_adult=true,  who_youth=false, email='eac.stignatius@gmail.com' WHERE name='Children''s Eucharistic Adoration';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=true,  who_youth=true  WHERE name='Family Choir & Salve Regina Orchestra';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=true,  who_youth=false WHERE name='EMHC';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['pray'],            who_adult=true,  who_youth=false WHERE name='Crossing';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=true,  who_youth=true  WHERE name='Laetare Choir';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['pray','mission'],  who_adult=true,  who_youth=true,  email='chadgerardtan@gmail.com' WHERE name='Lilies of the Valley';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['mission'],         who_adult=true,  who_youth=true,  email='chadgerardtan@gmail.com' WHERE name='PaCES Ministry';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=true,  who_youth=true  WHERE name='Celia''s Choir';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['pray'],            who_adult=true,  who_youth=true  WHERE name='Charismatic Renewal';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=false, who_youth=true  WHERE name='Altar Servers';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['mission'],         who_adult=true,  who_youth=true,  email='csi.comms@catholic.org.sg' WHERE name='Digital Media';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['mission'],         who_adult=true,  who_youth=true  WHERE name='Green Movement';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=true,  who_youth=false WHERE name='Wedding Ministry';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['mission'],         who_adult=true,  who_youth=true  WHERE name='St Vincent de Paul';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['sacrament'],       who_adult=true,  who_youth=true  WHERE name='Ignatian Voices';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['pray','learn','mission'], who_adult=true, who_youth=true WHERE name='RCIY';
UPDATE ministries SET rcia_suitable=true, app_categories=ARRAY['pray'],            who_adult=true,  who_youth=false WHERE name='Praying Parents Group';

-- ── 3. Insert 6 new ministries ────────────────────────────────

INSERT INTO ministries (name, category, description, phone, email, age, meeting, tags, rcia_suitable, app_categories, who_adult, who_youth, sort_order) VALUES

('Wednesday Wonderers', 'Formation & Community',
 'A Bible study group meeting weekly via Zoom, currently studying Romans: The Gospel of Salvation.',
 '9785 2268 / 9459 7557', '', '', 'Every Wednesday, 9.30am–12pm, Zoom',
 '{"grow":["scripture","formation"],"who":["adult","young-adult"],"time":["weekly"]}'::jsonb,
 true, ARRAY['learn'], true, true, 815),

('Road to Emmaus', 'Formation & Community',
 'A parish-wide Bible programme helping parishioners break open the Word of the weekend Liturgies, applying Scripture''s truths more deeply in daily life.',
 '', 'road.to.emmaus.st.ignatius@gmail.com', '', 'Every Monday, 7.45–10pm, Zoom',
 '{"grow":["scripture","formation"],"who":["adult","young-adult"],"time":["weekly"]}'::jsonb,
 true, ARRAY['learn'], true, true, 816),

('Saturday Rockers', 'Formation & Community',
 'A Bible study group meeting weekly via Zoom on Saturday afternoons, currently studying Luke: The Story of Salvation Fulfilled.',
 '', 'saturdayrockers@gmail.com', '', 'Every Saturday, 1.30–3.30pm, Zoom',
 '{"grow":["scripture","formation"],"who":["adult","young-adult"],"time":["weekly"]}'::jsonb,
 true, ARRAY['learn'], true, true, 817),

('Legion of Mary Bible Study Group', 'Formation & Community',
 'A monthly in-person Bible study group currently studying Luke: The Story of Salvation Fulfilled by Ascension Press.',
 '9680 8306 / 8877 3326', '', '', 'Every 2nd Sunday of the month, 1.30–4.30pm, Room 01-08/09',
 '{"grow":["scripture","formation"],"who":["adult","young-adult"],"time":["monthly"]}'::jsonb,
 true, ARRAY['learn'], true, true, 818),

('Listening to God', 'Formation & Community',
 'A Scripture study group meeting weekly via Google Meet, currently on a Bible Pilgrimage programme. Newcomers welcome anytime.',
 '', 'jkwding@gmail.com / ebeh2012@gmail.com', '', 'Every Saturday, 2.30–3.30pm, Google Meet',
 '{"grow":["scripture","formation"],"who":["adult","young-adult"],"time":["weekly"]}'::jsonb,
 true, ARRAY['learn'], true, true, 819),

('Tuesday Ladies'' Bible Study', 'Formation & Community',
 'A women''s Bible study group meeting weekly via Zoom, currently studying Foundations of Faith — A Journey Through the Catechism of the Catholic Church.',
 '9694 2778', '', '', 'Every Tuesday, 10am–12pm, Zoom',
 '{"grow":["scripture","formation"],"who":["adult"],"time":["weekly"]}'::jsonb,
 true, ARRAY['learn'], true, true, 820);
