import datetime

from src.core.db_manager import Table


class Booking(Table):
    table_name = 'bookings'
    _attrs = {
        "service_id": int,
        "customer_id": int,
        "address_id": int,
        "booking_date": datetime.date,
        "booking_time": datetime.time,
        "status": str     
    }
    required_fields = ["service_id", "customer_id", "address_id", "booking_date", "booking_time"]
    
    def __init__(self):
        self._attrs.update(super()._attrs)
        super().__init__()
        
    @staticmethod 
    def abstract_method():
        pass