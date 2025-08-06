package app.util;

import app.tarefas.TarefaBean;
import app.Utilidades;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;
import javax.servlet.jsp.JspWriter;

public class RenderizadorTarefas {

   public static void renderizar(List<TarefaBean> tarefas, boolean ativaInativa, JspWriter out) {
    try {
        StringBuilder aux = new StringBuilder();

        if (tarefas == null || tarefas.isEmpty()) {
            aux.append("<div class='container-imagem'>");
            aux.append("<p style='text-align: center'>")
               .append(ativaInativa ? "todas as tarefas foram concluídas." : "nenhuma tarefa concluída.")
               .append("</p>");
            aux.append("</div>");
        } else {
            
            SimpleDateFormat sdf = new SimpleDateFormat("EEEE, dd MMM - yyyy", new Locale("pt", "BR"));
            
            String AtivoInativo = ativaInativa ? "" : "opaco";
            if (!ativaInativa) {
                aux.append("<h2 class='titulo-centro '>Tarefas concluídas</h2>");
            }

            aux.append("<div class='task-list '>");
            for (TarefaBean tarefa : tarefas) {
                aux.append("<div class='task ")
                   .append(Utilidades.arrumarCaractereHtmlJs(tarefa.getPrioridade()))
                   .append("'>");

                aux.append("  <div class='task-content'>");

                aux.append("    <div class='task-title ").append(AtivoInativo).append("'>");
                aux.append("      <a href='novaTarefa.jsp?id_tarefa=").append(tarefa.getId_tarefa())
                   .append("&novoOuEditar=1' class='link-sem-estilo'>")
                   .append(Utilidades.arrumarCaractereHtmlJs(tarefa.getTitulo()))
                   .append("</a>");
                aux.append("    </div>");

                aux.append("    <div class='task-meta ").append(AtivoInativo).append("'>");
                aux.append("      <span><i class='fas fa-layer-group'></i> ")
                   .append(         tarefa.getSubtarefas_count()).append(" subtarefas</span>");
                aux.append("      <span><i class='fas fa-calendar-day'></i> ")
                   .append(         Utilidades.arrumarCaractereHtmlJs(sdf.format(tarefa.getData_criacao())))
                   .append("      </span>");
                aux.append("      <span><i class='fas fa-comments'></i> 0</span>");
                aux.append("    </div>");

                aux.append("    <span class='descricao ").append(AtivoInativo).append("'>")
                   .append(         Utilidades.arrumarCaractereHtmlJs(tarefa.getDescricao()))
                   .append("     </span>");
                aux.append("  </div>");

                aux.append("  <div class='task-actions'>");
                aux.append("    <div>");
                aux.append("      <label class='checkbox-container'>");
                aux.append("        <div class='usuario_concluir'>");
                aux.append("          <div class='assigned'>")
                   .append("            <strong>")
                   .append(                 Utilidades.arrumarCaractereHtmlJs(tarefa.getResponsavel()))
                   .append("            </strong>")
                   .append("          </div>");

                aux.append("          <form action='alterarTarefaAtivosInativos.jsp' method='get' style='display:inline;'>");
                aux.append("            <input type='hidden' name='estado_atual' value='").append(ativaInativa).append("'>");
                aux.append("            <input type='hidden' name='id_tarefa' value='").append(tarefa.getId_tarefa()).append("'>");
                aux.append("            <input type='checkbox' name='ativo' onchange='this.form.submit()' ")
                   .append(                 !ativaInativa ? "checked" : "")
                   .append("            >");
                aux.append("          </form>");
                aux.append("        </div>");
                aux.append("      </label>");
                aux.append("    </div>");

                aux.append("    <a href='#' class='deletar-link' onclick=\"openModalDeletar(")
                   .append(         tarefa.getId_tarefa()).append(", '")
                   .append(         Utilidades.arrumarCaractereHtmlJs(tarefa.getTitulo())).append("', '")
                   .append(         Utilidades.arrumarCaractereHtmlJs(tarefa.getResponsavel())).append("', '")
                   .append(         Utilidades.arrumarCaractereHtmlJs(tarefa.getPrioridade())).append("', '")
                   .append(         Utilidades.arrumarCaractereHtmlJs(tarefa.getStatus()))
                   .append("'     ); return false;\">");
                aux.append("      <i class='fas fa-trash'></i>");
                aux.append("    </a>");

                aux.append("  </div>"); // Fecha task-actions
                aux.append("</div>");    // Fecha task
            }
            aux.append("</div>"); // Fecha task-list
        }

        out.print(aux.toString());

    } catch (Exception e) {
        e.printStackTrace();
    }
}

}
