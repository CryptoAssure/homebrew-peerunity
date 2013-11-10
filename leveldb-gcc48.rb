require 'formula'

class LeveldbGcc48 < Formula
  homepage 'https://code.google.com/p/leveldb/'
  url 'https://leveldb.googlecode.com/files/leveldb-1.14.0.tar.gz'
  sha1 '641d54df4aaf7ee569ae003cfbdb888ebdee0d7f'

  keg_only "This is for libbitcoin."

  depends_on 'homebrew/versions/gcc48' => :build
  depends_on 'snappy' => :build

  def install
    ENV['CC']= "gcc-4.8"
    ENV['CXX'] = "g++-4.8"
    ENV['LD'] = ENV['CXX']

    system "make"
    system "make leveldbutil"
    include.install "include/leveldb"
    bin.install 'leveldbutil'
    lib.install 'libleveldb.a'
    lib.install 'libleveldb.dylib.1.14' => 'libleveldb.1.14.dylib'
    lib.install_symlink lib/'libleveldb.1.14.dylib' => 'libleveldb.dylib'
    lib.install_symlink lib/'libleveldb.1.14.dylib' => 'libleveldb.1.dylib'
  end
end
