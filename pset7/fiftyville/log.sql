-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Initial Information: When: 28-07-2020 | Where: Chamberlin Street => Query crime_scene_reports for a Description of this event
SELECT description FROM crime_scene_reports WHERE day = 28 AND month = 7 AND street = "Chamberlin Street";

-- From Crime Report Description: Theft took place at: 10:15am | Chamberlin Street Courthouse, 3 people interviewed and each mentioned "courthouse"
SELECT transcript FROM interviews WHERE year = 2020 AND month = 7 AND day = 28 AND transcript LIKE "%courthouse%";

-- From Interview Transcripts:
-- At 10:25am (within 10 minutes of theft) thief drove away => check courthouse securtity footage for cars leaving around that time
-- Suspect was at an ATM on Fifer Street before coming to the courthouse
-- After the crime suspect called somone for less than a minute => talked about earliest flight out of fiftyville tomorrow => asked for a ticket from accomplice
SELECT activity, license_plate FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25;
/* Cars leaving within suspected timeframe from the Courthouse Security Footage
exit | 5P2BI95
exit | 94KL13X
exit | 6P58WS2
exit | 4328GD8
exit | G412CB7
exit | L93JTIZ
exit | 322W7JE
exit | 0NTHK55
*/
SELECT * FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND transaction_type = "withdraw" AND atm_location = "Fifer Street";
/* ATM Transaction records
id | account_number | year | month | day | atm_location | transaction_type | amount
246 | 28500762 | 2020 | 7 | 28 | Fifer Street | withdraw | 48
264 | 28296815 | 2020 | 7 | 28 | Fifer Street | withdraw | 20
266 | 76054385 | 2020 | 7 | 28 | Fifer Street | withdraw | 60
267 | 49610011 | 2020 | 7 | 28 | Fifer Street | withdraw | 50
269 | 16153065 | 2020 | 7 | 28 | Fifer Street | withdraw | 80
288 | 25506511 | 2020 | 7 | 28 | Fifer Street | withdraw | 20
313 | 81061156 | 2020 | 7 | 28 | Fifer Street | withdraw | 30
336 | 26013199 | 2020 | 7 | 28 | Fifer Street | withdraw | 35
*/
SELECT * FROM phone_calls WHERE year = 2020 and month = 7 AND day = 28 AND duration < 60;
/* Phone Records
id | caller | receiver | year | month | day | duration
221 | (130) 555-0289 | (996) 555-8899 | 2020 | 7 | 28 | 51
224 | (499) 555-9472 | (892) 555-8872 | 2020 | 7 | 28 | 36
233 | (367) 555-5533 | (375) 555-8161 | 2020 | 7 | 28 | 45
251 | (499) 555-9472 | (717) 555-1342 | 2020 | 7 | 28 | 50
254 | (286) 555-6063 | (676) 555-6554 | 2020 | 7 | 28 | 43
255 | (770) 555-1861 | (725) 555-3243 | 2020 | 7 | 28 | 49
261 | (031) 555-6622 | (910) 555-3251 | 2020 | 7 | 28 | 38
279 | (826) 555-1652 | (066) 555-9701 | 2020 | 7 | 28 | 55
281 | (338) 555-6650 | (704) 555-2131 | 2020 | 7 | 28 | 54
*/

-- Check the bank_accounts and License_plates in the People table for shortlisting suspects.

-- Checking license_plates
SELECT * FROM people WHERE license_plate IN (SELECT license_plate FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25);
/*
id | name | phone_number | passport_number | license_plate
221103 | Patrick | (725) 555-4692 | 2963008352 | 5P2BI95
243696 | Amber | (301) 555-4174 | 7526138472 | 6P58WS2
396669 | Elizabeth | (829) 555-5269 | 7049073643 | L93JTIZ
398010 | Roger | (130) 555-0289 | 1695452385 | G412CB7
467400 | Danielle | (389) 555-5198 | 8496433585 | 4328GD8
514354 | Russell | (770) 555-1861 | 3592750733 | 322W7JE
560886 | Evelyn | (499) 555-9472 | 8294398571 | 0NTHK55
686048 | Ernest | (367) 555-5533 | 5773159633 | 94KL13X
*/

-- Checking Bank Accounts
SELECT * FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND transaction_type = "withdraw" AND atm_location = "Fifer Street");

/*
id | name | phone_number | passport_number | license_plate | account_number | person_id | creation_year
686048 | Ernest | (367) 555-5533 | 5773159633 | 94KL13X | 49610011 | 686048 | 2010
514354 | Russell | (770) 555-1861 | 3592750733 | 322W7JE | 26013199 | 514354 | 2012
458378 | Roy | (122) 555-4581 | 4408372428 | QX4YZN3 | 16153065 | 458378 | 2012
395717 | Bobby | (826) 555-1652 | 9878712108 | 30G67EN | 28296815 | 395717 | 2014
396669 | Elizabeth | (829) 555-5269 | 7049073643 | L93JTIZ | 25506511 | 396669 | 2014
467400 | Danielle | (389) 555-5198 | 8496433585 | 4328GD8 | 28500762 | 467400 | 2014
449774 | Madison | (286) 555-6063 | 1988161715 | 1106N58 | 76054385 | 449774 | 2015
438727 | Victoria | (338) 555-6650 | 9586786673 | 8X428L0 | 81061156 | 438727 | 2018
*/

-- Shortlisted Suspected with suspicious bank accounts and license_plates
SELECT name FROM people WHERE license_plate IN (SELECT license_plate FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25) INTERSECT SELECT name FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND transaction_type = "withdraw" AND atm_location = "Fifer Street");
/*
name
Danielle
Elizabeth
Ernest
Russell
*/
-- Shortlisted Suspected with suspicious bank accounts and license_plates - MORE INFO
SELECT name, passport_number, phone_number FROM people WHERE license_plate IN (SELECT license_plate FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25) INTERSECT SELECT name, passport_number, phone_number FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND transaction_type = "withdraw" AND atm_location = "Fifer Street");
/*
name | passport_number | phone_number
Danielle | 8496433585 | (389) 555-5198
Elizabeth | 7049073643 | (829) 555-5269
Ernest | 5773159633 | (367) 555-5533
Russell | 3592750733 | (770) 555-1861
*/

-- Checking which airport in Fiftyville city has exit flights on 29-07-2020
SELECT * FROM airports WHERE city = "Fiftyville";
/* One Airport from Fiftyville:
id | abbreviation | full_name | city
8 | CSF | Fiftyville Regional Airport | Fiftyville
*/

-- Check which flights leave tomorrow from CSF, order it to find the earliest flight
SELECT * FROM flights WHERE origin_airport_id = (SELECT id FROM airports WHERE city = "Fiftyville") AND day = 29 AND month = 7 AND year = 2020 ORDER BY hour;
/*
id | origin_airport_id | destination_airport_id | year | month | day | hour | minute
36 | 8 | 4 | 2020 | 7 | 29 | 8 | 20
43 | 8 | 1 | 2020 | 7 | 29 | 9 | 30
23 | 8 | 11 | 2020 | 7 | 29 | 12 | 15
53 | 8 | 9 | 2020 | 7 | 29 | 15 | 20
18 | 8 | 6 | 2020 | 7 | 29 | 16 | 0
*/

--Check the destination airports to see where the culprit went
SELECT * FROM airports WHERE id IN (SELECT destination_airport_id FROM flights WHERE origin_airport_id = (SELECT id FROM airports WHERE city = "Fiftyville") AND day = 29 AND month = 7 AND year = 2020 ORDER BY hour);
/*
id | abbreviation | full_name | city
1 | ORD | O'Hare International Airport | Chicago
4 | LHR | Heathrow Airport | London
6 | BOS | Logan International Airport | Boston
9 | HND | Tokyo International Airport | Tokyo
11 | SFO | San Francisco International Airport | San Francisco
*/


-- Check phone_calls table for receiver or accomplice
-- check passengers for passport number of people boarding

SELECT * FROM passengers WHERE passport_number IN (SELECT passport_number FROM people WHERE license_plate IN (SELECT license_plate FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25) INTERSECT SELECT passport_number FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND transaction_type = "withdraw" AND atm_location = "Fifer Street"));
/*
flight_id | passport_number | seat
11 | 8496433585 | 5D
18 | 3592750733 | 4C
24 | 3592750733 | 2C
26 | 7049073643 | 2C
36 | 5773159633 | 4A
36 | 8496433585 | 7B
48 | 8496433585 | 7C
54 | 3592750733 | 6C
*/

-- Catching the earliest flight and the person suspected
SELECT * FROM flights JOIN passengers ON flights.id = passengers.flight_id WHERE origin_airport_id = (SELECT id FROM airports WHERE city = "Fiftyville") AND day = 29 AND month = 7 AND year = 2020 AND passengers.passport_number IN (SELECT passport_number FROM passengers WHERE flight_id IN (SELECT id FROM flights WHERE origin_airport_id = (SELECT id FROM airports WHERE city = "Fiftyville") AND day = 29 AND month = 7 AND year = 2020 ORDER BY hour)) ORDER BY hour LIMIT 1;
/*
id | origin_airport_id | destination_airport_id | year | month | day | hour | minute | flight_id | passport_number | seat
36 | 8 | 4 | 2020 | 7 | 29 | 8 | 20 | 36 | 7214083635 | 2A
*/


SELECT * FROM flights JOIN passengers ON flights.id = passengers.flight_id WHERE origin_airport_id = (SELECT id FROM airports WHERE city = "Fiftyville") AND day = 29 AND month = 7 AND year = 2020 AND passengers.passport_number IN (SELECT passport_number FROM passengers WHERE flight_id IN (SELECT id FROM flights WHERE origin_airport_id = (SELECT id FROM airports WHERE city = "Fiftyville") AND day = 29 AND month = 7 AND year = 2020 ORDER BY hour)) ORDER BY hour;
/*
id | origin_airport_id | destination_airport_id | year | month | day | hour | minute | flight_id | passport_number | seat
36 | 8 | 4 | 2020 | 7 | 29 | 8 | 20 | 36 | 7214083635 | 2A
36 | 8 | 4 | 2020 | 7 | 29 | 8 | 20 | 36 | 1695452385 | 3B
36 | 8 | 4 | 2020 | 7 | 29 | 8 | 20 | 36 | 5773159633 | 4A <-------------------
36 | 8 | 4 | 2020 | 7 | 29 | 8 | 20 | 36 | 1540955065 | 5C
36 | 8 | 4 | 2020 | 7 | 29 | 8 | 20 | 36 | 8294398571 | 6C
36 | 8 | 4 | 2020 | 7 | 29 | 8 | 20 | 36 | 1988161715 | 6D
36 | 8 | 4 | 2020 | 7 | 29 | 8 | 20 | 36 | 9878712108 | 7A
36 | 8 | 4 | 2020 | 7 | 29 | 8 | 20 | 36 | 8496433585 | 7B <--------------------
43 | 8 | 1 | 2020 | 7 | 29 | 9 | 30 | 43 | 7597790505 | 7B
43 | 8 | 1 | 2020 | 7 | 29 | 9 | 30 | 43 | 6128131458 | 8A
43 | 8 | 1 | 2020 | 7 | 29 | 9 | 30 | 43 | 6264773605 | 9A
43 | 8 | 1 | 2020 | 7 | 29 | 9 | 30 | 43 | 3642612721 | 2C
43 | 8 | 1 | 2020 | 7 | 29 | 9 | 30 | 43 | 4356447308 | 3B
43 | 8 | 1 | 2020 | 7 | 29 | 9 | 30 | 43 | 7441135547 | 4A
23 | 8 | 11 | 2020 | 7 | 29 | 12 | 15 | 23 | 4149859587 | 7D
23 | 8 | 11 | 2020 | 7 | 29 | 12 | 15 | 23 | 9183348466 | 8A
23 | 8 | 11 | 2020 | 7 | 29 | 12 | 15 | 23 | 7378796210 | 9B
23 | 8 | 11 | 2020 | 7 | 29 | 12 | 15 | 23 | 7874488539 | 2C
23 | 8 | 11 | 2020 | 7 | 29 | 12 | 15 | 23 | 4195341387 | 3A
23 | 8 | 11 | 2020 | 7 | 29 | 12 | 15 | 23 | 6263461050 | 4A
23 | 8 | 11 | 2020 | 7 | 29 | 12 | 15 | 23 | 3231999695 | 5A
23 | 8 | 11 | 2020 | 7 | 29 | 12 | 15 | 23 | 7951366683 | 6B
53 | 8 | 9 | 2020 | 7 | 29 | 15 | 20 | 53 | 7894166154 | 9B
53 | 8 | 9 | 2020 | 7 | 29 | 15 | 20 | 53 | 6034823042 | 2C
53 | 8 | 9 | 2020 | 7 | 29 | 15 | 20 | 53 | 4408372428 | 3D
53 | 8 | 9 | 2020 | 7 | 29 | 15 | 20 | 53 | 2312901747 | 4D
53 | 8 | 9 | 2020 | 7 | 29 | 15 | 20 | 53 | 1151340634 | 5A
53 | 8 | 9 | 2020 | 7 | 29 | 15 | 20 | 53 | 8174538026 | 6D
53 | 8 | 9 | 2020 | 7 | 29 | 15 | 20 | 53 | 1050247273 | 7A
53 | 8 | 9 | 2020 | 7 | 29 | 15 | 20 | 53 | 7834357192 | 8C
18 | 8 | 6 | 2020 | 7 | 29 | 16 | 0 | 18 | 2835165196 | 9C
18 | 8 | 6 | 2020 | 7 | 29 | 16 | 0 | 18 | 6131360461 | 2C
18 | 8 | 6 | 2020 | 7 | 29 | 16 | 0 | 18 | 3231999695 | 3C
18 | 8 | 6 | 2020 | 7 | 29 | 16 | 0 | 18 | 3592750733 | 4C
18 | 8 | 6 | 2020 | 7 | 29 | 16 | 0 | 18 | 2626335085 | 5D
18 | 8 | 6 | 2020 | 7 | 29 | 16 | 0 | 18 | 6117294637 | 6B
18 | 8 | 6 | 2020 | 7 | 29 | 16 | 0 | 18 | 2996517496 | 7A
18 | 8 | 6 | 2020 | 7 | 29 | 16 | 0 | 18 | 3915621712 | 8D
*/


-- ERNEST , Danielle



-- Check phoen logs to chekc who received calls on flights
-- Passport Numbers of people who boarded the plane based on car_plate and ank accounts
SELECT passport_number FROM passengers WHERE passport_number IN (SELECT passport_number FROM people WHERE license_plate IN (SELECT license_plate FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25) INTERSECT SELECT passport_number FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND transaction_type = "withdraw" AND atm_location = "Fifer Street"));

-- Phoen calls received by passengers less than 60 sec duartion
SELECT * FROM phone_calls WHERE caller IN (SELECT phone_number FROM people WHERE license_plate IN (SELECT license_plate FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25) INTERSECT SELECT phone_number FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND transaction_type = "withdraw" AND atm_location = "Fifer Street")) AND duration < 60;
/*
id | caller | receiver | year | month | day | duration
233 | (367) 555-5533 | (375) 555-8161 | 2020 | 7 | 28 | 45 -- berthold (Suspected accomplice)
255 | (770) 555-1861 | (725) 555-3243 | 2020 | 7 | 28 | 49 -- Philip
395 | (367) 555-5533 | (455) 555-5315 | 2020 | 7 | 30 | 31 -- Charlotte (???)
*/

-- People who called for a duration of 60s with license and bank accounts suspicious
SELECT * FROM people WHERE phone_number IN (SELECT caller FROM phone_calls WHERE duration < 60) AND passport_number IN (SELECT passport_number FROM people WHERE license_plate IN (SELECT license_plate FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25) INTERSECT SELECT passport_number FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND transaction_type = "withdraw" AND atm_location = "Fifer Street"));
/*
id | name | phone_number | passport_number | license_plate
514354 | Russell | (770) 555-1861 | 3592750733 | 322W7JE
686048 | Ernest | (367) 555-5533 | 5773159633 | 94KL13X
*/

-- Finding receiver/ accomplice

SELECT receiver FROM phone_calls WHERE caller IN (SELECT phone_number FROM people WHERE phone_number IN (SELECT caller FROM phone_calls WHERE duration < 60) AND passport_number IN (SELECT passport_number FROM people WHERE license_plate IN (SELECT license_plate FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25) INTERSECT SELECT passport_number FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND transaction_type = "withdraw" AND atm_location = "Fifer Street")));


SELECT * FROM people WHERE phone_number IN (SELECT receiver FROM phone_calls WHERE caller IN (SELECT phone_number FROM people WHERE phone_number IN (SELECT caller FROM phone_calls WHERE duration < 60) AND passport_number IN (SELECT passport_number FROM people WHERE license_plate IN (SELECT license_plate FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute < 25) INTERSECT SELECT passport_number FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id WHERE bank_accounts.account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND transaction_type = "withdraw" AND atm_location = "Fifer Street"))));

SELECT * FROM phone_calls WHERE day = 28 AND month = 7 AND year = 2020 AND duration < 60 AND caller = "(367) 555-5533";
/*
id | caller | receiver | year | month | day | duration
233 | (367) 555-5533 | (375) 555-8161 | 2020 | 7 | 28 | 45 -- Berthold
*/