### 1. Weak Entity and Justification
**Weak Entity:** `Order Items`

**Justification:**
The `Order Items` entity is weak because its existence is entirely dependent on the `Orders` entity. An `Order Item` cannot exist without being associated with a specific `Order`. Its primary key is typically a composite key that includes the foreign key from `Orders`.

### 2. Many-to-Many Relationship with Attributes
**Relationship:** `Orders` and `Products`

**Justification:**
This is a many-to-many relationship because one `Order` can contain multiple `Products`, and one `Product` can be included in multiple `Orders`. To resolve this, a junction table called `Order Items` is used.

**Attributes in `Order Items`:**
- `order_id` (Foreign Key to `Orders`)
- `product_id` (Foreign Key to `Products`)
- `quantity` (The number of a specific product in the order)
- `price_at_time_of_order` (The price of the product when the order was placed, as prices can change over time)
