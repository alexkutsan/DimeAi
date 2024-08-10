require "file"
require "json"
require "openai"


module DimeAI
  extend self
  VERSION = "0.1.0"

  struct Profile
    include JSON::Serializable
    struct OpenAIConfig
      include JSON::Serializable
      getter api_key : String
      getter model : String
      def initialize(@api_key : String, @model : String)
      end
    end
    struct PromtTweaks
      include JSON::Serializable
      getter global_pre_prompts : Array(NamedTuple(role: String, content: String))
      getter each_user_message_prefix : String
      def initialize(@global_pre_prompts : Array(NamedTuple(role: String, content: String)), 
                     @each_user_message_prefix : String,
                     @each_user_message_postfix : String)
      end
      
    end
    getter openai : OpenAIConfig
    getter prompt_tweeks : PromtTweaks
    def initialize(@openai : OpenAIConfig, @prompt_tweeks : PromtTweaks)
    end
  end

  def default_profile : Profile
    Profile.new(
      openai: Profile::OpenAIConfig.new(
        api_key: ENV["OPENAI_API_KEY"]?.try(&.to_s) || "",
        model: "gpt-3.5-turbo"
      ),
      prompt_tweeks: Profile::PromtTweaks.new(
        global_pre_prompts: [{role: "system", content: "You are helpful AI programming assistant"}],
        each_user_message_prefix: "respond with the same language as the user",
        each_user_message_postfix: "Do not respond with a full code listing, just the relevant parts",
      )
    )
  end
  
  def get_profile(profile_name) : Profile
    config_dir = ENV.fetch("XDG_CONFIG_HOME") { "#{ENV["HOME"]}/.config" }
    dimeai_profiles_dir = Path.new("#{config_dir}/dimeai/profiles")
    profile_file = "#{dimeai_profiles_dir}/#{profile_name}.json"
    unless File.exists?(profile_file)
      STDERR.puts "Profile #{profile_name} not found in #{dimeai_profiles_dir}"
      return default_profile
    end
    json_str = File.read(profile_file)
    Profile.from_json(json_str)
  end

  def create_profile(profile_name, openai_key)
    config_dir = ENV.fetch("XDG_CONFIG_HOME") { "#{ENV["HOME"]}/.config" }
    dimeai_profiles_dir = Path.new("#{config_dir}/dimeai/profiles")
    Dir.mkdir_p(dimeai_profiles_dir) unless Dir.exists?(dimeai_profiles_dir)
    profile_file = "#{dimeai_profiles_dir}/#{profile_name}.json"
    if File.exists?(profile_file)
      puts "Profile #{profile_name} already exists in #{dimeai_profiles_dir}. Delete it to reinit"
      exit
    end
    profile = default_profile
    json_str = JSON.build do |json|
      json.indent = 2
      profile.to_json(json)
    end
    File.write(profile_file, json_str)
    puts "Profile #{profile_name} created in #{profile_file}"
  end

  def send_request(openai, 
                   prompt : String, 
                   model : String,
                   history : Array(NamedTuple(role: String, content: String)), 
                   &block : String ->)
    history << { role: "user", content: prompt }
    openai.chat(model, history, { "stream" => true }) do |chunk|
      if content = chunk.choices.first.delta.content
        block.call(content.to_s)
        history << { role: "assistant", content: content }
      end
    end
    history
  end

end
