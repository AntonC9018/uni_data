/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) *
  FROM Fact_Bilet

  inner join Dim_Locatie
  on Fact_Bilet.locatie_id = Dim_Locatie.id

  inner join Dim_Timp
  on Fact_Bilet.timp_id = Dim_Timp.id

  order by -vinzare_volum