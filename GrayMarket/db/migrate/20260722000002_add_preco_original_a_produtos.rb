class AddPrecoOriginalAProdutos < ActiveRecord::Migration[7.1]
  def change
    add_column :produtos, :preco_original, :decimal, precision: 10, scale: 2
  end
end
