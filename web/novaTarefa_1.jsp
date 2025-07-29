<%@page import="app.Utilidades"%>
<%@page import="app.subtarefa.SubtarefaDAO"%>
<%@page import="app.subtarefa.SubtarefaBean"%>
<%@page import="java.util.List"%>
<%@page import="app.tarefas.TarefaDAO"%>
<%@page import="app.tarefas.TarefaBean"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<%
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
    
    List<SubtarefaBean> subtarefasList = subtarefaDAO.listarPorTarefa(tarefa.getId_tarefas());
%>

<!DOCTYPE html>
<html lang="pt-br">

    <head>
        <meta charset="UTF-8">
        <title>Master-Detail de Tarefas</title>
        <link rel="stylesheet" href="./css/novaTarefa.css">
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
                                <button type="button" class="fechar" onclick="link('index.jsp')">Cancelar</button>
                            <% } else { %>                
                                <button id="btn-editar" type="reset" class="editar"  onclick="link('novaTarefa.jsp?id_tarefas=<%= tarefa.getId_tarefas() %>&?novoOuEditar=0')">Editar</button>
                            <% }  %>

                        
                    </div>
                </form>

                <hr>
                
                <% if (tarefa.getId_tarefas()!=0) { %>

                    <h2>Subtarefa</h2>
                    <form id="form-subtarefa" class="form" action="salvarSubtarefa.jsp" method="post">
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
                    </form>

                <% } %>
            </div>

            <!-- DETAIL -->
            <div id="area-detail" class="detail">
 
                <h2>Lista de subtarefas</h2>
                
                    <ul id="lista-tarefas">
                        <% for (SubtarefaBean sub : subtarefasList) {%>
                        <li>
                            <div>
                            <label>
                                <input type="checkbox">
                                <%= sub.getDescricao()%>
                            </label><br>
                            <small>Data: 2025-07-18</small>
                            </div>
                            <a href="deletarSubtarefa.jsp?fk_tarefa=<%= sub.getId_detalhe() %>&id_tarefas=<%= tarefa.getId_tarefas() %>" class="icone-lixeira"><i class="fas fa-trash"></i></a>
                        </li>
                        <% } %>
                    </ul>
                    
                    <hr>
                    
                    <ul id="lista-tarefas">
                       
                        <li>
                            <div>
                            <label>
                                <input type="checkbox" checked>
                                <span class="concluida">tarefa concluida 1</span>
                            </label><br>
                            <small class="data-concluida">Data: 2025-07-18</small>
                            </div>
                            <a href="#" class="icone-lixeira"><i class="fas fa-trash"></i></a>
                        </li>   
                       
                        <li>
                            <div>
                            <label>
                                <input type="checkbox" checked>
                                <span class="concluida">tarefa concluida 1</span>
                            </label><br>
                            <small class="data-concluida">Data: 2025-07-18</small>
                            </div>
                            <a href="#" class="icone-lixeira"><i class="fas fa-trash"></i></a>
                        </li>   
                        
                    </ul>                    
                
            </div>
        </div>

        <script src="./js/novaTarefa.js"></script>

    </body>
    <% tarefaDAO.fecharConexao(); %>
</html>