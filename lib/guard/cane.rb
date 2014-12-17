require 'guard/compat/plugin'

module Guard
  # Defines the guard, which is automatically seen by Guard
  class Cane < Plugin
    DEFAULTS = {
      run_all_on_start: true
    }

    SUCCESS = ["Passed", { title: "Cane", image: :success }]
    FAILED = ["Failed", { title: "Cane", image: :failed }]

    attr_reader :last_result, :options

    def initialize(options = {})
      super options

      @options = DEFAULTS.merge(options)
    end

    def start
      Compat::UI.info "Guard::Cane is running"

      run_all if options[:run_all_on_start]
    end

    def run_all
      cane
    end

    def run_on_modifications(paths)
      passed = cane paths
      run_all if options[:all_after_pass] && passed
    end

    def cane(paths = [])
      command = build_command(paths)

      Compat::UI.info "Running Cane: #{command}"

      result = system command

      if result
        Compat::UI.notify(*SUCCESS) if last_result == false
      else
        Compat::UI.notify(*FAILED)
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
