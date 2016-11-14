#!/bin/bash
SCRIPT_NAME=zopenconfig.sh
CONFIG_FILE=setting.conf 
SERVICE_FILE=service.conf
SERVICE_PATH=service
SERVICE_ENV_FILE=service-env.sh
ADMIN_ENV_FILE=admin-env.sh
PRE_INSTALL_FILE=pre-install.sh
CONFIG_SCRIPT=config.py
HELP_FILE=HELP
VERSION_FILE=VERSION
PACKAGE_LIST="\
vim \
python \
python-keystoneclient \
python-cinderclient \
python-neutronclient \
python-quantumclient \
python-novaclient \
python-glanceclient"
ITEM_LIST="\
role user tenant image \
usage service volume network \
hypervisor host floating-ip"

# args: FILE_NAME
load_file()
{
	local FILE_NAME=$1
	if [ ! -e $FILE_NAME ]; then
		echo "'$FILE_NAME' not exist"
		exit 1
	fi
	source $FILE_NAME
}

# args: FILE_NAME
import()
{
	load_file $SERVICE_PATH/$1
}


INVOKE="func_"

# args: variable or function name
is_usable()
{
  if type "$1" &>/dev/null; then
    return 0
  fi
  return 1
}

# args: actions-list
echo_usable_action()
{
  for item in $@;
  do
    if is_usable $INVOKE$item || is_usable "$INVOKE$SERVICE_NAME"_"$item"; then
      echo -n "$item "
    fi
  done
}

show_usage()
{
  echo "usage: ./zopenconfig.sh <Service_Name> [Action]"
  echo ""
  for item in `ls $SERVICE_PATH`;
  do
    echo "  ./"$SCRIPT_NAME $item
  done
  echo "  ./"$SCRIPT_NAME "package_test"
  echo "  "
  echo "  use '--help/-h' to learn more " 
}
show_help()
{
	if [ ! -e $HELP_FILE ]; then
		echo "'$HELP_FILE' not exist"
		exit 1
	fi
	more $HELP_FILE
}
show_version()
{
	if [ ! -e $VERSION_FILE ]; then
		echo "'$VERSION_FILE' not exist"
		exit 1
	fi
	more $VERSION_FILE
}
call_pre_install()
{
	export NEED_PRE_INSTALL
 	if  [ -z $NEED_PRE_INSTALL ]; then
		read -p "Maybe you need update or install some package.Do you need configure your soft-source by $PRE_INSTALL_FILE [Y/n]" NEED_PRE_INSTALL
	fi
	if [ 'y' = $NEED_PRE_INSTALL -o 'Y' = $NEED_PRE_INSTALL ]; then
		source $PRE_INSTALL_FILE
	fi
	NEED_PRE_INSTALL=n
}
#env PACKAGE_
func_install()
{
	sudo apt-get -y install $1
}

func_test_package()
{
	call_pre_install
	SET_PACKAGE_LIST=$PACKAGE_LIST
	echo $SET_PACKAGE_LIST
	for item in $SET_PACKAGE_LIST;
	do
		v=`which $item`
		echo $v
		if [ -z $v ];then
			func_install $item
			break
		fi
	done
}
# args: SERVICE_NAME,ACTION
invoke_service()
{
	SERVICE_NAME=$1
	ACTION=$2

	load_file "${SERVICE_PATH}/$SERVICE_NAME"


	if [ -z "$ACTION" ]&&[[ "$SERVICE_NAME" = "show" ]]; then
		echo "'$SERVICE_NAME' SUPPORT ACTIONS:"
		echo -n "  "
		echo_usable_action $ITEM_LIST
		echo " "
		return
	elif [ -z "$ACTION" ]; then
		echo "'$SERVICE_NAME' SUPPORT ACTIONS:"
		echo -n "  "
		echo_usable_action "add delete clean"
		echo " "
		return
	fi

	echo "${ACTION}: ${SERVICE_NAME}"
	if is_usable "$INVOKE$SERVICE_NAME"_"$ACTION"; then
	$INVOKE$SERVICE_NAME"_"$ACTION $*
	else
	echo "$SERVICE_NAME: '$ACTION' NOT IMPLEMENT"
	fi
}


if [ $# -le 0 ]; then
	show_usage
elif [ $# -eq 1 ] && [[ "--help" = "$1" || "-h" = "$1" ]]; then
	show_help
elif [ $# -eq 1 ] && [[ "--version" = "$1" || "-v" = "$1" ]]; then
	show_version
elif [ $# -eq 1 ] && [[ "package_test" = "$1"  ]]; then
	func_test_package
elif [ -e "${SERVICE_PATH}/$1" ]; then
	#load_file $SERVICE_ENV_FILE
	load_file $ADMIN_ENV_FILE
	invoke_service $*
else
	echo "command '$1' not found."
	exit 1
fi
