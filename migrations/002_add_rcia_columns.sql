-- ============================================================
-- Migration 002 — Add RCIA-app columns to ministries
-- ============================================================

ALTER TABLE ministries
  ADD COLUMN IF NOT EXISTS rcia_suitable  boolean  NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS app_categories text[]   NOT NULL DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS who_adult      boolean  NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS who_youth      boolean  NOT NULL DEFAULT false;
