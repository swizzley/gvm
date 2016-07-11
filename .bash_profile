function mkgoproj() { 
  if [ -z ${1} ]; then
    echo "mkproj requires the name of the go project you wish to create"
    return 1
  else
    echo "Creating Directory Structure: ~/projects/golang/${1}/{src,pkg,bin}"
    mkdir -p ~/projects/golang/${1}/{src,pkg,bin}
    if [ $? != 0 ]; then
      echo "[error]: Something went wrong with directory creation"
      return 1
    fi

    echo "Creating Go GVM Package Set ${1} "
    gvm pkgset create ${1}
    if [ $? != 0 ]; then
      echo "[error]: Something went wrong with pkgset creation"
      rm -rf ~/projects/golang/${1}
      gvm pkgset delete ${1}
      return 1
    fi

    echo "Modifying of GVM Package ENV ${1} "
    sed -i "s/\/${1}\/bin:\$PATH/\/${1}\/bin:\$HOME\/projects\/golang\/${1}\/bin:\$PATH/g" $HOME/.gvm/environments/go1.5@${1} 
    sed -i "s/\/${1}:\$GOPATH/\/${1}:\$HOME\/projects\/golang\/${1}:\$GOPATH/g" $HOME/.gvm/environments/go1.5@${1}
    if [ $? != 0 ]; then
      echo "[error]: Something went wrong with pkgenv modification"
      rm -rf ~/projects/golang/${1}
      gvm pkgset delete ${1}
      return 1
    fi
  fi

  echo "Golang Project ${1} Successfully Created"
  echo "Before going into VIM-GO execute:"
  echo "gvm pkgset use ${1}"
}

function cover () { 
    t="/tmp/go-cover.$$.tmp"
    go test -coverprofile=$t $@ && go tool cover -html=$t && unlink $t
}
