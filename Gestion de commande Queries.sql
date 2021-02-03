use GestionCom
-- 1-	Cr�er une proc�dure stock�e nomm�e PS_NbrArtCom qui retourne le nombre
-- d'articles d'une commande dont le num�ro est donn� en param�tre
create procedure PS_NbrArtCom
@numCom int,@nombreArticle int output
as 
   select @nombreArticle=count(*) from ligneCommande
   where numCom=@numCom

declare @nbA int;
exec PS_NbrArtCom 10,@nbA output
print @nbA

-- 2-	Cr�er une proc�dure stock�e nomm�e PS_TypePeriode qui retourne le type de la p�riode
-- en fonction du nombre de commande. Si le nombre de commandes est sup�rieur � 100, le type 
-- sera 'P�riode rouge'. Si le nombre de commandes est entre 50 et 100 le type sera 'P�riode 
-- jaune' sinon le type sera 'P�riode blanche' (exploiter la proc�dure PS_NbrCommandes).

create procedure PS_TypePeriode
@minDate date,@maxDate date,@typePeriod varchar(20) output
as 
      select @typePeriod=case
      when count(Commande.numCom)>10 then 'Periode rouge'
	  when count(Commande.numCom)>=50 and count(Commande.numCom)<=100 then 'Periode jaune'
	  when count(Commande.numCom)<50 then 'P�riode blanche'
	  end
  from LigneCommande join Commande
  on LigneCommande.numCom=Commande.numCom
  where dateCom>=@minDate or dateCom<=@maxDate

declare @Tperiod varchar(20)
exec PS_TypePeriode '2021-02-01','2021-02-01',@Tperiod output
print @Tperiod

-- 3-	Cr�er une proc�dure stock�e nomm�e PS_ListeArticles qui affiche la liste
--     des articles d'une commande dont le num�ro est donn� en param�tre
create procedure PS_ListeArticles
@numCom int
as 
 select Article.numArt,ligneCommande.numCom from LigneCommande join Article
 on LigneCommande.numArt=Article.numArt
 where numCom=@numCom

exec PS_ListeArticles 10

-- 4-	Cr�er une proc�dure stock�e nomm�e PS_ComPeriode qui affiche 
-- la liste des commandes effectu�es entre deux dates donn�es en param�tre.
create procedure PS_ComPeriode
@minDate date,@maxDate date
as 
  select * from Commande
  where dateCom between @minDate and @maxDate

exec PS_ComPeriode '2021-02-01','2021-02-03'

-- 5-	Cr�er une proc�dure stock�e nomm�e PS_TypeComPeriode qui affiche la liste des
-- commandes effectu�es entre deux dates pass�es en param�tres. En plus si le nombre de 
-- ces commandes est sup�rieur � 100, afficher 'P�riode rouge'. Si le nombre de ces commandes 
-- est entre 50 et 100 afficher 'P�riode jaune' sinon afficher 'P�riode blanche' (exploiter 
-- la proc�dure pr�c�dente).
create procedure PS_TypeComPeriode
@minDate date,@maxDate date
as
  exec PS_ComPeriode @minDate,@maxDate
  print case
      when  @@rowcount>100 then 'Periode rouge'
	  when  @@rowcount>=50 and @@rowcount<=100 then 'Periode jaune'
	  when  @@rowcount<50 then 'P�riode blanche'
	  end
exec PS_TypeComPeriode '2021-02-01','2021-02-03'
-- 6-	Cr�er une proc�dure stock�e nomm�e PS_TypePeriode qui renvoie un code de retour.
-- Si le nombre de commandes est sup�rieur � 100, la proc�dure renvoie 1. Si le nombre de
-- commandes est entre 50 et 100, la proc�dure renvoie 2. Si le nombre de commandes est inf�rieur
-- � 50, la proc�dure renvoie 3. Si une erreur syst�me a lieu, la proc�dure renvoie 4.
create procedure PS_NBCommande
as
   begin try
      declare @nbCom int;
      select @nbCom=count(*) from commande
      return case 
         when @nbCom>100 then 1
         when @nbCom>=50 and @nbCom<=100 then 2
         when @nbCom<50 then 3
      end
   end try
   begin catch
      return 4
   end catch

declare @nombre int
exec @nombre=PS_NBCommande
print @nombre
   