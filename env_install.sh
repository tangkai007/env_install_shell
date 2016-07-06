#打印菜单信息
menu(){
echo "*************************************";
echo "      欢迎使用自动创建文件加程序     ";
echo "       1.安装openjdk 1.7             ";
echo "       2.安装tomcat                  ";
echo "       3.安装zabbix(开发中)          ";
echo "       4.安装mysql                   ";
echo "       5.安装redis                   ";
echo "       6.安装zookeeper               ";
echo "       7.安装RabbitMQ                ";
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
	mv apache-tomcat-7.0.70.tar.gz /usr/local/package/

}

#安装zabbix
install_zabbix(){
echo "开发中"
}

#安装mysql
install_mysql(){
	yum install -y mysql-server.x86_64
    yum install -y mysql-devel.x86_64

}

#安装redis
install_redis(){
	cd /usr/local/software
	wget http://download.redis.io/releases/redis-3.2.1.tar.gz
	tar -zxf redis-3.2.1.tar.gz
	mv redis-3.2.1.tar.gz /usr/local/package/
}

#安装zookeeper
install_zookeeper(){
	cd /usr/local/software
	wget http://mirrors.cnnic.cn/apache/zookeeper/zookeeper-3.4.8/zookeeper-3.4.8.tar.gz
	tar -zxf zookeeper-3.4.8.tar.gz
	mv zookeeper-3.4.8.tar.gz /usr/local/package/
}

#安装RabbitMQ
install_rabbitMQ(){
echo "开始下载安装包"
cd /usr/local/software
wget https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
rpm --import https://packages.erlang-solutions.com/rpm/erlang_solutions.asc

echo "开始配置yum源信息"
echo "" >> /etc/yum.repos.d/CentOS-Base.repo
echo "[erlang-solutions]" >> /etc/yum.repos.d/CentOS-Base.repo
echo "name=Centos $releasever - $basearch - Erlang Solutions" >> /etc/yum.repos.d/CentOS-Base.repo
echo "baseurl=https://packages.erlang-solutions.com/rpm/centos/$releasever/$basearch" >> /etc/yum.repos.d/CentOS-Base.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/CentOS-Base.repo
echo "gpgkey=https://packages.erlang-solutions.com/rpm/erlang_solutions.asc" >> /etc/yum.repos.d/CentOS-Base.repo
echo "enabled=1" >> /etc/yum.repos.d/CentOS-Base.repo

echo "开始安装erlang。。。"
yum install erlang -y
yum install esl-erlang -y
mv erlang-solutions-1.0-1.noarch.rpm /usr/local/package/
echo "erlang 安装结束"

echo "开始安装rabbitMQ"
wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.2/rabbitmq-server-generic-unix-3.6.2.tar.xz
yum install xz -y
xz -d rabbitmq-server-generic-unix-3.6.2.tar.xz
tar -xf rabbitmq-server-generic-unix-3.6.2.tar
mv rabbitmq-server-generic-unix-3.6.2.tar /usr/local/package/
rabbitmq_server-3.6.2/sbin/rabbitmq-server start &
echo "打开浏览器管理界面，登录名：'guest',密码：'guest'不能远程登录，只能用localhost"
rabbitmq_server-3.6.2/sbin/rabbitmq-plugins enable rabbitmq_management
echo "[  {rabbit, [{tcp_listeners, [5672]}, {loopback_users, ['admin']}]} ]." >> rabbitmq.config
echo "添加远程登录用户 admin 登录密码:admin"
rabbitmq_server-3.6.2/sbin/rabbitmqctl add_user admin admin
rabbitmq_server-3.6.2/sbin/rabbitmqctl set_user_tags admin  administrator
rabbitmq_server-3.6.2/sbin/rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"

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
	elif [ "$input_code" = "7" ]; then
	install_rabbitMQ
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
