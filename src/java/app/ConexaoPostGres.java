package app;

// Importações da API JDBC para trabalhar com banco de dados
import java.sql.Connection;       // Interface que representa uma conexão com o banco
import java.sql.DriverManager;    // Classe que cria conexões via URL, usuário e senha
import java.sql.SQLException;     // Classe que representa erros de SQL (como falha ao conectar)


public class ConexaoPostGres {
    //private -> Só pode ser acessada dentro da própria classe.
    //final -> Só pode ser definida uma vez (normalmente no construtor) e não pode ser alterada depois.
    //String -> Uuma classe do pacote java.lang usada para representar sequências de caracteres.
    //host, porta, banco, usuario, senha -> Variáveis que armazenam as informações da conexão com o banco.
    private final String host;    
    private final String porta;   
    private final String banco;   
    private final String usuario; 
    private final String senha;  


    
    // Variável privada do tipo 'Connection'. Não é um tipo primitivo, e sim uma interface da biblioteca JDBC.
    // Será usada para enviar comandos SQL ao banco de dados e receber os resultados.
    private Connection conexaoComBanco;

    
    
    // Construtor público chamado ConexaoPostGres que recebe o nome do banco de dados como parâmetro.
    // Os demais parâmetros (host, porta, usuário e senha) são definidos com valores fixos.
    public ConexaoPostGres(String nomeDoBanco) {
        
        // Atribui o valor recebido no parâmetro ao atributo 'banco'
        banco = nomeDoBanco;

        // Define os demais parâmetros de conexão com valores fixos
        host = "localhost";      // Endereço do servidor (localhost = computador local)
        porta = "5432";          // Porta padrão do PostgreSQL
        usuario = "postgres";    // Nome de usuário padrão do PostgreSQL
        senha = "masterkey";     // Senha do usuário (não recomendável deixar fixa em produção)

    }
    
    
    // Método público chamado 'abrirConexao'.
    // Ele retorna um objeto do tipo 'Connection', que representa uma conexão com o banco de dados.
    // 'Connection' não é um tipo primitivo, e sim uma interface da biblioteca JDBC (pacote java.sql).
    // Esse objeto é usado para enviar comandos SQL ao banco e manipular os resultados.
    public Connection abrirConexao() {
        
        //Monte a URL de conexão com o banco de dados PostgreSQL, usando o host, a porta e o nome do banco, e guarde tudo na variável de texto url.”
        String url = "jdbc:postgresql://" + host + ":" + porta + "/" + banco;
        
        //Tente executar este bloco de código.
        try {
            //carrega a classe do driver JDBC do PostgreSQL dinamicamente em tempo de execução.
            Class.forName("org.postgresql.Driver");
            
            //Essa linha abre uma conexão com o banco de dados e atribui à variável conexao.
            conexaoComBanco = DriverManager.getConnection(url, usuario, senha);
        } 
        
        //Se acontecer um erro relacionado ao banco de dados, capture esse erro e armazene na variavel erro.
        catch (SQLException erro) {
            //Mostre no console a mensagem de erro que ocorreu ao tentar fechar a conexão com o banco.
            System.out.println("Erro ao conectar ao banco: " + erro.getMessage());
        } 
        
        //Se o Java não conseguir encontrar a classe do driver, capture esse erro e armazene na variavel erro.
        catch (ClassNotFoundException erro) {
            System.out.println("Driver JDBC não encontrado: " + erro.getMessage());
        } 
        
        //Pegue qualquer erro genérico que não tenha sido capturado antes, e armazene na variavel erro.
        catch (Exception erro) {
            System.out.println("Erro inesperado: " + erro.getMessage());
        }
        
        //Devolva a conexão com o banco de dados que está guardada na variável conexaoComBanco."
        return conexaoComBanco;
    }
    
    
    
    //Método público que não retorna nada chamado fecharConexao.
    public void fecharConexao() {
        
        //Tente executar este bloco de código.
        try {
            
            //Se a conexão com o banco não for nula e ainda não estiver fechada
            if (conexaoComBanco != null && !conexaoComBanco.isClosed()) {
                
                //Fecha a conexão com o banco de dados
                conexaoComBanco.close();
            }
            
        //Se acontecer um erro relacionado ao banco de dados, capture esse erro e armazene na variavel erro.
        } catch (SQLException erro) {
            System.out.println("Erro ao fechar conexão: " + erro.getMessage());
        }
    }
    
    
    
    //Obter a conexão com o banco que essa classe está usando agora."
    public Connection getConexao() {
        return conexaoComBanco;
    }
    
    
    
    //Troque a conexão que essa classe está usando por essa nova aqui que eu estou passando.
    public void setConexao(Connection conexao) {
        this.conexaoComBanco = conexao;
    }

}
