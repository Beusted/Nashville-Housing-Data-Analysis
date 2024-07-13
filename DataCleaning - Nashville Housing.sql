-- Cleaning Data in SQL Queries

SELECT *
FROM PortfolioProject..NashvilleHousing

/* Standarize Date Format // Changing datetime --> date */

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM PortfolioProject..NashvilleHousing


-- Adds a new column called SaleDateConverted with Date type
ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

-- Updates the values of SaleDateConverted to SaleDate's converted values
UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

-- Check to see if it works
SELECT SaleDate, SaleDateConverted, CONVERT(Date, SaleDate)
FROM PortfolioProject..NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------------

/* Populate Property Address Data */

SELECT *
FROM PortfolioProject..NashvilleHousing
-- WHERE PropertyAddress is null
ORDER BY ParcelID

-- use ISNULL(a, b), where if a is null, then populate it with b
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null

-- Update 'a' (NashvilleHousing alias), setting the PropertyAddress to the isnull function
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null

/* Breaking out Address into Individual Columns (Address, City, State) */

-- Use Substring to find a section of a string,
-- charindex to get the index value of the comma because the comma separates the address and the city
-- use LEN(propadd) to find the length of the string, which is the ending index value of the string

SELECT
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress)) AS City
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD Address NVARCHAR(255);

UPDATE NashvilleHousing
SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
ADD City NVARCHAR(255);

UPDATE NashvilleHousing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress))

SELECT *
FROM PortfolioProject..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------------

SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

-- Use PARSENAME to find periods, use replace to change commas to periods
SELECT
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1),
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
    FROM PortfolioProject..NashvilleHousing

-- Add State table
ALTER TABLE NashvilleHousing
ADD State NVARCHAR(255);

UPDATE NashvilleHousing
SET State = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- Remove the empty space that was in front of the period
UPDATE NashvilleHousing
SET State = REPLACE(State, ' ', '')

--------------------------------------------------------------------------------------------------------------------------------

/* Change Y and N to Yes and No in "Sold as Vacant" field */

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
Order by 2

SELECT SoldAsVacant,
    CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
    END
FROM PortfolioProject..NashvilleHousing

UPDATE NashVilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
    END

--------------------------------------------------------------------------------------------------------------------------------

/* Remove Duplicates */

WITH RowNumCTE AS(
SELECT *, 
    ROW_NUMBER() OVER (
        PARTITION BY ParcelID,
                     PropertyAddress,
                     SalePrice,
                     SaleDate,
                     LegalReference,
                     OwnerName
                ORDER BY UniqueID
    ) row_num
FROM PortfolioProject..NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

--------------------------------------------------------------------------------------------------------------------------------

/* Delete Unused Columns */
SELECT *
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate, OwnerAddress, TaxDistrict, PropertyAddress