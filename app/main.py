from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="Mock API Service", description="Demo API for QA Automation exercise")

# A simple request body model for POST/PUT
class Item(BaseModel):
    id: int
    name: str


# -------------------
# GET Examples
# -------------------
@app.get("/items/")
def get_item(item_id: int):
    if item_id == 1:
        return {"id": 1, "name": "Sample Item"}
    elif item_id <= 0:
        raise HTTPException(status_code=400, detail="Invalid item ID")
    else:
        raise HTTPException(status_code=404, detail="Item not found")


# -------------------
# POST Example
# -------------------
@app.post("/items")
def create_item(item: Item):
    if not item.name.strip():
        raise HTTPException(status_code=400, detail="Item name cannot be empty")
    if item.id == 999:
        raise HTTPException(status_code=500, detail="Database error simulation")
    return {"message": "Item created successfully", "item": item}


# -------------------
# PUT Example
# -------------------
@app.put("/items/")
def update_item(item_id: int, item: Item):
    if item_id != item.id:
        raise HTTPException(status_code=400, detail="Item ID mismatch")
    if item_id == 500:
        raise HTTPException(status_code=500, detail="Unexpected server error")
    return {"message": "Item updated successfully", "item": item}


# -------------------
# DELETE Example
# -------------------
@app.delete("/items/")
def delete_item(item_id: int):
    if item_id == 1:
        return {"message": "Item deleted successfully"}
    elif item_id <= 0:
        raise HTTPException(status_code=400, detail="Invalid item ID")
    else:
        raise HTTPException(status_code=404, detail="Item not found")
