class Rmethod < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :label, :code
  belongs_to :rclass
end
