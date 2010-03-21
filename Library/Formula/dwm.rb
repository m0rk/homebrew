require 'formula'

class Dwm <Formula
  url 'http://dl.suckless.org/dwm/dwm-5.7.2.tar.gz'
  homepage 'http://dwm.suckless.org/'
  md5 'a0b8a799ddc5034dd8a818c9bd76f3a3'
  head 'http://hg.suckless.org/dwm'

  def options
    [
      ['--custom-m0rk', "customized m0rk"]
    ]
  end

  def patches
    if ARGV.include? '--custom-m0rk'
      DATA
    end
  end

  def install
    # The dwm default quit keybinding Mod1-Shift-q collides with 
    # the Mac OS X Log Out shortcut in the Apple menu.
    #inreplace 'config.def.h',
    #'{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },',
    #'{ MODKEY|ControlMask,           XK_q,      quit,           {0} },'
    #inreplace 'dwm.1', '.B Mod1\-Shift\-q', '.B Mod1\-Control\-q'
    system "make PREFIX=#{prefix} install"
  end

  def caveats
    <<-EOS
    In order to use the Mac OS X command key for dwm commands,
    change the X11 keyboard modifier map using xmodmap (1).

    e.g. by running the following command from $HOME/.xinitrc
    xmodmap -e 'remove Mod2 = Meta_L' -e 'add Mod1 = Meta_L'&
    EOS
  end
end

__END__
diff --git a/config.def.h b/config.def.h
index cca63f7..3cd2c07 100644
--- a/config.def.h
+++ b/config.def.h
@@ -1,13 +1,13 @@
 /* See LICENSE file for copyright and license details. */
 
 /* appearance */
-static const char font[]            = "-*-*-medium-*-*-*-14-*-*-*-*-*-*-*";
-static const char normbordercolor[] = "#cccccc";
-static const char normbgcolor[]     = "#cccccc";
-static const char normfgcolor[]     = "#000000";
-static const char selbordercolor[]  = "#0066ff";
-static const char selbgcolor[]      = "#0066ff";
-static const char selfgcolor[]      = "#ffffff";
+static const char font[]            = "-*-Fixed-medium-r-*--13-*-*-*-*-*-ISO10646-1";
+static const char normbordercolor[] = "#333333";
+static const char normbgcolor[]     = "#333333";
+static const char normfgcolor[]     = "#999999";
+static const char selbordercolor[]  = "#4C4C4C";
+static const char selbgcolor[]      = "#333333";
+static const char selfgcolor[]      = "#FFFFFF";
 static const unsigned int borderpx  = 1;        /* border pixel of windows */
 static const unsigned int snap      = 32;       /* snap pixel */
 static const Bool showbar           = True;     /* False means no bar */
@@ -28,8 +28,8 @@ static const Bool resizehints = True; /* True means respect size hints in tiled
 
 static const Layout layouts[] = {
 	/* symbol     arrange function */
-	{ "[]=",      tile },    /* first entry is default */
-	{ "><>",      NULL },    /* no layout function means floating behavior */
+	{ "[T]",      tile },    /* first entry is default */
+	{ "[F]",      NULL },    /* no layout function means floating behavior */
 	{ "[M]",      monocle },
 };
 
@@ -46,7 +46,7 @@ static const Layout layouts[] = {
 
 /* commands */
 static const char *dmenucmd[] = { "dmenu_run", "-fn", font, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
-static const char *termcmd[]  = { "uxterm", NULL };
+static const char *termcmd[]  = { "urxvtc", NULL };
 
 static Key keys[] = {
 	/* modifier                     key        function        argument */
