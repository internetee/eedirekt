class DnssecKey < ApplicationRecord
  belongs_to :domain

  ALGORITHMS = %w[3 5 6 7 8 10 13 14 15 16].freeze
  PROTOCOLS = %w[3].freeze
  FLAGS = %w[0 256 257].freeze

  validates :flags, :protocol, :algorithm, :public_key, presence: true

  before_save :convert_to_integer

  private

  def convert_to_integer
    self.flags = self.flags.to_i
    self.protocol = self.protocol.to_i
    self.algorithm = self.algorithm.to_i
  end
end
