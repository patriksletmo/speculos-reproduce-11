# Reproducing example for issue #11
Example app used to demonstrate [issue #11](https://github.com/LedgerHQ/speculos/issues/11) in LedgerHQ/speculos.

## Testing
1. Build the application using the Nano S SDK for firmware 1.6.0
2. Launch the built application in speculos
3. Run `./test.sh`

The test script will send two messages to the device.
1. One message with length 5
2. One message with length 25

The lack of APDU message concatenation in the speculos emulator will cause the
end of the second message to not arrive at the receiving end. The device will
in turn reply with a non-OK status code.

Testing on a real device does not trigger the bug, because the received APDU
message chunks are concatenated before they are presented in `G_io_apdu_buffer`.
This can be tested by running `./test.sh device`.

### Expected output
#### Emulator
```
Testing against emulator...

OK example
=> b'e001000019aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
<= b''9000
<= Clear bytearray(b'')

Broken example
=> b'e0010000b0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
<= b''6a78
Traceback (most recent call last):
  File "/usr/lib/python3.7/runpy.py", line 193, in _run_module_as_main
    "__main__", mod_spec)
  File "/usr/lib/python3.7/runpy.py", line 85, in _run_code
    exec(code, run_globals)
  File "/home/patrik/Code/.venv/lib/python3.7/site-packages/ledgerblue/runScript.py", line 95, in <module>
    result = dongle.exchange(bytearray(data))
  File "/home/patrik/Code/.venv/lib/python3.7/site-packages/ledgerblue/commTCP.py", line 48, in exchange
    raise CommException("Invalid status %04x" % sw, sw)
ledgerblue.commException.CommException: Exception : Invalid status 6a78
```

#### Nano S
```
Testing against device...

OK example
HID => e001000019aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
HID <= 9000
<= Clear bytearray(b'')

Broken example
HID => e0010000b0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
HID <= 9000
<= Clear bytearray(b'')
```
