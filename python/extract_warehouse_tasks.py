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
    
def extract_warehouse_tasks(erp_client, warehouse_ids, storage_areas):

    """
    Extracts open warehouse tasks for operational analysis.

    Business Logic:
    -Filters to active warehouses
    -Excludes completed tasks
    """

    filters = {
        "warehouse_id": warehouse_ids,
        "storage_areas": storage_areas,
        "task_status": "OPEN"
    }

    raw_data = erp_client.run_report(
        report_name="warehouse_tasks",
        filters = filters
    )

    df = pd.DataFrame(raw_data)

    if df.empty:
        return df
    else:
        # Remove future-dated tasks to focus on actionable or overdue work
        df = df[df["due_date"] <= date.today()]

        return df
    
def export_to_excel(df, output_path):

    """
    Exports cleaned operational data for downstream analytics consumption.
    """

    df.sort_values(
        by=["warehouse_id", "storage_area", "task_id", "due_date"],
        inplace = True
    )

    df.to_excel(output_path, index=False)

def main(erp_client, warehouse_ids, storage_areas, output_path):
    df = extract_warehouse_tasks(erp_client, warehouse_ids, storage_areas)
    # Brief pause to allow upstream report execution to complete
    time.sleep(2)
    export_to_excel(df, output_path)
