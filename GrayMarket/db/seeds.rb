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
    preco: preco_netherite, estoque: rand(73..144) },
  { nome: "Peitoral de Netherite", categoria: "Netherite",
    descricao: "Peitoral de Netherite encantado.",
    preco: preco_netherite, estoque: rand(73..144) },
  { nome: "Calça de Netherite", categoria: "Netherite",
    descricao: "Calça de Netherite encantada.",
    preco: preco_netherite, estoque: rand(73..144) },
  { nome: "Botas de Netherite", categoria: "Netherite",
    descricao: "Botas de Netherite encantadas.",
    preco: preco_netherite, estoque: rand(73..144) },

  # ---------- Utilitários de Netherite ----------
  { nome: "Picareta de Netherite", categoria: "Netherite",
    descricao: "Picareta de Netherite encantada.",
    preco: preco_netherite, estoque: rand(73..144) },
  { nome: "Pá de Netherite", categoria: "Netherite",
    descricao: "Pá de Netherite encantada.",
    preco: preco_netherite, estoque: rand(73..144) },
  { nome: "Machado de Netherite", categoria: "Netherite",
    descricao: "Machado de Netherite encantado.",
    preco: preco_netherite, estoque: rand(73..144) },
  { nome: "Espada de Netherite", categoria: "Netherite",
    descricao: "Espada de Netherite encantada.",
    preco: preco_netherite, estoque: rand(73..144) },

  # ---------- Itens de Diamante (armadura ou ferramenta) ----------
  { nome: "Capacete de Diamante", categoria: "Diamante",
    descricao: "Capacete de Diamante encantado.",
    preco: preco_diamante, estoque: rand(73..144) },
  { nome: "Peitoral de Diamante", categoria: "Diamante",
    descricao: "Peitoral de Diamante encantado.",
    preco: preco_diamante, estoque: rand(73..144) },
  { nome: "Calça de Diamante", categoria: "Diamante",
    descricao: "Calça de Diamante encantada.",
    preco: preco_diamante, estoque: rand(73..144) },
  { nome: "Botas de Diamante", categoria: "Diamante",
    descricao: "Botas de Diamante encantadas.",
    preco: preco_diamante, estoque: rand(73..144) },
  { nome: "Picareta de Diamante", categoria: "Diamante",
    descricao: "Picareta de Diamante encantada.",
    preco: preco_diamante, estoque: rand(73..144) },
  { nome: "Pá de Diamante", categoria: "Diamante",
    descricao: "Pá de Diamante encantada.",
    preco: preco_diamante, estoque: rand(73..144) },
  { nome: "Machado de Diamante", categoria: "Diamante",
    descricao: "Machado de Diamante encantado.",
    preco: preco_diamante, estoque: rand(73..144) },
  { nome: "Espada de Diamante", categoria: "Diamante",
    descricao: "Espada de Diamante encantada.",
    preco: preco_diamante, estoque: rand(73..144) },

  # ---------- Diamante em stack ----------
  { nome: "Diamante x64", categoria: "Diamante",
    descricao: "Um stack completo (64) de diamantes brutos.",
    preco: 4.99, estoque: rand(73..144) },

  # ---------- Maça / Tridente ----------
  { nome: "Maça Encantada", categoria: "Maça e Tridente",
    descricao: "Maça (Mace) encantada, ideal para combos com Wind Charge.",
    preco: 8.49, estoque: rand(73..144) },
  { nome: "Tridente Encantado", categoria: "Maça e Tridente",
    descricao: "Tridente encantado.",
    preco: 8.49, estoque: rand(73..144) },

  # ---------- Esmeralda ----------
  { nome: "Esmeralda x64", categoria: "Esmeralda",
    descricao: "Um stack completo (64) de esmeraldas.",
    preco: 3.49, estoque: rand(73..144) },

  # ---------- Kits ----------
  { nome: "Spawner", categoria: "Kits",
    descricao: "Spawner de mob à sua escolha, entregue diretamente no seu terreno.",
    preco: 10.99, preco_original: 15.00, estoque: rand(73..144) },
  { nome: "Kit de Diamante", categoria: "Kits",
    descricao: "Picareta, pá, machado e espada de Diamante + armadura de Diamante completa (capacete, peitoral, calça e botas).",
    preco: 17.99, preco_original: (preco_diamante * 8).round(2), estoque: rand(73..144) },

  # ---------- Kits nomeados (Elite / Plus / VIP) ----------
  { nome: "Kit Elite", categoria: "Kits",
    descricao: "3x capacete, 3x peitoral, 3x calça e 3x botas de Netherite. " \
               "1x espada de Netherite Full encantada. 1x picareta de Netherite Full, " \
               "1x machado de Netherite, 1x pá de Netherite e 1x Shield.",
    preco: 20.99, estoque: rand(30..80) },
  { nome: "Kit Plus", categoria: "Kits",
    descricao: "2x capacete, 2x peitoral, 2x calça e 2x botas de Netherite. " \
               "1x espada de Netherite Full encantada. 1x picareta de Netherite Full e " \
               "1x machado de Netherite.",
    preco: 15.99, estoque: rand(30..80) },
  { nome: "Kit VIP", categoria: "Kits",
    descricao: "2x capacete, 2x peitoral, 2x calça e 2x botas de Diamante. " \
               "1x espada de Diamante Full encantada. 1x picareta de Diamante Full, " \
               "1x machado de Diamante e 1x pá de Diamante.",
    preco: 8.49, estoque: rand(30..80) },
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
