# Save GDB command history
set history save on
shell mkdir -p ~/.cache/gdb
set history filename ~/.cache/gdb/history

# Setup good pretty printing options
set print pretty on
set print object on
set print vtbl on
set print array on
set print static-members off
set print demangle on
set print asm-demangle on

# Destination goes on the right.
set disassembly-flavor intel

# Show stack traces from Python instead of just an error message
set python print-stack full
