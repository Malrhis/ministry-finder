-- ============================================================
-- Migration 006 — Make whatsapp column optional
-- ============================================================

-- Allow whatsapp to be empty (column stays for historical rows)
ALTER TABLE sessions ALTER COLUMN whatsapp DROP NOT NULL;
ALTER TABLE sessions ALTER COLUMN whatsapp SET DEFAULT '';

-- Update RLS: drop whatsapp requirement, keep consent + name check
DROP POLICY IF EXISTS "anon_insert_sessions" ON sessions;

CREATE POLICY "anon_insert_sessions"
  ON sessions FOR INSERT TO anon
  WITH CHECK (
    pdpa_consent = true
    AND length(trim(name)) > 0
  );
