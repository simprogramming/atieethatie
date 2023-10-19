return if ENV["NOCOV"] == "true"
return unless ENV["RAILS_ENV"] == "development"

require "simplecov-console"

SimpleCov.start "rails" do
  add_filter %w[vendor
                app/controllers/application_controller.rb
                # app/policies/application_policy.rb
                # app/decorators/application_decorator.rb
                app/jobs/application_job.rb
                app/helpers/application_helper.rb]

  add_filter do |source_file|
    source_file.lines.count < 5
  end

  add_group "Services", "app/services"

  SimpleCov.minimum_coverage line: 100
  minimum_coverage_by_file 100
  SimpleCov.maximum_coverage_drop 1

  SimpleCov::Formatter::Console.max_rows = 20

  formatters = [SimpleCov::Formatter::Console]

  formatters << SimpleCov::Formatter::HTMLFormatter unless ENV.fetch("COV_WITHOUT_HTML", "false") == "true"

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(formatters)
end
