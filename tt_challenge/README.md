# Drought Conditions in the US

The data this week comes from the [National Integrated Drought Information System](https://www.drought.gov/). 

This [web page](https://www.drought.gov/historical-information?dataset=1&selectedDateUSDM=20110301&selectedDateSpi=19580901) provides more information about the drought conditions data.

> The Standardized Precipitation Index (SPI) is an index to characterize meteorological drought on a range of timescales, ranging from 1 to 72 months, for the lower 48 U.S. states. The SPI is the number of standard deviations that observed cumulative precipitation deviates from the climatological average. NOAA's National Centers for Environmental Information produce the 9-month SPI values below on a monthly basis, going back to 1895.*

Credit: [Spencer Schien](Twitter handle or other social media profile)

# `drought.csv`

|variable         |class     |description |
|:----------------|:---------|:-----------|
|0                |double    |  |
|DATE             |character | Date |
|D0               |double    | Abnormally dry |
|D1               |double    | Moderate drought |
|D2               |double    | Severe drought|
|D3               |double    | Extreme drought |
|D4               |double    | Exceptional drought |
|-9               |double    |  |
|W0               |double    | Abnormally wet |
|W1               |double    | Moderate wet |
|W2               |double    | Severe wet |
|W3               |double    | Extreme wet |
|W4               |double    | Exceptional wet |
|state            |character | State |
