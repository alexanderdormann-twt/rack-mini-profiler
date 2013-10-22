if (defined?(Net) && defined?(Net::HTTP))

  Net::HTTP.class_eval do
    def request_with_mini_profiler(*args, &block)
      request = args[0]
      desc = "Net::HTTP #{request.method} #{request.path}"
      #Rack::MiniProfiler.step(desc) do
        start = Time.now
        result = request_without_mini_profiler(*args, &block)
        elapsed_time = ((Time.now - start).to_f * 1000).round(1)
        ::Rack::MiniProfiler.record_sql(desc, elapsed_time)
      
        result
      #end
    end
    alias request_without_mini_profiler request
    alias request request_with_mini_profiler
  end

end
