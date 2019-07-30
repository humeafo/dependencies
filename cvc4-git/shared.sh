#!/bin/sh

if [ -z "$build" ] ; then 
  echo '$build is undefined'
  exit 1
fi
if [ -z "$package_dir" ] ; then 
  echo '$build is undefined'
  exit 1
fi

package=cvc4
source=nosourcefile
build_dir=$build/$package-$version
url='https://github.com/CVC4/CVC4.git'

download() {
  mkdir -p $cache/$package-$version &&
  cd $cache/$package-$version &&
  if [ -d .git ]; then
    git pull
  else
    git clone $url .
    git checkout $branch
  fi
}

unpack() {
  cp -R $cache/$package-$version $build_dir
}
  
pre_build() {
  true
}

build_install() {
  if [ -z "$target" ] ; then
    echo '$target is undefined'
    exit 1
  fi
  cd "$build_dir" &&
  # build libantlr3c with provided script
  contrib/get-antlr-3.4 &&
  contrib/get-cadical &&
  #metasmt not support FP so skip it
  #contrib/get-symfpu &&
  ./configure.sh --prefix="$target" --antlr-dir=$build_dir/antlr-3.4 --cadical &&
  cd build &&
  make -j $num_threads &&
  make install &&
  cp -f "$package_dir/CVC4Config.cmake" "$target/CVC4Config.cmake"
}
