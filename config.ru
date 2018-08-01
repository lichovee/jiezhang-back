## --- Start of unicorn worker killer code ---
require 'unicorn/worker_killer'

max_request_min =  1024*100
max_request_max =  1024*200
# Max requests per worker
use Unicorn::WorkerKiller::MaxRequests, max_request_min, max_request_max, false

oom_min = (1024**3)
oom_max = (1024+256) * (1024**2)
# Max memory size (RSS) per worker
use Unicorn::WorkerKiller::Oom, oom_min, oom_max, 16, false
## --- End of unicorn worker killer code ---


# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

run Rails.application
