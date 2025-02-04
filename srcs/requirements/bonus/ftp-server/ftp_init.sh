sed -i "s|anonymous_enable=NO|anonymous_enable=YES|g" /etc/vsftpd.conf
sed -i "s|#ftpd_banner=Welcome to blah FTP service.|ftpd_banner=Welcome to Inception FTC service|g" /etc/vsftpd.conf
echo "chroot_local_user=YES" >> /etc/vsftpd.conf