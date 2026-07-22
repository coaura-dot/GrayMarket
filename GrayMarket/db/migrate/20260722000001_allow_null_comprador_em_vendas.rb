class AllowNullCompradorEmVendas < ActiveRecord::Migration[7.1]
  def change
    change_column_null :vendas, :comprador_id, true
  end
end
