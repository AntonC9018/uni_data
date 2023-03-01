import std.datetime;
import std.random;
import std.range;
import std.algorithm;
import std.conv;
import std.format;
import std.stdio;

struct Time
{
    int day;
    int month;
    int week;
    int year;
    Date date;
}

Time[] getTimes(Date dateStart, Date dateEnd)
{
    Time[] r;
    int week = 1;
    int month = dateStart.month;
    int day = 0;

    int i = 0;
    Date d = dateStart;
    while (d < dateEnd)
    {
        if (d.month != month)
        {
            month = d.month;
            week = 1;
            day = 1;
        }
        else
        {
            day++;
        }
        if (day == 7)
        {
            week++;
        }
        if (uniform01() > 0.9)
        {
            r ~=(Time(day, month, week, d.year, d));
        }
        i++;
        d += 1.days;
    } 
    return r;
}

struct Location
{
    string city;
    string country;
    string zone;
}

struct CountryData
{
    string name;
    string[] cities;
}

immutable CountryData[] countries = [
    CountryData("Germany", ["Berlin", "Hamburg", "Munich", "Cologne", "Frankfurt", "Stuttgart", "Dusseldorf", "Dortmund", "Essen", "Leipzig"]),
    CountryData("France", ["Paris", "Marseille", "Lyon", "Toulouse", "Nice", "Nantes", "Strasbourg", "Montpellier", "Bordeaux", "Lille"]),
    CountryData("United Kingdom", ["London", "Birmingham", "Leeds", "Glasgow", "Sheffield", "Bradford", "Liverpool", "Edinburgh", "Manchester", "Bristol"]),
    CountryData("Spain", ["Madrid", "Barcelona", "Valencia", "Seville", "Zaragoza", "Malaga", "Murcia", "Palma", "Las Palmas", "Bilbao"]),
    CountryData("Italy", ["Rome", "Milan", "Naples", "Turin", "Palermo", "Genoa", "Bologna", "Florence", "Catania", "Venice"]),
    CountryData("Poland", ["Warsaw", "Krakow", "Lodz", "Wroclaw", "Poznan", "Gdansk", "Szczecin", "Bydgoszcz", "Lublin", "Katowice"]),
    CountryData("Romania", ["Bucharest", "Iasi", "Cluj-Napoca", "Timisoara", "Constanta", "Galati", "Craiova", "Ploiesti", "Brasov", "Braila"]),
    CountryData("Netherlands", ["Amsterdam", "Rotterdam", "The Hague", "Utrecht", "Eindhoven", "Tilburg", "Groningen", "Almere", "Breda", "Nijmegen"]),
    CountryData("Belgium", ["Brussels", "Antwerp", "Ghent", "Charleroi", "Liège", "Bruges", "Namur", "Leuven", "Anderlecht", "Mechelen"]),
];

Location[] getLocations()
{
    Location[] r;
    foreach (countryData; countries)
    {
        foreach (city; countryData.cities)
        {
            foreach (zoneNumber; 0 .. uniform(0, 10))
            {
                r ~= Location(city, countryData.name, "Zone" ~ zoneNumber.to!string);
            }
        }
    }
    return r;
}

void main()
{
    auto times = getTimes(Date(2022, 9, 5), Date(2023, 12, 30));
    auto locations = getLocations();

    auto b = appender!string;

    foreach (time; times)
    {
        b.formattedWrite!"insert into Dim_Timp(zi, luna, saptamana, an, data_concreta)
            values(%s, %s, %s, %s, '%s');\n"(time.day, time.month, time.week, time.year, time.date.toISOExtString());
    }
    foreach (location; locations)
    {
        b.formattedWrite!"insert into Dim_Locatie(tara, locatie, zona)
            values('%s', '%s', '%s');\n"(location.country, location.city, location.zone);
    }
    foreach (idtime, time; times)
    foreach (idlocation, location; locations)
    {
        if (uniform01() > 0.25)
        {
            auto quantity = uniform(0, 1000);
            auto averagePrice = uniform(50, 100);

            // add some patters
            if (time.date.day == 1)
                quantity *= 2;

            if (time.date.day == 15)
                quantity *= 3;

            if (time.date.day == 30)
                quantity *= 4;

            if (time.date.month == 1)
                quantity /= 2;

            if (location.country.startsWith("R"))
                quantity /= 2;

            if (location.country.startsWith("B"))
                quantity *= 3;

            if (location.zone[4 .. $].to!int % 2 == 0)
                quantity *= 2;

            auto total = quantity * averagePrice;
            b.formattedWrite!"insert into Fact_Bilet(timp_id, locatie_id, vinzare_volum, vinzare_cantitati_bilete)
                values(%s, %s, %s, %s);\n"(idtime, idlocation, total, quantity);
        }
    }
    writeln(b[]);
}