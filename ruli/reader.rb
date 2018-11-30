# frozen_string_literals: true

class Reader
  TOKEN_REGEX = /[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"|;.*|[^\s\[\]{}('"`,;)]*)/

  def self.read_str(arg)
    tokens = tokenize(arg)
    r = new(tokens)
    read_form(r)
  end

  def self.tokenize(arg)
    arg.to_s.scan(TOKEN_REGEX).flatten
  end

  def self.read_form(reader)
    case reader.peek
    when nil then raise StandardError.new("EOF reached too soon")
    when "(" then reader.next; read_list(reader)
    else read_atom(reader)
    end
  end

  def self.read_list(reader)
    list = []
    while reader.peek != ")" do
      raise StandardError.new("incomplete list") if reader.peek.nil?
      list << read_form(reader)
    end
    reader.next
    list.compact
  end

  def self.read_atom(reader)
    tk = reader.next
    case tk
    when "+", "-", "/", "*", "**", '""' then tk.to_sym
    when "true", "false" then tk.to_sym
    when /[a-zA-Z]/ then tk
    when /[0-9]/ then tk.to_i
    end
  end

  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def next
    tk = @tokens[@position]
    return nil if tk.nil?
    @position += 1
    tk
  end

  def peek
    @tokens[@position]
  end
end
