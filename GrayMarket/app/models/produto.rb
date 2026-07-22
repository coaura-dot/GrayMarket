class Produto < ActiveRecord::Base
  belongs_to :vendedor, class_name: "Usuario", inverse_of: :produtos
  has_many :item_vendas, dependent: :destroy
  has_many :vendas, through: :item_vendas

  validates :nome, presence: true
  validates :preco, numericality: { greater_than: 0 }
  validates :estoque, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  CATEGORIAS = ["Netherite", "Diamante", "Maça e Tridente", "Kits", "Esmeralda", "Blocos"].freeze

  # Ordem de exibição na listagem: Kits primeiro, depois Netherite,
  # depois Maça e Tridente, e por fim o resto (na ordem que aparecerem).
  ORDEM_EXIBICAO = {
    "Kits" => 0,
    "Netherite" => 1,
    "Maça e Tridente" => 2
  }.freeze

  ORDEM_PADRAO = ORDEM_EXIBICAO.values.max + 1

  scope :busca, ->(termo) {
    termo.present? ? where("lower(nome) LIKE :t OR lower(descricao) LIKE :t OR lower(categoria) LIKE :t",
                            t: "%#{termo.to_s.downcase}%") : all
  }

  def disponivel?
    estoque > 0
  end

  # Retorna o percentual de desconto real (arredondado), com base no
  # preco_original salvo no banco. Retorna nil se não houver desconto.
  def desconto_percentual
    return nil if preco_original.blank? || preco_original <= preco

    (100 - (preco / preco_original * 100)).round
  end
end
