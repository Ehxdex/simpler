class SimplerLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    message = log_message(env, status, headers)
    write_log(message)
    
    [status, headers, body]
  end

  private

  def write_log(message)
    Dir.mkdir('logs') unless File.directory?('logs')
    File.open('logs/app.log', 'a') do |f|
      f.write(message)
    end
  end

  def log_message(env, status, headers)
    "
    Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}
    Handler: #{env['simpler.controller'].class}##{env['simpler.action']}
    Parameters: #{env['simpler.route_params']}
    Response: #{status} #{Rack::Utils::HTTP_STATUS_CODES[status]} [#{headers['Content-Type']}] #{env['simpler.template']}
    "
  end
end
