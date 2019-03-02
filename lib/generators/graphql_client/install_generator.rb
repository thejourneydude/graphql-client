# frozen_string_literal: true

require 'rails/generators/base'

module GraphqlClient
  class InstallGenerator < Rails::Generators::Base
    desc "Install GraphQL::Client boilerplate code"
    source_root File.expand_path('../templates', __FILE__)

    class_option :schema,
      type: :string,
      default: nil,
      desc: "Name for the schema constant (default: {app_name}Schema)"

    def install
      template("initializer.erb", "config/initializers/graphql_client.rb")

      inject_into_file 'app/controllers/application_controller.rb', after: "class ApplicationController < ActionController::Base\n" do <<-'RUBY'
  def graphql_context
    # Add your context here
    {}
  end
RUBY
    end

    private

    def schema_name
      @schema_name ||= begin
        if options[:schema]
          options[:schema]
        else
          require File.expand_path("config/application", destination_root)
          "#{Rails.application.class.parent_name}Schema"
        end
      end
    end
  end
end
