## 新しく作られたファイルのパーミッションがつねに 644 になるようにする。基本。
umask 022

## core ファイルを作らせないようにする。これも基本。
ulimit -c 0

## 環境変数の設定

# man とかを見るときはいつも less を使う。
export PAGER=less
# less のステータス行にファイル名と行数、いま何%かを表示するようにする。
export LESS='-X -i -P ?f%f:(stdin).  ?lb%lb?L/%L..  [?eEOF:?pb%pb\%..]'

# これを設定しないと日本語がでない less もあるので一応入れておく。
export JLESSCHARSET=japanese-ujis

# rsync では ssh を使う。
export RSYNC_RSH=ssh

# 対話的モードなら環境変数 PS1 (プロンプト文字列) が設定されている
# はずなので、それを調べる。
if [[ "$PS1" ]]; then

  # この中は対話的モードだ。

  # ログインしたときには環境変数 MAIL が設定されているが、
  # メールは別の方法で確認するので消しておく。
  unset MAIL

  # bashオプション設定

  # EOF (Ctrl-D) 入力は 10回まで許可。
  IGNOREEOF=10
  HISTSIZE=50000
  HISTFILESIZE=50000

  shopt -s histappend
  # "!"をつかって履歴上のコマンドを実行するとき、
  # 実行するまえに必ず展開結果を確認できるようにする。
  shopt -s histverify
  # 履歴の置換に失敗したときやり直せるようにする。
  shopt -s histreedit
  # 端末の画面サイズを自動認識。
  shopt -s checkwinsize
  # "@" のあとにホスト名を補完させない。
  shopt -u hostcomplete
  # つねにパス名のテーブルをチェックする。
  shopt -s checkhash
  # なにも入力してないときはコマンド名を補完しない。
  # (メチャクチャ候補が多いので。)
  shopt -s no_empty_cmd_completion

  # i: 直前の履歴 30件を表示する。引数がある場合は過去 1000件を検索する。
  # (history で履歴全部を表示させると多すぎるので)
  function i {
      if [ "$1" ]; then history 1000 | grep "$@"; else history 30; fi
  }
  # I: 直前の履歴 30件を表示する。引数がある場合は過去のすべてを検索する。
  function I {
      if [ "$1" ]; then history | grep "$@"; else history 30; fi
  }

  # GNU screen 用のコマンド。引数を screen のステータス行に表示。
  function dispstatus { 
      if [[ "$STY" ]]; then echo -en "\033k$1\033\134"; fi 
  }

  # 端末・プロンプトの設定

  # ホスト名とユーザ名の先頭 2文字をとりだす。全部だと長いので。
  h2=`expr $HOSTNAME : '\(..\).*'`
  u2=`expr $USERNAME : '\(..\).*'`
  # 現在のホストによってプロンプトの色を変える。
  case "$HOSTNAME" in
  apple*) col=31;;  # 赤
  mango*) col=36;;  # 水色
  grape*) col=32;;  # 緑
  giko*)  col=33;;  # 黄
  *) col=1;; # それ以外のホストでは強調表示
  esac
  if [[ "$EMACS" ]]; then
    # emacs の shell モードでは制御文字を使わない簡単なプロンプト
    stty -echo nl
    PS1="$u2@$h2\w\$ "
  else
    # プロンプトの設定
    if [[ "$SHELLTYPE" = session ]]; then
      # ある端末では短いプロンプトにする。
      PS1='$h2$ ';
      unset SHELLTYPE
    else
      PS1="$u2@$h2\[\e[${col}m\]\w[\!]\$\[\e[m\] "
    fi
    # 通常のプロンプト PS1 に加えて PS0 という変数を設定する。
    # (これは bash は何も関知しない、あとで述べる px というコマンドが使う)
    # 通常のプロンプトでは現在のカレントディレクトリのフルパス名を
    # 表示するようになっているが、これが長すぎるときに PS1 と PS0 を
    # 一時的に切り換えて使う。
    PS0="$u2@$h2:\[\e[${col}m\]\W[\!]\$\[\e[m\] "

    # 端末の設定
    stty dec crt erase ^H eof ^D quit ^\\ start ^- stop ^-
  fi

  # いろんな関数

  # つねに直前のコマンドの終了状態をチェックさせる。
  # もし異常終了した場合は、その状態(数値)を表示する。
  function showexit {
    local s=$?
    dispstatus "${PWD/\/home\/yusuke/~}"
    if [[ $s -eq 0 ]]; then return; fi
    echo "exit $s"
  }
  PROMPT_COMMAND=showexit

  # px: 長いプロンプトと短いプロンプトを切り換える。
  function px {
      local tmp=$PS1; PS1=$PS0; PS0=$tmp; 
  }

  # h: csh における which と同じ。
  function h { command -v $1; }

  # wi: whatis の略。指定されたコマンドの実体を表示。
  function wi {
    case `type -t "$1"` in
     alias|function) type "$1";;
     file) L `command -v "$1"`;;
     function) type "$1";;
    esac
  }

  if [ -f ~/.bashrc_local ]; then
      . ~/.bashrc_local
  fi

fi

