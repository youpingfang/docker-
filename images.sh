#!/bin/bash
# -n docker shell
# -a zad
echo

save_images() {  #保存镜像函数
echo
docker images |awk   'NR>1 {print $1}' |awk -F "/" '{print $NF }'  #查询所有的docker镜像名

echo
read -r  -p  "输入镜像名,多个请用空格间隔: "  images
echo 

for i in $images
do
echo
echo  "镜像:$i开始save"
echo
name=$(docker images |grep $i |awk '{print $1":"$2}')  #获取镜像全量名称和tag
docker save -o ./$i.tar  $name    #load镜像
if [ $? -eq 0 ]; then
    echo -e "\033[40;32m  ----Load  $i image ok!----\033[0m"
    echo  -----------------------------------------------------------
else
    echo "Load  $i image failed!"
fi

done

}

load_images() { #加载镜像函数
echo
echo "本目录镜像tar文件如下: "
echo
ls -l |awk '{print $NF}'| grep tar$
echo
read -r  -p  "输入要load的镜像,多个输入空格间隔:"  load_images
echo
for j in $load_images
do
echo -e "镜像: $j 开始load"
docker load -i $load_images
echo -e "\033[40;32m ---- << load: $j镜像成功 >> ----\033[0m\n"
done

}


tar_x(){
echo
read -r  -p  "输入要解压的包名:" tar_x_file
tar -zxvf $tar_x_file
echo 
}

tar_c(){
echo
read -r  -p  "输入要压缩的包名:" tar_c_file
tar -zcvf $tar_c_file.tar.gz  $tar_c_file
echo
}

scp_file(){

echo
#echo 默认是root用户,默认文件传到/root路径下面
echo
read -r  -p  "默认是root用户,请输入目的IP:" ip
echo 
read -r  -p  "请输入源文件地址:" file_address
scp   $file_address   root@$ip:/root 


}

echo -e "\033[40;32m  1:镜像save 2:镜像load 3:tar压缩  4:scp 5:tar解压 . 选择数字操作镜像:   \033[0m"
echo
read -r  -p "> " num
echo
case $num in
    1)
        
        echo -e "\033[40;32m 开始选择Save镜像,所有的images如下:  \033[0m"
        
        save_images
        ;;
    2)
        
        echo -e "\033[40;32m  开始选择Load镜像,所有的images如下:  \033[0m"
        
        load_images
        ;;

    3)

        echo -e "\033[40;32m 开始选择压缩文件路径:  \033[0m"

        tar_c
        ;;
    4)

        echo -e " 默认是root用户,默认文件传到/root路径下面\033[0m"

        scp_file
        ;;

    5)

        echo -e "\033[40;32m  开始选择解压缩文件路径:  \033[0m"

        tar_x
        ;;



    *)
        
        echo -e "\033[40;31m  输入数字错误,请重新输入 \033[0m"
        echo
        ;;
esac

