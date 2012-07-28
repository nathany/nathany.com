require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

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
run Nesta::App
