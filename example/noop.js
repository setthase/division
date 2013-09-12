process.stdin.resume();

process.on("uncaughtException", function (error) {
  if (error.toString() !== 'Error: IPC channel is already disconnected') {
    process.stderr.write(error.stack);
    process.exit(1);
  }
})
