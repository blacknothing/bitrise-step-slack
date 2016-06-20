#
#  message.rb
#
#  Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
#

module SlackStep

  class Message

    def initialize(env)
      @env = env
    end

    def fallback
      "Build #{build_verb}: ##{env.build_number} (#{env.git_commit} by #{env.git_author} on #{env.git_branch})"
    end

    def title
      "*Build #{build_verb}: [##{env.build_number}](#{env.build_url}) (#{env.git_commit} by #{env.git_author} on #{env.git_branch})*"
    end

    def border_color
      @env.build_successful? ? "good" : "danger"
    end

    def fields
      [
        field_commit,
        field_jira,
        field_scheme,
      ].compact
    end

    private

    attr_reader :env

    def build_verb
      env.build_successful? ? "succeeded" : "failed"
    end

    def field_commit
      {
        title: "Commit",
        value: env.git_message,
        short: false,
      }
    end

    def field_jira
      env.jira_task.nil? ? nil : {
        title: "Task",
        value: "[#{env.jira_task}](https://#{env.jira_domain}.atlassian.net/browse/#{env.jira_task})",
        short: true,
      }
    end

    def field_scheme
      env.install_page.nil? ? nil : {
        title: "Install",
        value: "[#{app_title} #{env.major_version_number}.0.#{env.build_number}](#{env.install_page})",
        short: true,
      }
    end

  end

end
