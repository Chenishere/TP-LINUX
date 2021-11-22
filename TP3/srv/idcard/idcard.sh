source /etc/os-release
# This is an ID card script by Yanice, run it as sudo for no right problems ans install curl for the random cat meme. Have fun !
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

echo "Top 5 processes by RAM usage :"

echo "- $(ps --sort -rss -eo %mem,cmd,pid | head -1)"
echo "- $(ps --sort -rss -eo %mem,cmd,pid | head -2 | tail -n+2)"
echo "- $(ps --sort -rss -eo %mem,cmd,pid | head -3 | tail -n+3)"
echo "- $(ps --sort -rss -eo %mem,cmd,pid | head -4 | tail -n+4)"
echo "- $(ps --sort -rss -eo %mem,cmd,pid | head -5 | tail -n+5)"
echo "- $(ps --sort -rss -eo %mem,cmd,pid | head -6 | tail -n+6)"

echo "Listening ports :"
lsof -i -P | grep LISTEN | uniq -w 20 | awk '{print "- " $9 " : " $1}' | tr ":" " " | awk '{print " - " $3 " : " $4}'

randomcat=$(curl https://api.thecatapi.com/v1/images/search --silent | cut -d'"' -f10)
echo "Here's your random cat : "$randomcat
