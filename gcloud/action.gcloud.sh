mkdir ${DESTINATION}/${GOOGLE_CREDENTIALS_LOCAL_DIR}
# yq -iy '.volumes += [{"./'${GOOGLE_CREDENTIALS_LOCAL_DIR}'":""}]' "${DESTINATION}/docker-compose.yml"
# yq -iy '.services.ide.volumes += ["./'"${GOOGLE_CREDENTIALS_LOCAL_DIR}"':'"${GOOGLE_CREDENTIALS_IMAGE_DIR}":ro'"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.gcloud.environment += ["CLOUDSDK_CONFIG='"${GOOGLE_CREDENTIALS_IMAGE_DIR}"'"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.gcloud.volumes += ["'${GOOGLE_CREDENTIALS_LOCAL_DIR}':'"${GOOGLE_CREDENTIALS_IMAGE_DIR}"':ro"]' "${DESTINATION}/docker-compose.yml"
yq -iy '.services.gcloud.volumes += ["'${GCLOUD_LOCAL_DIR}':'"${GCLOUD_IMAGE_DIR}"':ro"]' "${DESTINATION}/docker-compose.yml"

sed -ie 's/\(\-[ ]\+'"$(echo ${GCLOUD_LOCAL_DIR}|sed -e 's/\//\\\//g')"':.*$\)/# \1    #default value/g' "${DESTINATION}/docker-compose.yml"
