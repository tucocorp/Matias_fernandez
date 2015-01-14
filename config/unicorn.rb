APP_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__)))

worker_processes 1
working_directory APP_ROOT

timeout 30

listen APP_ROOT + "/tmp/octopull.sock", backlog: 64

pid APP_ROOT + "/tmp/octopull.pid"

stderr_path APP_ROOT + "/log/octopull.stderr.log"
stdout_path APP_ROOT + "/log/octopull.stdout.log"
