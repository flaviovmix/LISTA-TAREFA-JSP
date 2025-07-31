<%@page import="app.configuracao.ConfiguracaoBean"%>
<%@page import="app.configuracao.ConfiguracaoDAO"%>
<%@page import="app.Utilidades"%>
<%@page import="app.subtarefa.SubtarefaDAO"%>
<%@page import="app.subtarefa.SubtarefaBean"%>
<%@page import="java.util.List"%>
<%@page import="app.tarefas.TarefaDAO"%>
<%@page import="app.tarefas.TarefaBean"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%

    ConfiguracaoDAO configDAO = new ConfiguracaoDAO();
    ConfiguracaoBean configBean = new ConfiguracaoBean();
    configDAO.selecionarTema(configBean); 
    int temaAtual = configBean.getTema();

    
    TarefaBean tarefa = new TarefaBean();
    TarefaDAO tarefaDAO = new TarefaDAO();
    SubtarefaDAO subtarefaDAO = new SubtarefaDAO();
    
    Integer novoOuEditar = 0;
    if (request.getParameterMap().containsKey("novoOuEditar")) {
        novoOuEditar = Integer.parseInt(request.getParameter("novoOuEditar"));
    }
    
    if (request.getParameterMap().containsKey("id_tarefas")) {
        tarefa.setId_tarefas(Integer.parseInt(request.getParameter("id_tarefas")));
        tarefaDAO.select(tarefa);
    }
    
    List<SubtarefaBean> ativas = subtarefaDAO.listarAtivasPorTarefa(tarefa.getId_tarefas());
    List<SubtarefaBean> inativas = subtarefaDAO.listarInativasPorTarefa(tarefa.getId_tarefas());

%>

<!DOCTYPE html>
<html lang="pt-br">

    <head>
        <meta charset="UTF-8">
        <title>Master-Detail de Tarefas</title>
        <% if (temaAtual == 1) { %>
            <link rel="stylesheet" href="./css/novaTarefa_claro.css">
            <link rel="stylesheet" href="./css/modal_claro.css">
         <% } %>
     
         <% if (temaAtual == 2) { %>
            <link rel="stylesheet" href="./css/novaTarefa_escuro.css">
            <link rel="stylesheet" href="./css/modal_escuro.css">    
         <% } %>   
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        
    </head>

    <body>
        <div class="container">
            
            <!-- MASTER -->
            <div class="master">
                <button type="reset" class="voltar"  onclick="window.location.href = 'index.jsp'">Voltar</button>
                
                <h2>Tarefa</h2>

                <form id="formTarefa" method="get" action="salvarTarefa.jsp">

                    <div id="formTarefa" 
                        class="  
                            <% if (novoOuEditar != null && novoOuEditar.equals(1)) { %>
                                opaco
                            <% } %>     
                        ">
                        <input type="hidden" name="id_tarefas" id="id_tarefas" value="<%= Utilidades.nullTrim(tarefa.getId_tarefas()) %>" />
                        <input type="text" name="titulo" id="titulo" placeholder="Título da tarefa" value="<%= Utilidades.nullTrim(tarefa.getTitulo()) %>" required>
                        <input type="text" name="responsavel" id="responsavel" placeholder="Responsável da tarefa" value="<%= Utilidades.nullTrim(tarefa.getResponsavel()) %>" required>

                        <textarea  name="descricao" id="descricao" placeholder="Descrição da tarefa"><%= Utilidades.nullTrim(tarefa.getDescricao()) %></textarea>

                        <div class="linha">
                            <select name="prioridade" id="prioridade">
                                <option value="baixa" <%= "baixa".equals(tarefa.getPrioridade()) ? "selected" : "" %>>Baixa</option>
                                <option value="media" <%= "media".equals(tarefa.getPrioridade()) ? "selected" : "" %>>Média</option>
                                <option value="alta" <%= "alta".equals(tarefa.getPrioridade()) ? "selected" : "" %>>Alta</option>
                            </select>


                            <select name="status" id="status">
                                <option value="pendente"><%= Utilidades.nullTrim(tarefa.getStatus()) %></option>
                                <option value="feito">Feito</option>
                            </select>
                        </div>

                        <label for="data">Data prevista para conclusão</label>
                        <input type="date" name="data" id="data" value="<%= Utilidades.nullTrim(tarefa.getData_conclusao()) %>">
                    </div>
                    
                    <div class="botoes">
                        
                        <% if (novoOuEditar != null && novoOuEditar.equals(0)) { %>
                            <button type="submit" class="salvar">Salvar</button>
                            <button type="button" class="fechar" onclick="link('novaTarefa.jsp?id_tarefas=<%= tarefa.getId_tarefas() %>&novoOuEditar=1')">Cancelar</button>
                        <% } %>     
                        
                        <% if (novoOuEditar != null && novoOuEditar.equals(1)) { %>
                            <button id="btn-editar" type="reset" class="editar"  onclick="link('novaTarefa.jsp?id_tarefas=<%= tarefa.getId_tarefas() %>&novoOuEditar=0')">Editar</button>
                        <% }  %>
                        
                        <% if (novoOuEditar != null && novoOuEditar.equals(2)) { %>
                           <button type="submit" class="salvar">Salvar</button>
                           <button type="button" class="fechar" onclick="link('index.jsp')">Cancelar</button>
                        <% }  %>          
                        
                    </div>
                    
                </form>

                <hr>
                
                    <h2>Subtarefa</h2>
                    <form id="form-subtarefa" class="form" action="salvarSubtarefa.jsp" method="post">
                        <div class=" <% if (novoOuEditar==0 || novoOuEditar==2) { %> opaco <% } %>">
                        <input type="hidden" name="fk_tarefa" id="fk_tarefa" value="<%= tarefa.getId_tarefas() %>">

                        <div class="campo">
                            <textarea name="descricao" id="descricaoDetail"
                            placeholder="Digite a descrição..." required></textarea>
                        </div>

                        <div class="campo">
                            <label for="dataDetail">Data prevista para conclusão</label>
                            <input type="date" name="data_conclusao" id="dataDetail" >
                        </div>

                        <button type="submit" class="salvar">Adicionar subtarefa</button>
                    </div>
                    </form>
                
            </div>

            <!-- DETAIL -->
            <div id="area-detail" class="detail <% if (novoOuEditar==0 || novoOuEditar==2) { %> opaco <% } %>">

                <h2>Subtarefas Pendentes</h2>
                <ul id="lista-tarefas">
                    <% for (SubtarefaBean sub : ativas) { %>
                    <li>
                        <div>
                        <form action="alterarAtivosInativos.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="estado_atual" value="true">
                            <input type="hidden" name="id_detalhe" value="<%= sub.getId_detalhe() %>">
                            <input type="hidden" name="id_tarefas" value="<%= sub.getFk_tarefa() %>">
                            <input type="checkbox" name="ativo" onchange="this.form.submit()">
                            <%= sub.getDescricao() %>
                        </form>
                        <br>
                        <small>Data: <%= sub.getData_conclusao() != null ? sub.getData_conclusao() : "Sem data" %></small>
                        </div>
                        <a class="icone-lixeira" href="#"
                           onclick="openModalDeletar(<%= sub.getId_detalhe() %>, <%= sub.getFk_tarefa() %>, '<%= sub.getDescricao()%>'); return false;">
                           <i class="fas fa-trash"></i>
                        </a>
                    </li>
                    <% } %>
                </ul>

                <hr>

                <h2>Subtarefas Concluídas</h2>
                <ul id="lista-tarefas">
                    <% for (SubtarefaBean sub : inativas) { %>
                    <li>
                        <div>
                        <form action="alterarAtivosInativos.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="estado_atual" value="false">
                            <input type="hidden" name="id_detalhe" value="<%= sub.getId_detalhe() %>">
                            <input type="hidden" name="id_tarefas" value="<%= sub.getFk_tarefa() %>">
                            <input type="checkbox" name="ativo" onchange="this.form.submit()" checked>
                            <span class="concluida"><%= sub.getDescricao() %></span>
                        </form>
                        <br>
                        <small class="data-concluida">Data: <%= sub.getData_conclusao() != null ? sub.getData_conclusao() : "Sem data" %></small>
                        </div>
                        <a class="icone-lixeira" href="#"
                           onclick="openModalDeletar(<%= sub.getId_detalhe() %>, <%= sub.getFk_tarefa() %>, '<%= sub.getDescricao()%>'); return false;">
                           <i class="fas fa-trash"></i>
                        </a>
                    </li>
                    <% } %>
                </ul>

            </div>

        </div>
       
        <!-- Modal de Deletar oculto -->
        <div class="modal-overlay" id="modalDeletar" style="display:none;">
            <div class="modal">
                <h2>Confirmar Exclusão</h2>
                <div class="confirmacao">
                    <p id="texto-descricao" class="area-info"></p>
                    <form id="formDeletar" method="post" action="deletarSubtarefa.jsp">
                        <input type="hidden" name="id-detalhe" id="id-detalhe" value="0" />
                        <input type="hidden" name="id-tarefa" id="id-tarefa" value="0" />
                        <div class="modal-buttons">
                            <button type="submit" class="btn-deletar-confirmar" onclick="confirmarDelete()">Sim, deletar</button>
                            <button type="button" class="btn-cancelar" onclick="closeModalDeletar()">Cancelar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="./js/novaTarefa.js"></script>
        <script src="./js/Utilidades.js"></script>

        <% if (novoOuEditar==0 || novoOuEditar==2) { %>
            <script>selecionarAddTarefa()</script>
        <% } %>    
        
        <% if (novoOuEditar==1) { %>
            <script>selecionarAddSubTarefa()</script>
        <% } %>
            
    </body>
    <% tarefaDAO.fecharConexao(); %>
</html>