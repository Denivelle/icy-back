# frozen_string_literal: true

AdminUser.destroy_all
User.destroy_all

AdminUser.create!(email: 'admin@example.com', password: 'password') if Rails.env.development?
