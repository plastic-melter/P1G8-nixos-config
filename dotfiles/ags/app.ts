import { App } from "astal/gtk3"
import { Variable } from "astal"
import Hyprland from "gi://AstalHyprland"
import Mpris from "gi://AstalMpris"
import Battery from "gi://AstalBattery"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"
import { Astal, Gtk } from "astal/gtk3"

const time = Variable("").poll(1000, () => {
  return new Date().toLocaleTimeString("en-US", { 
    hour12: false,
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit"
  })
})

const date = Variable("").poll(10000, () => {
  return new Date().toLocaleDateString("en-US", { 
    weekday: "long",
    month: "long", 
    day: "numeric"
  })
})

function TimeWidget() {
  return (
    <box className="section time-section" vertical>
      <label className="time-big" label={time()} />
      <label className="date-small" label={date()} />
    </box>
  )
}

function BatteryWidget() {
  const bat = Battery.get_default()
  
  return (
    <box className="section" vertical>
      <box className="stat-row">
        <label className="icon" label="" />
        <box vertical hexpand>
          <box>
            <label className="label" halign={Gtk.Align.START} label="Battery" />
            <label 
              className="value" 
              halign={Gtk.Align.END} 
              hexpand 
              label={`${Math.floor(bat.percentage * 100)}%`} 
            />
          </box>
          <levelbar
            className="progress-bar battery-bar"
            value={bat.percentage}
          />
        </box>
      </box>
    </box>
  )
}

function VolumeWidget() {
  const speaker = Wp.get_default()?.audio.defaultSpeaker!
  
  return (
    <box className="section">
      <label className="icon" label={speaker.mute ? "󰝟" : "󰕾"} />
      <box vertical hexpand>
        <box>
          <label className="label" halign={Gtk.Align.START} label="Volume" />
          <label 
            className="value" 
            halign={Gtk.Align.END} 
            hexpand 
            label={`${Math.floor(speaker.volume * 100)}%`} 
          />
        </box>
        <slider
          className="volume-slider"
          value={speaker.volume}
          onDragged={({ value }) => speaker.volume = value}
        />
      </box>
    </box>
  )
}

function StatsWindow() {
  return (
    <window
      className="stats-window"
      name="stats"
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
      exclusivity={Astal.Exclusivity.NORMAL}
      application={App}
      visible={false}
      margin={60}
      marginRight={20}
    >
      <box className="main-container" vertical spacing={10}>
        <TimeWidget />
        <BatteryWidget />
        <VolumeWidget />
      </box>
    </window>
  )
}

App.start({
  css: "./style.css",
  main() {
    StatsWindow()
  },
})
