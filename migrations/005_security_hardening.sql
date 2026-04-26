-- ============================================================
-- Migration 005 — Security hardening
-- ============================================================

-- Drop old permissive policy and replace with one that enforces
-- PDPA consent and non-empty required fields at the DB layer.
DROP POLICY IF EXISTS "anon_insert_sessions" ON sessions;

CREATE POLICY "anon_insert_sessions"
  ON sessions FOR INSERT TO anon
  WITH CHECK (
    pdpa_consent = true
    AND length(trim(name))     > 0
    AND length(trim(whatsapp)) > 0
  );
