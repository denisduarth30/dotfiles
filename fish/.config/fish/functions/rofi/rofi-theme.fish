#!/usr/bin/fish

sleep 0.05

set -l window_id (xdotool getactivewindow 2>/dev/null)
set -l app_name ""

if test -n "$window_id"
    set -l xprop_output (xprop -id $window_id WM_CLASS 2>/dev/null)
    set app_name (echo $xprop_output | string match -ra '"([^"]+)"' | tail -n 1 | string lower)

    set -l window_title (xprop -id $window_id WM_NAME 2>/dev/null | string lower)

    if string match -qr "área de trabalho|desktop" "$window_title"
        set app_name "desktop"
    end
end

if test -z "$app_name"
    set app_name "desktop"
end

set -l dark_theme "$HOME/.config/rofi/themes/dark-theme.rasi"
set -l light_theme "$HOME/.config/rofi/themes/light-theme.rasi"
set -l mint_dark "$HOME/.config/rofi/themes/mint-dark.rasi"

if string match -qr "firefox|chrome|brave|code|spotify|zed|zed-editor|dev.zed.zed|alacritty|kitty" "$app_name"
    set theme_selected $dark_theme
else if string match -qr "nemo|nautilus" "$app_name"
    set theme_selected $mint_dark
else
    set theme_selected $light_theme
end

echo -n $theme_selected > /tmp/rofi-current-theme

set -l mode combi
if contains -- "web" $argv
    set mode web
else if contains -- "run" $argv
    set mode run
else if contains -- "ani-cli" $argv
    set mode ani-cli
else if contains -- "powermenu" $argv
    set mode powermenu
end

if test "$mode" = web
    set phrases \
        "A resposta tá no Google ou no Stack?" \
        "Digite sua query existencial..." \
        "Google, DDG ou o de sempre?" \
        "Pesquisar na gringa ou em PT?" \
        "O que a internet sabe sobre isso?" \
        "Qual segredo a web esconde hoje?" \
        "Digitando... procurando... achando?" \
        "De volta à matrix da web..." \
        "O que você quer decifrar agora?" \
        "Procurando soluções rápidas..." \
        "Aquela pesquisa de 5 segundos que vira 2 horas..." \
        "Cadê o link que sumiu?" \
        "O que o DuckDuckGo diria sobre isso?" \
        "Buscando threads no Reddit..." \
        "Navegando na maré do Fish..." \
        "Procurar erro de sintaxe ou erro de lógica?" \
        "Pronto para lançar o buscador." \
        "Mais uma pesquisa pro histórico..." \
        "O que você quer encontrar primeiro?" \
        "Qual o seu termo de busca da vez?" \
        "Procurando aquela documentação esquecida..." \
        "O que o Arch Wiki diz?" \
        "Buscando insights na rede..." \
        "A internet tá rápida o suficiente hoje?" \
        "O que você precisa descobrir em 5 minutos?" \
        "Sua barra de pesquisa personalizada." \
        "A resposta está por aí..." \
        "Consultando os oráculos da internet." \
        "Escreve o erro aí, vamos ver o que o StackOverflow diz." \
        "Buscando a verdade na World Wide Web." \
        "O que a inteligência artificial responderia aqui?" \
        "Por favor, que não seja um link quebrado de 2012." \
        "Alguém já deve ter resolvido isso em um fórum obscuro." \
        "Caçando a documentação oficial..." \
        "Qual o repositório daquela lib?" \
        "De volta ao vício de abrir abas..." \
        "O que você quer minerar na web hoje?" \
        "Pesquisando para não ter que pensar." \
        "Qual o segredo para corrigir esse bug?" \
        "Buscando pacotes e respostas." \
        "Mais uma busca que vai acabar no GitHub Issues." \
        "Qual o link definitivo para isso?" \
        "Rofi, faça a busca na grande rede." \
        "O que você quer rastrear?" \
        "Uma query vale mais que mil palavras." \
        "O que a comunidade do Reddit acha disso?" \
        "Procurando o censo comum da internet." \
        "Rastreadores prontos, digite a busca." \
        "Se tá na internet, deve ser verdade... ou não." \
        "Procurando o tutorial perfeito." \
        "Quantos cliques até a solução?" \
        "O que você quer validar hoje?" \
        "Pesquisa rápida ou mergulho profundo?" \
        "Onde foi parar aquela especificação?" \
        "Procurando cheat sheets..." \
        "O que a barra de endereços vai receber?" \
        "Buscando inspiração na web alheia." \
        "A internet é um oceano, digite o que pescar." \
        "Qual a melhor ferramenta para isso? Vamos buscar." \
        "Procurando por aquela resposta salva na memória." \
        "O que diz o manual da internet?" \
        "Não sabe? Pergunta pro buscador." \
        "Buscando artigos que eu nunca vou ler inteiros." \
        "Onde está o repositório oficial?" \
        "Mais um termo para o algoritmo aprender sobre você." \
        "Qual o repositório Git desse projeto?" \
        "Procurando código para copiar e colar de forma elegante." \
        "O que os gringos discutiram sobre esse erro?" \
        "Procurando aquela tradução ou sinônimo perfeito." \
        "Buscando a URL da salvação." \
        "Seja específico, a internet é gigante." \
        "O que o buscador vai trazer do submundo?" \
        "Caçando a resposta definitiva para tudo." \
        "Qual o pacote NPM ou Python que faz isso?" \
        "Procurando o post perfeito no blog de tecnologia." \
        "O que a barra do Rofi vai varrer na rede?" \
        "Abre o mapa da web, onde vamos?" \
        "Buscando os segredos do backend de alguém." \
        "O que você quer descobrir em tempo recorde?" \
        "Procurando alternativas open source para..." \
        "Qual o melhor framework para essa loucura?" \
        "Buscando referências visuais na web." \
        "O que o mundo está codando sobre isso?" \
        "Procurando o changelog da última versão." \
        "A internet sabe, o Rofi busca." \
        "O que você quer pesquisar antes de admitir que não sabe?" \
        "Caçando explicações simples para coisas complexas." \
        "Buscando a linha de comando exata no histórico do site." \
        "Qual a melhor prática recomendada pelo W3C?" \
        "Procurando por aquela API pública e gratuita." \
        "O que o repositório do AUR esconde?" \
        "Buscando o significado desse código de erro." \
        "Onde está o download oficial?" \
        "Qual fórum vai salvar sua pele hoje?" \
        "Procurando a solução sem precisar ler 50 páginas." \
        "O que o Duck está procurando para você?" \
        "Buscando o padrão de projeto correto." \
        "Navegar é preciso, buscar também." \
        "Qual o link para o deploy que funcionou?" \
        "Procurando a luz no fim do túnel da internet."

else if test "$mode" = run
    set phrases \
        "O que você precisa rodar?" \
        "Mais um comando..." \
        "Systemctl status de quê?" \
        "Qual processo dar um kill -9?" \
        "Qual script vai salvar sua pele hoje?" \
        "Falta permissão de root?" \
        "O que o chmod +x vai resolver hoje?" \
        "Qual utilitário CLI você descobriu ontem?" \
        "Qual histórico do Fish vamos revirar?" \
        "Qual porta tá em uso?" \
        "Sua jornada começa com um comando." \
        "O que o terminal manda?" \
        "Mais um script de shell?" \
        "O que o cron vai rodar hoje?" \
        "Qual comando você copiou do StackOverflow?" \
        "O script rodou de primeira ou deu ruim?" \
        "O que o fzf não encontrou?" \
        "Qual o comando supremo de agora?" \
        "Só mais um comando..." \
        "Qual atalho você ainda não decorou?" \
        "O que o log tá dizendo?" \
        "Qual config você vai tunar hoje?" \
        "Qual terminal você vai abrir dentro do terminal?" \
        "Fish ou bash, a eterna questão." \
        "Alias novo hoje?" \
        "O que o man page diz?" \
        "Grep ou ripgrep?" \
        "Tem script quebrado esperando?" \
        "Qual processo tá comendo RAM?" \
        "htop ou btop?" \
        "O que o journalctl esconde?" \
        "Mais um workaround ou solução de verdade?" \
        "Qual variável de ambiente sumiu?" \
        "Qual o comando que resolve isso de vez?" \
        "Executando scripts com fé na máquina." \
        "O que vamos automatizar em um só comando?" \
        "Qual binário perdido no /usr/bin você quer chamar?" \
        "Rofi run: o lançador de foguetes do Linux." \
        "Qual o pipe (`|`) mais longo que você vai fazer hoje?" \
        "O que o interpretador vai processar agora?" \
        "E lá vamos nós para o terminal..." \
        "Digite o comando e reze para não dar Syntax Error." \
        "Qual utilitário Coreutils você precisa?" \
        "Invocando processos em 3, 2, 1..." \
        "Qual serviço do systemd morreu de novo?" \
        "Limpar o cache do sistema ou deixar explodir?" \
        "Qual o PID daquele processo travado?" \
        "Rodando em background ou foreground?" \
        "O que o bash/fish vai engolir hoje?" \
        "Qual flag secreta você vai passar para o binário?" \
        "Hora de rodar aquela linha mágica do terminal." \
        "O que o compilador de C vai reclamar hoje?" \
        "Qual script do Python vai rodar no loop eterno?" \
        "Verificando as conexões de rede com o CLI." \
        "Qual comando vai salvar seu emprego hoje?" \
        "Rofi pronto para disparar tarefas brutas." \
        "O que o terminal vai cuspir de output?" \
        "Testando scripts no ambiente de produção (corajoso)?" \
        "Qual alias vai te poupar 10 segundos de digitação?" \
        "O que o comando awk vai filtrar hoje?" \
        "Sed, awk ou xargs? Qual o canivete suíço da vez?" \
        "Iniciando uma rotina automatizada." \
        "Qual comando vai limpar a bagunça do disco?" \
        "Verificando logs em tempo real..." \
        "O que o comando find vai caçar no sistema?" \
        "O shell aguarda suas instruções destrutivas." \
        "Qual ferramenta de rede rodar hoje?" \
        "O que o curl vai requisitar da API?" \
        "Rodando comandos antes que o café esfrie." \
        "Qual script local vai fazer a mágica?" \
        "O que o interpretador de comandos vai ler?" \
        "Disparando processos sem interface gráfica." \
        "Qual o comando mais perigoso que você vai rodar hoje?" \
        "O que o comando df -h vai dizer sobre seu espaço?" \
        "Verificando a temperatura da CPU via CLI." \
        "Qual tarefa de automação colocar em execução?" \
        "Executando o plano B via terminal." \
        "O que o comando top vai te ocultar?" \
        "Chamando funções do arquivo de configuração." \
        "Qual comando você decorou na marra?" \
        "Rofi run: o poder bruto nas suas mãos." \
        "O que o comando de pacotes vai instalar hoje?" \
        "Atualizando o sistema via linha de comando?" \
        "Qual daemon precisa de um restart?" \
        "O que o comando lsof vai dedurar?" \
        "Qual script do Rofi você quer disparar?" \
        "Invocando o superusuário em breve?" \
        "Qual comando vai criar uma pasta que você vai esquecer?" \
        "O que o comando cat vai exibir na tela?" \
        "Processando dados brutos via pipeline." \
        "Qual utilitário CLI vai te surpreender hoje?" \
        "O que o seu shell de preferência vai cuspir?" \
        "Mais uma linha para o seu arquivo .bash_history." \
        "Qual comando vai rodar em paralelo?" \
        "O que o comando watch vai monitorar?" \
        "Iniciando o script que você escreveu meio dormindo." \
        "Qual comando de diagnóstico rodar agora?" \
        "Rofi executando comandos na velocidade do pensamento." \
        "O que o terminal vai executar sem fazer perguntas?" \
        "Até o fim do arquivo de script..."

else if test "$mode" = ani-cli
    set phrases \
        "Hora de procrastinar com estilo?" \
        "Qual episódio ficou pendente?" \
        "Pipoca na mão? O que vamos assistir?" \
        "Buscando animes na velocidade da luz..." \
        "Mais um episódio antes de dormir (mentira)?" \
        "Foco cancelado. Modo otaku ativado." \
        "Qual mundo vamos explorar hoje?" \
        "Sessão cinema no terminal." \
        "Qual temporada começar hoje?" \
        "O que o reprodutor de vídeo vai abrir?" \
        "Procurando aquele anime clássico..." \
        "Qual a boa do catálogo de hoje?" \
        "Rofi no modo entretenimento." \
        "Chega de código, hora de assistir algo." \
        "Qual o nome daquela obra prima?" \
        "Buscando legendas e servidores rápidos..." \
        "Qual o próximo da lista de recomendados?" \
        "Procurando um filler para pular ou assistir?" \
        "O terminal também é cultura e lazer." \
        "Qual estúdio vai te surpreender hoje?" \
        "Buscando lançamentos da temporada." \
        "O que assistir enquanto o build do código roda?" \
        "O que o ani-cli vai pescar nos servidores?" \
        "Sessão otaku iniciada com sucesso." \
        "Procurando aquela animação lendária." \
        "Qual o título que vai te fazer chorar ou rir hoje?" \
        "Abre o player de vídeo, o Rofi escolhe." \
        "Chega de commits por hoje, hora de maratonar." \
        "Qual o shonen da vez?" \
        "Buscando animes de ficção científica ou fantasia?" \
        "Qual o nome do protagonista mesmo?" \
        "O que o script do ani-cli vai listar hoje?" \
        "Procurando batalhas épicas no terminal." \
        "Qual anime vai te fazer esquecer dos bugs?" \
        "Buscando a continuação daquele arco incrível." \
        "O que você vai assistir na hora do almoço?" \
        "Qual filme de animação colocar na fila?" \
        "Escreve o nome aí, o scraping faz o resto." \
        "Procurando por waifus e husbando no banco de dados." \
        "Qual mistério vamos desvendar nesse anime?" \
        "Buscando o episódio da semana." \
        "Chega de servidores lentos, puxando direto pelo CLI." \
        "O que o reprodutor local vai rodar hoje?" \
        "Qual jornada começar agora?" \
        "Buscando animações de alta qualidade." \
        "Qual abertura de anime não sai da sua cabeça?" \
        "Procurando o spin-off daquela série." \
        "O que assistir para limpar a mente?" \
        "Qual o anime mais hypado do momento?" \
        "Buscando animes subestimados no banco de dados." \
        "O que o terminal vai reproduzir em tela cheia?" \
        "Qual o nome em japonês ou em inglês?" \
        "Procurando aquela dose semanal de entretenimento." \
        "Qual o estúdio de animação favorito da vez?" \
        "Buscando por episódios em alta definição." \
        "O que o script vai raspar da web hoje?" \
        "Maratona de fim de semana ou de madrugada?" \
        "Qual clássico dos anos 90 rever hoje?" \
        "Procurando animes de mecha, esporte ou isekai?" \
        "O que o reprodutor MPV/VLC vai carregar?" \
        "Buscando aquela animação que todo mundo tá falando." \
        "Qual herói vai salvar o dia na sua tela?" \
        "Procurando animes com trilha sonora impecável." \
        "O que assistir quando nada mais faz sentido?" \
        "Buscando o desfecho daquela temporada." \
        "Qual anime tem o melhor plot twist?" \
        "Procurando entretenimento sem anúncios irritantes." \
        "O que o ani-cli vai decodificar agora?" \
        "Qual o próximo passo da sua watchlist?" \
        "Buscando o anime que vai virar seu favorito." \
        "Qual história vai te prender hoje?" \
        "Procurando um anime curto de 12 episódios." \
        "O que maratonar até o sol raiar?" \
        "Buscando produções originais incríveis." \
        "Qual universo alternativo visitar hoje?" \
        "Procurando por aquela animação de tirar o fôlego." \
        "O que o player vai transmitir direto da rede?" \
        "Qual luta marcou sua infância? Vamos rever." \
        "Buscando animes aconchegantes para relaxar." \
        "Qual o nome daquele filme que ganhou prêmios?" \
        "Procurando animes de comédia para desestressar." \
        "O que assistir depois de um deploy fracassado?" \
        "Buscando animes de terror ou suspense psicodélico." \
        "Qual o nome daquela light novel que virou anime?" \
        "Procurando no catálogo dos principais servidores." \
        "O que o terminal vai transmitir via streaming?" \
        "Qual o próximo episódio do seu vício atual?" \
        "Buscando produções que valem cada segundo." \
        "Qual o anime com a melhor animação de combate?" \
        "Procurando histórias de superação e código? Não, só de superação." \
        "O que assistir quando bater o tédio?" \
        "Buscando a versão sem censura ou estendida." \
        "Qual a melhor recomendação do MyAnimeList para hoje?" \
        "Procurando por aquele slice-of-life tranquilo." \
        "O que colocar de fundo enquanto faz outra coisa?" \
        "Buscando aquela produção nostálgica." \
        "Qual o anime que vai explodir sua mente hoje?" \
        "Procurando por episódios especiais e OVAs." \
        "O que assistir para fingir que não tem obrigações?" \
        "Sua TV de terminal está ligada, escolha o canal."

else
    set phrases \
        "O que vamos fazer hoje?" \
        "Bora codar?" \
        "Digite algo para buscar..." \
        "Que a força esteja com você." \
        "Procurando algo específico?" \
        "O que você precisa?" \
        "Vamos lá, o que será hoje?" \
        "Tem algo na manga?" \
        "Me diz o que quer." \
        "Bora resolver isso." \
        "Qual é a missão de hoje?" \
        "Buscando algo?" \
        "Pode digitar, tô aqui." \
        "O que está na sua cabeça?" \
        "Hoje é dia de produtividade?" \
        "Café na mão, o que vamos abrir?" \
        "Qual app te salva hoje?" \
        "Sem pressa, pode digitar." \
        "Mais um dia, mais um terminal." \
        "Qual é o plano?" \
        "Abre o quê hoje?" \
        "Tô esperando." \
        "Me convence a abrir algo útil." \
        "Foco. O que vem primeiro?" \
        "Bora fazer acontecer." \
        "Qual tarefa tá gritando seu nome?" \
        "Tem bug pra corrigir?" \
        "Mais um commit épico hoje?" \
        "Produtividade ou procrastinação?" \
        "Alguma ideia brilhante hoje?" \
        "O que vamos destruir hoje (no bom sentido)?" \
        "Tem PR pra revisar?" \
        "Qual aba você deveria ter fechado?" \
        "Hora de codar ou hora de dormir?" \
        "O que o stack trace diz?" \
        "Mais um feature ou mais um fix?" \
        "Qual serviço tá caindo agora?" \
        "Tem reunião ou tem paz?" \
        "O que seu futuro eu vai agradecer?" \
        "Bora tirar do backlog?" \
        "Abre o editor ou abre o YouTube?" \
        "Hoje tem deploy?" \
        "O que você devia estar fazendo?" \
        "Tem algo no clipboard?" \
        "Procrastinar ou entregar?" \
        "Mais um dotfile pra ajustar?" \
        "Stow funcionou dessa vez?" \
        "Qual plugin novo você vai instalar?" \
        "O tema tá perfeito ou quase?" \
        "Tem fonte nova pra testar?" \
        "Qual função você devia ter escrito antes?" \
        "Qual TODO virou DONE hoje?" \
        "Tem issue aberta com seu nome?" \
        "O README tá atualizado?" \
        "Qual branch você esqueceu de deletar?" \
        "git stash show diz o quê?" \
        "Tem conflito de merge esperando?" \
        "O .env tá completo?" \
        "Container subiu ou caiu?" \
        "O que o Docker Compose reclama hoje?" \
        "Tem volume pra limpar?" \
        "Qual imagem tá desatualizada?" \
        "O que você vai automatizar hoje?" \
        "Qual keybind você ainda não configurou?" \
        "O que o neofetch não mostra?" \
        "Wallpaper novo hoje?" \
        "Tema claro ou escuro hoje?" \
        "Qual atalho do rofi você ainda não usa?" \
        "O que você procura?" \
        "Pode digitar à vontade." \
        "Tô aqui, pode pedir." \
        "O que resolve seu problema agora?" \
        "Qual app você vai redescobrir hoje?" \
        "Abre algo incrível." \
        "Web ou localhost? Onde vamos?" \
        "Menos reuniões, mais código. O que abre?" \
        "O que o mestre do código deseja?" \
        "Foco total ou modo aleatório?" \
        "Abre o terminal ou abre o navegador?" \
        "Cadê o link que sumiu?" \
        "Buscando pacotes no repositório..." \
        "Qual pacote AUR você quer instalar agora?" \
        "Configurando o sistema ou quebrando ele?" \
        "Reiniciar o i3/Sway ou continuar codando?" \
        "Qual workspace vamos usar?" \
        "Mais um alias pro config.fish?" \
        "Abre os dotfiles ou o projeto principal?" \
        "O que está drenando sua bateria?" \
        "O terminal é seu Canvas. Digite." \
        "O que o GitHub copilot sugeriria aqui?" \
        "Código limpo ou código que funciona?" \
        "Falta uma aspa em algum lugar?" \
        "O que o compilador reclamou?" \
        "Qual o hash desse commit?" \
        "git push --force? Tem certeza?" \
        "Quem deu blame nessa linha?" \
        "O servidor de homologação tá de pé?" \
        "Qual API caiu no final de semana?" \
        "Qual JSON veio quebrado hoje?" \
        "Postman ou curl?" \
        "Buscando o IP da máquina..." \
        "Onde foi parar aquela chave SSH?" \
        "Quantos containers estão rodando?" \
        "O que o docker-compose.yml esconde?" \
        "Abre o Neovim ou o VS Code?" \
        "Qual plugin do Vim quebrou hoje?" \
        "Qual atalho do tmux você esqueceu?" \
        "Onde está o gargalo do sistema?" \
        "Quantos giga de RAM o Chrome tá usando?" \
        "Qual aba do navegador tá tocando música?" \
        "Abre o Spotify ou o reprodutor local?" \
        "O que tá tocando no terminal?" \
        "Qual a playlist de foco hoje?" \
        "O som tá saindo no fone certo?" \
        "Bluetooth conectou de primeira?" \
        "Qual o nível da bateria dos periféricos?" \
        "O que a cronjob fez na última hora?" \
        "Qual log do systemd vamos ler?" \
        "Onde está o gargalo da CPU?" \
        "O gerenciador de janelas tá respondendo?" \
        "O layout do teclado mudou sozinho?" \
        "Onde está salvo aquele screenshot?" \
        "Qual pasta do /home/ tá uma bagunça?" \
        "Limpar o /tmp/ hoje ou deixar pra lá?" \
        "Qual o tamanho da pasta node_modules?" \
        "Abre o gerenciador de arquivos ou faz no CLI?" \
        "Digite e deixe o Rofi fazer a mágica." \
        "O que você vai criar do zero hoje?" \
        "Qual o escopo do projeto de agora?" \
        "Pronto para resolver o mistério?" \
        "Abre a mente e digite." \
        "Qual o destino final desse comando?" \
        "Sua área de trabalho precisa de quê?" \
        "Qual o comando supremo de agora?" \
        "Feche os olhos e digite (ou não)." \
        "O Rofi está ao seu dispor." \
        "O que o shell Fish vai pescar hoje?" \
        "Qual o atalho para a felicidade?" \
        "Digite seu destino..." \
        "O sistema aguarda seu input." \
        "Qual a última linha que você escreveu?" \
        "Pronto para o próximo deploy da vida?" \
        "Ativar modo hiperfoco." \
        "Escreve aí, eu procuro." \
        "O que o coração de dev pede?" \
        "Até o fim do arquivo..."
end

set index (random 1 (count $phrases))
set frase_escolhida $phrases[$index]

set -x ROFI_PRIVATE_SEARCH false
if contains -- "-p" $argv
    set -x ROFI_PRIVATE_SEARCH true
end

set -l rasi_override "entry { placeholder: \"$frase_escolhida\"; }"

if test "$mode" = web
    rofi -show web \
         -modi "web:$HOME/.config/fish/functions/rofi/rofi-web.fish" \
         -theme $theme_selected \
         -theme-str "$rasi_override element-icon { enabled: false; } element { spacing: 0px; } listview { require-input: false; }"
else if test "$mode" = run
    rofi -show run \
        -modi "run:$HOME/.config/fish/functions/rofi/rofi-run.fish" \
        -theme $theme_selected \
        -theme-str "$rasi_override element-icon { enabled: false; } element { spacing: 0px; } listview { require-input: false; }"
else if test "$mode" = ani-cli
    rofi -show ani-cli \
        -modi "ani-cli:$HOME/.config/fish/functions/rofi/rofi-ani-cli.fish" \
        -theme $theme_selected \
        -theme-str "$rasi_override element-icon { enabled: false; } element { spacing: 0px; } listview { require-input: false; }"
else if test "$mode" = powermenu
    rofi -show powermenu \
        -modi "powermenu:$HOME/.config/fish/functions/rofi/rofi-powermenu.fish" \
        -theme $theme_selected \
        -theme-str "$rasi_override element-icon { enabled: false; } element { spacing: 0px; } listview { require-input: false; }"
else
    rofi -show combi \
         -combi-modi "drun" \
         -theme $theme_selected \
         -combi-hide-mode-prefix \
         -no-custom \
         -theme-str "$rasi_override"
end
