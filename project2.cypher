//query 1
MATCH (c:Crime)-[:WHERE]->(n:Neighborhood {neighborhood: "Inman Park"})
MATCH (c:Crime)-[:WHEN]->(d:Date)
WHERE c.crime_type = "AGG ASSAULT"
AND d.date >= dateTime("2010-09-30")
AND d.date <= dateTime("2010-10-31")
RETURN c.crime_type, COUNT(c) AS crimeCount

//query2
MATCH (c1:Crime)-[:WHERE]->(n1:Neighborhood), (c1:Crime)-[:WHAT_TYPE_LOC]->(l:TypeOfLoc)<-[:WHAT_TYPE_LOC]-(c2:Crime)-[:WHERE]->(n2:Neighborhood)
WHERE n1 <> n2
WITH n1, n2, COUNT(DISTINCT l.type) AS commonCrimeTypes
ORDER BY commonCrimeTypes DESC
RETURN n1.neighborhood AS neighborhood1, n2.neighborhood AS neighborhood2, commonCrimeTypes
LIMIT 7

//query3
MATCH (c:Crime)-[:WHERE]->(n:Neighborhood)
MATCH (c:Crime)-[:WHEN]->(d:Date)
WHERE c.crime_type = "AUTO THEFT" AND d.date >= dateTime("2010-09-30")
AND d.date <= dateTime("2010-11-01")
WITH n, COUNT(c) AS crimeCount
ORDER BY crimeCount DESC
LIMIT 5
RETURN n.neighborhood AS neighborhood, crimeCount

//query4
MATCH (l:TypeOfLoc)<-[r:WHAT_TYPE_LOC]-(c:Crime)
RETURN l.type AS PropertyType, COLLECT(DISTINCT c.crime_type) AS CrimeTypes

//query5
MATCH (c:Crime)-[:WHEN]->(d:Date), (c:Crime)-[:COVERED_BY]->(b:Beat), (b:Beat)-[:COMES_UNDER]->(z:Zone)
WHERE d.year = 2010
WITH d.month AS month, b.beat AS beat, z.zone AS zone, COUNT(*) AS crimeCount
ORDER BY month, crimeCount DESC
RETURN month, COLLECT({zone: zone, beat: beat, crimeCount: crimeCount}) AS beatData

//query6
MATCH (c:Crime)-[:WHEN]->(d:Date)
MATCH (c:Crime)-[:COVERED_BY]->(b:Beat)-[:COMES_UNDER]->(z:Zone)
RETURN z.zone_adjacent, COLLECT(DISTINCT z.zone)

//query7
//which zone has expireinced the least number of "Auto theft" crime
MATCH (c:Crime {crime_type: 'AUTO THEFT'})-[:COVERED_BY]->(b:Beat)-[:COMES_UNDER]->(z:Zone)
RETURN z.zone, COUNT(c) AS auto_theft_count
ORDER BY auto_theft_count ASC
// LIMIT 1


//query8
//Which crime types are more likely to occur in tourism areas compared to the buildings?
MATCH (l1:TypeOfLoc {type: 'tourism'})<-[:WHAT_TYPE_LOC]-(c1:Crime)
WITH DISTINCT c1.crime_type AS crime_type, COUNT(DISTINCT c1) AS tourism_count
MATCH (l2:TypeOfLoc {type: 'building'})<-[:WHAT_TYPE_LOC]-(c2:Crime)
WITH crime_type, tourism_count, COUNT(DISTINCT c2) AS building_count
RETURN crime_type, tourism_count, building_count