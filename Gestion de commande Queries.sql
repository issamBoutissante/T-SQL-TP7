use GestionCom
-- 1-	Créer une procédure stockée nommée PS_NbrArtCom qui retourne le nombre
-- d'articles d'une commande dont le numéro est donné en paramètre
create procedure PS_NbrArtCom
@numCom int,@nombreArticle int output
as 
   select @nombreArticle=count(*) from ligneCommande
   where numCom=@numCom

declare @nbA int;
exec PS_NbrArtCom 10,@nbA output
print @nbA

-- 2-	Créer une procédure stockée nommée PS_TypePeriode qui retourne le type de la période
-- en fonction du nombre de commande. Si le nombre de commandes est supérieur à 100, le type 
-- sera 'Période rouge'. Si le nombre de commandes est entre 50 et 100 le type sera 'Période 
-- jaune' sinon le type sera 'Période blanche' (exploiter la procédure PS_NbrCommandes).

create procedure PS_TypePeriode
@minDate date,@maxDate date,@typePeriod varchar(20) output
as 
      select @typePeriod=case
      when count(Commande.numCom)>10 then 'Periode rouge'
	  when count(Commande.numCom)>=50 and count(Commande.numCom)<=100 then 'Periode jaune'
	  when count(Commande.numCom)<50 then 'Période blanche'
	  end
  from LigneCommande join Commande
  on LigneCommande.numCom=Commande.numCom
  where dateCom>=@minDate or dateCom<=@maxDate

declare @Tperiod varchar(20)
exec PS_TypePeriode '2021-02-01','2021-02-01',@Tperiod output
print @Tperiod

-- 3-	Créer une procédure stockée nommée PS_ListeArticles qui affiche la liste
--     des articles d'une commande dont le numéro est donné en paramètre
create procedure PS_ListeArticles
@numCom int
as 
 select Article.numArt,ligneCommande.numCom from LigneCommande join Article
 on LigneCommande.numArt=Article.numArt
 where numCom=@numCom

exec PS_ListeArticles 10

-- 4-	Créer une procédure stockée nommée PS_ComPeriode qui affiche 
-- la liste des commandes effectuées entre deux dates données en paramètre.
create procedure PS_ComPeriode
@minDate date,@maxDate date
as 
  select * from Commande
  where dateCom between @minDate and @maxDate

exec PS_ComPeriode '2021-02-01','2021-02-03'

-- 5-	Créer une procédure stockée nommée PS_TypeComPeriode qui affiche la liste des
-- commandes effectuées entre deux dates passées en paramètres. En plus si le nombre de 
-- ces commandes est supérieur à 100, afficher 'Période rouge'. Si le nombre de ces commandes 
-- est entre 50 et 100 afficher 'Période jaune' sinon afficher 'Période blanche' (exploiter 
-- la procédure précédente).
create procedure PS_TypeComPeriode
@minDate date,@maxDate date
as
  exec PS_ComPeriode @minDate,@maxDate
  print case
      when  @@rowcount>100 then 'Periode rouge'
	  when  @@rowcount>=50 and @@rowcount<=100 then 'Periode jaune'
	  when  @@rowcount<50 then 'Période blanche'
	  end
exec PS_TypeComPeriode '2021-02-01','2021-02-03'
-- 6-	Créer une procédure stockée nommée PS_TypePeriode qui renvoie un code de retour.
-- Si le nombre de commandes est supérieur à 100, la procédure renvoie 1. Si le nombre de
-- commandes est entre 50 et 100, la procédure renvoie 2. Si le nombre de commandes est inférieur
-- à 50, la procédure renvoie 3. Si une erreur système a lieu, la procédure renvoie 4.
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
   