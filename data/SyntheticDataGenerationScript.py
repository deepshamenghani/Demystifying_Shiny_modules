from faker import Faker
from geopy.geocoders import Nominatim
from tqdm import tqdm
import pandas as pd
import numpy as np  # This line is added at the imports section to use numpy


# Initialize faker and geolocator
fake = Faker('en_US')
geolocator = Nominatim(user_agent="geoapi")

# Function to generate random latitude and longitude within US bounds
def generate_us_coordinates():
    while True:
        lat = fake.latitude()
        lon = fake.longitude()
        # Adjusting to ensure lat/lon well within US boundaries
        if 26 <= lat <= 47 and -125 <= lon <= -70:
            return lat, lon

# Function to generate a single data row
def generate_row():
    lat, lon = generate_us_coordinates()
    return {
        'latitude': lat,
        'longitude': lon,
        'date': fake.date_between(start_date='-40y', end_date='today').strftime('%m/%d/%Y'),
        'county': get_county(lat, lon),
        'state': get_state(lat, lon)
    }

# Function to get the county from latitude and longitude
def get_county(lat, lon):
    try:
        location = geolocator.reverse((lat, lon), language='en', timeout=20)  # Increased timeout
        address = location.raw.get('address', {})
        return address.get('county', 'Unknown')
    except Exception as e:
        print(f"Error fetching county for coordinates ({lat}, {lon}): {e}")
        return 'Unknown'

# Function to get the state from latitude and longitude
def get_state(lat, lon):
    try:
        location = geolocator.reverse((lat, lon), language='en', timeout=20)  # Increased timeout
        address = location.raw.get('address', {})
        return address.get('state', 'Unknown')
    except Exception as e:
        print(f"Error fetching state for coordinates ({lat}, {lon}): {e}")
        return 'Unknown'

# Generate dataset
rows = []
for _ in tqdm(range(1000)):
    rows.append(generate_row())

# Create DataFrame
df = pd.DataFrame(rows)

df_cleaned = df[(df['county'] != 'Unknown') & (df['state'] != 'Unknown')]

# Randomly repeat certain county sightings by taking every 5th row and duplicating it n number of times
duplicated_rows = pd.DataFrame()
for idx, row in df_cleaned.iloc[::5].iterrows():
    repeat_count = np.random.randint(6, 31)  # Random count between 6 and 30
    duplicated_rows = pd.concat([duplicated_rows, pd.DataFrame([row] * repeat_count)])

# Append duplicated rows back to df_cleaned
df_augmented = pd.concat([df_cleaned, duplicated_rows], ignore_index=True)

# Save to CSV
df_augmented.to_csv('synthetic_bigfoot_sightings.csv', index=False)
