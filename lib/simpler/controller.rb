require_relative 'view'
require 'rack'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_headers(:html)
      # render plain: "Plain text"
      status 200
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_headers(header)
      header == :html ? @response['Content-Type'] = 'text/html' : @response['Content-Type'] = 'text/plain'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      if @request.env['simpler.plain_text']
        @response['Content-Type'] = 'text/plain'
        @request.env['simpler.plain_text']
      else
        View.new(@request.env).render(binding)
      end
    end

    def params
      @request.params.merge(@request.env['simpler.route_params'])
    end

    def render(template = nil, plain: nil)
      if plain
        @request.env['simpler.plain_text'] = plain
      else 
        @request.env['simpler.template'] = template
      end
    end

    def status(code)
      @response.status = code
    end
  end
end
