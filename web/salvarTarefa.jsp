<%@page import="app.tarefas.TarefaDAO"%>
<%@page import="app.tarefas.TarefaBean"%>
<%
    TarefaBean tarefa = new TarefaBean();
    TarefaDAO dao = new TarefaDAO();

    tarefa.setId_tarefa(Integer.parseInt(request.getParameter("id_tarefa")));
    tarefa.setTitulo(request.getParameter("titulo"));
    tarefa.setResponsavel(request.getParameter("responsavel"));
    tarefa.setDescricao(request.getParameter("descricao"));
    tarefa.setStatus(request.getParameter("status"));
    tarefa.setPrioridade(request.getParameter("prioridade"));
    
    if (tarefa.getId_tarefa()==0){
        dao.adicionarTarefa(tarefa);
    } else {
        dao.alterarTarefa(tarefa);
    }
    response.sendRedirect("tarefaMasterDetail.jsp?id_tarefa=" + tarefa.getId_tarefa() + "&novoOuEditar=1");
    
    dao.fecharConexao();
%>