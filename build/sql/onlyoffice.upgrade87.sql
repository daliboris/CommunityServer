DELIMITER DLM00

DROP PROCEDURE IF EXISTS upgrade87 DLM00

CREATE PROCEDURE upgrade87()
BEGIN
	IF NOT EXISTS(SELECT * FROM information_schema.`COLUMNS` WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'tenants_partners' AND COLUMN_NAME = 'affiliate_id') THEN
		ALTER TABLE `tenants_partners` ADD COLUMN `affiliate_id` VARCHAR(50) DEFAULT NULL;
		ALTER TABLE `tenants_partners` ALTER `partner_id` DROP DEFAULT;
		ALTER TABLE `tenants_partners` CHANGE COLUMN `partner_id` `partner_id` VARCHAR(36) DEFAULT NULL;
	END IF;

	IF NOT EXISTS(SELECT * FROM information_schema.`COLUMNS` WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'calendar_events' AND COLUMN_NAME = 'uid') THEN
		ALTER TABLE `calendar_events` ADD COLUMN `uid` VARCHAR(255) NULL DEFAULT NULL;
	END IF;

	IF NOT EXISTS(SELECT * FROM information_schema.`COLUMNS` WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'calendar_events' AND COLUMN_NAME = 'status') THEN
		ALTER TABLE `calendar_events` ADD COLUMN `status` SMALLINT NOT NULL DEFAULT 0;
	END IF;

	INSERT IGNORE INTO `crm_currency_info` (`resource_key`, `abbreviation`, `symbol`, `culture_name`, `is_convertable`, `is_basic`) VALUES ('Currenct_NigerianNaira', 'NGN', '?', 'NG', 1, 0);
	INSERT IGNORE INTO `crm_currency_info` (`resource_key`, `abbreviation`, `symbol`, `culture_name`, `is_convertable`, `is_basic`) VALUES ('Currency_CubanPeso', 'CUP', '$', 'CU', 0, 0);

	INSERT INTO `tenants_tariff` (`tenant`, `tariff`, `stamp`, `tariff_key`, `comment`, `create_on`) SELECT -1, `tariff`, `stamp`, `tariff_key`, `comment`, NOW() FROM `tenants_tariff` WHERE `tenant` != -1 ORDER BY `id` DESC LIMIT 1;
END DLM00

CALL upgrade87() DLM00

DELIMITER ;