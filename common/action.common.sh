# mkdir ${DESTINATION}/${DOCKER_USER}
# mkdir ${DESTINATION}/${AWS_CREDENTIALS_LOCAL_DIR}
# mkdir ${DESTINATION}/${AWS_SAM_CREDENTIALS_LOCAL_DIR}
# mkdir ${DESTINATION}/${GOOGLE_CREDENTIALS_LOCAL_DIR}

# mkdir -p ${DESTINATION}/${CERTS_LOCAL_DIR}
# yq -iy '.services.[].volumes += ["./'"${CERTS_LOCAL_DIR}"':'"${CERTS_IMAGE_DIR}"':ro"]' "${DESTINATION}/docker-compose.yml"
