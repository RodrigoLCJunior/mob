 # 🏗️ Arquitetura do Projeto
 - O projeto foi desenvolvido utilizando uma abordagem sólida e escalável, combinando diferentes padrões arquiteturais que se complementam:

🔥 MVVM (Model-View-ViewModel)
 - O projeto segue o padrão de arquitetura MVVM, que organiza o código em três camadas principais:

 - Model: Responsável pela regra de negócio e estrutura de dados.

 - View: A interface do usuário e seus componentes visuais.

 - ViewModel: Faz a ponte entre a View e o Model, controlando os estados e a lógica de apresentação.

- 🧠 Toda a gestão de estado é feita de forma clara e bem definida, diferenciando:

    - Estados Efêmeros: Estados temporários, como carregamentos e animações.

    - Estados Compartilhados: Dados persistentes durante a navegação, como informações de usuário e progresso no jogo.

    - Para essa gestão, utilizamos o pacote BLoC (Business Logic Component), garantindo que:

    - A lógica de negócio permaneça desacoplada da interface.

    - Os estados sejam bem controlados, previsíveis e reativos.

 # 🎯 Mini Arquitetura Paralela: ECS (Entity Component System)
    - Dentro da própria arquitetura MVVM, o projeto incorpora uma mini arquitetura ECS (Entity Component System) aplicada especificamente no módulo de gameplay e combate.

    - O padrão ECS oferece uma abordagem altamente modular, performática e escalável, especialmente eficiente para desenvolvimento de jogos.

  - 🔧 Funcionamento do ECS no projeto:

    - Entities: São os objetos do jogo, como o jogador, o inimigo, efeitos, etc.

    - Components: Dados ou atributos que são adicionados às entidades (ex.: vida, ataque, defesa, status).

    - Systems: Contêm a lógica que processa as entidades que possuem determinados componentes (ex.: sistema de combate, sistema de turno, sistema de efeitos).

  - ✅ O ECS também respeita e utiliza a gestão de estado baseada em BLoC, mantendo:

    - Separação de responsabilidades.

    - Clareza nos estados efêmeros e compartilhados.

    - Alto desempenho durante os combates e interações dinâmicas do jogo.

 # 🔥 Benefícios dessa Arquitetura
 - 🔄 Código altamente reutilizável e organizado.

 - 🛠️ Facilidade de manutenção e expansão do projeto.

 - ⚙️ Permite uma separação clara entre UI, lógica de negócio e lógica do jogo.

 - 🚀 Desempenho otimizado no módulo de gameplay graças ao ECS.


# 🎮 Funcionamento do Jogo
🏠 Tela Inicial
- Exibe a logo do jogo com visual imersivo.
  
- Você pode segurar e arrastar a tela para visualizar todo o background.

- Ao clicar rapidamente na tela, um raio aparece brevemente, e o background muda, permitindo explorar essa nova cena. Ao clicar novamente, surge um trovão.

- Para começar, clique no botão “Press Here”, que abrirá uma modal de Login ou Cadastro.

⚠️ É obrigatório ter uma conta para acessar o jogo. Você pode criar uma nova ou fazer login se já tiver uma.

🌟 Tela Principal
 - Após o login, você chega à tela principal, onde pode:

 - Visualizar suas moedas, que são usadas para melhorias.

 - Acessar a aba de Habilidades clicando na estrela ⭐ (localizada na parte inferior).

 - Aqui, você pode aprimorar habilidades utilizando suas moedas.

 - Clicar na engrenagem ⚙️, que está em manutenção e ainda não possui funcionalidade.

 - Na mesma tela, você pode escolher uma missão clicando no ícone do livro 📖 (primeiro botão).

 - Logo, o jogo inicia a fase de combate correspondente.

# 📜 Missões e Combate

🎯 Como funciona o combate:

Interface com:

 - Barra de vida do inimigo e do jogador.

 - Feedback visual ao jogar cartas.

 - No canto superior esquerdo vamos ter o botão para caso o jogador queira voltar 
 a Tela de Menu.

Início do combate:

 - Tanto você quanto o inimigo recebem 5 cartas aleatórias.

 - As cartas possuem diferentes ações, como ataque, defesa ou buffs.

Jogando cartas:

 - Para usar uma carta, arraste-a até o inimigo.

 - Cada carta possui uma descrição clara do seu efeito.

 Turnos:

- Após jogar suas cartas, clique no botão “Pular Turno”, localizado no canto inferior direito.

- O inimigo então realiza seu turno.

Próximos turnos:

- Nos turnos seguintes, ambos compram 3 cartas por turno (em vez de 5).

- Condição de vitória:

- O combate continua até que a barra de vida de um dos dois chegue a zero.

- Quem zerar a vida primeiro, perde a partida.

🏆 Objetivo
- Vença os inimigos para ganhar moedas.

- Utilize as moedas para aprimorar suas habilidades, tornando-se mais forte em cada batalha.

# 🔗 Conexão com o Backend
🚀 O jogo se conecta com uma API desenvolvida em nosso backend, que está hospedada na plataforma Render.

 - Sempre que você realiza uma ação como:

🔑 Login

🆕 Cadastro

⚔️ Entrar em um combate
 - O jogo realiza uma requisição para a API.

⚠️ Atenção:
 - A plataforma Render entra em estado de hibernação quando não há uso por cerca de 15 minutos.
 - Quando isso acontece, a primeira requisição após esse período pode demorar entre 1 e 2 minutos para ser processada, enquanto o servidor é reativado.

 - Após esse tempo inicial, as requisições voltam a ser rápidas e em tempo real, até que o servidor hiberne novamente por inatividade.

🕐 Portanto, caso perceba um tempo elevado de carregamento, aguarde a conclusão. Isso é um comportamento normal da hospedagem gratuita na Render.
