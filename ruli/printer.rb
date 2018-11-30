# frozen_string_literals: true

class Printer
  def self.pr_str(tokens)
    return tokens.to_s unless tokens.is_a?(Array)
    tks = tokens.map do |t|
      next "#{pr_str(t)}" if t.is_a?(Array)
      t.to_s
    end.join(" ")
    "(#{tks})"
  end
end
