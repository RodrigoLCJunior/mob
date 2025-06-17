# 🎮 Funcionamento do Jogo
🏠 Tela Inicial
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

# 📜 Missões e Combate

🎯 Como funciona o combate:
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
