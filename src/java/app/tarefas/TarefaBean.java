package app.tarefas;

import app.subtarefa.SubtarefaBean;
import java.sql.Date;
import java.util.List;

public class TarefaBean {
    
    private int id_tarefas;
    private String titulo;
    private String descricao;
    private String status;
    private String prioridade;
    private String responsavel;
    private Date data_criacao;
    private Date data_conclusao;
    
    private List<SubtarefaBean> subtarefas;

    public int getId_tarefas() {
        return id_tarefas;
    }
    public void setId_tarefas(int id_tarefas) {
        this.id_tarefas = id_tarefas;
    }

    public String getTitulo() {
        return titulo;
    }
    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescricao() {
        return descricao;
    }
    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public String getPrioridade() {
        return prioridade;
    }
    public void setPrioridade(String prioridade) {
        this.prioridade = prioridade;
    }
    
    public boolean isPrioridadeBaixa(){
        return ("baixa".equals(getPrioridade()));
    }
    public boolean isPrioridadeMedia(){
        return ("media".equals(getPrioridade()));
    }
    public boolean isPrioridadeAlta(){
        return ("alta".equals(getPrioridade()));
    }

    public String getResponsavel() {
        return responsavel;
    }
    public void setResponsavel(String responsavel) {
        this.responsavel = responsavel;
    }
    
    public Date getData_criacao() {
        return data_criacao;
    }
    public void setData_criacao(Date data_criacao) {
        this.data_criacao = data_criacao;
    }

    public Date getData_conclusao() {
        return data_conclusao;
    }
    public void setData_conclusao(Date data_conclusao) {
        this.data_conclusao = data_conclusao;
    }
    
    public List<SubtarefaBean> getSubtarefas() {
        return subtarefas;
    }

    public void setSubtarefas(List<SubtarefaBean> subtarefas) {
        this.subtarefas = subtarefas;
    }
    
    
}
