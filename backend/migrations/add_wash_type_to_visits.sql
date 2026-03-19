-- Migration: Add wash_type column to visits table
-- Date: 2026-03-19
-- Description: Adds wash_type field to track the type of car wash service selected by user

-- Add wash_type column to visits table
ALTER TABLE visits 
ADD COLUMN IF NOT EXISTS wash_type VARCHAR(20) DEFAULT 'sedan';

-- Add comment to the column
COMMENT ON COLUMN visits.wash_type IS 'Type of wash service: express, sedan, krossover, minivan, suv';

-- Create index for faster queries on wash_type
CREATE INDEX IF NOT EXISTS idx_visits_wash_type ON visits(wash_type);

-- Update existing records to have default wash_type
UPDATE visits 
SET wash_type = 'sedan' 
WHERE wash_type IS NULL;
