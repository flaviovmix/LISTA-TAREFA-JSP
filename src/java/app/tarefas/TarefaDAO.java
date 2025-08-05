package app.tarefas;

import app.MinhaConexao;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TarefaDAO {

    private MinhaConexao dataBase;

    public TarefaDAO() {
        dataBase = new MinhaConexao("lista_tarefas");
        dataBase.abrirConexao();
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

    public List<TarefaBean> listarTarefas() {

        List<TarefaBean> tarefas = new ArrayList<>();
        String sql = "SELECT a.*, (select count(*) from detalhes_tarefa b where b.fk_tarefa=a.id_tarefa) as subtarefas_count FROM tarefas a";
        
        try 
            (
                PreparedStatement ps = dataBase.getConexao().prepareStatement(sql);
                ResultSet rs = ps.executeQuery();
            ) {
            
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
                tarefa.setSubtarefas_counts(rs.getInt("subtarefas_count"));

                tarefas.add(tarefa);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tarefas;
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
    
    public List<TarefaBean> listaTarefasAtivas(int idTarefa) {
        return listarTarefasAtivoEInativas(idTarefa, true);
    }
    public List<TarefaBean> listaTarefasInativas(int idTarefa) {
        return listarTarefasAtivoEInativas(idTarefa, false);
    }
    private List<TarefaBean> listarTarefasAtivoEInativas(int idTarefa, boolean ativoOuInativo) {
        List<TarefaBean> lista = new ArrayList<>();
        
        String sql = "SELECT * FROM tarefas WHERE id_tarefa = ? AND ativo = ?";
        
        try (PreparedStatement ps = dataBase.getConexao().prepareStatement(sql);) {
            
            ps.setInt(1, idTarefa);
            ps.setBoolean(2, ativoOuInativo);
            
            try (ResultSet rs = ps.executeQuery();) {

                while (rs.next()) {
                    TarefaBean tarefa = new TarefaBean();

                    tarefa.setData_conclusao(rs.getDate("data_conclusao"));
                    tarefa.setData_criacao(rs.getDate("data_criacao"));
                    tarefa.setDescricao(rs.getString("descricao"));
                    tarefa.setId_tarefa(rs.getInt("id_tarefa"));
                    tarefa.setPrioridade(rs.getString("prioridade"));
                    tarefa.setResponsavel(rs.getString("responsavel"));
                    tarefa.setStatus(rs.getString("status"));
                    //tarefa.setSubtarefas_counts(rs.getDate(""));
                    tarefa.setTitulo(rs.getString("titulo"));
                    
                    lista.add(tarefa);
                }
                
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
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
