#!/bin/bash
#
# Autor         : Joao Arquimedes de S. Costa
#
# -----------------------------------------------------------------------
# Este script tem por objetivo coletar e retornar o número de status de
# log do catalina.out.
# -----------------------------------------------------------------------

# Saídas/Retorno para o Nagios
# OK=0
# WARNING=1
# CRITICAL=2
# UNKNOWN=3

MENSAGEM_USO="Uso: $(basename "$0") [OPÇÕES]
   OPTIONS:
    --log          Log catalina.out
    -c             Critical number for error log
    -w             Warning number for error log
    -h, --help     Help
"

LOGPATH=null
LOGSIZE=""
CRITICALVALUE=""
WARNINGVALUE=""

# Verifica se recebeu algum valor
[[ "$1" = "" ]] && { $0 --help; exit 3 ;}
# Verifica se a variável é um número
TestNumber() { [[ "$1" =~ ^[0-9]+$ ]] || { echo "Error: Not a number: $1" >&2; exit 3 ; } ; }
while test -n "$1" 
do
    case "$1" in
        --log)              shift; LOGPATH=$1;;
        -c)                 shift; TestNumber $1; CRITICALVALUE=$1;;
        -w)                 shift; TestNumber $1; WARNINGVALUE=$1;;
        -h | --help)        echo "$MENSAGEM_USO"; exit 0;;
        *)                  echo "$MENSAGEM_USO"; exit 1;;
    esac
    shift
done

# Verifica se o caminho do log foi informado
[[ $LOGPATH = null ]] && { echo "Informe o caminho completo do catalina.out. --help"; exit 3 ;}
# Verifica se o arquivo existe
[[ ! -f $LOGPATH ]] && { echo "Arquivo não localizado: $LOGPATH"; exit 3 ; }

ALERT_CRITICAL=false
ALERT_WARNING=false

GET_ERROR()              { grep " ERROR " $LOGPATH | wc -l ; }
GET_WARNING()            { egrep " (WARN|WARNING) " $LOGPATH | wc -l ; }
GET_INFO()               { grep " INFO " $LOGPATH | wc -l ; }
GET_GRAVE()              { grep "GRAVE\:" $LOGPATH | wc -l ; }
GET_DEPLOYING()          { grep " Deploying web application " $LOGPATH | wc -l ; }
GET_DEPLOYING_ERROR()    { grep " Error deploying " $LOGPATH | wc -l ; }
GET_APP_STARTUP_FAILED() { grep " Application startup failed" $LOGPATH | wc -l; }
GET_SERVER_STARTUP()     { grep " Server startup in " $LOGPATH | wc -l ; }
GET_SERVER_STOP()        { grep "AbstractProtocol.stop" $LOGPATH | uniq | wc -l ; }
GET_SIZE()               { stat --printf="%s" $LOGPATH ; }

# Converter o tamanho do log em Byte, Kilo Byte, Mega Byte ou Giga Byte.
for B in $(GET_SIZE); do
    [ $B -lt 1024 ] && LOGSIZE="${B}byte" && break
    KB=$(((B+512)/1024))
    [ $KB -lt 1024 ] && LOGSIZE="${KB}KB" && break
    MB=$(((KB+512)/1024))
    [ $MB -lt 1024 ] && LOGSIZE="${MB}MB" && break
    GB=$(((MB+512)/1024))
    [ $GB -lt 1024 ] && LOGSIZE="${GB}GB" && break
    LOGSIZE="$(((GB+512)/1024))TB"
done

[[ $CRITICALVALUE != "" ]] && [[ $(GET_ERROR)   -gt $CRITICALVALUE ]] && ALERT_CRITICAL=true
[[ $WARNINGVALUE != "" ]] && [[ $(GET_ERROR)   -gt $WARNINGVALUE ]] && ALERT_WARNING=true

MSG_ERROR="Error: $(GET_ERROR); ";

MSG_PFDATA_[0]="error=$(GET_ERROR);;;${WN};${CN} "
MSG_PFDATA_[1]="warning=$(GET_WARNING);;;; "
MSG_PFDATA_[2]="info=$(GET_INFO);;;; "
MSG_PFDATA_[3]="grave=$(GET_GRAVE);;;; "
MSG_PFDATA_[4]="deploying=$(GET_DEPLOYING);;;; "
MSG_PFDATA_[5]="deploying_error=$(GET_DEPLOYING_ERROR);;;; "
MSG_PFDATA_[6]="app_startup_failed=$(GET_APP_STARTUP_FAILED);;;; "
MSG_PFDATA_[7]="server_startup=$(GET_SERVER_STARTUP);;;; "
MSG_PFDATA_[8]="server_stop=$(GET_SERVER_STOP);;;; "
MSG_PFDATA_[9]="size=$(GET_SIZE);;;;"


Message() { echo "${MSG_ERROR}Size: ${LOGSIZE}" ; }
PerformanceData() {  printf "%s" "${MSG_PFDATA_[@]}" ; }

[ $ALERT_CRITICAL = true ] && { echo "Log Catalina.out Critical: $(Message) | $(PerformanceData)"; exit 2 ; }
[ $ALERT_WARNING = true ] && { echo "Log Catalina.out Warning: $(Message) | $(PerformanceData)"; exit 1 ; }
echo "Log Catalina.out OK: Size: ${LOGSIZE} | $(PerformanceData)" ; exit 0
