function env_to_xcconfig() {
  if [ -f "$1" ]; then
    echo "Reading .env from $1" >&2
    while IFS='=' read -r key value || [[ -n "$key" ]]; do
      case "$key" in
        \#*) ;;
        *)
          if [[ ! -z "$key" ]]; then
            value=$(echo "${value}" | sed -e 's/^["]//' -e 's/["]$//')
            echo "$key=$value"
          fi
          ;;
      esac
    done < "$1"
  fi
}

ENV_FILE=".env"
XCCONFIG_FILE="ios/Flutter/Generated.xcconfig"
> "$XCCONFIG_FILE"
echo "Writing env variables to ${XCCONFIG_FILE}" >&2
env_to_xcconfig "$ENV_FILE" >> "$XCCONFIG_FILE"