require_relative "../config/environment"

puts "Limpando banco..."
ItemVenda.delete_all
Venda.delete_all
Produto.delete_all
Usuario.delete_all

puts "Criando usuários..."
vendedor = Usuario.create!(
  nome: "Loja Oficial BAWMC",
  email: "loja@bawmc.net",
  cpf: "00000000000",
  telefone: "(62) 90000-0000",
  senha: "123456"
)

comprador = Usuario.create!(
  nome: "Steve_BR",
  email: "steve@bawmc.net",
  cpf: "11111111111",
  telefone: "(62) 91111-1111",
  senha: "123456"
)

puts "Criando produtos..."

# Preços unitários base usados no cálculo dos kits (com desconto de 15%)
preco_netherite = 7.99
preco_diamante  = 3.49

produtos = [
  # ---------- Armadura de Netherite (peça avulsa) ----------
  { nome: "Capacete de Netherite", categoria: "Netherite",
    descricao: "Capacete de Netherite encantado.",
    preco: preco_netherite, estoque: 83 },
  { nome: "Peitoral de Netherite", categoria: "Netherite",
    descricao: "Peitoral de Netherite encantado.",
    preco: preco_netherite, estoque: 83 },
  { nome: "Calça de Netherite", categoria: "Netherite",
    descricao: "Calça de Netherite encantada.",
    preco: preco_netherite, estoque: 83 },
  { nome: "Botas de Netherite", categoria: "Netherite",
    descricao: "Botas de Netherite encantadas.",
    preco: preco_netherite, estoque: 83 },

  # ---------- Utilitários de Netherite ----------
  { nome: "Picareta de Netherite", categoria: "Netherite",
    descricao: "Picareta de Netherite encantada.",
    preco: preco_netherite, estoque: 76 },
  { nome: "Pá de Netherite", categoria: "Netherite",
    descricao: "Pá de Netherite encantada.",
    preco: preco_netherite, estoque: 76 },
  { nome: "Machado de Netherite", categoria: "Netherite",
    descricao: "Machado de Netherite encantado.",
    preco: preco_netherite, estoque: 76 },
  { nome: "Espada de Netherite", categoria: "Netherite",
    descricao: "Espada de Netherite encantada.",
    preco: preco_netherite, estoque: 76 },

  # ---------- Itens de Diamante (armadura ou ferramenta) ----------
  { nome: "Capacete de Diamante", categoria: "Diamante",
    descricao: "Capacete de Diamante encantado.",
    preco: preco_diamante, estoque: 151 },
  { nome: "Peitoral de Diamante", categoria: "Diamante",
    descricao: "Peitoral de Diamante encantado.",
    preco: preco_diamante, estoque: 151 },
  { nome: "Calça de Diamante", categoria: "Diamante",
    descricao: "Calça de Diamante encantada.",
    preco: preco_diamante, estoque: 151 },
  { nome: "Botas de Diamante", categoria: "Diamante",
    descricao: "Botas de Diamante encantadas.",
    preco: preco_diamante, estoque: 151 },
  { nome: "Picareta de Diamante", categoria: "Diamante",
    descricao: "Picareta de Diamante encantada.",
    preco: preco_diamante, estoque: 151 },
  { nome: "Pá de Diamante", categoria: "Diamante",
    descricao: "Pá de Diamante encantada.",
    preco: preco_diamante, estoque: 151 },
  { nome: "Machado de Diamante", categoria: "Diamante",
    descricao: "Machado de Diamante encantado.",
    preco: preco_diamante, estoque: 151 },
  { nome: "Espada de Diamante", categoria: "Diamante",
    descricao: "Espada de Diamante encantada.",
    preco: preco_diamante, estoque: 151 },

  # ---------- Diamante em stack ----------
  { nome: "Diamante x64", categoria: "Diamante",
    descricao: "Um stack completo (64) de diamantes brutos.",
    preco: 4.99, estoque: 94 },

  # ---------- Maça / Tridente ----------
  { nome: "Maça Encantada", categoria: "Maça e Tridente",
    descricao: "Maça (Mace) encantada, ideal para combos com Wind Charge.",
    preco: 8.49, estoque: 151 },
  { nome: "Tridente Encantado", categoria: "Maça e Tridente",
    descricao: "Tridente encantado.",
    preco: 8.49, estoque: 151 },

  # ---------- Esmeralda ----------
  { nome: "Esmeralda x64", categoria: "Esmeralda",
    descricao: "Um stack completo (64) de esmeraldas.",
    preco: 3.49, estoque: 88 },

  # ---------- Kits (preço total dos itens avulsos -22%) ----------
  { nome: "Kit de Netherite", categoria: "Kits",
    descricao: "22% OFF! Picareta, pá, machado e espada de Netherite + armadura de Netherite completa (capacete, peitoral, calça e botas). 22% de desconto sobre o preço total dos itens avulsos.",
    preco: (preco_netherite * 8 * 0.78).round(2), estoque: 20 },
  { nome: "Kit de Diamante", categoria: "Kits",
    descricao: "22% OFF! Picareta, pá, machado e espada de Diamante + armadura de Diamante completa (capacete, peitoral, calça e botas). 22% de desconto sobre o preço total dos itens avulsos.",
    preco: (preco_diamante * 8 * 0.78).round(2), estoque: 20 },
]

produtos.each { |attrs| vendedor.produtos.create!(attrs) }

puts "Criando uma venda de exemplo..."
espada = vendedor.produtos.find_by(nome: "Espada de Netherite")
venda = Venda.finalizar_compra!(
  comprador: comprador,
  carrinho: { espada.id.to_s => 1 },
  endereco_entrega: "Spawn, x:0 y:70 z:0"
)
venda.update!(status: "paga")

puts "Seed concluído!"
puts "Login vendedor: loja@bawmc.net / 123456"
puts "Login comprador: steve@bawmc.net / 123456"
