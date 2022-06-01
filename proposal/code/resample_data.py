import sys
import os
import pandas as pd
import numpy as np
from tqdm.auto import tqdm
import time


def process_data(rawdata_df):

    print("    Cleaning...")
    data_df = rawdata_df.query('EX != ["D", "M"]').copy()

    # Add datetime info
    data_df["datetime"] = pd.to_datetime(
        data_df["DATE"].map(str) + " " + data_df["TIME_M"]
    )
    data_df["date"] = data_df["datetime"].dt.date

    # Rename variables
    data_df.rename(columns={"SYM_ROOT": "ticker", "PRICE": "price"}, inplace=True)

    # Resample
    print("    Resampling...")
    data_resample_df = (
        data_df.set_index("datetime")
        .groupby(["ticker", "date"])
        .resample("5min", label="right")["price"]
        .last()
        .reset_index()
    )
    data_resample_df["price"] = (
        data_resample_df.sort_values(by="datetime")
        .groupby(["ticker", "date"])["price"]
        .fillna(method="ffill")
    )

    # Fix dates
    data_resample_df = data_resample_df.sort_values(by="datetime")
    data_resample_df = data_resample_df.drop("date", axis=1)

    return data_resample_df


if __name__ == "__main__":

    divider_str = "=" * 70

    print("\n" + divider_str + "\nRunning with args:")
    print(sys.argv[1:])

    in_folder = "../data/temp/"
    in_file = sys.argv[1]
    out_folder = in_folder
    out_file = "resample_" + in_file

    ## Read file
    print(divider_str + "\nReading...")
    # Params
    n = os.path.getsize(in_folder + in_file) * 0.133
    chunksize = 200000
    # Read
    rawdata_df = pd.concat(
        (
            x
            for x in tqdm(
                pd.read_csv(in_folder + in_file, nrows=100000, chunksize=chunksize),
                total=int(n / chunksize),
            )
        )
    )

    print(divider_str + "\nProcessing...")
    t = time.time()
    data_resample_df = process_data(rawdata_df)
    print(f"Time elapsed: {(time.time() - t):0.1f}s")

    print(divider_str + "\nSaving...\n" + divider_str + "\n")
    data_resample_df.to_csv(out_folder + out_file, index=False)
