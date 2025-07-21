            
<%@page import="Tarefas.TarefaDAO"%>
<%@page import="Tarefas.TarefaBean"%>

<%
    TarefaBean tarefa = new TarefaBean();

    tarefa.setId_tarefas(Integer.parseInt(request.getParameter("id_tarefas")));
    tarefa.setTitulo(request.getParameter("titulo"));
    tarefa.setResponsavel(request.getParameter("responsavel"));
    tarefa.setDescricao(request.getParameter("descricao"));
    tarefa.setStatus(request.getParameter("status"));
    tarefa.setPrioridade(request.getParameter("prioridade"));
    
    TarefaDAO dao = new TarefaDAO();
    if (tarefa.getId_tarefas()==0){
        dao.adicionarTarefa(tarefa);
        response.sendRedirect("novaTarefa.jsp?id_tarefas=" + tarefa.getId_tarefas() + "&novoOuEditar=0");
    } else {
        dao.alterarTarefa(tarefa);
        response.sendRedirect("novaTarefa.jsp?id_tarefas=" + tarefa.getId_tarefas() + "&novoOuEditar=1");
    }
    

    // Suponha que você salvou a tarefa com sucesso
    //response.sendRedirect("index.jsp?dadoVazio=1");
%>