<%@page import="app.tarefas.TarefaDAO"%>
<%@page import="app.tarefas.TarefaBean"%>
<%
    TarefaBean tarefa = new TarefaBean();
    TarefaDAO tarefaDAO = new TarefaDAO();

    tarefa.setId_tarefas(Integer.parseInt(request.getParameter("id_tarefas")));
    tarefa.setTitulo(request.getParameter("titulo"));
    tarefa.setResponsavel(request.getParameter("responsavel"));
    tarefa.setDescricao(request.getParameter("descricao"));
    tarefa.setStatus(request.getParameter("status"));
    tarefa.setPrioridade(request.getParameter("prioridade"));
    
    if (tarefa.getId_tarefas()==0){
        tarefaDAO.adicionarTarefa(tarefa);
        response.sendRedirect("novaTarefa.jsp?id_tarefas=" + tarefa.getId_tarefas() + "&novoOuEditar=0");
    } else {
        tarefaDAO.alterarTarefa(tarefa);
        response.sendRedirect("novaTarefa.jsp?id_tarefas=" + tarefa.getId_tarefas() + "&novoOuEditar=1");
    }
%>