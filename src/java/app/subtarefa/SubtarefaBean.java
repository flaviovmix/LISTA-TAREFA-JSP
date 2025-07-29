package app.subtarefa;

public class SubtarefaBean {
    private int id_detalhe;
    private int fk_tarefa;
    private String descricao;
    private String data_conclusao;
    private boolean ativo;

    public int getId_detalhe() {
        return id_detalhe;
    }
    public void setId_detalhe(int id_detalhe) {
        this.id_detalhe = id_detalhe;
    }

    public int getFk_tarefa() {
        return fk_tarefa;
    }
    public void setFk_tarefa(int fk_tarefa) {
        this.fk_tarefa = fk_tarefa;
    }

    public String getDescricao() {
        return descricao;
    }
    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getData_conclusao() {
        return data_conclusao;
    }
    public void setData_conclusao(String data_conclusao) {
        this.data_conclusao = data_conclusao;
    }
    
    public boolean isAtivo() {
        return ativo;
    }
    public void setAtivo(boolean ativo) {
        this.ativo = ativo;
    }
    
    
}
