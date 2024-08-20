# Nashville Housing Data Analysis

---------------------------------------------------------------------------------------

This SQL script is focused on cleaning and standardizing data in the `NashvilleHousing` table as part of a data processing workflow. The script first converts date formats and adds a new column to store standardized date values. It then handles missing property addresses by populating null fields using existing data, followed by breaking down the `PropertyAddress` into separate columns for address and city. The script also standardizes values in the `SoldAsVacant` field by replacing 'Y' and 'N' with 'Yes' and 'No'. Additionally, it removes duplicate records and deletes unnecessary columns to streamline the dataset.

---------------------------------------------------------------------------------------

