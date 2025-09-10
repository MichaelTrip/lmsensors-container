#!/bin/bash

# SensorDash Configuration Management Script
# This script helps manage node configuration in the ConfigMap

NAMESPACE="sensordash"
CONFIGMAP="sensordash-config"

function show_help() {
    echo "SensorDash Configuration Manager"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  view                    View current node configuration"
    echo "  add <name> <display>    Add a new node"
    echo "  remove <name>           Remove a node"
    echo "  edit                    Edit configuration interactively"
    echo "  backup                  Backup current configuration"
    echo "  restore <file>          Restore configuration from backup"
    echo "  example                 Show example configuration"
    echo ""
}

function view_config() {
    echo "📋 Current Node Configuration:"
    kubectl get configmap $CONFIGMAP -n $NAMESPACE -o jsonpath='{.data.nodes\.json}' | jq .
}

function add_node() {
    local name=$1
    local display=$2

    if [[ -z "$name" ]]; then
        echo "❌ Error: Node name is required"
        echo "Usage: $0 add <name> [display_name]"
        exit 1
    fi

    if [[ -z "$display" ]]; then
        display=$name
    fi

    echo "➕ Adding node: $name ($display)"

    # Get current config
    local current_config=$(kubectl get configmap $CONFIGMAP -n $NAMESPACE -o jsonpath='{.data.nodes\.json}')

    # Add new node using jq
    local new_config=$(echo "$current_config" | jq --arg name "$name" --arg display "$display" '
        .nodes += [{
            "name": $name,
            "displayName": $display,
            "description": "Added via config manager",
            "status": "online"
        }]
    ')

    # Update ConfigMap
    kubectl create configmap $CONFIGMAP --from-literal="nodes.json=$new_config" --dry-run=client -o yaml | kubectl apply -n $NAMESPACE -f -

    echo "✅ Node added successfully!"
}

function remove_node() {
    local name=$1

    if [[ -z "$name" ]]; then
        echo "❌ Error: Node name is required"
        echo "Usage: $0 remove <name>"
        exit 1
    fi

    echo "🗑️  Removing node: $name"

    # Get current config
    local current_config=$(kubectl get configmap $CONFIGMAP -n $NAMESPACE -o jsonpath='{.data.nodes\.json}')

    # Remove node using jq
    local new_config=$(echo "$current_config" | jq --arg name "$name" '
        .nodes = (.nodes | map(select(.name != $name)))
    ')

    # Update ConfigMap
    kubectl create configmap $CONFIGMAP --from-literal="nodes.json=$new_config" --dry-run=client -o yaml | kubectl apply -n $NAMESPACE -f -

    echo "✅ Node removed successfully!"
}

function edit_config() {
    echo "✏️  Opening configuration for editing..."
    kubectl edit configmap $CONFIGMAP -n $NAMESPACE
}

function backup_config() {
    local backup_file="sensordash-config-backup-$(date +%Y%m%d-%H%M%S).json"
    kubectl get configmap $CONFIGMAP -n $NAMESPACE -o jsonpath='{.data.nodes\.json}' > "$backup_file"
    echo "💾 Configuration backed up to: $backup_file"
}

function restore_config() {
    local backup_file=$1

    if [[ -z "$backup_file" ]] || [[ ! -f "$backup_file" ]]; then
        echo "❌ Error: Backup file not found or not specified"
        echo "Usage: $0 restore <backup_file>"
        exit 1
    fi

    echo "🔄 Restoring configuration from: $backup_file"

    local config_content=$(cat "$backup_file")
    kubectl create configmap $CONFIGMAP --from-literal="nodes.json=$config_content" --dry-run=client -o yaml | kubectl apply -n $NAMESPACE -f -

    echo "✅ Configuration restored successfully!"
}

function show_example() {
    cat << 'EOF'
📝 Example Configuration:

{
  "nodes": [
    {
      "name": "virt1",
      "displayName": "Virtual Node 1",
      "description": "Primary virtual machine",
      "status": "online"
    },
    {
      "name": "virt2",
      "displayName": "Virtual Node 2",
      "description": "Secondary virtual machine",
      "status": "online"
    },
    {
      "name": "worker-01",
      "displayName": "Worker Node 01",
      "description": "Production worker node",
      "status": "online"
    }
  ],
  "settings": {
    "refreshInterval": 30000,
    "fallbackNodes": ["node-001", "node-002"],
    "autoDiscovery": true,
    "displayMode": "terminal"
  }
}

🔧 Configuration fields:
- name: Internal node identifier (must match your actual node names)
- displayName: Human-readable name shown in UI
- description: Optional description (shown in tooltips)
- status: Default status (online/warning/offline)

⚙️ Settings:
- refreshInterval: How often to refresh data (milliseconds)
- fallbackNodes: Nodes to show when no data is available
- autoDiscovery: Whether to auto-discover nodes not in config
- displayMode: UI display mode (currently only "terminal")
EOF
}

# Main script logic
case "${1:-}" in
    view)
        view_config
        ;;
    add)
        add_node "$2" "$3"
        ;;
    remove)
        remove_node "$2"
        ;;
    edit)
        edit_config
        ;;
    backup)
        backup_config
        ;;
    restore)
        restore_config "$2"
        ;;
    example)
        show_example
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ Unknown command: ${1:-}"
        echo ""
        show_help
        exit 1
        ;;
esac
