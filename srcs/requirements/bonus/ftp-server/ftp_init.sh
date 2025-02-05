#!/bin/bash

if [ ! -f "/etc/vsftpd.conf.bak" ]; then

    mkdir -p /var/www/html
    mkdir -p /var/run/vsftpd/empty

    cp /etc/vsftpd.conf /etc/vsftpd.conf.bak

    sed -i "s|anonymous_enable=NO|anonymous_enable=YES|g" /etc/vsftpd.conf
    sed -i "s|#ftpd_banner=Welcome to blah FTP service.|ftpd_banner=Welcome to Inception FTC service|g" /etc/vsftpd.conf
    sed -i "s|listen=NO|listen=YES|g" /etc/vsftpd.conf
    sed -i "s|listen_ipv6=YES|#listen_ipv6=YES|g" /etc/vsftpd.conf
    sed -i "s|anonymous_enable=NO|anonymous_enable=YES|g" /etc/vsftpd.conf
    sed -i "s|secure_chroot_dir=/var/run/vsftpd/empty|#secure_chroot_dir=/var/run/vsftpd/empty|g" /etc/vsftpd.conf
    sed -i "s|#write_enable=YES|write_enable=YES|g" /etc/vsftpd.conf


    echo "" >> /etc/vsftpd.conf

    echo "chroot_local_user=YES" >> /etc/vsftpd.conf
    echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf
    echo "user_sub_token=$FTP_USER" >> /etc/vsftpd.conf
    echo "local_root=/var/www/html" >> /etc/vsftpd.conf

    echo "" >> /etc/vsftpd.conf

    echo "listen_port=21" >> /etc/vsftpd.conf
    echo "listen_address=0.0.0.0" >> /etc/vsftpd.conf
    echo "seccomp_sandbox=NO" >> /etc/vsftpd.conf

    echo "" >> /etc/vsftpd.conf

    echo "pasv_enable=YES" >> /etc/vsftpd.conf
    echo "pasv_max_port=21100" >> /etc/vsftpd.conf
    echo "pasv_max_port=21110" >> /etc/vsftpd.conf

    echo "" >> /etc/vsftpd.conf

    echo "userlist_enable=YES" >> /etc/vsftpd.conf
    echo "userlist_file=/etc/vsftpd.userlist" >> /etc/vsftpd.conf
    echo "userlist_deny=NO" >> /etc/vsftpd.conf

    #adduser --disabled-password --gecos "" "$FTP_USER"
    useradd -m -d /var/www "$FTP_USER" && echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    usermod -aG www-data "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    chown -R $FTP_USER:$FTP_USER /var/www/html
    echo "$FTP_USER" | tee -a /etc/vsftpd.userlist > /dev/null
    chown -R www-data /var/www
    chmod -R 777 /var/www
fi

/usr/sbin/vsftpd /etc/vsftpd.conf
