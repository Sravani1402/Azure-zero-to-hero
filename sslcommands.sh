To convert your SSL certificate (.crt) and private key (.key) files into a Personal Information Exchange (PFX) file, you can use OpenSSL, a widely-used open-source toolkit for SSL/TLS.
Step :1
openssl pkcs12 -export -out certificate.pfx -inkey privateKey.key -in certificate.crt
Step 2:
# Extract certificate and private key from PFX file
openssl pkcs12 -in dpro.ai.pfx -out intermediate.pem -nodes
 
# Separate certificate and private key (if needed)
openssl rsa -in intermediate.pem -out privatekey.pem
 
# Extract certificate chain (if applicable)
openssl crl2pkcs7 -nocrl -certfile intermediate.pem | openssl pkcs7 -print_certs -out certificate_chain.pem
 
# Clean up intermediate files (optional)
rm intermediate.pem
 
 
kubectl create secret tls keycloak-tls-cert  --cert=certificate_chain.pem --key=privatekey.pem  -n prod-keycloak




step 1: 
openssl pkcs12 -out exinhealth_cert.pfx -inkey 1_exinhealth.key -in ./sslCert-_exinhealth_com.crt 






$token = [System.Text.Encoding]::UTF8.GetBytes($env:SonarToken + ":")
$base64 = [System.Convert]::ToBase64String($token)
 
$basicAuth = [string]::Format("Basic {0}", $base64)
$headers = @{ Authorization = $basicAuth }
 
$result = Invoke-RestMethod -Method Get -Uri http://alegrisource.westeurope.cloudapp.azure.com/api/qualitygates/project_status?projectKey=alegri-cockpit20 -Headers $headers
$result | ConvertTo-Json | Write-Host
 
if ($result.projectStatus.status -eq "OK") {
Write-Host "Quality Gate Succeeded"
}else{
throw "Quality gate failed"
}