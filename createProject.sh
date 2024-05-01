usage(){
cat <<EOF
  -h --help                                           usage 
  create  <destination> <env_file> <service1 service2 ...>       docker-compose configs
  list                                                shows potential configuration
  merge   <destination> <env_file> <service1 service2 ...>       docker-compose configs
EOF
}
downloadImages(){
  [ -d "docker-images" ] && git submodule update --remote docker-images
}
listServices(){
  find . -name 'docker-compose.*.yml' | sed -e 's/\.\/docker-compose.//g;s/.yml//g'
}
postCreateActions(){
local destination=$1; shift
local envfile=$1; shift
local common_env="./common/common.env"
local services="common $@"

echo postcreateActions dest:${destination} serv:${services} envfile:${envfile}
[ "${destination}"x = x ] && echo "Destination dir not set" && return 1
[ "${envfile}"x = x ] && echo "Env file not set" && return 1
[ "${services}"x = x ] && echo "Services not set" && return 1
[ -d "${destination}" ] || return 3

  for service in ${services}; do
    local service_env="./${service}/${service}.env"
    local action=${destination}/postcreate.${service}.yml
    file="${service}/action.${service}.sh"
    echo "action exec ${service} from file $file"
    if [ -f "${file}" ] ; then
    ( . ./docker-images/run.sh env "${envfile} ${common_env} ${service_env}" >/dev/null || true \
      && export DESTINATION=${destination} \
      && envsubst <"$file">>"${action}" \
      && echo '
      '>>"${action}" \
      && . ${action} \
      && rm ${action} \
        )
    else
      echo "Error: $file for $service, not found"
      return 1
    fi
  done;

}
create(){
local destination=$1; shift
local envfile=$1; shift
local services="common $@"
local common_env="./common/common.env"
local dockerfile=${destination}/docker-compose.yml

echo create dest:${destination} serv:${services} envfile:${envfile}
[ "${destination}"x = x ] && echo "Destination dir not set" && return 1
[ "${envfile}"x = x ] && echo "Env file not set" && return 1
[ "${services}"x = x ] && echo "Services not set" && return 1

  for service in ${services}; do
    local service_env="./${service}/${service}.env"
    local file="${service}/docker-compose.${service}.yml"
    echo "adding ${service} from file $file"
    if [ -f "${file}" ] ; then
      if grep -e 'image:[ ]\+'${service}'[ ]*$' "${dockerfile}" >/dev/null 2>&1; then
        echo "[Warn] service: $service exist on ${dockerfile}"
      else 
        if grep 'version:' "${dockerfile}">/dev/null 2>&1 ; then
          (. ./docker-images/run.sh env "${envfile} ${common_env} ${service_env}">/dev/null || true && envsubst <"$file"|grep -v 'version:'|grep -v 'services:'>>"${dockerfile}")
        else
          (. ./docker-images/run.sh env "${envfile} ${common_env} ${service_env}">/dev/null || true && envsubst <"$file">>"${dockerfile}")
        fi
      fi
    else
      echo "Error: $file for $service, not found"
      return 1
    fi
  done
}
createProject(){
  downloadImages \
  && create $@ \
  && postCreateActions $@
}

mergeProject(){
  echo merge
}

act="$1"; shift;
case "${act}" in
  create)
    destination="$1";shift
    [ -d "${destination}" ] || mkdir -p ${destination}
    createProject "${destination}" $@
  ;;
  merge)
    destination="$1";shift
    [ -f "${destination}" ] || echo "Error dest $destination"
    mergeProject "${destination}" $@
  ;;
  list)
    listServices
  ;;
  -h|--help|*)
    usage
  ;;
esac
