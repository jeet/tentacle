class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :logged_in?, :current_user, :admin?, :controller_path, :hosted_url, :hosted_url_for
  
  session(Tentacle.session_options) unless Tentacle.domain.blank?

  Tentacle::Application.constants.each do |sub|
    $stderr.puts "Including #{sub}"
    include "Tentacle::Application::#{sub}".constantize
  end
  
  around_filter :set_context
  
  expiring_attr_reader :current_user,       :retrieve_current_user
  expiring_attr_reader :admin?,             :retrieve_admin

  def logged_in?
    !!current_user
  end
  
  def admin?
    logged_in? && current_user.admin?
  end
  
  protected
    # specifies a controller action that only tentacle administrators are allowed
    def admin_required
      admin? || access_denied_message("You must be an administrator to visit this page.")
    end

    def login_required
      logged_in? || access_denied_message("You must be logged to access this page.")
    end

    # handles non-html responses in DEV mode when there are exceptions
    def rescue_action_locally(exception)
      if api_format?
        render :text => "Error: #{exception.message}", :status => :internal_server_error
      else
        super
      end
    end

    # handles non-html responses in PRODUCTION mode when there are exceptions
    def rescue_action_in_public(exception)
      if api_format?
        render :text => "An error has occurred with Tentacle.  Check your #{RAILS_ENV} logs.", :status => :internal_server_error
      else
        super
      end
    end

    # Renders simple page w/ the error message.
    def status_message(type, message = nil, template = nil)
      @message = message || "A login is required to visit this page."
      if api_format?
        render :text => @message, :status => :internal_server_error
      else
        render :template => (template || "shared/#{type}")
      end
      false
    end

    # Same as #status_message but sends the 401 basic auth headers
    def access_denied_message(message)
      if api_format?
        headers["WWW-Authenticate"] = %(Basic realm="Web Password")
        render :text => "Couldn't authenticate you.", :status => :unauthorized
      else
        status_message(:error, message)
      end
    end

    def node_directory_path
      return nil if @node.nil?
      @node.dir? ? @node.path : File.dirname(@node.path)
    end
        
    def current_user=(value)
      session[:user_id] = value ? value.id : nil
      @current_user     = value
    end
    
    def retrieve_current_user
      @current_user || 
        authenticate_with_http_basic { |u, p| User.find_by_token(u) } ||
        (cookies[:login_token] && User.find_by_id_and_token(*cookies[:login_token].split(";"))) || 
        (session[:user_id] && User.find_by_id(session[:user_id]))
    end
    
    def installed?
      !Tentacle.domain.blank? && Repository.count > 0
    end
    
    def install
      reset_session
      redirect_to installer_path
    end

    def hosted_url(*args)
      repository, name = extract_repository_and_args(args)
      if repository.nil?
        send("#{name}_path", *args)
      else
        "http%s://%s%s%s" % [
          ('s' if request.ssl?),
          (repository ? repository.domain : Tentacle.domain),
          (':' + request.port.to_s unless request.port == request.standard_port),
          send("#{name}_path", *args)
          ]
        end
    end
    
    def hosted_url_for(repository, *args)
      args.unshift repository unless repository.is_a?(Repository) || repository.nil?
      url_for(*args)
    end
    
    def extract_repository_and_args(args)
      if args.first.is_a?(Symbol)
        [nil, args.shift]
      else
        [args.shift, args.shift]
      end
    end

    # stores cache fragments that have already been read by
    # #cached_in?
    def current_cache
      @cache ||= {}
    end
    
    # checks if the given name has been cached.  If so,
    # read into #current_cache
    def cached_in?(name, options = nil)
      name && current_cache[name] ||= read_fragment(name, options)
    end

    def set_context
      ActiveRecord::Base.with_context do
        yield
      end
    end
    
    def api_format?
      request.format.atom? || request.format.xml?
    end
end
