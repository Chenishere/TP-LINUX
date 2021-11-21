# This is an ID card script by Yanice, run it as sudo for no right problems ans install curl for the random cat meme. Have fun !
source /etc/os-release
MachineName=$(hostname)
echo "Machine name : $MachineName"

name=${NAME}
Kernelversion=${VERSION_ID}
echo "Os" $name "and kernel version is" $Kernelversion

ip=$(ip a | grep -w inet | sed -n '3p' | cut -d "d" -f2 | cut -d " " -f2 )
echo "IP : $ip"

ramtotal=$(free -mh | grep Mem | awk '{print $2}')
ramavailable=$(free -mh | grep Mem | awk '{print $7}')
echo "RAM : $ramavailable RAM restante sur $ramtotal RAM totale"

echo "Disque : $(df -h | grep /dev/sda5 | cut -d" " -f12) left"

Top5="$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | grep -v PPID | head -n 5)"
echo "Top 5 processes by RAM usage :"
echo "$Top5" | while read line
do
  echo "  - $line"  
done

echo "Listening ports :"
ss -alnpt | sed "1 d" | while read  line
do
    ports=$(echo $line | tr -s ' ' | cut -d' ' -f4 | rev | cut -d':'  -f1 | rev)
    echo "- $ports : "
done

randomcat=$(curl https://api.thecatapi.com/v1/images/search --silent | cut -d'"' -f10)
echo "Here's your random cat : "$randomcat
