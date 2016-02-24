DELIMITER $$

DROP PROCEDURE IF EXISTS `ps_games` $$
CREATE  PROCEDURE `ps_games`(
	in platform_name varchar(1000),
 	in games_title	varchar(255),
    in games_image_url	text,
    in games_date	date,
    in games_year	varchar(4),
    in games_month varchar(16),
    in games_day	varchar(4))

BEGIN
declare  name_pl varchar(255) default '';

    declare i int default 1;

    declare count int default 0;
    -- this for games
	declare mgame_id int(16) default -1;
	
	-- this for platforms
	declare mplatform_id int(16) default -1;
    
    	if exists(select 1=1 from games where title=games_title) then
        begin 
            set mgame_id = (select id from games where title=games_title);
            UPDATE `games` SET `title`=games_title,`image_url`=games_image_url,`date`=games_date,`year`=games_year,`month`=games_month,`day`=games_day WHERE `id`=mgame_id;
        end;
	else
        begin
            INSERT INTO `games`(`title`, `image_url`, `date`, `year`, `month`, `day`) 
            VALUES (games_title,games_image_url,games_date,games_year,games_month,games_day);
            set mgame_id = LAST_INSERT_ID();
        end;
	end if;
    
    set count=LENGTH(platform_name) - LENGTH(REPLACE(platform_name, ',', '')) + 1;
set i=1;
while i<=count do
set name_pl =SUBSTRING_INDEX(SUBSTRING_INDEX(platform_name, ',', i) , ',' , -1 ) ;
	IF EXISTS (select  * from platforms where name=name_pl) THEN
    begin
        set mplatform_id=(select  id from platforms where name=name_pl);
    end;
	ELSE
     begin
	    INSERT INTO `platforms`( `name`) VALUES (name_pl);
		SET mplatform_id = LAST_INSERT_ID();
     end;
	END IF;

	if not exists(select * from supports where game_id=mgame_id and platform_id=mplatform_id ) then 
		INSERT INTO `supports`( `game_id`, `platform_id`)
		VALUES (mgame_id,mplatform_id);
	end if;
    set i=i+1;
  end while;  
END $$

DELIMITER ;