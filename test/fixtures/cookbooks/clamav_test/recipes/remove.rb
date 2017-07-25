# encoding: utf-8
# frozen_string_literal: true

include_recipe '::default'

clamav 'default' do
  action :remove
end
