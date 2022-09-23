existing_arns=$(aws backup list-recovery-points-by-backup-vault --backup-vault-name "$1" --region "$2" --query 'RecoveryPoints[].RecoveryPointArn' --output text)
existing_arns_amount=$(echo $existing_arns | wc -w)

for arn in $existing_arns; do 
  echo "deleting ${arn} ..."
  aws backup delete-recovery-point --backup-vault-name "$1" --region "$2" --recovery-point-arn "${arn}"
done

while [[ $existing_arns_amount -gt 0 ]] ; 
  do
  sleep 3
  existing_arns_amount=$(aws backup list-recovery-points-by-backup-vault --backup-vault-name "$1" --region "$2" --query 'RecoveryPoints[].RecoveryPointArn' --output text | wc -w)
done