from src.core.db_manager import Table


class District(Table):
    table_name = 'districts'
    _attrs = {
        "name": str     
    }
    required_fields = ["name"]
    
    def __init__(self):
        self._attrs.update(super()._attrs)
        super().__init__()
        
    @staticmethod 
    def abstract_method():
        pass
    
class Location(Table):
    table_name = 'locations'
    _attrs = {
        "area": str,
        "ward": int,
        "city": str,
        "district_id": int,   
    }
    required_fields = ["area", "ward", "city", "district_id"]
    
    def __init__(self):
        self._attrs.update(super()._attrs)
        super().__init__()
        
    @staticmethod 
    def abstract_method():
        pass



class Address(Table):
    table_name = 'addresses'
    _attrs = {
        "user_id": int,
        "location_id": int,
        "landmarks": str     
    }
    required_fields = ["user_id", "location_id", "landmarks"]
    
    def __init__(self):
        self._attrs.update(super()._attrs)
        super().__init__()
        
    @staticmethod 
    def abstract_method():
        pass