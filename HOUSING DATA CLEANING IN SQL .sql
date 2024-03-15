SELECT * 
From NashvilleHousing

--Standard Date Format

--SELECT SaleDate , CONVERT(date,SaleDate) as SalesDate
--From NashvilleHousing

--SELECT Salesdateconverted 
--From NashvilleHousing

ALTER TABLE NashvilleHousing
Add Salesdateconverted Date;

UPDATE NashvilleHousing
SET Salesdateconverted = CONVERT(date,SaleDate)

-- populate Property Adress data

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress is null
order by ParcelID

SELECT a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress ,ISNULL(a.PropertyAddress ,b.PropertyAddress )
FROM NashvilleHousing a
JOIn NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress ,b.PropertyAddress )
FROM NashvilleHousing a
JOIn NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null

--Breaking out Adress into individual colums(Address , city , State)

SELECT *
From NashvilleHousing

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) As ADDress
, SUBSTRING(PropertyAddress , CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress) )As City
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
Add SplitAdress nvarchar(255);

ALTER TABLE NashvilleHousing
Add SplitCIty nvarchar(255);

update NashvilleHousing
SET SplitAdress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

update NashvilleHousing
SET SplitCIty = SUBSTRING(PropertyAddress , CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress) )

SELECT SplitCIty , SplitAdress ,OwnerAddress
From NashvilleHousing

-- Spllitng Owner Adresses 

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From NashvilleHousing
WHere OwnerAddress is not null

ALTER Table NashvilleHousing
Add Ownersplitadress varchar(255);

ALTER Table NashvilleHousing
Add Ownersplitcity varchar(255);

ALTER Table NashvilleHousing
Add Ownersplitstate varchar(255);

update NashvilleHousing
set Ownersplitadress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

update NashvilleHousing
set Ownersplitcity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

update NashvilleHousing
set Ownersplitstate = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

-- change Y and N to Yes and No in Sold Vacunt Field

SELECT Distinct(soldasvacant),COunt(soldasvacant)
from NashvilleHousing
group by soldasvacant

Select soldasvacant ,
 CASE When soldasvacant = 'Y' THEN 'Yes'
	  When soldasvacant = 'N' THEN 'NO'
	  ElSE soldasvacant
	  END as NewSoldAsVacant
From NashvilleHousing

update NashvilleHousing
Set SoldAsVacant = CASE When soldasvacant = 'Y' THEN 'Yes'
	  When soldasvacant = 'N' THEN 'NO'
	  ElSE soldasvacant
	  END 

-- Removing Duplicates

WITH RowNumCTE AS (
SELECT *,ROW_NUMBER() OVER (
	Partition by ParcelId,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by UniqueID )
				 As RowNumber
FROM NashvilleHousing
)

SELECT * 
FROM RowNumCTE
Where RowNumber>1

--Delete Unused Colums 

SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress , TaxDistrict ,PropertyAddress
