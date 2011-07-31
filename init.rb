require 'redmine'
require 'change_callback_order'

Redmine::Plugin.register :redmine_change_callback_order do
  name 'Redmine Change Callback Order plugin'
  author 'Masamitsu MURASE'
  description 'This plugin changes the order of callback function.'
  version '0.0.1'
  url ''
  author_url 'http://example.com/about'
end
