module AdapterInterface
  def create_domain(payload:)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

