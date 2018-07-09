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
  cd $build_dir &&
  ./contrib/setup-cadical.sh &&
  ./contrib/setup-lingeling.sh &&
  ./contrib/setup-btor2tools.sh &&
  ./configure.sh && cd build && make -j $num_threads &&
  mkdir -p "$target/include" &&
  mkdir -p "$target/bin" &&
  mkdir -p "$target/lib" &&
  cp ../src/*.h "$target/include" &&
  cp -R bin/* "$target/bin" &&
  cp -R lib/* "$target/lib" &&
  cp ../deps/btor2tools/build/libbtor2parser.a "$target/lib" &&
  cp ../deps/cadical/build/libcadical.a "$target/lib" &&
  cp ../deps/lingeling/liblgl.a "$target/lib" &&
  cp $config_files_dir/boolector-config.cmake "$target"
}
