<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Tarefas.TarefaDAO"%>
<%@page import="Tarefas.TarefaBean"%>
<%@page import="Tarefas.SubtarefaBean"%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Lista de Tarefas</title>
    <style>
/*        body { font-family: Arial; background: #f4f4f4; padding: 20px; }
        .tarefa { background: #fff; padding: 15px; border-radius: 6px; box-shadow: 0 2px 5px #ccc; margin-bottom: 20px; }
        h2, h3 { margin-bottom: 5px; }
        ul { padding-left: 20px; }
        .sem-sub { color: gray; font-style: italic; }*/
    </style>
</head>
<body>

<%
    TarefaDAO dao = new TarefaDAO();
    List<TarefaBean> tarefas = dao.listarTarefasComSubtarefas();
%>
<button class="btn-add" onclick="window.location.href='index.jsp'">HOME</button></BR>
---------------------------------------------
<% if (tarefas != null && !tarefas.isEmpty()) { %>
    <% for (TarefaBean tarefa : tarefas) { %>
    
        <div class="tarefa">
            <h2><%= tarefa.getTitulo() %></h2>
            <p><strong>Status:</strong> <%= tarefa.getStatus() %> | 
               <strong>Prioridade:</strong> <%= tarefa.getPrioridade() %> | 
               <strong>Responsável:</strong> <%= tarefa.getResponsavel() %></p>
            <p><strong>Descrição:</strong> <%= tarefa.getDescricao() %></p>
            <p><strong>Data de criação:</strong> <%= tarefa.getData_criacao() %> |
               <strong>Conclusão:</strong> <%= tarefa.getData_conclusao() != null ? tarefa.getData_conclusao() : "Não definida" %></p>

            <h3>Subtarefas</h3>
            <ul>
                <% for (SubtarefaBean sub : tarefa.getSubtarefas()) { %>
                    <li>
                        <%= sub.getDescricao() %> –
                        <%= sub.getData_conclusao() != null ? sub.getData_conclusao() : "Sem data" %>
                    </li>
                <% } %>

                <% if (tarefa.getSubtarefas().isEmpty()) { %>
                    <li class="sem-sub">Sem subtarefas cadastradas.</li>
                <% } %>
            </ul>
            ---------------------------------------------
        </div>
    <% } %>
<% } else { %>
    <p><em>Nenhuma tarefa cadastrada.</em></p>
<% } %>

</body>
</html>
