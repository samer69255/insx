require 'net/http'
require 'net/https'
require 'uri'
require 'json'

def Init
    
    #puts "User Name :"
    #$User = gets.chomp
    $User = makeid(5)
    #puts "Domain :"
    #$Domain = gets.chomp
    $Domain = "#{makeid(5, 1)}.#{makeid(2, 1)}"
    #puts "Password :"
    #$Password = gets.chomp
    $Password = "Samer@88"
    puts "Number Of Accounts :"
    $N = gets.chomp.to_i or 20
    #$fh = File.open("ins_#{$User}.json", "r+")
	$path = "ins_#{$User}.json"
	File.write($path, "{}")
    uri = URI("https://www.instagram.com/accounts/emailsignup/")
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Get.new(uri.path)
    req['upgrade-insecure-requests'] = '1'
    req['user-agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36 Edge/18.17763'
    req['Content-Type'] = 'application/x-www-form-urlencoded'
    res = https.request(req)
    all_cookies = res.get_fields('set-cookie')
    
    cookies_array = Array.new
    all_cookies.each { | cookie |
        cookies_array.push(cookie.split('; ')[0])
    }
    $cookies = cookies_array.join('; ')
    $cookies += '; mcd=3'
    #puts cookies
end

def Create(n)
    #puts $cookies
    headers = getHeaders()
    uri = URI("https://www.instagram.com/accounts/web_create_ajax/")
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, headers)
    req.set_form_data(getData(n))
    req['Cookie'] = $cookies
    res = https.request(req)
    json = JSON.parse(res.body)
    puts "=> #{json["account_created"]}"
    if json["error_type"] == "form_validation_error"
        puts json["errors"]
    elsif json["account_created"] == true
		ck = res.get_fields('set-cookie')
		cookies_array = Array.new
		ck.each { | cookie |
        cookies_array.push(cookie.split('; ')[0])
		}
		cc = cookies_array.join('; ')
		save($email, cc)
    end
end

def getData(n)
    
    user = "#{$User}#{n}"
    $email = "#{user}@#{$Domain}"
    puts $email
    return {
        email:$email,
        password:$Password,
        username:user,
        seamless_login_enabled:	1,
        tos_version: "row",
        opt_into_one_tap:false
    }
    
end
    
def getHeaders
        
        return {
        origin:'https://www.instagram.com',
        referer:"https://www.instagram.com/accounts/emailsignup/",
        "user-agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36 Edge/18.17763",
        accept:"/",
        "content-type":"application/x-www-form-urlencoded",
        'x-requested-with':'XMLHttpRequest',
        'x-csrftoken':$cookies.match(/csrftoken=(.*?);/)[1]
    }
    
   
end

def save(em, cook)
	
	json = File.read($path)
	json = JSON.parse(json)
	json.store(em, cook)
	File.write($path, json.to_json)
	
end

def makeid(size = 6, em = 0)
        if (em == 1) then
		  charset = %w{ a b c e f g h j k l m n o p q r s t u v w x y z}
        else
            charset = %w{ _ a b c e f g h j k l m n o p q r s t u v w x y z}
        end
  	(0...size).map{ charset.to_a[rand(charset.size)] }.join
end

def start
    puts 'Initing ...'
    Init()
	for i in 0..$N
		Create(i)
	end
	#$fh.close()
#puts File.zero?("ins_#{$User}.txt")
	if File.zero?($path) or File.read($path) == "{}"
		File.delete($path)
end

end


start()
