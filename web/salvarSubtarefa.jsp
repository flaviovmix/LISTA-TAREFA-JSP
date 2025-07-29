<%@page import="app.subtarefa.SubtarefaDAO"%>
<%@page import="app.subtarefa.SubtarefaBean"%>
<%@page import="app.MinhaConexao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    SubtarefaBean subtarefa = new SubtarefaBean();
    SubtarefaDAO dao = new SubtarefaDAO();

    subtarefa.setDescricao(request.getParameter("descricao"));
    subtarefa.setData_conclusao(request.getParameter("data_conclusao"));
    subtarefa.setFk_tarefa(Integer.parseInt(request.getParameter("fk_tarefa")));

    if (subtarefa.getId_detalhe() == 0) {
        dao.adicionarSubtarefa(subtarefa);
        response.sendRedirect("novaTarefa.jsp?id_tarefas=" + subtarefa.getFk_tarefa()+"&novoOuEditar=1");
    } 

    dao.fecharConexao();
%>
