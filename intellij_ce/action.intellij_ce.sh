mkdir -p ${DESTINATION}/${SOURCE_CODE_LOCAL_DIR} #idea
mkdir -p ${DESTINATION}/${JDKS_LOCAL_DIR} #idea downloaded jdks versions
mkdir -p ${DESTINATION}/${CODE_EXTENSIONS_LOCAL_DIR} # vscode extensions folder


yq -iy '.services.'"${SERVICE_NAME}"'.volumes += ["'"${SOURCE_CODE_LOCAL_DIR}"':'"${SOURCE_CODE_IMAGE_DIR}"'"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.'"${SERVICE_NAME}"'.volumes += ["'"${JDKS_LOCAL_DIR}"':'"${JDKS_IMAGE_DIR}"'"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.'"${SERVICE_NAME}"'.volumes += ["'"${CODE_EXTENSIONS_LOCAL_DIR}"':'"${CODE_EXTENSIONS_IMAGE_DIR}"'"]' "${DESTINATION}/docker-compose.yml"