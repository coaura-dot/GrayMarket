document.addEventListener("DOMContentLoaded", function () {
  "use strict";

  /* ---------------------------------------------------------
     1. Fundo animado: portal + brasas flutuantes
     --------------------------------------------------------- */
  (function criarFundo() {
    var reduzMovimento = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

    var fundo = document.createElement("div");
    fundo.className = "bg-fx";
    fundo.innerHTML = '<div class="brasa-camada"></div><div class="grade"></div>';
    document.body.prepend(fundo);

    if (reduzMovimento) return;

    var container = document.createElement("div");
    container.id = "ember-container";
    document.body.prepend(container);

    var TOTAL = window.innerWidth < 700 ? 14 : 26;
    for (var i = 0; i < TOTAL; i++) {
      var brasa = document.createElement("span");
      brasa.className = "ember" + (Math.random() > 0.6 ? " roxa" : "");
      var tamanho = 3 + Math.random() * 6;
      brasa.style.width = tamanho + "px";
      brasa.style.height = tamanho + "px";
      brasa.style.left = Math.random() * 100 + "vw";
      brasa.style.setProperty("--deriva", (Math.random() * 80 - 40) + "px");
      var duracao = 9 + Math.random() * 14;
      brasa.style.animationDuration = duracao + "s";
      brasa.style.animationDelay = (Math.random() * duracao) + "s";
      container.appendChild(brasa);
    }
  })();

  /* ---------------------------------------------------------
     2. Cabeçalho: sombra ao rolar
     --------------------------------------------------------- */
  var topo = document.querySelector(".topo");
  if (topo) {
    var aoRolar = function () {
      topo.classList.toggle("rolado", window.scrollY > 8);
    };
    window.addEventListener("scroll", aoRolar, { passive: true });
    aoRolar();
  }

  /* ---------------------------------------------------------
     3. Toasts: move alertas do servidor para a área flutuante,
        adiciona botão de fechar e some sozinho
     --------------------------------------------------------- */
  (function configurarToasts() {
    var alertas = document.querySelectorAll(".conteudo > .alerta");
    if (!alertas.length) return;

    var area = document.getElementById("toast-area");
    if (!area) {
      area = document.createElement("div");
      area.id = "toast-area";
      document.body.appendChild(area);
    }

    alertas.forEach(function (alerta) {
      area.appendChild(alerta);

      var fechar = document.createElement("button");
      fechar.className = "alerta-fechar";
      fechar.type = "button";
      fechar.setAttribute("aria-label", "Fechar aviso");
      fechar.textContent = "\u2715";
      alerta.appendChild(fechar);

      var barra = document.createElement("div");
      barra.className = "alerta-barra";
      alerta.appendChild(barra);

      var remover = function () {
        alerta.classList.add("saindo");
        setTimeout(function () { alerta.remove(); }, 260);
      };
      fechar.addEventListener("click", remover);
      var temporizador = setTimeout(remover, 4800);
      alerta.addEventListener("mouseenter", function () { clearTimeout(temporizador); barra.style.animationPlayState = "paused"; });
    });
  })();

  window.mostrarToast = function (mensagem, tipo) {
    var area = document.getElementById("toast-area");
    if (!area) {
      area = document.createElement("div");
      area.id = "toast-area";
      document.body.appendChild(area);
    }
    var alerta = document.createElement("div");
    alerta.className = "alerta alerta-" + (tipo || "sucesso");
    alerta.textContent = mensagem;

    var fechar = document.createElement("button");
    fechar.className = "alerta-fechar";
    fechar.type = "button";
    fechar.textContent = "\u2715";
    alerta.appendChild(fechar);

    var barra = document.createElement("div");
    barra.className = "alerta-barra";
    alerta.appendChild(barra);

    area.appendChild(alerta);
    var remover = function () {
      alerta.classList.add("saindo");
      setTimeout(function () { alerta.remove(); }, 260);
    };
    fechar.addEventListener("click", remover);
    setTimeout(remover, 4800);
  };

  /* ---------------------------------------------------------
     4. Modal genérico (confirmação e imagem)
     --------------------------------------------------------- */
  var overlay = document.createElement("div");
  overlay.className = "modal-overlay";
  overlay.innerHTML = '<div class="modal-caixa" role="dialog" aria-modal="true"></div>';
  document.body.appendChild(overlay);
  var caixaModal = overlay.querySelector(".modal-caixa");

  function fecharModal() {
    overlay.classList.remove("aberto");
    document.removeEventListener("keydown", aoPressionarEsc);
  }
  function aoPressionarEsc(e) {
    if (e.key === "Escape") fecharModal();
  }
  overlay.addEventListener("click", function (e) {
    if (e.target === overlay) fecharModal();
  });

  function abrirModalConfirmacao(opcoes) {
    caixaModal.className = "modal-caixa";
    caixaModal.innerHTML =
      "<h3>" + (opcoes.titulo || "Confirmar ação") + "</h3>" +
      "<p>" + (opcoes.mensagem || "Tem certeza que deseja continuar?") + "</p>" +
      '<div class="modal-acoes">' +
      '<button type="button" class="botao botao-secundario" data-acao="cancelar">Cancelar</button>' +
      '<button type="button" class="botao ' + (opcoes.perigo ? "botao-perigo" : "") + '" data-acao="confirmar">' + (opcoes.confirmarTexto || "Confirmar") + "</button>" +
      "</div>";

    caixaModal.querySelector('[data-acao="cancelar"]').addEventListener("click", fecharModal);
    caixaModal.querySelector('[data-acao="confirmar"]').addEventListener("click", function () {
      fecharModal();
      if (typeof opcoes.aoConfirmar === "function") opcoes.aoConfirmar();
    });

    overlay.classList.add("aberto");
    document.addEventListener("keydown", aoPressionarEsc);
  }

  function abrirModalImagem(src, titulo) {
    caixaModal.className = "modal-caixa modal-imagem";
    caixaModal.innerHTML =
      "<h3>" + titulo + "</h3>" +
      '<img src="' + src + '" alt="' + titulo + '">' +
      '<div class="modal-acoes" style="justify-content:center;">' +
      '<button type="button" class="botao botao-secundario" data-acao="fechar">Fechar</button>' +
      "</div>";
    caixaModal.querySelector('[data-acao="fechar"]').addEventListener("click", fecharModal);
    overlay.classList.add("aberto");
    document.addEventListener("keydown", aoPressionarEsc);
  }

  /* intercepta formulários/links marcados com data-confirmar
     em vez do confirm() nativo do navegador */
  document.querySelectorAll("form[data-confirmar]").forEach(function (form) {
    form.addEventListener("submit", function (e) {
      if (form.dataset.confirmado === "1") return;
      e.preventDefault();
      abrirModalConfirmacao({
        titulo: form.dataset.confirmarTitulo || "Confirmar ação",
        mensagem: form.dataset.confirmar,
        confirmarTexto: form.dataset.confirmarBotao || "Confirmar",
        perigo: form.dataset.confirmarPerigo === "1",
        aoConfirmar: function () {
          form.dataset.confirmado = "1";
          form.submit();
        }
      });
    });
  });

  /* lightbox nas imagens de produto marcadas com data-lightbox */
  document.querySelectorAll("[data-lightbox]").forEach(function (el) {
    el.addEventListener("click", function () {
      var img = el.querySelector("img");
      if (!img) return;
      abrirModalImagem(img.src, img.alt || "Item");
    });
  });

  /* ---------------------------------------------------------
     5. Revelar cartas/painéis ao rolar a página
     --------------------------------------------------------- */
  var alvosRevelar = document.querySelectorAll(".card-produto, .painel, .hero-loja, .selos-confianca");
  if ("IntersectionObserver" in window && alvosRevelar.length) {
    alvosRevelar.forEach(function (el) { el.classList.add("reveal"); });
    var observador = new IntersectionObserver(function (entradas) {
      entradas.forEach(function (entrada) {
        if (entrada.isIntersecting) {
          entrada.target.classList.add("visivel");
          observador.unobserve(entrada.target);
        }
      });
    }, { threshold: 0.08, rootMargin: "0px 0px -40px 0px" });
    alvosRevelar.forEach(function (el) { observador.observe(el); });
  }
});
