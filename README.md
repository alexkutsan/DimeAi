Here's a revised version of the README with improved style and grammar:

---

# DimeAI

"Dime AI" is like a "Tell me, AI", translated from Spanish.

DimeAI is a command-line interface (CLI) tool for interacting with LLM models. It allows users to send prompts and receive responses directly from the terminal.

There are several other similar projects, including:
- [AskGPT by Drew Baumann](https://github.com/drewbaumann/AskGPT)
- [askGPT by Meir M](https://github.com/meirm/askGPT)
- [askgpt by JBGruber](https://github.com/JBGruber/askgpt)
- [chatGPT-shell-cli by 0xacx](https://github.com/0xacx/chatGPT-shell-cli)
- [chatgpt-cli by Kardolus](https://github.com/kardolus/chatgpt-cli)
- [gpt-cli by Kharvd](https://github.com/kharvd/gpt-cli)

Many of these projects are better than this one; they offer more features, better support, and larger communities that provide timely fixes. However, they all have one significant drawback—they are not developed by me. 
This one I feel fomfortable for me, may be will be useful for someone else. 

## Features

- Interact with OpenAI's GPT models from the command line
- Custom pre-prompts in the config file before each user message and at the beginning of the conversation

### Planned Features

While the current feature set meets my needs, I plan to add the following in the future if inspiration or necessity arises:
- [ ] Create a Nix package and publish it in the Nix Store
- [ ] Create a Homebrew package and publish it as a Cask
- [ ] Create a Debian package
- [ ] Store API key in the system keyring
- [ ] Support interactive conversations
- [ ] Save conversation history locally
- [ ] Support multiple profiles with different prompt presets
- [ ] Attach files to prompts
- [ ] Support the Anthropic Claude API
- [ ] Support [LocalAI](https://github.com/mudler/LocalAI) API

## Build from Source

1. Ensure you have Crystal installed on your system.
2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/dimeai.git
   cd dimeai
   ```
3. Build the project:
   ```bash
   shards build --static --release
   ```
   The resulting binary will be located in `./bin/dimeai`.

## Installation

This app is a statically linked binary. 
The easiest way to install it is to download the binary for your architecture from the [GitHub releases page](<github releases>), git execution access to it and place it in `/usr/local/bin`.

## Usage

### (Optional) Initialize the Default Profile

```bash
./dimeai --init
```

This command will create a default profile in `$XDG_CONFIG_HOME/dimeai/profiles/` (or `~/.config/dimeai/profiles/` if `XDG_CONFIG_HOME` is not set).

App works without profile as well, if OPENAI_API_KEY env is set. In that case it will use default settings. 

### Send a Prompt

```bash
./dimeai Your prompt here
```

or

```bash
./dimeai "Prompt & with special? * bash symbols"
```

or 

```bash
echo "Your prompt here" | ./dimeai
```

### Configuration

DimeAI uses configuration profiles stored in JSON format. The default profile is located at `$XDG_CONFIG_HOME/dimeai/profiles/default.json` (or `~/.config/dimeai/profiles/default.json`).

## Environment Variables

- `OPENAI_API_KEY`: Your OpenAI API key. If not set, the program will look for it in the profile configuration.
- `XDG_CONFIG_HOME`: The directory where configuration files are stored. Defaults to `~/.config` if not set.

## Contributing

Contributions are welcome! Feel free to submit a pull request.

---