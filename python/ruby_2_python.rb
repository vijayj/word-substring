#Ruby to python converter
#Author: olamide bakre

RB_FILE = ARGV[0] || "ruby_sample.txt"  #Filename of ruby script
OUT_PUT = "ruby_sample_python.txt" #Filename of python script
NOT_INCLUDE = %w[initialize class if while do]

@ruby_script = IO.readlines(RB_FILE)
@out_script = []
@tabCount = 1
for _text_ in @ruby_script
	split_text = _text_.split(" ")
	text = split_text.join(" ")
	text.gsub!("false","False")
	text.gsub!("true","True")
	text.gsub!("@","self.")
	text.gsub!("nil","None")
	text.gsub!("\n","")
	if(text.strip().slice(0,1) == "#")
		@out_script << sprintf("%s%s","\t"*@tabCount,text)
		next 
	end
	if(text.slice(0,5) == "class") then
		@tabCount = 1
		if(text.include?("<")) then
			split_text = text.split("<")
			str = sprintf("%s(%s):",split_text[0],split_text[1])
			@out_script << str
		else
			@out_script << sprintf("%s(object):",text)
		end
	elsif(text.include?("initialize") && !text.include?("alias") && 
			!text.include?("_initialize")) then
		if(text.include?("(")) then
			text.slice!("initialize")
			text.slice!("("); text.slice!(")")
			if(text.include?(",")) then
				text.slice!("def")
				text.strip!()
				split_text = text.split(",")
				split_text.unshift("self")
				params = split_text.join(",")
				str = sprintf("%sdef __init__(%s):","\t"*@tabCount,params)
				@out_script << str
				@tabCount += 1
			else
				text.slice!("def")
				text.strip!()
				split_text = text.split(" ")
				split_text.unshift("self")
				params = split_text.join(",")
				str = sprintf("%sdef __init__(%s):","\t"*@tabCount,params)
				@out_script << str
				@tabCount += 1				
			end
		else
			@out_script << sprintf("%sdef __init__(self):","\t"*@tabCount)
			@tabCount += 1
		end
	elsif(text.slice(0,3) == "def" && !text.include?("initialize")) then
		@tabCount = 1
		if(text.include?("(")) then
			text.slice!(")")
			if(text.include?(",")) then
				text.slice!("def")
				text.strip!()
				text.gsub!("(",",")
				split_text = text.split(",")
				method_name = split_text[0]
				split_text.shift()
				split_text.unshift("self")
				params = split_text.join(",")
				str = sprintf("%sdef %s(%s):","\t"*@tabCount,method_name,
				params)
				@out_script << str
				@tabCount += 1
			else
				text.slice!("def")
				text.gsub!("("," ")
				text.strip!()
				split_text = text.split(" ")
				method_name = split_text[0]
				split_text.shift()
				split_text.unshift("self")
				params = split_text.join(",")
				str = sprintf("%sdef %s(%s):","\t"*@tabCount,method_name,
				params)
				@out_script << str
				@tabCount += 1
			end
		else
			split_text = text.split(" ")
			method_name = split_text[-1]
			method_name.strip!()
			@out_script << sprintf("%sdef %s(self):","\t"*@tabCount,method_name)
			@tabCount += 1
		end
	elsif(text.slice(0,2) == "if" || text.slice(0,5) == "while"  || 
			text.slice(0,4) == "else" || 
			text.slice(0,5) == "elsif" || 
			text.slice(text.size-2,text.size) == "do" ||
			text.slice(0,3) == "for" ||
			text.slice(0,4) == "case") then
		text.gsub!("then","")
		@tabCount -= 1 if(text.include?("else") ||  text.include?("elsif"))
		text.gsub!("elsif","elif")
		split_text = text.split(" ")
		str = split_text.join(" ")
		str += ":"
		str_text = sprintf("%s%s","\t"*@tabCount,str)
		@out_script << str_text
		@tabCount += 1
	elsif(text.include?("end"))
		if(text.size > 3)
			str = sprintf("%s%s","\t"*@tabCount,str)
			@out_script << str
			next
		end
		text.gsub!("end","")
		@tabCount -= 1 if @tabCount > 1
		@out_script << "\n"
	else
		split_text = text.split(" ")
		str = split_text.join(" ")
		@out_script << sprintf("%s%s","\t"*@tabCount,str)
	end
end
@file_io = File.new(OUT_PUT, "w")
for text in @out_script
	@file_io.write(text + (text.include?("\n") ? "" : "\n"))
end
@file_io.close()
