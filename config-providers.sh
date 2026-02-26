#!/data/data/com.termux/files/usr/bin/bash
# Quick provider configuration

echo "🛡️ Configure API Providers"
echo "=========================="

config_file="$HOME/.openclaw/config.json"

# Function to update config
update_config() {
    local provider=$1
    local key=$2
    
    if command -v jq >/dev/null; then
        # Use jq if available
        jq --arg provider "$provider" --arg key "$key" \
           '.providers[$provider].apiKey = $key | .providers[$provider].enabled = true' \
           "$config_file" > tmp.json && mv tmp.json "$config_file"
    else
        # Fallback: use sed (basic)
        sed -i "s/\"$provider\": {/\"$provider\": {\n      \"apiKey\": \"$key\",/" "$config_file"
        sed -i "s/\"$provider\": {\n      \"enabled\": false/\"$provider\": {\n      \"enabled\": true/" "$config_file"
    fi
}

# Menu
echo ""
echo "Select provider:"
echo "1) Claude (Anthropic) - Best for coding"
echo "2) OpenAI - Fast and capable"
echo "3) Google Gemini - Long context"
echo "4) Check current config"
echo "5) Set default provider"
echo ""
read -p "Choice (1-5): " choice

case $choice in
    1)
        read -sp "Enter Claude API key: " key
        echo ""
        update_config "anthropic" "$key"
        echo "✅ Claude configured!"
        ;;
    2)
        read -sp "Enter OpenAI API key: " key
        echo ""
        update_config "openai" "$key"
        echo "✅ OpenAI configured!"
        ;;
    3)
        read -sp "Enter Gemini API key: " key
        echo ""
        update_config "google" "$key"
        echo "✅ Gemini configured!"
        ;;
    4)
        cat "$config_file" | head -40
        ;;
    5)
        echo "Select default:"
        echo "1) Claude"
        echo "2) OpenAI"
        echo "3) Gemini"
        echo "4) Ollama (Local)"
        read -p "Choice: " default_choice
        case $default_choice in
            1) openclaw config set defaultProvider anthropic ;;
            2) openclaw config set defaultProvider openai ;;
            3) openclaw config set defaultProvider google ;;
            4) openclaw config set defaultProvider ollama ;;
        esac
        echo "✅ Default provider set!"
        ;;
esac
