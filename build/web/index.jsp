<%@page import="app.RenderizarModalDeletarTarefa"%>
<%@page import="app.RenderizarModalConfig"%>
<%@page import="app.util.RenderizadorTarefas"%>
<%@page import="app.configuracao.ConfiguracaoBean"%>
<%@page import="app.configuracao.ConfiguracaoDAO"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="app.Utilidades" %>
<%@page import="app.tarefas.TarefaBean"%>
<%@page import="java.util.List"%>
<%@page import="app.tarefas.TarefaDAO"%>
<%@page import="app.ConexaoPostGres"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    ConfiguracaoDAO configDAO = new ConfiguracaoDAO();
    ConfiguracaoBean configBean = new ConfiguracaoBean();
    configDAO.selecionarTema(configBean); 
    int temaAtual = configBean.getTema();
    
    Integer configuracao = 0;
    if (request.getParameterMap().containsKey("configuracao")) {
        configuracao = Integer.parseInt(request.getParameter("configuracao"));
    }
    
    Integer ativa = 0;
    if (request.getParameterMap().containsKey("ativa")) {
        ativa = Integer.parseInt(request.getParameter("ativa"));
    }

    // Não foi necessário dar um new TarefaBean() aqui porque os objetos são criados 
    // dentro dos métodos listaTarefasAtivas() e listaTarefasInativas() do TarefaDAO.
    // Esses métodos instanciam TarefaBean internamente, preenchem seus dados e retornam 
    // uma lista já pronta com todos os objetos.
    TarefaDAO tarefaDAO = new TarefaDAO();
    List<TarefaBean> tarefasAtivas = tarefaDAO.listaTarefasAtivas();
    List<TarefaBean> tarefasInativas = tarefaDAO.listaTarefasInativas();
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8" />
        <title>To-Do List</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="./css/guias.css">
        
        <% if (temaAtual == 1) { %>
            <link rel="stylesheet" href="./css/index-claro.css">
            <link rel="stylesheet" href="./css/modal-claro.css">
        <% } else if (temaAtual == 2) { %>
            <link rel="stylesheet" href="./css/index-escuro.css">
            <link rel="stylesheet" href="./css/modal-escuro.css">
        <% } else { %>
            <script>
                const temaEscuro = window.matchMedia('(prefers-color-scheme: dark)').matches;
                if (temaEscuro) {
                    document.write('<link rel="stylesheet" href="./css/index-escuro.css">');
                    document.write('<link rel="stylesheet" href="./css/modal-escuro.css">');
                } else {
                    document.write('<link rel="stylesheet" href="./css/index-claro.css">');
                    document.write('<link rel="stylesheet" href="./css/modal-claro.css">');
                }
            </script>
        <% } %>
    
        <style>
            
 .alert {
    position: fixed;
    top: 5px;
    left: 50%;
    transform: translate(-50%, -20px);
    width: 700px;
    max-width: 90%;
    padding: 12px 15px;
    border-radius: 5px;
    font-family: Arial, sans-serif;
    z-index: 9999;
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    opacity: 0;
    transition: opacity 0.8s ease, transform 0.8s ease;
    display: none;
    
    display: flex; /* alinhamento horizontal */
    justify-content: space-between;
    align-items: center;
    gap: 10px;
  }

  .alert.show {
    opacity: 1;
    transform: translate(-50%, 0);
  }

  .alert-blue {
    background-color: #d1ecf1;
    color: #0c5460;
    border: 1px solid #bee5eb;
  }

  .alert-text {
    flex: 1;
  }

  .btn {
    padding: 6px 10px;
    border-radius: 4px;
    border: none;
    cursor: pointer;
    font-size: 14px;
    white-space: nowrap;
  }

  .btn-cancel {
    background-color: #f8d7da;
    border: 1px solid #f5c6cb;
    color: #721c24;
  }

  .btn-cancel:hover {
    background-color: #f5c6cb;
  }

  .btn-confirm {
    background-color: #c3e6cb;
    border: 1px solid #b1dfbb;
    color: #155724;
  }

  .btn-confirm:hover {
    background-color: #b1dfbb;
  }
            
</style>
    </head>
    
    <body>
        <header>
            <div class="container">
                <button class="btn-add" onclick="window.location.href='tarefaMasterDetail.jsp?novoOuEditar=2'">Nova Tarefa</button>
                <a href="#" class="config-icon" onclick="openModalConfig(); return false;">
                    <i class="fas fa-cog"></i>
                </a>
            </div>
        </header>
        

        
        <%  
            if (
                    (tarefasAtivas == null || tarefasAtivas.isEmpty()) && 
                    (tarefasInativas == null || tarefasInativas.isEmpty())
               ) 
            { %> 
                <div class="container-imagem">
                    <img src="./img/personagem.png">
                </div>
            <%} else { %>
                <div class='task-list '>
                    

                    <div class="alert alert-blue" id="alertBox">
                      <span class="alert-text">
                        <strong>ARRUMAR A SALA</strong> será movida para concluída em <span id="countdown">9</span>.
                      </span>
                      <button class="btn btn-cancel" onclick="cancelarAcao()">Cancelar</button>
                      <button class="btn btn-confirm" onclick="confirmarAcao()">Confirmar agora</button>
                    </div>
                    
                    <div class="tabs">
                       <!-- Radios controlam as abas -->
                       <input type="radio" name="tabs" id="tab-ativas" 
                            <% if (ativa != null && ativa.equals(0)) { %>
                                  checked       
                            <% } %>                              
                       >
                       <label for="tab-ativas">Ativas</label>                       
                       
                       <input type="radio" name="tabs" id="tab-inativas"
                            <% if (ativa != null && ativa.equals(1)) { %>
                                  checked       
                            <% } %>
                       >
                       <label for="tab-inativas">Concluídas</label>

                       <!-- Conteúdo da Aba: ATIVAS -->
                       <div class="tab-content content-ativas">
                           <% RenderizadorTarefas.renderizar(tarefasAtivas, true, out);%>
                       </div>
                       <!-- Conteúdo da Aba: INATIVAS -->
                       <div class="tab-content content-inativas">
                           <% RenderizadorTarefas.renderizar(tarefasInativas, false, out); %>
                       </div>
                   </div>
                </div>
           <% } %>

        
        <%= RenderizarModalDeletarTarefa.renderizar() %>

        <%= RenderizarModalConfig.renderizar(temaAtual) %>

        <script src="./js/index.js"></script>  
        <script src="./js/Utilidades.js"></script>

         <% if (configuracao != null && configuracao.equals(1)) { %>
            <script>openModalConfig();</script>
         <% } %>
         
    </body>
    
    <% tarefaDAO.fecharConexao(); %>
    
<script>
  let tempo = 9;
  let timer;
  const alertBox = document.getElementById('alertBox');
  const countdownEl = document.getElementById('countdown');

  function mostrarAlerta() {
    tempo = 9;
    countdownEl.textContent = tempo;
    alertBox.style.display = 'flex';
    setTimeout(() => {
      alertBox.classList.add('show');
    }, 100);

    timer = setInterval(() => {
      tempo--;
      countdownEl.textContent = tempo;
      if (tempo <= 0) {
        clearInterval(timer);
        confirmarAcao();
      }
    }, 1000);
  }

  function confirmarAcao() {
    clearInterval(timer);
    fecharAlerta();
  }

  function cancelarAcao() {
    clearInterval(timer);
    fecharAlerta();
  }

  function fecharAlerta() {
    alertBox.classList.remove('show');
    setTimeout(() => {
      alertBox.style.display = 'none';
    }, 800);
  }

  // Simulação
  mostrarAlerta();
</script>
</html>