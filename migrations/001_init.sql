-- ============================================================
-- St Ignatius Ministry Finder — Supabase Migration 001
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- ──────────────────────────────────────────────────────────────
-- 1. TABLES
-- ──────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS ministries (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text        NOT NULL,
  category    text        NOT NULL,  -- Spirituality | Liturgy | Music | Formation & Community | Mission
  description text,
  phone       text,
  email       text,
  age         text,
  meeting     text,
  tags        jsonb       NOT NULL DEFAULT '{"grow":[],"who":[],"time":[]}'::jsonb,
  random      boolean     NOT NULL DEFAULT false,
  active      boolean     NOT NULL DEFAULT true,
  sort_order  integer     NOT NULL DEFAULT 0,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS sessions (
  id                      uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  name                    text        NOT NULL,
  whatsapp                text        NOT NULL,
  grow_interests          text[]      NOT NULL DEFAULT '{}',
  age_group               text[]      NOT NULL DEFAULT '{}',
  recommended_ministries  text[]      NOT NULL DEFAULT '{}',
  created_at              timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS cta_events (
  id            uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id    uuid        REFERENCES sessions(id),
  ministry_name text        NOT NULL,
  cta_type      text        NOT NULL,  -- whatsapp | email | website | parish_office
  clicked_at    timestamptz NOT NULL DEFAULT now()
);

-- ──────────────────────────────────────────────────────────────
-- 2. ROW LEVEL SECURITY
-- ──────────────────────────────────────────────────────────────

ALTER TABLE ministries  ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions    ENABLE ROW LEVEL SECURITY;
ALTER TABLE cta_events  ENABLE ROW LEVEL SECURITY;

-- Public: read active ministries only
CREATE POLICY "anon_read_active_ministries"
  ON ministries FOR SELECT TO anon
  USING (active = true);

-- Public: insert sessions (no read-back)
CREATE POLICY "anon_insert_sessions"
  ON sessions FOR INSERT TO anon
  WITH CHECK (true);

-- Public: insert CTA events
CREATE POLICY "anon_insert_cta_events"
  ON cta_events FOR INSERT TO anon
  WITH CHECK (true);

-- Authenticated (admin dashboard): full access
CREATE POLICY "auth_all_ministries"
  ON ministries FOR ALL TO authenticated
  USING (true) WITH CHECK (true);

CREATE POLICY "auth_read_sessions"
  ON sessions FOR SELECT TO authenticated
  USING (true);

CREATE POLICY "auth_read_cta_events"
  ON cta_events FOR SELECT TO authenticated
  USING (true);

-- ──────────────────────────────────────────────────────────────
-- 3. SEED: MINISTRIES
-- ──────────────────────────────────────────────────────────────

INSERT INTO ministries (name, category, description, phone, email, age, meeting, tags, sort_order) VALUES

-- ── Spirituality ────────────────────────────────────────────
('Rosary', 'Spirituality',
 'A long-standing Marian prayer community praying the Rosary daily in church and via Zoom, interceding for the Pope, the Parish, and those in need.',
 '9782 9251 / 9126 2629 / 9797 7091', '', '', 'Morning: Mon–Sat after 7.30am Mass (church) & Mon–Fri 9am (Zoom); Evening: Mon–Fri 5.15–5.45pm (church) & Mon–Sat 5pm (Zoom)',
 '{"grow":["prayer","contemplative"],"who":["all-ages"],"time":["weekly"]}'::jsonb, 10),

('Divine Mercy', 'Spirituality',
 'Conducts Divine Mercy devotion after the Wednesday 6pm Mass, praying the Chaplet for the needs of the world and performing spiritual and corporal works of mercy.',
 '', 'emilkyeo@gmail.com', '', 'Every Wednesday, after the 6pm Mass, Main Church',
 '{"grow":["prayer","contemplative"],"who":["all-ages"],"time":["weekly"]}'::jsonb, 20),

('Children''s Eucharistic Adoration', 'Spirituality',
 '', '', '', '', '',
 '{"grow":["prayer","worship"],"who":["children"],"time":["weekly"]}'::jsonb, 30),

('Christian Meditation', 'Spirituality',
 'A group practising Christian Meditation as a simple prayer of the heart — meeting weekly to listen to a talk, read the day''s Gospel, share Gospel values, and meditate for 20 minutes.',
 '9180 1208', 'nancykcwchoy@gmail.com', '', 'Every Friday, 2.30–3.30pm, St Francis Xavier Chapel, Kingsmead Hall',
 '{"grow":["prayer","contemplative"],"who":["adult","senior"],"time":["weekly"]}'::jsonb, 40),

('Legion of Mary', 'Spirituality',
 'A Marian apostolic association of ~100 members across six praesidia, serving through prayer, home and hospital visits, evangelism, and parish apostolic works.',
 '9710 5934', 'simonchiath@gmail.com', '', '',
 '{"grow":["prayer","service","outreach"],"who":["adult","senior"],"time":["weekly"]}'::jsonb, 50),

('Charismatic Renewal', 'Spirituality',
 'Gathers Catholics to encounter God through the Holy Spirit via healing sessions, Mass, Bible sharing, talks, and intercessory prayers — all are welcome.',
 '', 'cpg.cosi@gmail.com', '', 'Every Wednesday, 8–9.30pm, St Ignatius Hall (fellowship from 7.20pm); Intercessory Prayer: Tuesdays 2.30pm, Sacred Heart Adoration Room',
 '{"grow":["prayer","worship","community"],"who":["all-ages"],"time":["weekly"]}'::jsonb, 60),

('Open Studio', 'Spirituality',
 'A creative prayer ministry where participants listen to Scripture and respond through art, writing, or other creative expressions. Themed for Lent, Easter, Ordinary Time, and Advent. No prior art experience needed.',
 '', 'openstudio.stignatius@gmail.com', '', '',
 '{"grow":["creative","prayer"],"who":["adult"],"time":["ad-hoc","seasonal"]}'::jsonb, 70),

('Lilies of the Valley', 'Spirituality',
 'A bereavement ministry providing spiritual aid and support to bereaved parishioners and their families by praying at wakes and assisting in funeral services.',
 '', '', '', '',
 '{"grow":["service","prayer"],"who":["adult","senior"],"time":["ad-hoc"]}'::jsonb, 80),

-- ── Liturgy ─────────────────────────────────────────────────
('EMHC', 'Liturgy',
 'Assists priests with the distribution of Holy Communion at all weekday and weekend Masses, and at Archdiocesan events when required.',
 '9689 2313', 'danleecg@gmail.com', '', 'Weekday and weekend Masses, Main Church',
 '{"grow":["service","liturgy"],"who":["adult"],"time":["weekly"]}'::jsonb, 110),

('Lectors', 'Liturgy',
 'A ministry of ~80 commissioned Proclaimers of the Word, proclaiming Scripture at all Masses with fervour and conviction, with regular preparatory sessions, retreats, and social events.',
 '', 'mayyintay@gmail.com', '', 'Every Wednesday 8–9pm (Zoom); Weekday & Weekend Masses as rostered',
 '{"grow":["service","scripture","liturgy"],"who":["adult"],"time":["weekly"]}'::jsonb, 120),

('Altar Servers', 'Liturgy',
 'An active community of Catholic boys assisting priests during all Masses and liturgical events, with ongoing training and faith formation throughout the year.',
 '', 'stignatiusaltarservers@gmail.com', '', 'Weekday and weekend Masses, Main Church',
 '{"grow":["service","liturgy"],"who":["youth"],"time":["weekly"]}'::jsonb, 130),

('Traffic Assistance', 'Liturgy',
 'Manages carparks at Kingsmead Hall and Sacred Heart Hall to ensure safe and orderly parking for Mass-goers and special parish events.',
 '9667 6690', 'rajoypebe@gmail.com', '', '30 min before Masses and events',
 '{"grow":["service"],"who":["adult","senior"],"time":["weekly"]}'::jsonb, 140),

('Flower Ladies', 'Liturgy',
 'A dedicated group who beautify the altar with flowers to complement the liturgy — also providing floral arrangements for Wedding Masses upon request. Basic flower arrangement training required.',
 '', 'famtjia@yahoo.com', '', 'Every Friday, Church Sacristy (timing varies)',
 '{"grow":["creative","service","liturgy"],"who":["adult"],"time":["weekly"]}'::jsonb, 150),

('Hospitality', 'Liturgy',
 'Creates a welcoming environment of love, acceptance, and care for visitors and parishioners — serving as greeters and collectors to enhance the worship experience and build community.',
 '', 'hm.stignatius@gmail.com', '', '',
 '{"grow":["service","community"],"who":["adult"],"time":["weekly"]}'::jsonb, 160),

('Infant Baptism', 'Liturgy',
 'Facilitates baptism for children up to 7 years of age, guiding parents and godparents in their commitment to raise the child in the Catholic faith. For children aged 7–16, contact the Catechetical Coordinator.',
 '', 'sflchoo@yahoo.com', 'Up to 7 years', '',
 '{"grow":["formation"],"who":["parent"],"time":["ad-hoc"]}'::jsonb, 170),

('Wedding Ministry', 'Liturgy',
 'Journeys with engaged couples in preparation for their Church wedding, providing mentorship and serving as a bridge between the Church and soon-to-be-married couples.',
 '', 'csi.weddings@catholic.org.sg', '', '',
 '{"grow":["service","community"],"who":["adult","couple"],"time":["ad-hoc"]}'::jsonb, 180),

('Digital Media', 'Liturgy',
 '', '', 'https://docs.google.com/forms/d/e/1FAIpQLSctovEKrbLKLE_i5zY34-b1zO9WKCare0OR_oa4twO5QrvkuQ/viewform', '', '',
 '{"grow":["creative","service"],"who":["adult","young-adult"],"time":["ad-hoc"]}'::jsonb, 190),

('Liturgy of the Word for Children (LOWC)', 'Liturgy',
 'Proclaims the Sunday Gospel to children aged 3–10 during the 8am Mass in an age-appropriate way, with seasonal activities. No registration required.',
 '', 'csi.childrensliturgy@gmail.com', '3–10 years', 'Sunday 8am Mass, La Storta Room (Attic Level)',
 '{"grow":["service","formation"],"who":["children"],"time":["weekly"]}'::jsonb, 200),

('Advent Wreath Ministry', 'Liturgy',
 'Organises the annual Advent Wreath making for parishioners to mark the start of the liturgical season of Advent.',
 '9815 2588 / 9762 0868', 'lynetteme@gmail.com / vivienc02@gmail.com', '', 'Start of Advent, Sacred Heart Hall',
 '{"grow":["creative","community"],"who":["all-ages"],"time":["seasonal"]}'::jsonb, 210),

-- ── Music ────────────────────────────────────────────────────
('Laudate Dominum Choir', 'Music',
 'Leads the congregation in song at the 1st, 3rd & 5th Saturday 6pm Mass.',
 '', 'LDChoir0623@gmail.com', '', '1st, 3rd & 5th Saturday, 3.45–6pm, MR1',
 '{"grow":["worship","music"],"who":["young-adult","adult"],"time":["weekly"]}'::jsonb, 310),

('St Francis Xavier Choir', 'Music',
 'Leads the 2nd & 4th Saturday 6pm Mass in song.',
 '', 'mtatoy@gmail.com / goof68at@gmail.com', '', '2nd & 4th Saturday, 3.30–6pm, MR1',
 '{"grow":["worship","music"],"who":["young-adult","adult"],"time":["weekly"]}'::jsonb, 320),

('Family Choir & Salve Regina Orchestra', 'Music',
 'An intergenerational choir for all ages leading the Sunday 8am Mass; the Orchestra plays for Christmas, Easter, and Feast Days.',
 '', 'stiggyfamilychoir@gmail.com', '', 'Every Sunday, 9.30–11.30am, MR2 & 3',
 '{"grow":["worship","music"],"who":["all-ages"],"time":["weekly"]}'::jsonb, 330),

('Ignatian Voices', 'Music',
 'Leads the Sunday 10am Mass in song.',
 '', 'huang.adrian@gmail.com', '', 'Last Saturday of month 2–4.30pm (MR2); Sundays 9.20–9.50am (Main Church)',
 '{"grow":["worship","music"],"who":["young-adult","adult"],"time":["weekly"]}'::jsonb, 340),

('Laetare Choir', 'Music',
 'Leads the 1st & 3rd Sunday 4pm Mass in song.',
 '8622 6937 / 9003 3419', '', '', '1st & 3rd Sunday, 2–3.30pm, MR1',
 '{"grow":["worship","music"],"who":["adult","senior"],"time":["monthly"]}'::jsonb, 350),

('Instruments of Love Choir', 'Music',
 'Leads the 2nd Sunday 4pm Mass in song.',
 '9231 3163', '', '', '2nd Sunday, 1.30–3pm, MR2 & 3',
 '{"grow":["worship","music"],"who":["adult"],"time":["monthly"]}'::jsonb, 360),

('Celia''s Choir', 'Music',
 'Leads the 4th & 5th Sunday 4pm Mass in song.',
 '9691 2349', '', '', '4th Tuesday 8–10pm (MR1); 4th & 5th Sunday 2–3.30pm (Main Church)',
 '{"grow":["worship","music"],"who":["adult","senior"],"time":["monthly"]}'::jsonb, 370),

('Soli Deo Gloria (SDG) Choir', 'Music',
 'Leads the Sunday 6pm Mass in song.',
 '9690 3887', '', '', 'Every Sunday, 3.30–6pm, MR1',
 '{"grow":["worship","music"],"who":["young-adult","adult"],"time":["weekly"]}'::jsonb, 380),

-- ── Formation & Community ────────────────────────────────────
('Alpha', 'Formation & Community',
 'A relaxed, friendly introduction to the Christian faith through weekly sessions with a meal, talk, and group discussion — open to anyone exploring life''s big questions.',
 '', 'aptks88@gmail.com', '', '2 runs/year, 10–15 weekly sessions; Tuesdays 7.30–9.30pm',
 '{"grow":["formation","community","exploring"],"who":["adult","young-adult"],"time":["weekly"]}'::jsonb, 410),

('Rite of Christian Initiation (RCIA & RCIY)', 'Formation & Community',
 'A faith journey for those curious about the Catholic Church — through prayer, scripture, and spiritual conversations, candidates may be baptised or received into the Church.',
 '', 'rciastignatius@gmail.com', '25 & above (RCIA) / 16–25 (RCIY)', 'Every Tuesday, 8.00–10.00pm, Annexe Hall',
 '{"grow":["formation","prayer","scripture","exploring"],"who":["adult"],"time":["weekly"]}'::jsonb, 420),

('Catechetical', 'Formation & Community',
 'Provides faith formation and religious education for children, youth, and adults in the parish.',
 '', '', '', '',
 '{"grow":["formation","scripture"],"who":["children"],"time":["weekly"]}'::jsonb, 430),

('Bible Apostolate', 'Formation & Community',
 'Combines personal Bible reading, lectures, small-group faith sharing, and prayer to deepen participants'' understanding of Scripture and relationship with God.',
 '9667 6690', 'batstigsingapore@gmail.com', '', '',
 '{"grow":["scripture","formation","community"],"who":["adult"],"time":["weekly"]}'::jsonb, 440),

('HK Bible Study Group', 'Formation & Community',
 '', '', '', '', '',
 '{"grow":["scripture","formation","community"],"who":["adult"],"time":["weekly"]}'::jsonb, 450),

('Magis Family Ministry', 'Formation & Community',
 'A family life ministry open to all parishioners, fostering the spiritual growth of families through the Couple Empowerment Programme, Couple Mentorship Journey, Magis Circles, family Masses, and gatherings.',
 '', 'magisfamilyministry.stignatius@gmail.com', '', '',
 '{"grow":["formation","community"],"who":["couple","parent","adult"],"time":["monthly"]}'::jsonb, 460),

('Couple Empowerment', 'Formation & Community',
 'A post-marriage catechesis programme helping Catholic couples deepen their understanding of Church teaching on marriage and family, develop life skills, effective parenting, and faith formation.',
 '', 'goto_cep@hotmail.com', 'Married couples', '',
 '{"grow":["formation","community"],"who":["married"],"time":["weekly"]}'::jsonb, 470),

('Couple Mentor Journey', 'Formation & Community',
 'A couple-to-couple mentorship programme pairing newly-wed couples with seven seasoned married couples for an eight-week journey of accompaniment, prayer, and support.',
 '', 'magisfamilyministry.stignatius@gmail.com', 'Engaged & married couples', '',
 '{"grow":["formation","community"],"who":["married","engaged"],"time":["weekly"]}'::jsonb, 480),

('Marriage Preparation Course (MPC)', 'Formation & Community',
 'Established in 1983, a Catholic programme helping couples planning to marry prepare meaningfully for their life as spouses, future parents, and members of the Christian community.',
 '', 'https://www.mpcsingapore.com/homepage', 'Engaged / pre-marriage couples', '',
 '{"grow":["formation"],"who":["engaged"],"time":["ad-hoc"]}'::jsonb, 490),

('Catholic Engaged Encounter (CEE)', 'Formation & Community',
 'An international weekend marriage preparation programme approved by the Catholic Church — giving engaged couples time to communicate honestly about their plans and grow their relationship before marriage.',
 '', '', 'Engaged / pre-marriage couples', '',
 '{"grow":["formation","community"],"who":["engaged"],"time":["weekend"]}'::jsonb, 500),

('NCC', 'Formation & Community',
 'Small Christian community groups of 8–12 members based in neighbourhoods around the parish, gathering regularly to grow in faith through Scripture sharing, worship, prayers, pilgrimages, and charity works.',
 '9450 7077', 'ncc.stignatius.sg@gmail.com', '', 'Varies depending on each NCC group',
 '{"grow":["community","prayer","scripture","service"],"who":["all-ages"],"time":["weekly"]}'::jsonb, 510),

('Landings', 'Formation & Community',
 'A 10-week reconciliation ministry welcoming returning Catholics back to the Church through small groups and shared faith stories in a warm, non-judgmental environment.',
 '9012 9698 / 9783 6026', 'stignatius@landings.org.sg', '', 'Every Friday, 7.30pm, Cathedral of the Good Shepherd',
 '{"grow":["formation","community","returning"],"who":["adult"],"time":["weekly"]}'::jsonb, 520),

('Crossing', 'Formation & Community',
 'A young adults community (early 30s–40s) deepening their relationship with God through Ignatian Spirituality — journeying together as companions in faith, breaking bread, and seeking God in all things.',
 '', 'crossingcore@gmail.com', 'Early 30s to early 40s', 'Fridays 8.30–10pm; Saturdays AM or PM',
 '{"grow":["community","prayer"],"who":["young-adult"],"time":["weekly"]}'::jsonb, 530),

('DVC', 'Formation & Community',
 'The De Vita Christi Youth Community gathers St Ignatius'' youth ministries into one close-knit family, focused on living Christ-centred lives and accompanying one another in faith and service.',
 '', '', '', '',
 '{"grow":["community","service","formation","worship"],"who":["youth","young-adult"],"time":["weekly"]}'::jsonb, 540),

('Generation CHRIST@I', 'Formation & Community',
 'A Eucharistic Adoration ministry promoting parish-wide adoration programmes through Scripture reflection, Rosary, and Zoom sessions to foster a deeper relationship with Christ.',
 '', 'gen.christ.ministry@gmail.com', '', 'Scripture reflection/Adoration: 1st Friday 9–9.45pm (Zoom); Rosary: every Saturday 9–9.45pm (Zoom)',
 '{"grow":["prayer","worship","contemplative"],"who":["young-adult"],"time":["ad-hoc"]}'::jsonb, 550),

('Channel of Peace', 'Formation & Community',
 '', '', '', '', '',
 '{"grow":["prayer","community"],"who":["adult"],"time":["monthly"]}'::jsonb, 560),

('I2O Ministry', 'Formation & Community',
 'Connects people to Jesus and community through THE SEARCH — a 7-week programme of video sessions and group discussions for those seeking life''s ultimate meaning.',
 '', 'de.search.st.igs@gmail.com', '', 'Every Wednesday, 7–9pm, Crossings Cafe, 55 Waterloo St',
 '{"grow":["outreach","formation","exploring","returning"],"who":["adult","young-adult"],"time":["weekly"]}'::jsonb, 570),

('Praying Parents Group', 'Formation & Community',
 'Brings together mothers and fathers who desire to pray for their children and families — a safe space for sharing, mutual encouragement, and intercession through monthly gatherings.',
 '', 'aaronboey2012@gmail.com / cindyvyeo@gmail.com', 'Parents', 'Every 2nd/3rd Saturday of catechetical year, 4–5.30pm, La Storta Room',
 '{"grow":["prayer","community"],"who":["parent"],"time":["monthly"]}'::jsonb, 580),

('RCIY', 'Formation & Community',
 'A programme for youths aged 16–25 interested in the Catholic Faith — a vibrant community of facilitators, sponsors, inquirers, and confirmands journeying together towards baptism and beyond.',
 '9728 5806', 'rciy.ignatius@gmail.com', '16–25', 'Every Saturday, 1.30–3.45pm, Attic (L3 Annexe), St Ignatius',
 '{"grow":["formation","prayer","scripture","exploring"],"who":["youth"],"time":["weekly"]}'::jsonb, 590),

('DVC Youth Choir', 'Formation & Community',
 'A close-knit youth choir leading the 12.15pm Sunday Mass in song, empowering young members to grow as worshippers musically and spiritually in a Christ-centred community.',
 '', 'dvcyouthchoir@gmail.com', 'Youth', 'Every Sunday, 9am–12pm, MR 2 & 3',
 '{"grow":["worship","music","community"],"who":["youth"],"time":["weekly"]}'::jsonb, 600),

('DVC Facilitators', 'Formation & Community',
 'Companions to Sec 3 & 4 confirmation students, journeying alongside young people in faith — assisting catechists, building friendships, and reflecting Christ''s love and mercy.',
 '', 'facilsministrydvc.stigs@gmail.com', 'Youth', 'Every Saturday 3–6pm; Sundays 9.30am–12pm (Zoom)',
 '{"grow":["service","formation"],"who":["youth"],"time":["weekly"]}'::jsonb, 610),

('DVC Harbour Community', 'Formation & Community',
 'A community for young adults (born 1995–2000) gathering weekly for faith formation, Scripture, Church teachings, and fellowship — creating a space for disciples to grow together.',
 '', 'harbourcore@gmail.com', 'Born 1995–2000', 'Saturdays 4.30–6.30pm, St Ignatius Annexe Building',
 '{"grow":["community","formation","scripture"],"who":["young-adult"],"time":["weekly"]}'::jsonb, 620),

('Seeking Surrender', 'Formation & Community',
 'DVC''s worship community and music ministry, serving at camps and events through song — a welcoming, faith-filled community growing through scripture, prayer, and fellowship. No musical experience required!',
 '8428 6675', '', 'Youth', 'Every Wednesday, 8–10pm, Annexe Hall',
 '{"grow":["worship","music","community","prayer"],"who":["youth","young-adult"],"time":["weekly"]}'::jsonb, 630),

-- ── Mission ──────────────────────────────────────────────────
('St Vincent de Paul', 'Mission',
 'A Catholic lay organisation serving those in need — visiting and supporting about 120 vulnerable families with monthly aid, and reaching out to migrant workers and at-risk youth.',
 '', 'stignatius@ssvpsingapore.org', '', 'Every 1st & 3rd Sunday, 9.45–11.30am, Room #01-04/05',
 '{"grow":["service","outreach"],"who":["adult","senior"],"time":["monthly"]}'::jsonb, 710),

('Willing Hands', 'Mission',
 'Comes together to clean the Church — sweeping, mopping, dusting, and tidying — especially during Lent and Advent, followed by Mass and breakfast as a group.',
 '9737 3002', '', '', 'Every Tuesday, 9.00am, Main Church',
 '{"grow":["service"],"who":["adult","senior"],"time":["weekly"]}'::jsonb, 720),

('HomeMakers', 'Mission',
 'Organises bi-annual Jumble Sales to raise funds for the Church''s Social Mission Fund, meeting weekly to sort, clean, and pack donated items. All are welcome!',
 '9782 9251', 'boonlanyong@yahoo.com', '', 'Every Wednesday, 9am–11am, Sacred Heart Hall',
 '{"grow":["service","community"],"who":["adult","senior"],"time":["weekly"]}'::jsonb, 730),

('Social Mission', 'Mission',
 'Reaches out to those who have slipped through existing social aid — providing financial assistance, mentoring, and companionship to help beneficiaries navigate available support.',
 '', 'csi.social@catholic.org.sg', '', 'Ad-hoc',
 '{"grow":["service","outreach"],"who":["adult"],"time":["ad-hoc"]}'::jsonb, 740),

('Green Movement', 'Mission',
 'Responds to Pope Francis'' ''Laudato Si'' by promoting care for the earth — raising environmental awareness, initiating sustainable practices, and tending the parish community garden.',
 '9664 2094', 'ambersky268@gmail.com', '', 'Ad-hoc meetings/events throughout the year',
 '{"grow":["service","outreach"],"who":["all-ages"],"time":["ad-hoc"]}'::jsonb, 750),

('Iggy Connect', 'Mission',
 '', '', '', '', '',
 '{"grow":["community","outreach"],"who":["young-adult","adult"],"time":["ad-hoc"]}'::jsonb, 760),

('PaCES Ministry', 'Mission',
 'Journeys with the housebound elderly and sick through pastoral visits, prayer, and bringing sacraments to them in their homes or hospitals.',
 '9675 6621', '', '', '5 meetings annually or as required',
 '{"grow":["service"],"who":["adult","senior"],"time":["monthly"]}'::jsonb, 770),

('D''Fellowship', 'Mission',
 'A dementia-friendly ministry offering fellowship, structured exercises, games, music, and spiritual activities to parishioners with dementia and their caregivers.',
 '', 'margaret.loong@gmail.com', '', 'Every 2nd & 4th Tuesday, 10am–12noon, Sacred Heart Hall Canteen',
 '{"grow":["service","community"],"who":["senior"],"time":["monthly"]}'::jsonb, 780),

('Parish Emergency Resource Team (PERT)', 'Mission',
 'First responders trained to help the parish manage emergencies — from medical assistance to safe evacuation during fires or security threats. Training provided for all volunteers.',
 '6466 0625', 'csi.admin@catholic.org.sg', '', 'Coordinated virtually; annual in-person training only',
 '{"grow":["service"],"who":["adult"],"time":["ad-hoc"]}'::jsonb, 790),

('Sunday Canteen', 'Mission',
 '', '', '', '', '',
 '{"grow":["service","community"],"who":["adult","senior"],"time":["weekly"]}'::jsonb, 800);
