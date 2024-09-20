## swaync

I can add custom actions to swaync's button grid (it is on the bottom). I can trigger shell scripts and include toogle commands (to switch something on and off). Example:

``` json

/* config.json */

{
    ...
    "buttons-grid": {
      "actions": [
        {
          "label": "󰂯",
          "command": "blueman-manager"
        },
        {
          "label": "直",
          "type": "toggle",
          "active": true,
          "command": "sh -c '[[ $SWAYNC_TOGGLE_STATE == true ]] && nmcli radio wifi on || nmcli radio wifi off'",
          "update_command": "sh -c '[[ $(nmcli radio wifi) == \"enabled\" ]] && echo true || echo false'"
        }
      ]
    }
}

```

