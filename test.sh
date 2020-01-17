#!/usr/bin/env bash

GOOD_EXAMPLE=`python3 -c "print('e001000019' + 'AA' * 25)"`
BAD_EXAMPLE=`python3 -c "print('e0010000B0' + 'AA' * 176)"`

if [[ "$1" == "device" ]]; then
  echo "Testing against device..."
  echo
else
  echo "Testing against emulator..."
  echo
  export LEDGER_PROXY_ADDRESS=127.0.0.1
  export LEDGER_PROXY_PORT=9999
fi

echo "OK example"
echo $GOOD_EXAMPLE | \
python3 -m ledgerblue.runScript --apdu

echo
echo "Broken example"
echo $BAD_EXAMPLE | \
python3 -m ledgerblue.runScript --apdu
