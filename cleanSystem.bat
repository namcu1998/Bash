#! /bin/bash

cd /sdcard

sleep 1

echo "Xoá tập tin không sử dụng trong 30 ngày"

find . -type f -mtime +30 -delete

sleep 1

echo "Xoá thư mục trống"

find . -type d -empty -delete

termux-notification --content "Đã dọn dẹp"
