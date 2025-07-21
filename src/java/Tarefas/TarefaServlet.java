package Tarefas;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;

public class TarefaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        try {
            TarefaDAO dao = new TarefaDAO();
            List<TarefaBean> lista = dao.listarTarefasComSubtarefas(4);

            request.setAttribute("listaTarefas", lista);
            RequestDispatcher dispatcher = request.getRequestDispatcher("lista_tarefas.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao listar tarefas: " + e.getMessage());
            request.getRequestDispatcher("erro.jsp").forward(request, response);
        }
    }
}
