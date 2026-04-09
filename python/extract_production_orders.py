import pandas as pd
from datetime import date, timedelta
import time

class ERPClient:
    def run_report(self, report_name: str, filters: dict):

        """
        Executes an ERP report and returns raw tabular data.

        Parameters:
        report_name (str): Logical report identifier
        filters (dict): Business-level filter criteria
        """
        
        raise NotImplementedError

def extract_production_orders(erp_client, plant_ids, order_type, lookback_days, lookforward_days):

    """
    Extracts open production orders for operational analysis.

    Business Logic:
    -Filters to active plants
    -Includes orders within rolling date window
    -Excludes completed or fully delivered orders
    """

    filters = {
        "plant_id": plant_ids,
        "min_start_date": date.today() - timedelta(days=lookback_days),
        "max_start_date": date.today() + timedelta(days=lookforward_days),
        "order_status": "OPEN",
        "order_type": order_type
    }

    raw_data = erp_client.run_report(
        report_name="production_order_overview",
        filters = filters
    )

    df = pd.DataFrame(raw_data)
    if df.empty:
        return df
    else:
        df["open_quantity"] = df["order_quantity"] - df["confirmed_quantity"]
        df = df[df["open_quantity"] > 0]

        return df

def export_to_excel(df, output_path):
    """
    Exports cleaned operational data for downstream analytics consumption.
    """

    df.sort_values(
        by=["plant_id", "scheduled_date", "production_order"],
        inplace = True
    )

    df.to_excel(output_path, index=False)


def main(erp_client, plant_ids, order_type, lookback_days, lookforward_days, output_path):
    df = extract_production_orders(erp_client, plant_ids, order_type, lookback_days, lookforward_days)
    # Brief pause to allow upstream report execution to complete
    time.sleep(2)
    export_to_excel(df, output_path)
