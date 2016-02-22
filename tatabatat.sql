DELIMITER $$

DROP PROCEDURE IF EXISTS `ps_games` $$
CREATE  PROCEDURE `ps_games`(
	in platform_name varchar(32),
 	in games_title	varchar(255),
    in games_image_url	text,
    in games_date	date,
    in games_year	varchar(4),
    in games_month varchar(16),
    in games_day	varchar(4))

BEGIN

 	-- var existe
	declare existe int(16) default 0;
    
    
    
    -- this for games
	declare game_id int(16) default -1;
	
	-- this for platforms
	declare platform_id int(16) default -1;
    
	set platform_id =(select  id from platforms where name=platform_name);
	IF platform_id=-1 THEN
		INSERT INTO `platforms`( `name`) VALUES (platform_name);
		SET platform_id = mysql_insert_id();
	ELSE
	 UPDATE `platforms` SET `name`= @platform_name WHERE `id`=platform_id;
	 SET existe=1;
	END IF;
	
	
    
	set game_id=(select id from games where title=games_title);
    
	if game_id=-1 then
		INSERT INTO `games`(`title`, `image_url`, `date`, `year`, `month`, `day`) 
		VALUES (games_title,games_image_url,games_date,games_year,games_month,games_day);
		set game_id = mysql_insert_id();
	else
	UPDATE `games` SET `title`=games_title,`image_url`=games_image_url,`date`=games_date,`year`=games_year,`month`=games_month,`day`=games_day WHERE `id`=game_id;
	 set existe=existe+1;
	end if;
    
    
    
	if existe<>2 then 
		INSERT INTO `supports`( `game_id`, `platform_id`)
		VALUES (game_id,platform_id);
	end if;
    
END $$

DELIMITER ;