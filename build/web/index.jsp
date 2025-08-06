<%@page import="app.configuracao.ConfiguracaoBean"%>
<%@page import="app.configuracao.ConfiguracaoDAO"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="app.Utilidades" %>
<%@page import="app.tarefas.TarefaBean"%>
<%@page import="java.util.List"%>
<%@page import="app.tarefas.TarefaDAO"%>
<%@page import="app.MinhaConexao"%>
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
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8" />
        <title>To-Do List</title>
        
        <% if (temaAtual == 1) { %>
            <link rel="stylesheet" href="./css/index_claro.css">
            <link rel="stylesheet" href="./css/modal_claro.css">
        <% } %>
        
        <% if (temaAtual == 2) { %>
            <link rel="stylesheet" href="./css/index_escuro.css">
            <link rel="stylesheet" href="./css/modal_escuro.css">
        <% } %>        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    </head>
    
    <body>

        <header>
            <div class="container">
                <button class="btn-add" onclick="window.location.href='novaTarefa.jsp?novoOuEditar=2'">Nova Tarefa</button>
                <a href="#" class="config-icon" onclick="openModalConfig(); return false;">
                    <i class="fas fa-cog"></i>
                </a>
            </div>
        </header>


        

    <%
        Integer configuracao = 0;
        if (request.getParameterMap().containsKey("configuracao")) {
            configuracao = Integer.parseInt(request.getParameter("configuracao"));
        }

        TarefaBean tarafa = new TarefaBean();
        TarefaDAO tarefaDAO = new TarefaDAO();
        List<TarefaBean> tarefasAtivas = tarefaDAO.listaTarefasAtivas();
        List<TarefaBean> tarefasInativas = tarefaDAO.listaTarefasInativas();
    %>

    <%    if ((tarefasAtivas == null || tarefasAtivas.isEmpty()) && (tarefasInativas == null || tarefasInativas.isEmpty())) { %> 
            <div class="container-imagem">
                <img src="./img/personagem.png">
            </div>
        <%} else { %>
        
<div class="task-list">
    <%    if (tarefasAtivas == null || tarefasAtivas.isEmpty()) { %>
    
            <div class="container-imagem">
                <p style="text-align: center">todas as tarefas foram concluídas.</p>
            </div>
    <%
        } else {

            SimpleDateFormat sdf = new SimpleDateFormat("EEEE, dd MMM - yyyy", new Locale("pt", "BR"));

            for (TarefaBean tarefaAtiva : tarefasAtivas) {
    %>
                <div class='task <%= Utilidades.arrumarCaractereHtmlJs(tarefaAtiva.getPrioridade()) %>'>
                    <div class='task-content'>

                        <div class='task-title'>
                            <a href='novaTarefa.jsp?id_tarefa=<%= tarefaAtiva.getId_tarefa() %>&novoOuEditar=1' 
                               class='link-sem-estilo'>
                                <%= Utilidades.arrumarCaractereHtmlJs(tarefaAtiva.getTitulo()) %>
                            </a>
                        </div>

                        <div class='task-meta'>
                            <span><i class='fas fa-layer-group'></i> <%= tarefaAtiva.getSubtarefas_count() %> subtarefas</span>
                            <span><i class='fas fa-calendar-day'></i> <%= Utilidades.arrumarCaractereHtmlJs(sdf.format(tarefaAtiva.getData_criacao())) %></span>
                            <span><i class='fas fa-comments'></i> 0</span>
                        </div>

                        <span class='descricao'><%= Utilidades.arrumarCaractereHtmlJs(tarefaAtiva.getDescricao()) %></span>
                    </div>

                    <div class='task-actions'>
                        <div>
                            <label class='checkbox-container'>
                                <div class='usuario_concluir'>
                                    <div class='assigned'>
                                        <strong><%= Utilidades.arrumarCaractereHtmlJs(tarefaAtiva.getResponsavel()) %></strong>
                                    </div>
                                    
                                    <form action="alterarTarefaAtivosInativos.jsp" method="get" style="display:inline;">
                                        <input type="hidden" name="estado_atual" value="true">
                                        <input type="hidden" name="id_tarefa" value="<%= tarefaAtiva.getId_tarefa()%>">
                                        <input type="checkbox" name="ativo" onchange="this.form.submit()">
                                    </form>
                                   
                                </div>
                            </label>
                        </div>

                        <!-- Botão de deletar -->
                        <a href='#' class='deletar-link' 
                           onclick="openModalDeletar(
                               <%= tarefaAtiva.getId_tarefa() %>, 
                               '<%= Utilidades.arrumarCaractereHtmlJs(tarefaAtiva.getTitulo()) %>', 
                               '<%= Utilidades.arrumarCaractereHtmlJs(tarefaAtiva.getResponsavel()) %>', 
                               '<%= Utilidades.arrumarCaractereHtmlJs(tarefaAtiva.getPrioridade()) %>', 
                               '<%= Utilidades.arrumarCaractereHtmlJs(tarefaAtiva.getStatus()) %>'
                           ); return false;">
                            <i class='fas fa-trash'></i>
                        </a>
                    </div>
                </div>
    <%
            } // fim for
        } // fim else
    %>

    </div>
    
<div class="task-list">
        <h2>Tarefas concluídas</h2>
        <%    if (tarefasInativas == null || tarefasInativas.isEmpty()) { %>

                <div class="container-imagem">
                    <p style="text-align: center">nenhuma tarefa concluída.</p>
                </div>
        <%
            } else {

                SimpleDateFormat sdf = new SimpleDateFormat("EEEE, dd MMM - yyyy", new Locale("pt", "BR"));

                for (TarefaBean tarefaInativa : tarefasInativas) {
        %>
                    <div class='task <%= Utilidades.arrumarCaractereHtmlJs(tarefaInativa.getPrioridade()) %>'>
                        <div class='task-content'>

                            <div class='task-title'>
                                <a href='novaTarefa.jsp?id_tarefa=<%= tarefaInativa.getId_tarefa() %>&novoOuEditar=1' 
                                   class='link-sem-estilo'>
                                    <%= Utilidades.arrumarCaractereHtmlJs(tarefaInativa.getTitulo()) %>
                                </a>
                            </div>

                            <div class='task-meta'>
                                <span><i class='fas fa-layer-group'></i> <%= tarefaInativa.getSubtarefas_count() %> subtarefas</span>
                                <span><i class='fas fa-calendar-day'></i> <%= Utilidades.arrumarCaractereHtmlJs(sdf.format(tarefaInativa.getData_criacao())) %></span>
                                <span><i class='fas fa-comments'></i> 0</span>
                            </div>

                            <span class='descricao'><%= Utilidades.arrumarCaractereHtmlJs(tarefaInativa.getDescricao()) %></span>
                        </div>

                        <div class='task-actions'>
                            <div>
                                <label class='checkbox-container'>
                                    <div class='usuario_concluir'>
                                        <div class='assigned'>
                                            <strong><%= Utilidades.arrumarCaractereHtmlJs(tarefaInativa.getResponsavel()) %></strong>
                                        </div>
                                        
                                        <form action="alterarTarefaAtivosInativos.jsp" method="get" style="display:inline;">
                                            <input type="hidden" name="estado_atual" value="false">
                                            <input type="hidden" name="id_tarefa" value="<%= tarefaInativa.getId_tarefa()%>">
                                            <input type="checkbox" name="ativo" onchange="this.form.submit()" checked="true">
                                        </form>
                                    </div>
                                </label>
                            </div>

                            <!-- Botão de deletar -->
                            <a href='#' class='deletar-link' 
                               onclick="openModalDeletar(
                                   <%= tarefaInativa.getId_tarefa() %>, 
                                   '<%= Utilidades.arrumarCaractereHtmlJs(tarefaInativa.getTitulo()) %>', 
                                   '<%= Utilidades.arrumarCaractereHtmlJs(tarefaInativa.getResponsavel()) %>', 
                                   '<%= Utilidades.arrumarCaractereHtmlJs(tarefaInativa.getPrioridade()) %>', 
                                   '<%= Utilidades.arrumarCaractereHtmlJs(tarefaInativa.getStatus()) %>'
                               ); return false;">
                                <i class='fas fa-trash'></i>
                            </a>
                        </div>
                    </div>
        <%
                } // fim for
            } // fim else
        %>

        </div>
        
        
    <% } %>
        <!-- Modal de Deletar -->
        <div class="modal-overlay" id="modalDeletar" style="display:none;">
            <div class="modal">
                <h2>Confirmar Exclusão</h2>
                <table class="tabela-confirmacao">
                    <tr>
                        <td><i class="fas fa-pen"></i> Título:</td>
                        <td id="tituloDeletar"></td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-user"></i> Responsável:</td>
                        <td id="tituloResponsavel"></td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-bolt"></i> Prioridade:</td>
                        <td id="tituloPrioridade"></td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-thumbtack"></i> Status:</td>
                        <td id="tituloStatus"></td>
                    </tr>
                </table>
                <form id="formDeletar" method="post" action="deletarTarefa.jsp">
                    <input type="hidden" name="id_tarefa" id="id_tarefa_deletar" value="0" />
                    <div class="modal-buttons">
                        <button type="submit" class="btn-deletar-confirmar">Sim, deletar</button>
                        <button type="button" class="btn-cancelar" onclick="closeModalDeletar()">Cancelar</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="modal-overlay" id="modalConfig" style="display:none;">
            <div class="modal">
                <h2>Configurações</h2>

                    <table class="tabela-configuracao">
                        <tr>
                            <td><i class="fas fa-adjust"></i> <Strong>Tema:</Strong></td>
                            <td id="tituloDeletar"></td>
                        </tr>
                        <tr>
                            <td>

                                <form id="formTema" action="alterarTema.jsp" method="post">
                                    <input type="hidden" name="id_configuracao" value="1">

                                    <div class="bolinhas-wrapper">
                                        <div class="bolinhas-selector">
                                            <input type="radio" id="bolinha1" name="tema" value="1" 
                                                   onchange="document.getElementById('formTema').submit()" 
                                                   <%= (temaAtual == 1 ? "checked" : "") %>>
                                            <label for="bolinha1">Claro</label>
                                        </div>

                                        <div class="bolinhas-selector">
                                            <input type="radio" id="bolinha2" name="tema" value="2" 
                                                   onchange="document.getElementById('formTema').submit()" 
                                                   <%= (temaAtual == 2 ? "checked" : "") %>>
                                            <label for="bolinha2">Escuro</label>
                                        </div>

                                        <div class="bolinhas-selector">
                                            <input type="radio" id="bolinha3" name="tema" value="3" 
                                                   onchange="document.getElementById('formTema').submit()" 
                                                   <%= (temaAtual == 3 ? "checked" : "") %>>
                                            <label for="bolinha3">Base no Sistema</label>
                                        </div>
                                    </div>
                                </form>

                            </td>
                        </tr>

                    </table>

                    <table class="tabela-configuracao">
                        <tr>
                            <td><i class="fas fa-adjust"></i> <Strong>Nada:</Strong></td>
                            <td id="tituloDeletar"></td>
                        </tr>
                        <tr>
                                <td><i class="fas fa-thumbtack"></i>vazio</td>
                                <td id="tituloStatus"></td>
                        </tr>


                    </table>        



                <div class="modal-buttons">
                    <button type="button" class="btn-cancelar" onclick="closeModalConfig()">Fechar</button>
                </div>
            </div>
        </div>

        <script src="./js/index.js"></script>  
        <script src="./js/Utilidades.js"></script>

         <% if (configuracao != null && configuracao.equals(1)) { %>
            <script>openModalConfig();</script>
         <% } %>
    </body>
    
    <% tarefaDAO.fecharConexao(); %>
    
</html>