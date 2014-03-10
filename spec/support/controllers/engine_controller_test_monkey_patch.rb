# writing Rails engine rspec controller tests
# from http://pivotallabs.com/writing-rails-engine-rspec-controller-tests/
module EngineControllerTestMonkeyPatch
  def get(action, parameters = nil, session = nil, flash = nil)
    process_action(action, parameters, session, flash, "GET")
  end

  # Executes a request simulating POST HTTP method and set/volley the response
  def post(action, parameters = nil, session = nil, flash = nil)
    process_action(action, parameters, session, flash, "POST")
  end

  # Executes a request simulating PUT HTTP method and set/volley the response
  def put(action, parameters = nil, session = nil, flash = nil)
    process_action(action, parameters, session, flash, "PUT")
  end

  # Executes a request simulating DELETE HTTP method and set/volley the response
  def delete(action, parameters = nil, session = nil, flash = nil)
    process_action(action, parameters, session, flash, "DELETE")
  end

  private

  def process_action(action, parameters = nil, session = nil, flash = nil, method = "GET")
    default_parameters = { use_route: :comable }

    parameters ||= {}
    parameters = default_parameters.merge(parameters)

    case Rails::VERSION::MAJOR
    when 4
      process(action, method, parameters, session, flash, )
    when 3
      process(action, parameters, session, flash, method)
    end
  end
end
