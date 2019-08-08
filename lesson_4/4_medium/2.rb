class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    @quantity = updated_count if updated_count >= 0
  end
end

product = InvoiceEntry.new("product", 1)
product.update_quantity(3)
p product.quantity # => 1 before, 3 now

# The problem here comes from the fact that the update_quantity
# method calls the local variable "quantity" instead of the
# setter method quantity=() or the instance variable @quantity.

# We need to either call @quantity on line 11, or call
# self.quantity and initialize the quantity setter method
# through an attr_accessor.
