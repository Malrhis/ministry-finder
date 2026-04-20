-- ============================================================
-- Migration 004 — Add PDPA consent column to sessions
-- ============================================================

ALTER TABLE sessions
  ADD COLUMN IF NOT EXISTS pdpa_consent boolean NOT NULL DEFAULT false;
