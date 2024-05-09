USE career_project;

SELECT * FROM career_track_info;
SELECT * FROM career_track_student_enrollments;

SELECT
	track_enroll.student_id,
    CONCAT(track_enroll.student_id, ROW_NUMBER() OVER w) AS unique_stuent_track_id,
    track_info.track_name,
    track_enroll.date_enrolled,
    track_enroll.date_completed,
    CASE
		WHEN track_enroll.date_completed IS NULL THEN 0
        ELSE 1
    END AS Track_Status,
    DATEDIFF(track_enroll.date_completed, track_enroll.date_enrolled) AS Days_to_Complete,
    CASE 
		WHEN DATEDIFF(track_enroll.date_completed, track_enroll.date_enrolled) = 0 THEN "Same Day"
        WHEN DATEDIFF(track_enroll.date_completed, track_enroll.date_enrolled) BETWEEN 1 AND 7 THEN "1 to 7 days"
		WHEN DATEDIFF(track_enroll.date_completed, track_enroll.date_enrolled) BETWEEN 8 AND 30 THEN "8 to 30 days"
		WHEN DATEDIFF(track_enroll.date_completed, track_enroll.date_enrolled) BETWEEN 31 AND 60 THEN "31 to 60 days"
		WHEN DATEDIFF(track_enroll.date_completed, track_enroll.date_enrolled) BETWEEN 61 AND 90 THEN "61 to 90 days"
		WHEN DATEDIFF(track_enroll.date_completed, track_enroll.date_enrolled) BETWEEN 91 AND 365 THEN "91 to 365 days"
		WHEN DATEDIFF(track_enroll.date_completed, track_enroll.date_enrolled) > 365 THEN "366+ days"
		ELSE null
	END AS Span_to_complete
FROM 
	career_track_student_enrollments as track_enroll
LEFT JOIN 
	career_track_info as track_info ON track_enroll.track_id = track_info.track_id
WINDOW w AS(PARTITION BY track_enroll.student_Id ORDER BY track_enroll.track_id ASC);