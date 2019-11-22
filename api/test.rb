require "active_record"

class PgLocks < ActiveRecord::Base
end

while PgLocks.where(locktype: 'advisory').count > 0
  puts "Waiting for locks to be lifted"
end

