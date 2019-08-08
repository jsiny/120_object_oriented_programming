class InvoiceEntry
  attr_reader :product_name
  attr_accessor :quantity

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    self.quantity = updated_count if updated_count >= 0
  end
end

# This solution is correct syntactically.
# However, it's not a very good idea, because we're now allowing
# clients of the class to change the quantity directly
# (calling the accessor with the instance.quantity = <new value>)
# rather than by going through `update_quantity`.
# Therefore, the protections built around this method can
# be circumvented, and this can potentially cause problems.
