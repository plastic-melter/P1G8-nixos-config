const hyprland = await Service.import("hyprland");
const mpris = await Service.import("mpris");
const audio = await Service.import("audio");
const battery = await Service.import("battery");
const network = await Service.import("network");

// Helper functions
function getCpuUsage() {
  return Utils.exec("bash -c \"top -bn1 | grep 'Cpu' | awk '{print int($2)}'\"");
}

function getMemoryUsage() {
  return Utils.exec("bash -c \"free | grep Mem | awk '{printf \\\"%d\\\", $3/$2 * 100}'\"");
}

function getDiskUsage() {
  return Utils.exec("bash /etc/nixos/dotfiles/scripts/diskuse.sh");
}

function getTemp() {
  return Utils.exec("bash /etc/nixos/dotfiles/scripts/cooling.sh");
}

function getPower() {
  return Utils.exec("bash /etc/nixos/dotfiles/scripts/watts.sh");
}

function getP1G8Mode() {
  return Utils.exec("bash /etc/nixos/dotfiles/scripts/p1g8power.sh");
}

// Time & Date section
const TimeDate = () => Widget.Box({
  class_name: "section time-section",
  vertical: true,
  children: [
    Widget.Label({
      class_name: "time-big",
      label: Utils.derive([Utils.interval(1000)], () => 
        new Date().toLocaleTimeString('en-US', { hour12: false })
      ).as(v => v),
    }),
    Widget.Label({
      class_name: "date-small",
      label: Utils.derive([Utils.interval(10000)], () =>
        new Date().toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' })
      ).as(v => v),
    }),
  ],
});

// Launcher
const Launcher = () => Widget.Box({
  class_name: "section launcher-section",
  hpack: "center",
  children: [
    Widget.Button({
      class_name: "launcher-btn",
      on_clicked: () => Utils.exec("nwg-menu -va top"),
      child: Widget.Label(""),
    }),
  ],
});

// Workspaces
const Workspaces = () => Widget.Box({
  class_name: "section workspaces-section",
  hpack: "center",
  children: Array.from({ length: 5 }, (_, i) => i + 1).map(i => Widget.Button({
    class_name: hyprland.active.workspace.bind("id").as(id => 
      `workspace-btn${id === i ? " active" : ""}`
    ),
    on_clicked: () => hyprland.messageAsync(`dispatch workspace ${i}`),
    child: Widget.Label(`${i}`),
  })),
});

// Media Player
const Player = () => Widget.Box({
  class_name: "section player-section",
  vertical: true,
  visible: mpris.bind("players").as(p => p.length > 0),
  children: [
    Widget.Box({
      class_name: "stat-row",
      children: [
        Widget.Label({
          class_name: "icon player-icon",
          label: mpris.bind("players").as(p => {
            const player = p[0];
            return player?.play_back_status === "Playing" ? "󰐌" : "󰏥";
          }),
        }),
        Widget.Label({
          class_name: "label player-label",
          hexpand: true,
          truncate: "end",
          max_width_chars: 30,
          label: mpris.bind("players").as(p => {
            const player = p[0];
            return player ? `${player.track_artists[0]} - ${player.track_title}` : "No media";
          }),
        }),
      ],
    }),
    Widget.Box({
      class_name: "player-controls",
      hpack: "center",
      children: [
        Widget.Button({
          class_name: "player-btn",
          on_clicked: () => mpris.getPlayer("")?.previous(),
          child: Widget.Label(""),
        }),
        Widget.Button({
          class_name: "player-btn play-pause",
          on_clicked: () => mpris.getPlayer("")?.playPause(),
          child: Widget.Label({
            label: mpris.bind("players").as(p => {
              const player = p[0];
              return player?.play_back_status === "Playing" ? "" : "";
            }),
          }),
        }),
        Widget.Button({
          class_name: "player-btn",
          on_clicked: () => mpris.getPlayer("")?.next(),
          child: Widget.Label(""),
        }),
      ],
    }),
  ],
});

// System stats with progress bars
const SystemStat = (icon, label, getValue, interval = 2000) => {
  const value = Variable(0);
  Utils.interval(interval, () => {
    value.value = parseInt(getValue());
  });

  return Widget.Box({
    class_name: "stat-row",
    children: [
      Widget.Label({ class_name: "icon", label: icon }),
      Widget.Box({
        vertical: true,
        hexpand: true,
        children: [
          Widget.Box({
            children: [
              Widget.Label({ 
                class_name: "label", 
                hpack: "start",
                label: label 
              }),
              Widget.Label({
                class_name: "value",
                hpack: "end",
                hexpand: true,
                label: value.bind().as(v => `${v}%`),
              }),
            ],
          }),
          Widget.ProgressBar({
            class_name: "progress-bar",
            value: value.bind().as(v => v / 100),
          }),
        ],
      }),
    ],
  });
};

const SystemStatText = (icon, label, getValue, interval = 2000) => {
  const value = Variable("");
  Utils.interval(interval, () => {
    value.value = getValue();
  });

  return Widget.Box({
    class_name: "stat-row",
    children: [
      Widget.Label({ class_name: "icon", label: icon }),
      Widget.Box({
        hexpand: true,
        children: [
          Widget.Label({ 
            class_name: "label", 
            hpack: "start",
            label: label 
          }),
          Widget.Label({
            class_name: "value",
            hpack: "end",
            hexpand: true,
            label: value.bind(),
          }),
        ],
      }),
    ],
  });
};

// System section
const SystemStats = () => Widget.Box({
  class_name: "section",
  vertical: true,
  children: [
    SystemStat("󰓅", "CPU", getCpuUsage, 2000),
    SystemStat("", "Memory", getMemoryUsage, 5000),
    SystemStatText("󰋊", "Disk", getDiskUsage, 10000),
    SystemStatText("󰏈", "Temp", getTemp, 2000),
  ],
});

// Power section
const PowerStats = () => Widget.Box({
  class_name: "section",
  vertical: true,
  children: [
    Widget.Box({
      class_name: "stat-row",
      children: [
        Widget.Label({ class_name: "icon", label: "" }),
        Widget.Box({
          vertical: true,
          hexpand: true,
          children: [
            Widget.Box({
              children: [
                Widget.Label({ class_name: "label", hpack: "start", label: "Battery" }),
                Widget.Label({
                  class_name: "value",
                  hpack: "end",
                  hexpand: true,
                  label: battery.bind("percent").as(p => `${p}%`),
                }),
              ],
            }),
            Widget.ProgressBar({
              class_name: "progress-bar battery-bar",
              value: battery.bind("percent").as(p => p / 100),
            }),
          ],
        }),
      ],
    }),
    SystemStatText("⚡", "Power", getPower, 2000),
    SystemStatText("", "Mode", getP1G8Mode, 2000),
  ],
});

// Network section
const NetworkStats = () => Widget.Box({
  class_name: "section",
  vertical: true,
  children: [
    Widget.Box({
      class_name: "stat-row",
      children: [
        Widget.Label({ class_name: "icon", label: "󰤨" }),
        Widget.Box({
          hexpand: true,
          children: [
            Widget.Label({ class_name: "label", hpack: "start", label: "Network" }),
            Widget.Label({
              class_name: "value",
              hpack: "end",
              hexpand: true,
              label: network.wifi.bind("ssid").as(ssid => ssid || "Disconnected"),
            }),
          ],
        }),
      ],
    }),
    Widget.Box({
      class_name: "stat-row",
      children: [
        Widget.Label({ class_name: "icon", label: "" }),
        Widget.Box({
          vertical: true,
          hexpand: true,
          children: [
            Widget.Box({
              children: [
                Widget.Label({ class_name: "label", hpack: "start", label: "Brightness" }),
                Widget.Label({
                  class_name: "value",
                  hpack: "end",
                  hexpand: true,
                  label: "66%", // TODO: implement brightness monitoring
                }),
              ],
            }),
            Widget.Slider({
              class_name: "brightness-slider",
              draw_value: false,
              on_change: ({ value }) => Utils.exec(`brightnessctl s ${Math.floor(value * 100)}%`),
              value: 0.66,
            }),
          ],
        }),
      ],
    }),
  ],
});

// Volume section
const VolumeControl = () => Widget.Box({
  class_name: "section",
  children: [
    Widget.Label({
      class_name: "icon",
      label: audio.speaker.bind("is_muted").as(m => m ? "󰝟" : "󰕾"),
    }),
    Widget.Box({
      vertical: true,
      hexpand: true,
      children: [
        Widget.Box({
          children: [
            Widget.Label({ class_name: "label", hpack: "start", label: "Volume" }),
            Widget.Label({
              class_name: "value",
              hpack: "end",
              hexpand: true,
              label: audio.speaker.bind("volume").as(v => `${Math.floor(v * 100)}%`),
            }),
          ],
        }),
        Widget.Slider({
          class_name: "volume-slider",
          draw_value: false,
          on_change: ({ value }) => audio.speaker.volume = value,
          value: audio.speaker.bind("volume"),
        }),
      ],
    }),
  ],
});

// Main stats window
export const StatsWindow = () => Widget.Window({
  name: "stats",
  class_name: "stats-window",
  anchor: ["top", "right"],
  margins: [60, 20, 0, 0],
  exclusivity: "normal",
  keymode: "on-demand",
  visible: false,
  child: Widget.Box({
    class_name: "main-container",
    vertical: true,
    children: [
      TimeDate(),
      Launcher(),
      Workspaces(),
      Player(),
      SystemStats(),
      PowerStats(),
      NetworkStats(),
      VolumeControl(),
    ],
  }),
});
