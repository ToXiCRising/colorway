/*
 * Copyright 2021 Lains
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
namespace Colorway {
    public class Application : Adw.Application {
        public static MainWindow win = null;
        public static GLib.Settings gsettings;
        private const GLib.ActionEntry app_entries[] = {
            { "quit", on_quit },
        };

        public Application () {
            Object (
                flags: ApplicationFlags.HANDLES_COMMAND_LINE ,
                application_id: Config.APP_ID
            );
            add_action_entries(app_entries, this);
            this.command_line.connect(on_command_line);
        }
        static construct {
            gsettings = new GLib.Settings ("io.github.lainsce.Colorway");
        }

        private int on_command_line(GLib.ApplicationCommandLine cmdline) {
            print("Handling command line\n");

            string[] owned_args = cmdline.get_arguments();
            unowned string[] args = owned_args;

            try {
                var context = new OptionContext ("- Colorway options");
                context.set_help_enabled (true);
                context.add_main_entries (options, null);
                context.parse(ref args); // This now works
            } catch (OptionError e) {
                stderr.printf ("Error parsing options: %s\n", e.message);
                return 1;
            }

            if (picker) {
                print("--color-picker selected. Starting in picker mode...\n");
                start_picker = true;  // set flag
                this.activate();
                return 0;
            }

            this.activate();
            return 0;
        }
        construct {
            Intl.setlocale (LocaleCategory.ALL, "");
            Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.LOCALEDIR);
            Intl.textdomain (Config.GETTEXT_PACKAGE);
        }
        private void on_quit() {
            win.destroy();
        }
        public MainWindow get_window () {
            return win;
        }

        protected override void activate () {
            if (win != null) {
                win.present();
                if (start_picker)
                    win.activate_color_picker();
                return;
            }
            win = new MainWindow(this);
            win.show();
            if (start_picker)
                win.activate_color_picker();
        }

        private const GLib.OptionEntry[] options = {
            // --version
            { "color-picker", '\0', OptionFlags.NONE, OptionArg.NONE, ref picker, "Starts program with colorpicker selected", null },

            // list terminator
            { null }
        };
        private static bool picker = false;
        private static bool start_picker = false;
        public static int main (string[] args) {

            var app = new Colorway.Application ();
            return app.run (args);
        }
    }
}
