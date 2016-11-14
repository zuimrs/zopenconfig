#zopenconfig
[https://github.com/zuimrs/zopenconfig](https://github.com/zuimrs/zopenconfig)

An easy method that helps you to manage Openstack</br>

vim setting.conf # edit your setting firstly. Like password,IPaddress,net-card</br>

You need run package_test to test whether you install all basic package</br>

support ubuntu 14.04</br>


##Usage:
	./zopenconfig.sh  [-h] <Service_Name> [Action] [-v]
>###optional arguments:
  -h,--help                    show this help message and exit</br>
  -v,--version                 show the version of these bash scripts</br>


##For example:
	./zopenconfig.sh package_test
	./zopenconfig.sh show
	./zopenconfig.sh user
	./zopenconfig.sh role
	./zopenconfig.sh tenant

###Show openstack cluster information

	./zopenconfig.sh show

###Manage user

	./zopenconfig.sh user 

###Manage role

	./zopenconfig.sh role

###Manage tenant

	./zopenconfig.sh tenant
