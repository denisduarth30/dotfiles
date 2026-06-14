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
    "Abre algo incrível."

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

if test "$mode" = web
    rofi -show web \
         -combi-modi "drun,web:$HOME/.config/fish/functions/rofi-search.fish" \
         -theme $theme_tmp \
         -theme-str 'element-icon { enabled: false; } element { spacing: 0px; }'
else
    rofi -show combi \
         -combi-modi "drun,web:$HOME/.config/fish/functions/rofi-search.fish" \
         -theme $theme_tmp \
         -combi-hide-mode-prefix \
         -no-custom
end
