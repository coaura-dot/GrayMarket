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
    descricao: "Peça de armadura em Netherite, encantada e pronta para batalha.",
    preco: preco_netherite, estoque: rand(73..144) },
  { nome: "Peitoral de Netherite", categoria: "Netherite",
    descricao: "Peça de armadura em Netherite, encantada e pronta para batalha.",
    preco: preco_netherite, estoque: rand(73..144) },
  { nome: "Calça de Netherite", categoria: "Netherite",
    descricao: "Peça de armadura em Netherite, encantada e pronta para batalha.",
    preco: preco_netherite, estoque: rand(73..144) },
  { nome: "Botas de Netherite", categoria: "Netherite",
    descricao: "Peça de armadura em Netherite, encantada e pronta para batalha.",
    preco: preco_netherite, estoque: rand(73..144) },

  # ---------- Utilitários de Netherite ----------
  { nome: "Picareta de Netherite", categoria: "Netherite",
    descricao: "Ferramenta em Netherite, encantada para mineração rápida e eficiente.",
    preco: preco_netherite, estoque: rand(73..144) },
  { nome: "Pá de Netherite", categoria: "Netherite",
    descricao: "Ferramenta em Netherite, encantada para mineração rápida e eficiente.",
    preco: preco_netherite, estoque: rand(73..144) },
  { nome: "Machado de Netherite", categoria: "Netherite",
    descricao: "Ferramenta em Netherite, encantada para combate e mineração.",
    preco: preco_netherite, estoque: rand(73..144) },
  { nome: "Espada de Netherite", categoria: "Netherite",
    descricao: "Arma em Netherite, encantada para máximo dano em combate.",
    preco: preco_netherite, estoque: rand(73..144) },

  # ---------- Itens de Diamante (armadura ou ferramenta) ----------
  { nome: "Capacete de Diamante", categoria: "Diamante",
    descricao: "Peça de armadura em Diamante, encantada e resistente.",
    preco: preco_diamante, estoque: rand(73..144) },
  { nome: "Peitoral de Diamante", categoria: "Diamante",
    descricao: "Peça de armadura em Diamante, encantada e resistente.",
    preco: preco_diamante, estoque: rand(73..144) },
  { nome: "Calça de Diamante", categoria: "Diamante",
    descricao: "Peça de armadura em Diamante, encantada e resistente.",
    preco: preco_diamante, estoque: rand(73..144) },
  { nome: "Botas de Diamante", categoria: "Diamante",
    descricao: "Peça de armadura em Diamante, encantada e resistente.",
    preco: preco_diamante, estoque: rand(73..144) },
  { nome: "Picareta de Diamante", categoria: "Diamante",
    descricao: "Ferramenta em Diamante, encantada para mineração eficiente.",
    preco: preco_diamante, estoque: rand(73..144) },
  { nome: "Pá de Diamante", categoria: "Diamante",
    descricao: "Ferramenta em Diamante, encantada para mineração eficiente.",
    preco: preco_diamante, estoque: rand(73..144) },
  { nome: "Machado de Diamante", categoria: "Diamante",
    descricao: "Ferramenta em Diamante, encantada para combate e mineração.",
    preco: preco_diamante, estoque: rand(73..144) },
  { nome: "Espada de Diamante", categoria: "Diamante",
    descricao: "Arma em Diamante, encantada para bons resultados em combate.",
    preco: preco_diamante, estoque: rand(73..144) },

  # ---------- Diamante em stack ----------
  { nome: "Diamante x64", categoria: "Diamante",
    descricao: "Um stack completo (64x) de diamantes brutos, prontos para uso.",
    preco: 4.99, estoque: rand(73..144) },

  # ---------- Maça / Tridente ----------
  { nome: "Maça Encantada", categoria: "Maça e Tridente",
    descricao: "Maça encantada, ideal para combos devastadores com Wind Charge.",
    preco: 8.49, estoque: rand(73..144) },
  { nome: "Tridente Encantado", categoria: "Maça e Tridente",
    descricao: "Tridente encantado, com bons encantamentos para combate e mobilidade.",
    preco: 8.49, estoque: rand(73..144) },

  # ---------- Esmeralda ----------
  { nome: "Esmeralda x64", categoria: "Esmeralda",
    descricao: "Um stack completo (64x) de esmeraldas, prontas para uso.",
    preco: 3.49, estoque: rand(73..144) },

  # ---------- Kits ----------
  { nome: "Spawner", categoria: "Kits",
    descricao: "Spawner de mob à sua escolha, entregue diretamente no seu terreno.",
    preco: 10.99, preco_original: 15.00, estoque: rand(73..144) },
  { nome: "Kit de Diamante", categoria: "Kits",
    descricao: "Kit completo de Diamante: picareta, pá, machado e espada, além da armadura completa (capacete, peitoral, calça e botas).",
    preco: 17.99, preco_original: (preco_diamante * 8).round(2), estoque: rand(73..144) },

  # ---------- Kits nomeados (Elite / Plus / VIP) ----------
  { nome: "Kit Elite", categoria: "Kits",
    descricao: "Kit de Netherite Elite" \
               "<br>&bull; 3x Armadura Completa de Netherite (Capacete, Peitoral, Calça e Botas)" \
               "<br>&bull; 1x Espada de Netherite Encantada" \
               "<br>&bull; 1x Picareta de Netherite Encantada" \
               "<br>&bull; 1x Machado de Netherite Encantado" \
               "<br>&bull; 1x Pá de Netherite Encantada" \
               "<br>&bull; 1x Shield Encantado (Geralmente com Banner. Você pode negociar Banners raros com o vendedor)",
    preco: 20.99, estoque: rand(30..80) },
  { nome: "Kit Plus", categoria: "Kits",
    descricao: "Kit de Netherite Plus." \
               "<br>&bull; 2x Armadura Completa de Netherite (Capacete, Peitoral, Calça e Botas)" \
               "<br>&bull; 1x Espada de Netherite Encantada" \
               "<br>&bull; 1x Picareta de Netherite Encantada" \
               "<br>&bull; 1x Machado de Netherite Encantado",
    preco: 15.99, estoque: rand(30..80) },
  { nome: "Kit VIP", categoria: "Kits",
    descricao: "Kit de Diamante VIP." \
               "<br>&bull; 2x Armadura Completa de Diamante (Capacete, Peitoral, Calça e Botas)" \
               "<br>&bull; 1x Espada de Diamante Encantada" \
               "<br>&bull; 1x Picareta de Diamante Encantada" \
               "<br>&bull; 1x Machado de Diamante Encantado" \
               "<br>&bull; 1x Pá de Diamante Encantada",
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
