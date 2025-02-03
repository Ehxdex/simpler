module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = split_path(path)
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && compare_paths(split_path(path))
      end

      def params(path)
        add_params(split_path(path))
      end

      private

      def compare_paths(request_path)
        return false unless request_path.size == @path.size

        @path.each_index do |index|
          if @path[index] != request_path[index]
            return false unless @path[index].start_with?(':')
          end
        end
      end

      def add_params(request_path)
        params = {}

        @path.each_with_index do |e, i|
          if e.start_with?(':')
            id = e[1..-1].to_sym
            params[id] = request_path[i] 
          end
        end
        params
      end

      def split_path(path)
        path.split('/')
      end
    end
  end
end
