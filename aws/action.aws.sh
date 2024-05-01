mkdir ${DESTINATION}/${AWS_CREDENTIALS_LOCAL_DIR}

yq -iy '.services.ide.volumes += ["'"${AWS_CREDENTIALS_LOCAL_DIR}"':'"${AWS_CREDENTIALS_IMAGE_DIR}"':ro"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.aws.environment += ["JAVA_HOME='"${JAVA_HOME_IMAGE_DIR}"'"]' "${DESTINATION}/docker-compose.yml"

yq -iy '.services.[].volumes += ["'"${AWS_CREDENTIALS_LOCAL_DIR}"':'"${AWS_CREDENTIALS_IMAGE_DIR}"':ro"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.aws.volumes -= ["'"${AWS_CREDENTIALS_LOCAL_DIR}"':'"${AWS_CREDENTIALS_IMAGE_DIR}"':ro"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.aws.volumes += ["'"${AWS_CREDENTIALS_LOCAL_DIR}"':'"${AWS_CREDENTIALS_IMAGE_DIR}"'"]' "${DESTINATION}/docker-compose.yml"



mkdir ${DESTINATION}/${AWS_SAM_CREDENTIALS_LOCAL_DIR}
yq -iy '.services.ide.volumes += ["'"${AWS_SAM_CREDENTIALS_LOCAL_DIR}"':'"${AWS_SAM_CREDENTIALS_IMAGE_DIR}":ro'"]' "${DESTINATION}/docker-compose.yml"

yq -iy '.services.sam.environment += ["JAVA_HOME='"${JAVA_HOME_IMAGE_DIR}"'"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.[].volumes += ["'"${AWS_SAM_CREDENTIALS_LOCAL_DIR}"':'"${AWS_SAM_CREDENTIALS_IMAGE_DIR}"':ro"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.sam.volumes -= ["'"${AWS_SAM_CREDENTIALS_LOCAL_DIR}"':'"${AWS_SAM_CREDENTIALS_IMAGE_DIR}"':ro"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.sam.volumes += ["'"${AWS_SAM_CREDENTIALS_LOCAL_DIR}"':'"${AWS_SAM_CREDENTIALS_IMAGE_DIR}"'"]' "${DESTINATION}/docker-compose.yml"