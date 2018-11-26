cat << EOF > secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: codiad-secret
type: Opaque
data:
  username: $(echo -n 'admin' | base64)
  password: $(echo -n 'hello' | base64)
EOF
