class Hash
  def method_missing(method, *opts)
    m = method.to_s
    if self.has_key?(m)
      return self[m]
    elsif self.has_key?(m.to_sym)
      return self[m.to_sym]
    end
    super
  end
end


def load_config(file_path, overrides=[])

  lines = File.readlines(file_path).map { |line| line.strip  }
  override_param = overrides.last.to_s

  section=""
  config = {}
  lines = lines.each do |line|
    next if line.start_with?(';') || line.empty?
    if line.start_with?('[')
      section = line[1..-2]
      config[section]={}
      next
    end

    conf_line = line.split('=').map{|str| str.strip }
    return nil if check_on_errors(conf_line)

    add_value_to_config(config,conf_line,section,override_param)
  end

  config
end

def add_value_to_config(config,conf_line,section,override_param)
  opt_name = conf_line[0]
  idx1 = opt_name.index('<')
  idx2 = opt_name.index('>')
  if idx1.nil? && idx2.nil?
    key = "#{opt_name}"
  else
    if override_param == opt_name[idx1+1..idx2-1]
      key= "#{opt_name[0..idx1-1]}"
    end
  end
  config[section][key] = extract_conf_value(conf_line[1]) unless key.nil?
end

def check_on_errors(line)
  err1 =  line.size!=2
  err2 =  !line[0].index(';').nil?
  err1||err2
end

def extract_conf_value(line)
  idx = line.index(';')
  idx = -1 if  idx.nil?
  line = line[0..idx]
  line = line.split(',')
  line= line[0] if line.size==1
  line
end

p conf = load_config("data.conf",[:staging])
p conf.ftp.path
