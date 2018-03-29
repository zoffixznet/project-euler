set -x
while true
do
    arc='euler621-backup.tar'
    tar -cavf "$arc" parts/
    sky up "$arc"
    countdown 12m
done
