class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets

  def self.empty_params_link(params)
    queries = Application.empty_params(params)
    link = "/applications/new"
    queries.each_with_index do |query, index|
      if index == 0
        link += "?#{query}=true"
      else
        link += "&#{query}=true"
      end
    end
    link
  end

  def self.empty_params(params)
    params.select { |key, value| value ==  ""}.keys
  end

  def self.create_full_address(params)
    "#{params[:street_address]}, #{params[:city]}, #{params[:state]}, #{params[:zip_code]}"
  end


  def self.searched_pet(params)
    pets = Pet.all
    pets.where("name ilike ?", "%#{params[:search]}%")
  end

  def has_pets?
    self.pets.count > 0
    # require 'pry'; binding.pry
  end

  def find_approvals
    pets = self.pets.map { |pet| pet.id }
    approved_pets = pets.reduce([]) do |app_pets, pet|
      app_pets << pet if ApplicationPet.where("pet_id = '#{pet}' and application_id = '#{self.id}' and approved = true") != []
      app_pets
    end
  end
end
