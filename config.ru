require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

use Rack::Cache,
  verbose: true,
  metastore: "memcached://#{ENV['MEMCACHE_SERVERS']}/meta",
  entitystore: "memcached://#{ENV['MEMCACHE_SERVERS']}/body"

use Rack::ResponseHeaders do |headers|
  headers['Cache-Control'] = "public, max-age=3600"
end

use Rack::ConditionalGet
use Rack::ETag

require 'nesta/env'
Nesta::Env.root = ::File.expand_path('.', ::File.dirname(__FILE__))

use Rack::Rewrite do
  r301 %r{/developer/djangodash/?}, '/django-dash'
  r301 %r{/developer/vanpyz-from-future/?}, '/vanpyz'
  r301 %r{/developer/(.*)}, '/$1'
end

require 'nesta/app'

Nesta::App.configure :production do
  require 'newrelic_rpm'
end

run Nesta::App
