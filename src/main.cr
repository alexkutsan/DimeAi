require "./dimeai"
require "option_parser"

def main
    fall_interactive = false
    profile_name = "default"
    OptionParser.parse do |parser|
      parser.banner = "Usage: dimeai [arguments|prompt]"
      parser.on("--init", "Init default profile config in $XDG_CONFIG/dimeai") do
        if open_api_key = ENV["OPENAI_API_KEY"]?
          puts "Got API key from env OPENAI_API_KEY"
        else
          puts "env OPENAI_API_KEY is not set."
          print "Please provide OpenAI API key: "
          open_api_key = STDIN.gets.try(&.chomp)
          if open_api_key.try(&.empty?) || open_api_key.nil?
            puts "No API key provided"
            exit
          end
        end
        DimeAI.create_profile("default", open_api_key)
        exit
      end
      parser.on("-h", "--help", "Show this help") do
        puts parser
        exit
      end
    end
    profile = DimeAI.get_profile(profile_name)
    if ARGV.empty?
      puts "Reading prompt from stdin"
      unless prompt = STDIN.gets.try(&.chomp)
        puts "No prompt provided"
        exit
      end
    else
      prompt = ARGV.join(" ")
    end
    
    unless open_api_key = ENV["OPENAI_API_KEY"]?
      unless open_api_key = profile.try &.openai.try &.api_key
        puts "Please set OPENAI_API_KEY env variable or add it to profile"
        exit
      end
    end
    history = profile.prompt_tweeks.global_pre_prompts
    open_ai_client = OpenAI::Client.new(access_token: open_api_key)
    open_ai_client.on_error do |error|
      raise Exception.new("OpenAI error: #{error[:message]}")
    end
    begin
      history = DimeAI.send_request(open_ai_client, 
                                    prompt,
                                    profile.openai.try &.model || "gpt-3.5-turbo",
                                    history) do |response_chunk|
        print response_chunk
      end
    rescue ex : Exception
      STDERR.puts "Error: #{ex.message}"
    end
  end

  main