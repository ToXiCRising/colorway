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
                flags: ApplicationFlags.FLAGS_NONE ,
                application_id: Config.APP_ID
            );
            add_action_entries(app_entries, this);
        }
        static construct {
            gsettings = new GLib.Settings ("io.github.lainsce.Colorway");
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
                win.present ();
                return;
            }
            win = new MainWindow (this);
        }

        private const GLib.OptionEntry[] options = {
            // --version
            { "color-picker", '\0', OptionFlags.NONE, OptionArg.NONE, ref picker, "Starts program with colorpicker selected", null },

            // list terminator
            { null }
        };
        private static bool picker = false;
        public static int main (string[] args) {

            try {
                var opt_context = new OptionContext ("- OptionContext example");
                opt_context.set_help_enabled (true);
                opt_context.add_main_entries (options, null);
                opt_context.parse (ref args);
            } catch (OptionError e) {
                printerr ("error: %s\n", e.message);
                printerr ("Run '%s --help' to see a full list of available command line options.\n", args[0]);
                return 1;
            }


            if (picker) {
			    print ("Selected colorpicker\n");
			    return 0;
		    }
            var app = new Colorway.Application ();
            return app.run (args);
        }
    }
}
