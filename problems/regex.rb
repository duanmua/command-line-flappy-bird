#Could be more efficient using indices
#Of the original stings instead of
#Creating substrings in each call

def matchChar(car, comp)
  return car == comp || comp == '.'
end

def isMatch(str, regex)
  if !str.empty? && regex.empty?
    return false
  elsif str.empty? && regex.empty?
    return true
  end
  
  match = regex[0]
  if regex.length == 1
    if str.length != 1
      return false
    else
      return matchChar(str[0], regex[0])
    end
  elsif regex[1] == '*'
    i = 1
    while str.length > i && matchChar(str[i-1], match)
      if regex.length > 2
        if isMatch(str[i..-1], regex[2..-1])
          return true
        end
      end
      i += 1
    end
    if regex.length == 2 && i == str.length
      return true
    end
    return isMatch(str, regex[2..-1])
  else
    unless matchChar(str[0], match)
      return false
    else
      return isMatch(str[1..-1], regex[1..-1])
    end
  end
end

puts "Enter String to Match to: "
str = gets.chomp
puts "Enter Regex: "
regex = gets.chomp
puts isMatch(str, regex)
