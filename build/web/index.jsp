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

    TarefaBean tarafa = new TarefaBean();
    TarefaDAO tarefaDAO = new TarefaDAO();
    List<TarefaBean> tarefasAtivas = tarefaDAO.listaTarefasAtivas();
    List<TarefaBean> tarefasInativas = tarefaDAO.listaTarefasInativas();
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8" />
        <title>To-Do List</title>
        
        <% if (temaAtual == 1) { %>
            <link rel="stylesheet" href="./css/index-claro.css">
            <link rel="stylesheet" href="./css/modal-claro.css">
        <% } %>
        
        <% if (temaAtual == 2) { %>
            <link rel="stylesheet" href="./css/index-escuro.css">
            <link rel="stylesheet" href="./css/modal-escuro.css">
        <% } %>        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

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
            if ((tarefasAtivas == null || tarefasAtivas.isEmpty()) && (tarefasInativas == null || tarefasInativas.isEmpty())) { %> 
                <div class="container-imagem">
                    <img src="./img/personagem.png">
                </div>
            <%} else {
                RenderizadorTarefas.renderizar(tarefasAtivas, true, out);
                RenderizadorTarefas.renderizar(tarefasInativas, false, out);
            } 
        %>

        
        <%= RenderizarModalDeletarTarefa.renderizar() %>

        <%= RenderizarModalConfig.renderizar(temaAtual) %>

        <script src="./js/index.js"></script>  
        <script src="./js/Utilidades.js"></script>

         <% if (configuracao != null && configuracao.equals(1)) { %>
            <script>openModalConfig();</script>
         <% } %>
     
    </body>
    
    <% tarefaDAO.fecharConexao(); %>
    
</html>