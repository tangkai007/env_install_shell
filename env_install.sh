#打印菜单信息
menu(){
echo "*************************************";
echo "      欢迎使用自动创建文件加程序     ";
echo "       1.安装openjdk 1.7             ";
echo "       2.安装tomcat                  ";
echo "       3.安装zabbix(开发中)          ";
echo "       4.安装mysql                   ";
echo "       5.安装redis(开发中)           ";
echo "       6.安装zookeeper(开发中)       ";
echo "       0.退出                        ";
echo "*************************************";
read -a input_code -p "请选择您的操作:"
option $input_code
}

#检查目录是否存在，不存在则创建
check_dir(){
  #检查软件安装目录
  if [! -d "/usr/local/software"]; then
	echo "目录不存在，创建software目录"
	mkdir -p /usr/local/software
  fi
  #检查软件包存放目录
  if [! -d "/usr/local/package"]; then
 	echo "目录不存在，创建package目录"
  fi
  #检查命令是否存在
  type wget  >/dev/null 2>&1 || { 
	echo >&2 "wget命令没有安装，执行安装"; 
	yum install -y wget; 
	}
}

#安装openJDK
install_openJDK(){
 yum install -y java-1.7.0-openjdk-devel.x86_64
}

#安装tomcat
install_tomcat(){
	cd /usr/local/software
	wget http://mirrors.cnnic.cn/apache/tomcat/tomcat-7/v7.0.70/bin/apache-tomcat-7.0.70.tar.gz
	tar -zxf apache-tomcat-7.0.70.tar.gz

}
install_zabbix(){
echo "开发中"
}

#安装mysql
install_mysql(){
	yum install -y mysql-server.x86_64
        yum install -y mysql-devel.x86_64

}

install_redis(){
echo "开发中。。。"
}

install_zookeeper(){
echo "开发中。。。"
}

option(){
	check_dir
	echo $1
	input_code=$1
	if [ "$input_code" = "1" ]; then
	install_openJDK
	elif [ "$input_code" = "2" ]; then
	install_tomcat	
	elif [ "$input_code" = "3" ]; then
	install_zabbix
	elif [ "$input_code" = "4" ]; then
	install_mysql	
	elif [ "$input_code" = "5" ]; then
	install_redis
	elif [ "$input_code" = "6" ]; then
	install_zookeeper
	elif [ "$input_code" = "0" ]; then
	exit 1
	else
	    echo "输入错误，请重新输入"
	fi
	menu
}	

main(){
 	menu
}
main
