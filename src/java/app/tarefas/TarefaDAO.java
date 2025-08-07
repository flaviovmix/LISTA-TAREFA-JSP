package app.tarefas;

import app.ConexaoPostGres;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TarefaDAO {

    private ConexaoPostGres dataBase;

    public TarefaDAO() {
        dataBase = new ConexaoPostGres("lista_tarefas");
        dataBase.abrirConexao();
    }
    
    // Método público que retorna uma lista de tarefas ativas.
    // Ele delega a execução para o método listarTarefasAtivoEInativas passando o valor "verdadeiro" como argumento.
    // O retorno é do tipo List<TarefaBean>, sem expor qual implementação concreta da lista está sendo usada.
    // retornando apenas as tarefas ativas.    
    public List<TarefaBean> listaTarefasAtivas() {
        return listarTarefasAtivoEInativas(true);
    }

    //igual o anterior porem passando falso como argumento
    // retornando apenas as tarefas inativas.
    public List<TarefaBean> listaTarefasInativas() {
        return listarTarefasAtivoEInativas(false);
    }

    
    
    
    
    // Método privado que retorna uma lista de tarefas do tipo List<TarefaBean>.
    // Recebe um argumento do tipo boolean chamado ativoOuInativo, que determina
    // se o método deve buscar tarefas ativas (true) ou inativas (false).
    // Internamente, ele utiliza a implementação ArrayList para armazenar os resultados.
    private List<TarefaBean> listarTarefasAtivoEInativas(boolean ativoOuInativo) {
        
    // Em Java, List é uma interface da biblioteca java.util, ArrayList é uma classe concreta que implementa essa interface.
    // Estamos criando uma lista de TarefaBean usando a implementação ArrayList.
    List<TarefaBean> lista = new ArrayList<>();


    
        // Cria um novo objeto StringBuilder chamado sql.
        // StringBuilder é uma classe do Java usada para construir e manipular textos de forma eficiente.
        // Diferente da classe String (que é imutável), o StringBuilder permite modificar o conteúdo sem criar novos objetos na memória.
        // Isso é especialmente útil quando queremos montar uma string em várias partes
        //como é o caso da construção de uma consulta SQL longa e complexa.
        StringBuilder sql = new StringBuilder();
        
        //Seleciona todas as colunas da tabela tarefas
        sql.append("SELECT tarefas.* , (");

            // Faz uma subconsulta para contar as subtarefas selecionando a contagem de todos os registros
            sql.append("SELECT COUNT(*) ");

                // Da tabela detalhes_tarefa
                sql.append("FROM detalhes_tarefa ");

                // Onde a chave estrangeira da tabela detalhes_tarefa corresponda ao id da tabela tarefa
                sql.append("WHERE detalhes_tarefa.fk_tarefa = tarefas.id_tarefa ");

            // Nomeia a coluna resultante como numero_de_subtarefas
            sql.append(") AS quantidade_de_subtarefas ");

        // Da tabela principal tarefas
        sql.append("FROM tarefas WHERE ativo = ?;");


        try (PreparedStatement ps = dataBase.getConexao().prepareStatement(sql.toString())) {
            ps.setBoolean(1, ativoOuInativo);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TarefaBean tarefa = new TarefaBean();
                    tarefa.setId_tarefa(rs.getInt("id_tarefa"));
                    tarefa.setTitulo(rs.getString("titulo"));
                    tarefa.setDescricao(rs.getString("descricao"));
                    tarefa.setStatus(rs.getString("status"));
                    tarefa.setPrioridade(rs.getString("prioridade"));
                    tarefa.setResponsavel(rs.getString("responsavel"));
                    tarefa.setData_criacao(rs.getDate("data_criacao"));
                    tarefa.setData_conclusao(rs.getDate("data_conclusao"));
                    tarefa.setQuantidade_de_subtarefas(rs.getInt("quantidade_de_subtarefas"));
                    lista.add(tarefa);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public void selectUnico(TarefaBean tarefa) {
        String sql = "SELECT * FROM tarefas WHERE id_tarefa = ?";

        try (
            PreparedStatement ps = dataBase.getConexao().prepareStatement(sql)
        ) {
            ps.setInt(1, tarefa.getId_tarefa()); // Evita SQL Injection

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    tarefa.setTitulo(rs.getString("titulo"));
                    tarefa.setDescricao(rs.getString("descricao"));
                    tarefa.setStatus(rs.getString("status"));
                    tarefa.setPrioridade(rs.getString("prioridade"));
                    tarefa.setResponsavel(rs.getString("responsavel"));
                    tarefa.setData_criacao(rs.getDate("data_criacao"));
                    tarefa.setData_conclusao(rs.getDate("data_conclusao"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void adicionarTarefa(TarefaBean tarefa) {
        String sql = "INSERT INTO tarefas "
                + "(titulo, descricao, status, prioridade, responsavel) VALUES "
                + "(     ?,         ?,      ?,          ?,           ?)";

        try (PreparedStatement ps = dataBase.getConexao().prepareStatement(sql)) {
            ps.setString(1, tarefa.getTitulo());
            ps.setString(2, tarefa.getDescricao());
            ps.setString(3, tarefa.getStatus());
            ps.setString(4, tarefa.getPrioridade());
            ps.setString(5, tarefa.getResponsavel());

            ps.executeUpdate();

            maxId(tarefa);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void maxId(TarefaBean tarefa) {
        
        String sql = "SELECT max(id_tarefa) as id_tarefa FROM tarefas;";
        
        try (
                PreparedStatement ps = dataBase.getConexao().prepareStatement(sql);
                ResultSet rs = ps.executeQuery();                
            ) {
            
            if (rs.next()) {
                tarefa.setId_tarefa(rs.getInt("id_tarefa"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void alterarTarefa(TarefaBean tarefa) {
        String sql = "UPDATE tarefas SET "
                + "titulo = ?, "
                + "descricao = ?, "
                + "status = ?, "
                + "prioridade = ?, "
                + "responsavel = ? "
                + "WHERE id_tarefa = ?";

        try (PreparedStatement ps = dataBase.getConexao().prepareStatement(sql)) {
            ps.setString(1, tarefa.getTitulo());
            ps.setString(2, tarefa.getDescricao());
            ps.setString(3, tarefa.getStatus());
            ps.setString(4, tarefa.getPrioridade());
            ps.setString(5, tarefa.getResponsavel());
            ps.setInt(6, tarefa.getId_tarefa());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void excluirTarefa(Integer id_tarefa) {

        String sql = ("DELETE FROM tarefas WHERE id_tarefa = ?");
        
        try (PreparedStatement ps = dataBase.getConexao().prepareStatement(sql);) {
            
            ps.setInt(1, id_tarefa);
            
            ps.executeUpdate();
            
        }catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public TarefaBean buscarPorId(int id) {
        
        String sql = "SELECT * FROM tarefas WHERE id_tarefa = ?";
        
        TarefaBean tarefa = null;
        try (
                PreparedStatement ps = dataBase.getConexao().prepareStatement(sql);
                ResultSet rs = ps.executeQuery();
            ) {
            
            ps.setInt(1, id);
            
            if (rs.next()) {
                tarefa = new TarefaBean();
                tarefa.setId_tarefa(rs.getInt("id_tarefa"));
                tarefa.setTitulo(rs.getString("titulo"));
                tarefa.setDescricao(rs.getString("descricao"));
                tarefa.setStatus(rs.getString("status"));
                tarefa.setPrioridade(rs.getString("prioridade"));
                tarefa.setResponsavel(rs.getString("responsavel"));
                //tarefa.setData_criacao(rs.getDate("data_criacao"));
                //tarefa.setData_conclusao(rs.getDate("data_conclusao"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return tarefa;
    }
    
    
    public void alterarAtivoInativo(int id_tarefa, boolean ativo) {
        try {
            String sql = "UPDATE tarefas SET ativo = ? WHERE id_tarefa = ?";
            
            PreparedStatement ps = dataBase.getConexao().prepareStatement(sql);

            ps.setBoolean(1, ativo);
            ps.setInt(2, id_tarefa);
            ps.executeUpdate();

            ps.close(); 
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    
    public void fecharConexao() {
        dataBase.fecharConexao();
    }

}
