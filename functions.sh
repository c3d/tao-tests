die() {
  echo $1 >&2
  exit 1
}

_mktemp() {
  case $(uname) in
    MINGW*)
      if [ "$1" = "-d" ] ; then
        isdir = 1
      fi
      dst=$(echo $1 | sed 's/\.X\+/.'$$'/')
      if [ "$isdir" ] ; then
        mkdir -p $dst
      else
        touch $dst
      fi
      echo $dst
      ;;
    *)
      mktemp $@
      ;;
  esac;
}

