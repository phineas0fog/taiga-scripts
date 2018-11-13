function command-not-found {
    echo "[ERROR] command \"$1\" not found on your system..."
    exit 1
}

function get-distro {
    distro=$(cat /etc/*release | grep '^ID=' | cut -d '=' -f 2)
    cmd=""
    case "$distro" in
	"arch")
	    which pacman
	    if [ $? == 0 ]; then
		cmd="pacman -S --noconfirm "
	    else
		command-not-found pacman
	    fi
	    ;;
	"debian" | "ubuntu")
	    which apt-get
	    if [ $? == 0 ]; then
		cmd="apt-get install -y "
	    else
		command-not-found apt-get
	    fi
	    ;;
	"centos")
	    which yum
	    if [ $? == 0 ]; then
		cmd="yum install -y "
	    else
		command-not-found yum
	    fi
	    ;;
	"fedora")
	    which dnf
	    if [ $? == 0 ]; then
		cmd="dnf install -y "
	    else
		command-not-found dnf
	    fi
	    ;;
	*)
	    echo "[ERROR] unsupported distribution... exiting"
	    exit 1
	    
	echo "[INFO] detected linux distribution: \"$distro\", using \"$cmd\" for package installation"
    esac
}

function apt-install {
    get-distro
    for pkg in $@; do
        echo -e "[INFO] Installing package $pkg..."
        sudo $cmd $pkg
    done
}


function apt-install-if-needed {
    for pkg in $@; do
        if package-not-installed $pkg; then
            apt-install $pkg
        fi
    done
}


function package-not-installed {
    distro=$(cat /etc/*release | grep '^ID=' | cut -d '=' -f 2)
    cmd=""
    case "$distro" in
	"arch")
	    which pacman
	    if [ $? == 0 ]; then
		sudo pacman -Qi $1
	    else
		command-not-found pacman
	    fi
	    ;;
	"debian" | "ubuntu")
	    which apt-get
	    if [ $? == 0 ]; then
		sudo dpkg -s $1 2> /dev/null | grep Status
	    else
		command-not-found apt-get
	    fi
	    ;;
	"centos")
	    which yum
	    if [ $? == 0 ]; then
		sudo yum list installed $1
	    else
		command-not-found yum
	    fi
	    ;;
	"fedora")
	    which dnf
	    if [ $? == 0 ]; then
		sudo dnf list installed $1
	    else
		command-not-found dnf
	    fi
	    ;;
	*)
	    echo "[ERROR] unsupported distribution... exiting"
	    exit 1

	echo "[INFO] detected linux distribution: \"$distro\", using \"$cmd\" for packages updates"
	$cmd
    esac    
}

function update-packages {
    distro=$(cat /etc/*release | grep '^ID=' | cut -d '=' -f 2)
    cmd=""
    case "$distro" in
	"arch")
	    which pacman
	    if [ $? == 0 ]; then
		cmd="pacman -Syyu --noconfirm"
	    else
		command-not-found pacman
	    fi
	    ;;
	"debian" | "ubuntu")
	    which apt-get
	    if [ $? == 0 ]; then
		cmd="apt-get update -y; apt-get upgrade -y"
	    else
		command-not-found apt-get
	    fi
	    ;;
	"centos")
	    which yum
	    if [ $? == 0 ]; then
		cmd="yum update -y "
	    else
		command-not-found yum
	    fi
	    ;;
	"fedora")
	    which dnf
	    if [ $? == 0 ]; then
		cmd="dnf update -y "
	    else
		command-not-found dnf
	    fi
	    ;;
	*)
	    echo "[ERROR] unsupported distribution... exiting"
	    exit 1

	echo "[INFO] detected linux distribution: \"$distro\", using \"$cmd\" for packages updates"
	$cmd
    esac
}

sudo update-packages()
