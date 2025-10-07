
-- identify duplicates

WITH duplicate_cte AS
(
select *, ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
from layoffs_staging
)
SELECT * FROM duplicate_cte
Where row_num > 1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_staging2;

INSERT INTO layoffs_staging2
select *, ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
from layoffs_staging;

DELETE from layoffs_staging2 where row_num > 1;

select * from layoffs_staging2;

-- STANDARIZING DATA
SELECT TRIM(company) from layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

select * from layoffs_staging2 where industry like 'Crypto%';

select DISTINCT(country) from layoffs_staging2 order by 1;

UPDATE layoffs_staging2 Set industry = 'Crypto' Where industry like 'Crypto%';

SELECT Distinct(country), TRIM(TRAILING '.' From country) from layoffs_staging2 order by 1;

UPDATE layoffs_staging2
Set country= TRIM(TRAILING '.' From country)
Where country Like 'United States%';

Select 'date', 
str_to_date(`date`, '%m/%d/%Y')
From layoffs_staging2;

UPDATE layoffs_staging2
Set `date` = str_to_date(`date`, '%m/%d/%Y');

SELECT * FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT * FROM layoffs_staging2 where total_laid_off is null;

SELECT DISTINCT industry FROM layoffs_staging2;

SELECT * from layoffs_staging2 where industry is null and percentage_laid_off is null;

select * from layoffs_staging2 where company = 'Airbnb';

select * from layoffs_staging2 t1 join layoffs_staging2 t2 
on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

select t1.industry, t2.industry from layoffs_staging2 t1 join layoffs_staging2 t2 
on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2
Set industry = null WHERE industry = '';

UPDATE layoffs_staging2 t1
join layoffs_staging2 t2 
on t1.company = t2.company
Set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

select * from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;

DELETE from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;

SELECT * FROM LAYOFFS_STAGING2;

alter table layoffs_staging2
drop column row_num;