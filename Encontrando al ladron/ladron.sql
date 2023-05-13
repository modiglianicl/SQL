-- Keep a log of any SQL queries you execute as you solve the mystery.
-- We go to the crime scene on July 28
SELECT *
FROM crime_scene_reports
WHERE day = 28 AND month = 7 AND street = 'Humphrey Street';
-- Found: "Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery. Interviews were conducted today with three witnesses who were present at the time – each of their interview transcripts mentions the bakery."


-- We check the interviews from witnesses on july 28.
 SELECT *
 FROM interviews
 WHERE transcript LIKE '%bakery%' AND month = 7 AND day = 28;
-- Found 1: Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.X
-- Found 2: I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money. X
-- Found 3: As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow.
-- The thief then asked the person on the other end of the phone to purchase the flight ticket.

    -- We search transactions made on july 28 on the atm on Legget Street
    SELECT * FROM
    bank_accounts
        JOIN people ON people.id = bank_accounts.person_id
    WHERE account_number IN (
        SELECT account_number
        FROM atm_transactions
        WHERE month = 7 AND day = 28 AND transaction_type = 'withdraw' AND atm_location = 'Leggett 	Street'
                            );
    -- Found suspects : Bruce, Diana, Brooke, Kenny, Iman, Luca, Taylor, Benista with 	id,license_plates and passport_number
    -- Found : License_plates of suspects

    -- We search for the earliest flight out of Fiftyville.
    SELECT * FROM flights WHERE day = 29 ORDER BY hour,minute;
    -- Found : The earliest flight out of Fiftyville is flight id 36 on july 29 at 8:20 to New 	York City

    -- Who takes this flight?
    SELECT * FROM passengers
        JOIN flights ON flights.id = passengers.flight_id
    WHERE passport_number IN (
        SELECT passport_number
        FROM people
        WHERE name in('Bruce','Diana','Brooke','Kenny','Iman','Luca','Taylor','Benista'))
    AND origin_airport_id = 8 AND day = 29 AND month = 7 AND hour = 8 AND minute = 20
    ORDER BY day,hour,minute;
    -- Found : 4 suspects take this flight
    -- Found : 5773159633,1988161715,9878712108,8496433585 got money from ATM and took the earliest flight!

    --Query for 4 suspects:
    SELECT * FROM people WHERE passport_number IN (SELECT passport_number FROM passengers
        JOIN flights ON flights.id = passengers.flight_id
    WHERE passport_number IN (
        SELECT passport_number
        FROM people
        WHERE name in('Bruce','Diana','Brooke','Kenny','Iman','Luca','Taylor','Benista'))
                    AND origin_airport_id = 8 AND day = 29 AND month = 7 AND hour = 8 AND minute = 		20
                    ORDER BY day,hour,minute);

    -- We search cars that left the parking lot 10 minutes after the theft.
    SELECT license_plate
    FROM bakery_security_logs
    WHERE month = 7 AND day = 28 AND hour = 10 AND activity = 'exit' AND minute BETWEEN 10 AND 25 	AND year = 2021;

    -- We check what license plate we saw at bakery store in the theft 10 min timeframe intersects with one of our 4 suspects
    SELECT license_plate
    FROM bakery_security_logs
    WHERE license_plate IN (    SELECT license_plate FROM people WHERE passport_number IN (SELECT passport_number FROM passengers
        JOIN flights ON flights.id = passengers.flight_id
    WHERE passport_number IN (
        SELECT passport_number
        FROM people
        WHERE name in('Bruce','Diana','Brooke','Kenny','Iman','Luca','Taylor','Benista'))
                    AND origin_airport_id = 8 AND day = 29 AND month = 7 AND hour = 8 AND minute = 			20
                    ORDER BY day,hour,minute))
    AND month = 7 AND day = 28 AND hour = 10 AND activity = 'exit' AND minute BETWEEN 10 AND 25 AND year = 2021;
    -- Found: Two license plates that drew money from atm and left parking lot around 10:15 at bakery store AND took the earliest flight from Fiftyville airport
    -- 94KL13X and 4328GD8
    SELECT * FROM people WHERE license_plate = '94KL13X' OR license_plate = '4328GD8';
    -- Those two are suspects : Luca and Bruce
    -- Passports numbers : 8496433585 , 5773159633
    -- License plates : 4328GD8, 94KL13X
    -- Phone numbers : (389) 555-5198, (367) 555-5533
    -- Now i gotta check who called!!!
    SELECT * FROM phone_calls WHERE caller = '(389) 555-5198';
    -- There are no calls from Luca the day of the theft.
    SELECT * FROM phone_calls WHERE caller = '(367) 555-5533' AND duration <= 60 AND day = 28;
    -- There is a call from Bruce on the day and hour of theft that lasts less than a minute!
    -- The thief is Bruce!!

    -- Who is the accomplice? the person who called Bruce which is (375) 555-8161
    SELECT * FROM people WHERE phone_number = '(375) 555-8161';
    -- Found : Robin