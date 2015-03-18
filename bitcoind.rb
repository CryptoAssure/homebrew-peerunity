require 'formula'

class Bitcoind < Formula
  homepage 'https://bitcoin.org/'
  url 'https://github.com/bitcoin/bitcoin.git', :tag => 'v0.10.0'
  version '0.10.0'
  head 'https://github.com/bitcoin/bitcoin.git', :branch => 'master'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on 'berkeley-db4'
  depends_on 'boost'
  depends_on 'openssl'

  depends_on "miniupnpc" => :optional
  deprecated_option "with-upnp" => "with-miniupnpc"

  def install
    system "sh", "autogen.sh"
    # todo: make --without-qt optional
    system "./configure", "--prefix=#{prefix}", "--without-qt"
    system "make"
    system "strip src/bitcoin-cli"
    system "strip src/bitcoind"
    bin.install "src/bitcoin-cli"
    bin.install "src/bitcoind"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <dict>
          <key>PathState</key>
          <dict>
            <key>~/Library/Application Support/Bitcoin/bitcoind.pid</key>
            <false/>
          </dict>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/bin/bitcoind</string>
          <string>-daemon</string>
        </array>
      </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    You will need to setup your bitcoin.conf if you haven't already done so:

    echo -e "rpcuser=bitcoinrpc\\nrpcpassword=$(xxd -l 16 -p /dev/urandom)" > ~/Library/Application\\ Support/Bitcoin/bitcoin.conf
    chmod 600 ~/Library/Application\\ Support/Bitcoin/bitcoin.conf

    Use `bitcoind stop` to stop bitcoind if necessary! `brew services stop bitcoind` does not work!
    EOS
  end
end

__END__
