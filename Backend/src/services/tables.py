from src.core.db_manager import Table
from src.utils.storage import Storage

class Service(Table):
    table_name = 'services'
    _attrs = {
        "provider_id": int,
        "title": str,
        "service_type": str,
        "description": str,
        "thumbnail": str,
        "price": int,
        "price_unit": str,
        "archived": str     
    }
    required_fields = ["provider_id", "title", "service_type", "price", "price_unit"]
    
    def __init__(self):
        self._attrs.update(super()._attrs)
        super().__init__()
        
    @staticmethod 
    def abstract_method():
        pass
    
    def upload_thumbnail(self, file):
        if hasattr(self, "id"): 
            file_name = Storage().upload_file(
                bucket="service", 
                folder=f"{self.id}",
                file=file
            )
            return file_name
        else:
            raise ValueError("Id missing for this instance.") 
        
    def get_thumbnail_url(self, id:int, thumbnail_name:str):
        if not id:
            if self.id:
                id = self.id
            else:
                raise ValueError("Service id is required to upload thumbnail.")
            
        thumbnail_url =Storage().get_file_link(bucket="service", file_path=f'{id}/{thumbnail_name}')
        return thumbnail_url
        
    def delete_thumbnail(self):
        if hasattr(self, "thumbnail"):
            Storage().delete_file(bucket="service", folder=f"{self.id}", file_name=self.thumbnail)
    