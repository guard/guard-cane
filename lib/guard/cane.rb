require 'guard'
require 'guard/guard'

module Guard
  # Defines the guard, which is automatically seen by Guard
  class Cane < Guard
    DEFAULTS = {
      run_all_on_start: true
    }

    SUCCESS = ["Passed", { title: "Cane", image: :success }]
    FAILED = ["Failed", { title: "Cane", image: :failed }]

    attr_reader :last_result, :options

    def initialize(watchers = [], options = {})
      super

      @options = DEFAULTS.merge(options)
    end

    def start
      UI.info "Guard::Cane is running"

      run_all if options[:run_all_on_start]
    end

    def run_all
      cane
    end

    def run_on_modifications(paths)
      cane paths
    end

    def cane(paths = [])
      command = build_command(paths)

      UI.info "Running Cane: #{command}"

      result = system command

      if result
        Notifier.notify(*SUCCESS) if last_result == false
      else
        Notifier.notify(*FAILED)
      end

      @last_result = result

      result
    end

    def build_command(paths)
      command = []

      command << (options[:command] || "cane")

      if paths.any?
        joined_paths = paths.join(',')
        command << "--all '{#{joined_paths}}'"
      end

      command << options[:cli]

      command.compact.join(" ")
    end
  end
end
