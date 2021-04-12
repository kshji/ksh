
-- checksum731.sql
-- Creator: Jukka Inkeri 6.5.2020
-- Same as
-- https://github.com/kshji/ksh/tree/master/Sh  731.sh

create or replace function checksum731(refsrc in TEXT) 
returns SMALLINT
AS
$BODY$

DECLARE
/**
	SELECT checksum731('7');
	- return 1 => Ref is 71
	SELECT checksum731('7760011202383');
	- return 2 => Ref is 77600112023832

        SELECT v.ref AS orgvalue
                ,substr(v.ref,1,length(v.ref)-1 ) AS orgvalue_minus_last_char
                ,checksum731(substr(v.ref,1,length(v.ref)-1 )) AS checksumchar
                ,substr(v.ref,1,length(v.ref)-1 )
                 || checksum731(substr(v.ref,1,length(v.ref)-1 )) AS ref
        FROM (select '71'::text AS ref ) AS v
*/
  mask TEXT;
  sum int;
  i int;
  len int; 
  loc int;
  num TEXT;
  decnum int;
  checksum smallint;
  factor text;
  result int;
  mod int;

BEGIN
	mask := '731731731731731731731731731731731731731731731731';
       	sum:=0;
	i:=1;
	sum:=0;
	len:=length(refsrc);

	-- max 19 numbers
	IF len > 19 THEN
		RAISE EXCEPTION 'max. length 19' USING HINT='Check length';
                --RETURN NULL::SMALLINT;
        END IF;
	
	loc:=len;  -- 1. ind 1, jos olisi 0 niin -1
	WHILE i<=len LOOP
		--RAISE NOTICE '----%',i;
		factor:=substr(mask,i,1); 
		--RAISE NOTICE 'factor:%',factor;
		num:=substr(refsrc,loc,1);
		--RAISE NOTICE 'num:%',num;
		loc:=loc-1;
		i:=i+1 ;
		result:=factor::INT * num::INT ;
		--RAISE NOTICE 'result:%',result;
		sum:=sum+result;
	END LOOP;

	decnum:=sum;
	--RAISE NOTICE 'decnum1:%',decnum;
	mod:=sum%10;
	--RAISE NOTICE 'mod:%',mod;
	if mod <> 0 then  -- next equal 10
		decnum:= (sum/10+1)*10 ;
	END IF;
	--RAISE NOTICE 'decnum2:%',decnum;
	checksum := decnum-sum ;

	-- Output Payment reference Number checksum digit
	RETURN checksum;


END;
$BODY$
language plpgsql strict immutable;


