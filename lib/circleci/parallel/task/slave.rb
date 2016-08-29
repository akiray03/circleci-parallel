require 'circleci/parallel/task/base'

module CircleCI
  module Parallel
    module Task
      class Slave < Base
        def run
          create_node_data_dir
          configuration.before_join_hook.call(node.data_dir)
          mark_as_joining
          wait_for_master_node_to_download
          configuration.after_join_hook.call(node.data_dir)
        end

        private

        def wait_for_master_node_to_download
          # TODO: Consider implementing timeout mechanism
          Parallel.puts('Waiting for master node to download data...')
          Kernel.sleep(1) until downloaded?
        end

        def downloaded?
          File.exist?(DOWNLOAD_MARKER_FILE)
        end
      end
    end
  end
end