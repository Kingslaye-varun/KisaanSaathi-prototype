"""
Complete Preprocessing Pipeline for Indian Crop Yield Prediction
Optimized for Tier 3 Hybrid Model (RF + XGB + CNN-LSTM + Stacking)

Usage:
    python preprocess_crop_yield.py --input crop_yield.csv --output preprocessed_data
"""

import pandas as pd
import numpy as np
import argparse
import os
import joblib
import warnings
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.model_selection import StratifiedShuffleSplit

warnings.filterwarnings('ignore')


class CompleteIndianCropPreprocessor:
    """
    COMPLETE preprocessing pipeline for Indian crop yield prediction
    """
    
    def __init__(self):
        self.scaler_static = StandardScaler()
        self.label_encoders = {}
        self.feature_stats = {}
        
        # Define crop categories for India
        self.crop_categories = {
            'cereals': ['Rice', 'Wheat', 'Maize', 'Bajra', 'Jowar', 'Barley', 'Small millets', 'Ragi'],
            'pulses': ['Moong', 'Urad', 'Arhar/Tur', 'Gram', 'Lentil', 'Peas & beans', 'Khesari'],
            'oilseeds': ['Groundnut', 'Sunflower', 'Soyabean', 'Sesamum', 'Rapeseed &Mustard', 
                        'Niger seed', 'Safflower', 'Castor seed', 'Linseed'],
            'cash_crops': ['Cotton', 'Sugarcane', 'Jute', 'Tobacco', 'Mesta'],
            'spices': ['Onion', 'Turmeric', 'Chillies', 'Coriander', 'Ginger', 'Garlic', 'Black pepper'],
            'fruits_veg': ['Banana', 'Mango', 'Pineapple', 'Tomato', 'Potato', 'Sweet potato', 'Tapioca'],
            'plantation': ['Arecanut', 'Coffee', 'Tea', 'Rubber', 'Coconut']
        }
        
    def clean_data(self, df):
        """Step 1: Remove outliers and invalid records"""
        print("STEP 1: Data Cleaning...")
        
        initial_count = len(df)
        
        # Remove zero/negative production
        df_clean = df[df['Production'] > 0].copy()
        print(f"  Removed {initial_count - len(df_clean)} records with zero/negative production")
        
        # Remove extreme outliers using 1% and 99% percentiles
        for col in ['Yield', 'Area']:
            Q1 = df_clean[col].quantile(0.01)
            Q3 = df_clean[col].quantile(0.99)
            IQR = Q3 - Q1
            lower_bound = max(Q1 - 1.5 * IQR, 0)
            
            if col == 'Yield':
                upper_bound = min(Q3 + 1.5 * IQR, 10000)
            else:  # Area
                upper_bound = min(Q3 + 1.5 * IQR, 10_000_000)
            
            mask = (df_clean[col] >= lower_bound) & (df_clean[col] <= upper_bound)
            removed = (~mask).sum()
            df_clean = df_clean[mask]
            print(f"  Clipped {col}: kept {lower_bound:.2f} to {upper_bound:.2f} (removed {removed})")
        
        # Remove invalid fertilizer/pesticide
        df_clean = df_clean[df_clean['Fertilizer'] > 0]
        df_clean = df_clean[df_clean['Pesticide'] >= 0]
        
        print(f"  Final clean shape: {df_clean.shape} (retained {len(df_clean)/initial_count*100:.1f}%)\n")
        return df_clean.reset_index(drop=True)
    
    def engineer_features(self, df):
        """Step 2: Create domain-specific features"""
        print("STEP 2: Feature Engineering...")
        
        df = df.copy()
        
        # Season encoding
        season_priority = {'Kharif': 1, 'Rabi': 2, 'Summer': 3, 'Autumn': 4, 'Whole Year': 5}
        df['season_code'] = df['Season'].map(season_priority)
        
        # Agro-climatic zones
        agro_zones = {
            'Punjab': 'North_Western_Plains', 'Haryana': 'North_Western_Plains',
            'Rajasthan': 'Thar_Desert', 'Gujarat': 'North_Western_Plains',
            'Uttar Pradesh': 'Central_Plains', 'Bihar': 'Middle_Gangetic',
            'West Bengal': 'Lower_Gangetic', 'Odisha': 'East_Coast',
            'Andhra Pradesh': 'East_Coast', 'Telangana': 'Southern_Plateau',
            'Karnataka': 'Southern_Plateau', 'Tamil Nadu': 'Southern_Plateau',
            'Maharashtra': 'Central_Plateau', 'Madhya Pradesh': 'Central_Plateau',
            'Chhattisgarh': 'Central_Plateau', 'Jharkhand': 'Central_Plateau',
            'Assam': 'North_Eastern', 'Nagaland': 'North_Eastern', 'Manipur': 'North_Eastern',
            'Kerala': 'West_Coast', 'Goa': 'West_Coast'
        }
        df['agro_zone'] = df['State'].map(agro_zones).fillna('Other')
        
        # Crop category
        def get_crop_category(crop):
            for cat, crops in self.crop_categories.items():
                if crop in crops:
                    return cat
            return 'others'
        df['crop_category'] = df['Crop'].apply(get_crop_category)
        
        # Monsoon dependency
        rain_fed_states = ['Maharashtra', 'Karnataka', 'Telangana', 'Andhra Pradesh', 
                          'Madhya Pradesh', 'Gujarat', 'Rajasthan', 'Odisha']
        df['monsoon_dependent'] = (
            (df['Season'] == 'Kharif') & 
            (df['State'].isin(rain_fed_states))
        ).astype(int)
        
        # Irrigation intensity
        high_irrigation = ['Punjab', 'Haryana', 'Uttar Pradesh', 'West Bengal']
        medium_irrigation = ['Tamil Nadu', 'Andhra Pradesh', 'Kerala', 'Gujarat', 'Bihar']
        df['irrigation_intensity'] = df['State'].apply(
            lambda x: 0.85 if x in high_irrigation else (0.65 if x in medium_irrigation else 0.45)
        )
        
        # Input intensities
        df['fertilizer_per_ha'] = df['Fertilizer'] / df['Area']
        df['pesticide_per_ha'] = df['Pesticide'] / df['Area']
        df['input_intensity'] = (df['Fertilizer'] + df['Pesticide']) / df['Area']
        
        # Rainfall features
        df['rainfall_efficiency'] = df['Production'] / (df['Annual_Rainfall'] + 1)
        
        # Log transforms
        df['yield_log'] = np.log1p(df['Yield'])
        df['area_log'] = np.log1p(df['Area'])
        df['production_log'] = np.log1p(df['Production'])
        df['fertilizer_log'] = np.log1p(df['Fertilizer'])
        df['rainfall_log'] = np.log1p(df['Annual_Rainfall'])
        
        # Temporal
        df['year_normalized'] = (df['Crop_Year'] - 1997) / 23
        df['year_squared'] = df['year_normalized'] ** 2
        df['decade'] = ((df['Crop_Year'] - 1997) // 10).astype(int)
        
        print(f"  Created {df.shape[1] - 10} new features\n")
        return df
    
    def encode_categorical(self, df):
        """Step 3: Encode categoricals"""
        print("STEP 3: Encoding Categoricals...")
        
        categorical_cols = ['State', 'Crop', 'Season', 'agro_zone', 'crop_category']
        
        for col in categorical_cols:
            le = LabelEncoder()
            df[f'{col}_encoded'] = le.fit_transform(df[col].astype(str))
            self.label_encoders[col] = le
            print(f"  {col}: {len(le.classes_)} categories")
        
        print()
        return df
    
    def generate_temporal_sequences(self, df, seq_length=12):
        """Step 4: Generate weather sequences"""
        print("STEP 4: Generating Temporal Sequences...")
        
        sequences = []
        np.random.seed(42)
        
        for _, row in df.iterrows():
            if row['Season'] == 'Kharif':
                base_rain = np.array([20, 40, 90, 160, 210, 190, 130, 80, 45, 25, 15, 10])
                temp_base, temp_var, humidity_base = 30, 3, 82
            elif row['Season'] == 'Rabi':
                base_rain = np.array([8, 12, 18, 25, 35, 40, 35, 28, 20, 15, 8, 6])
                temp_base, temp_var, humidity_base = 22, 4, 68
            elif row['Season'] == 'Summer':
                base_rain = np.array([10, 15, 20, 25, 30, 35, 30, 22, 18, 15, 10, 8])
                temp_base, temp_var, humidity_base = 36, 3, 55
            else:
                base_rain = np.array([15, 25, 45, 80, 100, 90, 70, 50, 35, 25, 15, 12])
                temp_base, temp_var, humidity_base = 27, 5, 70
            
            # Scale by annual rainfall
            annual_rain = row['Annual_Rainfall']
            if annual_rain > 0 and base_rain.sum() > 0:
                scale_factor = (annual_rain * 0.7) / base_rain.sum()
                weekly_rain = base_rain * scale_factor
            else:
                weekly_rain = base_rain
            
            # Add noise
            weekly_rain = weekly_rain * (1 + np.random.normal(0, 0.15, seq_length))
            weekly_rain = np.maximum(weekly_rain, 0)
            
            # Temperature
            temp_max = temp_base + np.random.normal(0, temp_var, seq_length)
            temp_max += np.sin(np.linspace(0, 2*np.pi, seq_length)) * 2
            temp_min = temp_max - 8 - np.random.normal(0, 2, seq_length)
            
            # Humidity
            humidity = humidity_base - (temp_max - temp_base) * 0.5 + np.random.normal(0, 8, seq_length)
            humidity = np.clip(humidity, 30, 95)
            
            # Other features
            solar_rad = 18 + np.random.normal(0, 4, seq_length) + (100 - humidity) * 0.1
            wind_speed = 6 + np.random.normal(0, 2, seq_length)
            
            seq = np.column_stack([
                weekly_rain, temp_max, temp_min, humidity, 
                solar_rad, wind_speed, np.full(seq_length, row['irrigation_intensity'])
            ])
            sequences.append(seq)
        
        X_temporal = np.array(sequences, dtype=np.float32)
        print(f"  Generated: {X_temporal.shape}")
        print(f"  Memory: {X_temporal.nbytes / 1024**2:.1f} MB\n")
        return X_temporal
    
    def prepare_static_features(self, df):
        """Step 5: Prepare static features"""
        print("STEP 5: Preparing Static Features...")
        
        feature_cols = [
            'State_encoded', 'Crop_encoded', 'Season_encoded', 
            'agro_zone_encoded', 'crop_category_encoded',
            'area_log', 'year_normalized', 'rainfall_log',
            'fertilizer_log', 'fertilizer_per_ha', 'pesticide_per_ha', 
            'input_intensity', 'rainfall_efficiency', 'monsoon_dependent',
            'year_squared', 'decade', 'irrigation_intensity'
        ]
        
        X_static = df[feature_cols].values.astype(np.float32)
        X_static = np.nan_to_num(X_static, nan=0.0, posinf=10.0, neginf=-10.0)
        X_static = self.scaler_static.fit_transform(X_static)
        
        print(f"  Shape: {X_static.shape}")
        print(f"  Features: {len(feature_cols)}\n")
        return X_static, feature_cols
    
    def create_splits(self, X_static, X_temporal, y, df):
        """Step 6: Stratified split"""
        print("STEP 6: Creating Splits...")
        
        df['year_bin'] = pd.cut(df['Crop_Year'], bins=3, labels=['early', 'mid', 'late'])
        stratify_key = df['crop_category'] + '_' + df['year_bin'].astype(str)
        
        # Filter rare classes
        class_counts = stratify_key.value_counts()
        valid_classes = class_counts[class_counts >= 2].index
        mask = stratify_key.isin(valid_classes)
        
        X_static, X_temporal, y = X_static[mask], X_temporal[mask], y[mask]
        stratify_key = stratify_key[mask]
        df_filtered = df[mask].reset_index(drop=True)
        
        # Split
        sss1 = StratifiedShuffleSplit(n_splits=1, test_size=0.30, random_state=42)
        train_idx, temp_idx = next(sss1.split(X_static, stratify_key))
        
        stratify_temp = stratify_key.iloc[temp_idx]
        sss2 = StratifiedShuffleSplit(n_splits=1, test_size=0.50, random_state=42)
        val_idx_rel, test_idx_rel = next(sss2.split(np.zeros(len(temp_idx)), stratify_temp))
        
        val_idx = temp_idx[val_idx_rel]
        test_idx = temp_idx[test_idx_rel]
        
        splits = {
            'train': {
                'X_static': X_static[train_idx], 'X_temporal': X_temporal[train_idx],
                'y': y[train_idx], 'df': df_filtered.iloc[train_idx]
            },
            'val': {
                'X_static': X_static[val_idx], 'X_temporal': X_temporal[val_idx],
                'y': y[val_idx], 'df': df_filtered.iloc[val_idx]
            },
            'test': {
                'X_static': X_static[test_idx], 'X_temporal': X_temporal[test_idx],
                'y': y[test_idx], 'df': df_filtered.iloc[test_idx]
            }
        }
        
        for name, split in splits.items():
            print(f"  {name}: {len(split['y'])} samples ({len(split['y'])/len(y)*100:.1f}%)")
        print()
        return splits
    
    def save_data(self, splits, feature_cols, output_dir):
        """Step 7: Save everything"""
        print("STEP 7: Saving Data...")
        
        os.makedirs(output_dir, exist_ok=True)
        
        for split_name, data in splits.items():
            np.save(f"{output_dir}/X_static_{split_name}.npy", data['X_static'])
            np.save(f"{output_dir}/X_temporal_{split_name}.npy", data['X_temporal'])
            np.save(f"{output_dir}/y_{split_name}.npy", data['y'])
            data['df'].to_csv(f"{output_dir}/metadata_{split_name}.csv", index=False)
        
        joblib.dump(self.scaler_static, f"{output_dir}/scaler_static.pkl")
        joblib.dump(self.label_encoders, f"{output_dir}/label_encoders.pkl")
        joblib.dump(feature_cols, f"{output_dir}/feature_names.pkl")
        
        total_mb = sum(os.path.getsize(f"{output_dir}/{f}") for f in os.listdir(output_dir) 
                      if f.endswith('.npy')) / (1024**2)
        print(f"  Saved to {output_dir}/")
        print(f"  Total size: {total_mb:.1f} MB\n")
    
    def fit_transform(self, df, output_dir='preprocessed_data'):
        """Run full pipeline"""
        print("="*60)
        print("COMPLETE PREPROCESSING PIPELINE")
        print("="*60 + "\n")
        
        df_clean = self.clean_data(df)
        df_eng = self.engineer_features(df_clean)
        df_enc = self.encode_categorical(df_eng)
        X_temporal = self.generate_temporal_sequences(df_enc)
        X_static, feature_cols = self.prepare_static_features(df_enc)
        y = df_enc['yield_log'].values
        splits = self.create_splits(X_static, X_temporal, y, df_enc)
        self.save_data(splits, feature_cols, output_dir)
        
        print("="*60)
        print("PREPROCESSING COMPLETE ✓")
        print("="*60)
        print(f"\nReady for training:")
        print(f"  • Static: {X_static.shape[1]} features")
        print(f"  • Temporal: {X_temporal.shape[1:]} sequences")
        print(f"  • Total samples: {len(y):,}")
        
        return splits, feature_cols


def main():
    parser = argparse.ArgumentParser(description='Preprocess Indian Crop Yield Data')
    parser.add_argument('--input', type=str, default='crop_yield.csv', help='Input CSV file')
    parser.add_argument('--output', type=str, default='preprocessed_data', help='Output directory')
    args = parser.parse_args()
    
    # Load data
    print(f"Loading {args.input}...")
    df = pd.read_csv(args.input)
    print(f"Loaded: {df.shape}\n")
    
    # Preprocess
    preprocessor = CompleteIndianCropPreprocessor()
    splits, feature_names = preprocessor.fit_transform(df, args.output)
    
    print(f"\nPreprocessed data saved to: {args.output}/")


if __name__ == '__main__':
    main()