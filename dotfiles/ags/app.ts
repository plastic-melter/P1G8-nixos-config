import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"

function StatsWindow() {
    return <window
        className="stats-window"
        anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
        exclusivity={Astal.Exclusivity.NORMAL}
        keymode={Astal.Keymode.ON_DEMAND}
        application={App}
        visible={false}
        name="stats"
    >
        <box className="main-container" vertical>
            <label label="AGS v2 Stats Panel" />
        </box>
    </window>
}

App.start({
    css: "./scss/style.scss",
    main() {
        StatsWindow()
    },
})
