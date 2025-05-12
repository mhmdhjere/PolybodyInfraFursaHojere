#!/bin/bash

# Usage:
#   ./bastion_connect.sh <BASTION_IP>                             → connect to bastion
#   ./bastion_connect.sh <BASTION_IP> <PRIVATE_IP>                → SSH to private instance via bastion
#   ./bastion_connect.sh <BASTION_IP> <PRIVATE_IP> <COMMAND...>   → run command on private via bastion

if [ -z "$KEY_PATH" ]; then
  echo "❌ Error: You must export KEY_PATH to your bastion .pem file"
  echo "Example: export KEY_PATH=~/bastion.pem"
  exit 5
fi

if [ "$#" -eq 1 ]; then
  # Case: connect to bastion only
  BASTION_IP="$1"
  ssh -i "$KEY_PATH" -tt ubuntu@"$BASTION_IP"

elif [ "$#" -eq 2 ]; then
  # Case: SSH to private instance
  BASTION_IP="$1"
  PRIVATE_IP="$2"
  ssh -i "$KEY_PATH" -tt ubuntu@"$BASTION_IP" "ssh -i ~/hojere.pem ubuntu@$PRIVATE_IP"

elif [ "$#" -ge 3 ]; then
  # Case: Run command on private instance
  BASTION_IP="$1"
  PRIVATE_IP="$2"
  shift 2
  CMD="$*"
  ssh -i "$KEY_PATH" -tt ubuntu@"$BASTION_IP" "ssh -i ~/hojere.pem ubuntu@$PRIVATE_IP \"$CMD\""

else
  echo "Usage:"
  echo "  $0 <BASTION_IP>"
  echo "  $0 <BASTION_IP> <PRIVATE_IP>"
  echo "  $0 <BASTION_IP> <PRIVATE_IP> <COMMAND...>"
  exit 1
fi
