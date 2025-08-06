<%@page import="app.util.RenderizadorTarefas"%>
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
            <link rel="stylesheet" href="./css/index-claro.css">
            <link rel="stylesheet" href="./css/modal_escuro.css">
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