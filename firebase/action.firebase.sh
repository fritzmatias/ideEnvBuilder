mkdir -p ${DESTINATION}/${FIREBASE_CERTS_LOCAL_DIR}
mkdir -p "${DESTINATION}/${FIREBASE_LOCAL_DIR}"

yq -iy '.services.ide.environment += ["FIRESTORE_EMULATOR_HOST='"${SERVICE_NAME}:8082"'"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.ide.environment += ["DATASTORE_EMULATOR_HOST='"${SERVICE_NAME}:8082"'"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.ide.depends_on+= ["'"${SERVICE_NAME}"'"]' "${DESTINATION}/docker-compose.yml"


yq -iy '.services.'"${SERVICE_NAME}"' += {"working_dir":"'"${FIREBASE_IMAGE_DIR}"'"}' "${DESTINATION}/docker-compose.yml" #default value
yq -iy '.services.'"${SERVICE_NAME}"'.environment += ["FIREBASE_PROJECT_ID="]' "${DESTINATION}/docker-compose.yml" #required
yq -iy '.services.'"${SERVICE_NAME}"'.environment += ["GOOGLE_APPLICATION_CREDENTIALS='"${CERTS_IMAGE_DIR}"'/serviceAccountKey.json"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.'"${SERVICE_NAME}"'.environment += ["FIREBASE_IMAGE_DIR='"${FIREBASE_IMAGE_DIR}"'"]' "${DESTINATION}/docker-compose.yml" #default value
yq -iy '.services.'"${SERVICE_NAME}"'.volumes += ["'"${FIREBASE_CERTS_LOCAL_DIR}"':'"${FIREBASE_CERTS_IMAGE_DIR}"':ro"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.'"${SERVICE_NAME}"'.volumes += ["'"${FIREBASE_LOCAL_DIR}"':'"${FIREBASE_IMAGE_DIR}"':ro"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.'"${RUNNER_NAME}"'.volumes += ["'"${FIREBASE_LOCAL_DIR}"'/firebase.json:'"${FIREBASE_IMAGE_DIR}"'/firebase.json:ro"]' "${DESTINATION}/docker-compose.yml"
# yq -iy '.services.'"${SERVICE_NAME}"'.volumes -= ["'"${FIREBASE_LOCAL_DIR}"':'"${FIREBASE_IMAGE_DIR}":ro'"]' "${DESTINATION}/docker-compose.yml"
# yq -iy '.services.'"${SERVICE_NAME}"'.volumes += ["'"${FIREBASE_LOCAL_DIR}"':'"${FIREBASE_IMAGE_DIR}"'"]' "${DESTINATION}/docker-compose.yml" #default value


yq -iy '.services.'"${RUNNER_NAME}"' += {"working_dir":"'"${FIREBASE_IMAGE_DIR}"'"}' "${DESTINATION}/docker-compose.yml" #default value
yq -iy '.services.'"${RUNNER_NAME}"'.environment += ["FIREBASE_PROJECT_ID="]' "${DESTINATION}/docker-compose.yml" #required
yq -iy '.services.'"${RUNNER_NAME}"'.environment += ["GOOGLE_APPLICATION_CREDENTIALS='"${FIREBASE_CERTS_IMAGE_DIR}"'/serviceAccountKey.json"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.'"${RUNNER_NAME}"'.environment += ["FIREBASE_IMAGE_DIR='"${FIREBASE_IMAGE_DIR}"'"]' "${DESTINATION}/docker-compose.yml" #default value
yq -iy '.services.'"${RUNNER_NAME}"'.volumes += ["'"${FIREBASE_CERTS_LOCAL_DIR}"':'"${FIREBASE_CERTS_IMAGE_DIR}"':ro"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.'"${RUNNER_NAME}"'.volumes += ["'"${FIREBASE_LOCAL_DIR}"':'"${FIREBASE_IMAGE_DIR}"':ro"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.'"${RUNNER_NAME}"'.volumes += ["'"${FIREBASE_LOCAL_DIR}"'/firebase.json:'"${FIREBASE_IMAGE_DIR}"'/firebase.json:ro"]' "${DESTINATION}/docker-compose.yml"
# yq -iy '.services.'"${SERVICE_NAME}"'.volumes -= ["'"${FIREBASE_LOCAL_DIR}"':'"${FIREBASE_IMAGE_DIR}":ro'"]' "${DESTINATION}/docker-compose.yml"
# yq -iy '.services.'"${SERVICE_NAME}"'.volumes += ["'"${FIREBASE_LOCAL_DIR}"':'"${FIREBASE_IMAGE_DIR}"'"]' "${DESTINATION}/docker-compose.yml" #default value


sed -ie 's/\(\-[ ]\+FIREBASE_PROJECT_ID=.*\)/\1    #required /g' "${DESTINATION}/docker-compose.yml"
sed -ie 's/\(\-[ ]\+FIREBASE_IMAGE_DIR=.*\)/# \1    #default value/g' "${DESTINATION}/docker-compose.yml"
sed -ie 's/\(\-[ ]\+GOOGLE_APPLICATION_CREDENTIALS=.*\)/# \1    #recomended /g' "${DESTINATION}/docker-compose.yml"
sed -ie 's/\([ ]\+working_dir:.*\)/# \1    #default value/g' "${DESTINATION}/docker-compose.yml"
sed -ie 's/\(\-[ ]\+'"$(echo ${FIREBASE_LOCAL_DIR}|sed -e 's/\//\\\//g')"':.*$\)/# \1    #default value/g' "${DESTINATION}/docker-compose.yml"
sed -ie 's/\(\-[ ]\+'"$(echo ${FIREBASE_LOCAL_DIR}/firebase.json|sed -e 's/\//\\\//g')"':.*$\)/# \1    #to modify firebase.json file/g' "${DESTINATION}/docker-compose.yml"
# sed -ie 's/\(\-[ ]\+'"$(echo ${FIREBASE_CERTS_LOCAL_DIR}|sed -e 's/\//\\\//g')"':.*$\)/# \1    #default value/g' "${DESTINATION}/docker-compose.yml"
