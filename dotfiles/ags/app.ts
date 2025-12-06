import { App } from "astal/gtk3"
import { Variable, GLib } from "astal"
import Hyprland from "gi://AstalHyprland"
import Mpris from "gi://AstalMpris"
import Battery from "gi://AstalBattery"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"
import { Astal, Gtk, Gdk } from "astal/gtk3"

// Time variables
const time = Variable("").poll(1000, () => {
  return GLib.DateTime.new_now_local().format("%H:%M:%S") || ""
})

const date = Variable("").poll(10000, () => {
  return GLib.DateTime.new_now_local().format("%A, %B %d") || ""
})

// Helper functions for system stats
function getCpuUsage(): string {
  try {
    return Utils.exec("bash -c \"top -bn1 | grep 'Cpu' | awk '{print int($2)}'\"")
  } catch {
    return "0"
  }
}

function getMemoryUsage(): string {
  try {
    return Utils.exec("bash -c \"free | grep Mem | awk '{printf \\\"%d\\\", $3/$2 * 100}'\"")
  } catch {
    return "0"
  }
}

const cpuUsage = Variable(0).poll(2000, () => parseInt(getCpuUsage()))
const memoryUsage = Variable(0).poll(5000, () => parseInt(getMemoryUsage()))

// Time widget
function TimeWidget() {
  return Widget.Box({
    className: "section time-section",
    vertical: true,
    children: [
      Widget.Label({
        className: "time-big",
        label: time(),
      }),
      Widget.Label({
        className: "date-small",
        label: date(),
      }),
    ],
  })
}

// Launcher
function Launcher() {
  return Widget.Box({
    className: "section launcher-section",
    hpack: "center",
    children: [
      Widget.Button({
        className: "launcher-btn",
        onClicked: () => Utils.execAsync("nwg-menu -va top"),
        child: Widget.Label(""),
      }),
    ],
  })
}

// Workspaces
function Workspaces() {
  const hypr = Hyprland.get_default()
  
  return Widget.Box({
    className: "section workspaces-section",
    hpack: "center",
    children: [1, 2, 3, 4, 5].map(i => 
      Widget.Button({
        className: Variable.derive(
          [Variable(hypr.get_focused_workspace().get_id())],
          (id) => `workspace-btn${id === i ? " active" : ""}`
        )(),
        onClicked: () => hypr.dispatch("workspace", `${i}`),
        child: Widget.Label(`${i}`),
        setup: (self) => {
          hypr.connect("notify::focused-workspace", () => {
            const id = hypr.get_focused_workspace().get_id()
            self.className = `workspace-btn${id === i ? " active" : ""}`
          })
        },
      })
    ),
  })
}

// Media Player
function MediaPlayer() {
  const mpris = Mpris.get_default()
  
  return Widget.Box({
    className: "section player-section",
    vertical: true,
    visible: Variable.derive(
      [Variable(mpris.get_players())],
      (players) => players.length > 0
    )(),
    setup: (self) => {
      mpris.connect("notify::players", () => {
        self.visible = mpris.get_players().length > 0
      })
    },
    children: [
      Widget.Box({
        className: "stat-row",
        children: [
          Widget.Label({
            className: "icon player-icon",
            setup: (self) => {
              const updateIcon = () => {
                const player = mpris.get_players()[0]
                self.label = player?.playbackStatus === Mpris.PlaybackStatus.PLAYING ? "󰐌" : "󰏥"
              }
              mpris.connect("notify::players", updateIcon)
              updateIcon()
            },
          }),
          Widget.Label({
            className: "label player-label",
            hexpand: true,
            truncate: "end",
            maxWidthChars: 30,
            setup: (self) => {
              const updateLabel = () => {
                const player = mpris.get_players()[0]
                if (player) {
                  const artist = player.artist || "Unknown"
                  const title = player.title || "Unknown"
                  self.label = `${artist} - ${title}`
                } else {
                  self.label = "No media"
                }
              }
              mpris.connect("notify::players", updateLabel)
              updateLabel()
            },
          }),
        ],
      }),
      Widget.Box({
        className: "player-controls",
        hpack: "center",
        children: [
          Widget.Button({
            className: "player-btn",
            onClicked: () => mpris.get_players()[0]?.previous(),
            child: Widget.Label(""),
          }),
          Widget.Button({
            className: "player-btn play-pause",
            onClicked: () => mpris.get_players()[0]?.play_pause(),
            child: Widget.Label({
              setup: (self) => {
                const updateIcon = () => {
                  const player = mpris.get_players()[0]
                  self.label = player?.playbackStatus === Mpris.PlaybackStatus.PLAYING ? "" : ""
                }
                mpris.connect("notify::players", updateIcon)
                updateIcon()
              },
            }),
          }),
          Widget.Button({
            className: "player-btn",
            onClicked: () => mpris.get_players()[0]?.next(),
            child: Widget.Label(""),
          }),
        ],
      }),
    ],
  })
}

// System stats
function SystemStats() {
  return Widget.Box({
    className: "section",
    vertical: true,
    children: [
      // CPU
      Widget.Box({
        className: "stat-row",
        children: [
          Widget.Label({ className: "icon", label: "󰓅" }),
          Widget.Box({
            vertical: true,
            hexpand: true,
            children: [
              Widget.Box({
                children: [
                  Widget.Label({ className: "label", halign: Gtk.Align.START, label: "CPU" }),
                  Widget.Label({
                    className: "value",
                    halign: Gtk.Align.END,
                    hexpand: true,
                    label: cpuUsage(cpu => `${cpu}%`),
                  }),
                ],
              }),
              Widget.LevelBar({
                className: "progress-bar",
                value: cpuUsage(cpu => cpu / 100),
              }),
            ],
          }),
        ],
      }),
      // Memory
      Widget.Box({
        className: "stat-row",
        children: [
          Widget.Label({ className: "icon", label: "" }),
          Widget.Box({
            vertical: true,
            hexpand: true,
            children: [
              Widget.Box({
                children: [
                  Widget.Label({ className: "label", halign: Gtk.Align.START, label: "Memory" }),
                  Widget.Label({
                    className: "value",
                    halign: Gtk.Align.END,
                    hexpand: true,
                    label: memoryUsage(mem => `${mem}%`),
                  }),
                ],
              }),
              Widget.LevelBar({
                className: "progress-bar",
                value: memoryUsage(mem => mem / 100),
              }),
            ],
          }),
        ],
      }),
    ],
  })
}

// Battery
function BatteryWidget() {
  const bat = Battery.get_default()
  
  return Widget.Box({
    className: "section",
    vertical: true,
    children: [
      Widget.Box({
        className: "stat-row",
        children: [
          Widget.Label({ className: "icon", label: "" }),
          Widget.Box({
            vertical: true,
            hexpand: true,
            children: [
              Widget.Box({
                children: [
                  Widget.Label({ className: "label", halign: Gtk.Align.START, label: "Battery" }),
                  Widget.Label({
                    className: "value",
                    halign: Gtk.Align.END,
                    hexpand: true,
                    setup: (self) => {
                      self.label = `${Math.floor(bat.get_percentage() * 100)}%`
                      bat.connect("notify::percentage", () => {
                        self.label = `${Math.floor(bat.get_percentage() * 100)}%`
                      })
                    },
                  }),
                ],
              }),
              Widget.LevelBar({
                className: "progress-bar battery-bar",
                setup: (self) => {
                  self.value = bat.get_percentage()
                  bat.connect("notify::percentage", () => {
                    self.value = bat.get_percentage()
                  })
                },
              }),
            ],
          }),
        ],
      }),
    ],
  })
}

// Volume
function VolumeWidget() {
  const audio = Wp.get_default()
  const speaker = audio?.get_default_speaker()
  
  if (!speaker) {
    return Widget.Box({})
  }
  
  return Widget.Box({
    className: "section",
    children: [
      Widget.Label({
        className: "icon",
        setup: (self) => {
          const update = () => {
            self.label = speaker.get_mute() ? "󰝟" : "󰕾"
          }
          speaker.connect("notify::mute", update)
          update()
        },
      }),
      Widget.Box({
        vertical: true,
        hexpand: true,
        children: [
          Widget.Box({
            children: [
              Widget.Label({ className: "label", halign: Gtk.Align.START, label: "Volume" }),
              Widget.Label({
                className: "value",
                halign: Gtk.Align.END,
                hexpand: true,
                setup: (self) => {
                  const update = () => {
                    self.label = `${Math.floor(speaker.get_volume() * 100)}%`
                  }
                  speaker.connect("notify::volume", update)
                  update()
                },
              }),
            ],
          }),
          Widget.Slider({
            className: "volume-slider",
            drawValue: false,
            hexpand: true,
            onDragged: ({ value }) => speaker.set_volume(value),
            setup: (self) => {
              self.value = speaker.get_volume()
              speaker.connect("notify::volume", () => {
                self.value = speaker.get_volume()
              })
            },
          }),
        ],
      }),
    ],
  })
}

// Network
function NetworkWidget() {
  const network = Network.get_default()
  const wifi = network.get_wifi()
  
  return Widget.Box({
    className: "section",
    children: [
      Widget.Label({ className: "icon", label: "󰤨" }),
      Widget.Box({
        hexpand: true,
        children: [
          Widget.Label({ className: "label", halign: Gtk.Align.START, label: "Network" }),
          Widget.Label({
            className: "value",
            halign: Gtk.Align.END,
            hexpand: true,
            setup: (self) => {
              const update = () => {
                self.label = wifi?.get_ssid() || "Disconnected"
              }
              wifi?.connect("notify::ssid", update)
              update()
            },
          }),
        ],
      }),
    ],
  })
}

// Main window
function StatsWindow() {
  return Widget.Window({
    className: "stats-window",
    name: "stats",
    anchor: Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT,
    exclusivity: Astal.Exclusivity.NORMAL,
    visible: false,
    application: App,
    margins: [60, 20, 0, 0],
    child: Widget.Box({
      className: "main-container",
      vertical: true,
      children: [
        TimeWidget(),
        Launcher(),
        Workspaces(),
        MediaPlayer(),
        SystemStats(),
        BatteryWidget(),
        NetworkWidget(),
        VolumeWidget(),
      ],
    }),
  })
}

App.start({
  css: "./style.css",
  main() {
    StatsWindow()
  },
})
