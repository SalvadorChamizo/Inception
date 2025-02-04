if [ ! -f "/etc/vsftpd.conf.bak" ]; then

    mkdir -p /var/www/html

    cp /etc/vsftpd.conf /etc/vsftpd.conf.bak

    sed -i "s|anonymous_enable=NO|anonymous_enable=YES|g" /etc/vsftpd.conf
    sed -i "s|#ftpd_banner=Welcome to blah FTP service.|ftpd_banner=Welcome to Inception FTC service|g" /etc/vsftpd.conf
    sed -i "s|listen=NO|listen=YES|g" /etc/vsftpd.conf
    sed -i "s|listen_ipv6=YES|#listen_ipv6=YES|g" /etc/vsdtpd.conf
    sed -i "s|anonymous_enable=NO|anonymous_enable=YES|g" /etc/vsftpd.conf

    echo "" >> /etc/vsftpd.conf

    echo "chroot_local_user=YES" >> /etc/vsftpd.conf
    echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf
    echo "user_sub_token=$USER" >> /etc/vsftpd.conf
    echo "local_root=/var/www/html" >> /etc/vsftpd.conf

    echo "" >> /etc/vsftpd.conf

    echo "listen_post=21" >> /etc/vsftpd.conf
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

    adduser $FTP_USER --disabled-password
    echo "$FTP_USER:$FTP_PASSWORD" | /usr/sbin/chpasswd &> /dev/null
    chown -R $FTP_USER:$FTP_USER /var/www/html

fi

/usr/sbin/vsftpd /etc/vsftpd.conf