yq -iy '.services.ide.depends_on+= ["'"${SERVICE_NAME}"'"]' "${DESTINATION}/docker-compose.yml"
