worker_processes Integer(ENV['UNICORN_WORKERS'] || 4)
 
# Load your app into the master before forking
# workers for super-fast worker spawn times
preload_app true
 
# Immediately restart any workers that haven't responded
# Heroku will hangup after 30 seconds
# https://devcenter.heroku.com/articles/rails-unicorn#timeouts
timeout Integer(ENV['UNICORN_TIMEOUT'] || 15)
 
before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end
end
 
after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end
 
  # Dalli does not need anything special in Unicorn/Passenger since 2.0.4. 
end

# If you are running unicorn on multiple machines, lowering this number can help
# your load balancer detect when a machine is overloaded and give requests to a
# different machine. (default 1024)
# http://unicorn.bogomips.org/Unicorn/Configurator.html#method-i-listen
# http://manpages.ubuntu.com/manpages/gutsy/man2/listen.2.html (max 128)
listen ENV['PORT'], :backlog => Integer(ENV['UNICORN_BACKLOG'] || 128)

