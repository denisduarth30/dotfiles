#!/usr/bin/fish

sleep 0.05

set -l window_id (xdotool getactivewindow 2>/dev/null)
set -l app_name ""

if test -n "$window_id"
    set -l xprop_output (xprop -id $window_id WM_CLASS 2>/dev/null)
    set app_name (echo $xprop_output | string match -ra '"([^"]+)"' | tail -n 1 | string lower)
end

if test -z "$app_name"
    set app_name "desktop"
end

set -l dark_theme "$HOME/.config/rofi/themes/dark-theme.rasi"
set -l light_theme "$HOME/.config/rofi/themes/light-theme.rasi"

if string match -qr "firefox|chrome|brave|code|spotify|zed|zed-editor|dev.zed.zed|alacritty" "$app_name"
    set theme_selected $dark_theme
else
    set theme_selected $light_theme
end

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
    "O que precisa rodar?" \
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
    "O que o terminal manda?" \
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
    "Qual atalho você ainda não decorou?" \
    "Abre o editor ou abre o YouTube?" \
    "Hoje tem deploy?" \
    "O que você devia estar fazendo?" \
    "Só mais um comando..." \
    "Qual dependência quebrou agora?" \
    "npm install de novo?" \
    "Tem algo no clipboard?" \
    "O que o log tá dizendo?" \
    "Procrastinar ou entregar?" \
    "Qual config você vai tunar hoje?" \
    "Mais um dotfile pra ajustar?" \
    "Stow funcionou dessa vez?" \
    "Qual plugin novo você vai instalar?" \
    "O tema tá perfeito ou quase?" \
    "Tem fonte nova pra testar?" \
    "Qual terminal você vai abrir dentro do terminal?" \
    "Fish ou bash, a eterna questão." \
    "Alias novo hoje?" \
    "Qual função você devia ter escrito antes?" \
    "O que o man page diz?" \
    "Grep ou ripgrep?" \
    "Tem script quebrado esperando?" \
    "O que o cron vai rodar hoje?" \
    "Systemctl status de quê?" \
    "Qual processo tá comendo RAM?" \
    "htop ou btop?" \
    "Tem atualização disponível?" \
    "Qual pacote você não usa mas não remove?" \
    "O que o journalctl esconde?" \
    "Mais um workaround ou solução de verdade?" \
    "Qual TODO virou DONE hoje?" \
    "Tem issue aberta com seu nome?" \
    "O README tá atualizado?" \
    "Qual branch você esqueceu de deletar?" \
    "git stash show diz o quê?" \
    "Tem conflito de merge esperando?" \
    "Qual variável de ambiente sumiu?" \
    "O .env tá completo?" \
    "Qual porta tá em uso?" \
    "Container subiu ou caiu?" \
    "O que o Docker Compose reclama hoje?" \
    "Tem volume pra limpar?" \
    "Qual imagem tá desatualizada?" \
    "O que você vai automatizar hoje?" \
    "Mais um script de shell?" \
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
    "A resposta tá no Google ou no Stack?" \
    "Digite sua query existencial..." \
    "Google, DDG ou o de sempre?" \
    "Pesquisar na gringa ou em PT?" \
    "O que a internet sabe sobre isso?" \
    "Rofi está pronto para a busca." \
    "Qual segredo a web esconde hoje?" \
    "Digitando... procurando... achando?" \
    "De volta à matrix da web..." \
    "O que você quer decifrar agora?" \
    "Procurando soluções rápidas..." \
    "Menos reuniões, mais código. O que abre?" \
    "Aquela pesquisa de 5 segundos que vira 2 horas..." \
    "O que o mestre do código deseja?" \
    "Navegando na maré do Fish..." \
    "Procurar erro de sintaxe ou erro de lógica?" \
    "Pronto para lançar o buscador." \
    "O que você quer automatizar agora?" \
    "Foco total ou modo aleatório?" \
    "Mais uma pesquisa pro histórico..." \
    "O que você quer encontrar primeiro?" \
    "Abre o terminal ou abre o navegador?" \
    "Qual o seu termo de busca da vez?" \
    "Procurando aquela documentação esquecida..." \
    "Cadê o link que sumiu?" \
    "O que o DuckDuckGo diria sobre isso?" \
    "Buscando pacotes no repositório..." \
    "Qual pacote AUR você quer instalar agora?" \
    "O que o Arch Wiki diz?" \
    "Configurando o sistema ou quebrando ele?" \
    "Reiniciar o i3/Sway ou continuar codando?" \
    "Qual workspace vamos usar?" \
    "Mais um alias pro config.fish?" \
    "Abre os dotfiles ou o projeto principal?" \
    "O que está drenando sua bateria?" \
    "Qual script vai salvar sua pele hoje?" \
    "O terminal é seu Canvas. Digite." \
    "Buscando threads no Reddit..." \
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
    "Qual processo dar um kill -9?" \
    "O gerenciador de janelas tá respondendo?" \
    "Qual script do Rofi você quer rodar?" \
    "O layout do teclado mudou sozinho?" \
    "Onde está salvo aquele screenshot?" \
    "Qual pasta do /home/ tá uma bagunça?" \
    "Limpar o /tmp/ hoje ou deixar pra lá?" \
    "Qual o tamanho da pasta node_modules?" \
    "Abre o gerenciador de arquivos ou faz no CLI?" \
    "Qual comando você copiou do StackOverflow?" \
    "O script rodou de primeira ou deu ruim?" \
    "Falta permissão de root?" \
    "O que o chmod +x vai resolver hoje?" \
    "Qual utilitário CLI você descobriu ontem?" \
    "O que o fzf não encontrou?" \
    "Qual histórico do Fish vamos revirar?" \
    "Digite e deixe o Rofi fazer a mágica." \
    "O que você vai criar do zero hoje?" \
    "Qual o escopo do projeto de agora?" \
    "Pronto para resolver o mistério?" \
    "Abre a mente e digite." \
    "Qual o destino final desse comando?" \
    "Sua área de trabalho precisa de quê?" \
    "Buscando insights na rede..." \
    "A internet tá rápida o suficiente hoje?" \
    "O que você precisa descobrir em 5 minutos?" \
    "Qual o comando supremo de agora?" \
    "Feche os olhos e digite (ou não)." \
    "O Rofi está ao seu dispor." \
    "O que o shell Fish vai pescar hoje?" \
    "A jornada começa com um comando." \
    "Qual o atalho para a felicidade?" \
    "Digite seu destino..." \
    "O sistema aguarda seu input." \
    "Qual a última linha que você escreveu?" \
    "Pronto para o próximo deploy da vida?" \
    "Ativar modo hiperfoco." \
    "Escreve aí, eu procuro." \
    "Sua barra de pesquisa personalizada." \
    "O que o coração de dev pede?" \
    "E lá vamos nós para o terminal..." \
    "Até o fim do arquivo..."

set index (random 1 (count $phrases))
set theme_tmp /tmp/rofi-theme-tmp.rasi

sed "s/placeholder: \".*\"/placeholder: \"$phrases[$index]\"/" $theme_selected > $theme_tmp

set -x ROFI_PRIVATE_SEARCH false
if contains -- "-p" $argv
    set -x ROFI_PRIVATE_SEARCH true
end

set -l mode combi
if contains -- "web" $argv
    set mode web
end

if contains -- "run" $argv
    set mode run
end

if test "$mode" = web
    rofi -show web \
         -combi-modi "web:$HOME/.config/fish/functions/rofi-search.fish" \
         -theme $theme_tmp \
         -theme-str 'element-icon { enabled: false; } element { spacing: 0px; }'
else if test "$mode" = run
    rofi -show run \
        -modi "run:$HOME/.config/fish/functions/rofi-run.fish" \
        -theme $theme_tmp \
        -theme-str 'element-icon { enabled: false; } element { spacing: 0px; }'
else
    rofi -show combi \
         -combi-modi "drun" \
         -theme $theme_tmp \
         -combi-hide-mode-prefix \
         -no-custom
end
