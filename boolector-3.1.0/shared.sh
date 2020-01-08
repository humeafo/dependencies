#!/bin/sh

if [ -z "$build" ] ; then 
  echo '$build is undefined'
  exit 1
fi
if [ -z "$package_dir" ] ; then 
  echo '$build is undefined'
  exit 1
fi

package=boolector
source=nosourcefile
build_dir=$build/$package-$version
url='https://github.com/Boolector/boolector.git'

download() {
  mkdir -p $cache/$package-$version &&
  cd $cache/$package-$version &&
  if [ -d .git ]; then
    git pull
  else
    git clone $url .
    git checkout $branch
    git cherry-pick 87920b1379d5a942e4ac11a1751e8408a98c48c2
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
  contrib/setup-btor2tools.sh &&
  contrib/setup-lingeling.sh &&
  contrib/setup-cadical.sh  &&  
  ./configure.sh --prefix "$target" --no-minisat --no-picosat &&
  cd build &&
  make -j $num_threads &&
  make install &&
  cp ../deps/install/lib/libbtor2parser.a $target/lib &&
  cp ../deps/install/lib/libcadical.a $target/lib &&
  cp ../deps/install/lib/liblgl.a $target/lib &&
  install_cmake_files $cmake_files_dir &&
  cp BoolectorConfig.cmake "$target"
}