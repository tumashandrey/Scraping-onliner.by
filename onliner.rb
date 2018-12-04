require 'curb'
require 'nokogiri'
require 'json'


class Scraping

	attr_accessor :uri

	def initialize(uri="https://catalog.api.onliner.by/search/mobile?group=1")

		@uri = uri
		@curl = Curl::Easy.new
		@products = Array.new

	end

	def run


		json = download_page(@uri)
		parsing_page(json)
		print_products

	end

	def download_page(url)

		@curl.url = url
		@curl.perform
		JSON.parse(@curl.body_str)

	end

	def parsing_page(json)

		json['products'].map do |product_block| 

			product = Hash.new

			product[:type] = product_block['name_prefix']
			product[:name] = product_block['name']
			product[:img] = product_block['images']['header']
			product[:description] = product_block['description']

			@products << product

		end
		
	end

	def print_products

		@products.each do |product|

			puts "Type: #{product[:type]}"
			puts "Name: #{product[:name]}"
			puts "Img: #{product[:img]}"
			puts "Description: #{product[:description]}"
			puts "-" * 80

		end
	end

end

Scraping.new.run