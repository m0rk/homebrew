require 'formula'

class RxvtUnicode <Formula
  url 'http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.07.tar.bz2'
  homepage 'http://software.schmorp.de/pkg/rxvt-unicode.html'
  md5 '49bb52c99e002bf85eb41d8385d903b5'

  def options
    [
      ['--xterm-colors-256', 'enable Xterm 88 or 256 color model']
    ]
  end

  def patches
    # fix for "make: `install' is up to date."
    # patch for macosx-clipboard (working cut & paste without dependencies)
    patch_files = [
      DATA
    ]
    patch_files << "doc/urxvt-8.2-256color.patch" if ARGV.include? '--xterm-colors-256'

    patch_files
  end

  def install
    # fix for "checking for /usr/bin/perl suitability... configure: error: no, unable to link"
    ENV['CXXFLAGS'] = ENV['CXXFLAGS'].gsub(/-msse[^\s]+/, '').gsub(/-march[^\s]+/, '')
    # fix for "Undefined symbols for architecture ppc" and "Undefined symbols for architecture i386"
    ENV['ARCHFLAGS'] = "-arch x86_64" if bits_64?

    configure_args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
    ]
    configure_args << "--enable-xterm-colors=256" if ARGV.include? '--xterm-colors-256'
    configure_args << "--build=x86_64-apple-darwin10.2.0" if bits_64?

    system "./configure", *configure_args
    system "make install"
  end

  def caveats
    <<-EOS
    In order to have a working copy and paste, add this to your .Xdefaults

    URxvt.perl-ext-common: macosx-clipboard
    URxvt.keysym.M-c: perl:macosx-clipboard:copy
    URxvt.keysym.M-v: perl:macosx-clipboard:paste
    EOS
  end

  private

    def bits_64?
      MACOS_VERSION >= 10.6 && Hardware.is_64_bit?
    end

end

__END__
diff --git a/Makefile.in b/Makefile.in
index 491776d..bdf84a5 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -32,6 +32,8 @@ subdirs = src doc
 
 RECURSIVE_TARGETS = all allbin alldoc tags clean distclean realclean install
 
+.PHONY: Makefiles all allbin alldoc check clean distclean distclean-local distdir install realclean tags tar.bz2 tar.gz
+
 #-------------------------------------------------------------------------
 
 $(RECURSIVE_TARGETS):
diff --git a/src/perl/macosx-clipboard b/src/perl/macosx-clipboard
index 344b914..7e2aba8 100644
--- a/src/perl/macosx-clipboard
+++ b/src/perl/macosx-clipboard
@@ -29,15 +29,14 @@
 # URxvt.keysym.M-c: perl:macosx-clipboard:copy
 # URxvt.keysym.M-v: perl:macosx-clipboard:paste
 
-use Mac::Pasteboard;
-
-my $pasteboard = new Mac::Pasteboard;
+use Fcntl;
 
 sub copy {
    my ($self) = @_;
 
-   $pasteboard->clear;
-   $pasteboard->copy ($self->selection);
+   open(CLIPBOARD, "| pbcopy");
+   print CLIPBOARD $self->selection;
+   close CLIPBOARD;
 
    ()
 }
@@ -45,10 +44,7 @@ sub copy {
 sub paste {
    my ($self) = @_;
 
-   # $str = $pasteboard->stringForType_($type)->UTF8String;
-   my $str = $pasteboard->paste;
-   utf8::decode $str;
-   $self->tt_write ($self->locale_encode ($str));
+   $self->tt_write(`pbpaste`);
 
    ()
 }
@@ -65,5 +61,4 @@ sub on_user_command {
    }
 
    ()
-}
-
+}
\ No newline at end of file
