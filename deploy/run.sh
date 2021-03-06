sudo chmod +x master.sh
sudo chmod +x webservice.sh
sudo chmod +x mining.sh

if [ "$1" == "clean" ]; then
rm -rf ./8082 ./8083 ./8084
rm -rf master8000.txt
rm -rf master8001.txt
rm -rf master8002.txt
rm -rf mining.txt
else if [ "$1" == "run" ]; then
./master.sh run 8000
tail -f -n 1 master8000.txt | echo | grep -qe "Started Master"
./master.sh run 8001
tail -f -n 1 master8001.txt | echo | grep -qe "Started Master"
./master.sh run 8002
tail -f -n 1 master8002.txt | echo | grep -qe "Started Master"
./mining.sh run
./webservice.sh run
else if [ "$1" == "start" ]; then
echo "Starting masters at 8000, 8001, 8002"
./master.sh start 8000
tail -f master8000.txt | while read LOGLINE
do
[[ "${LOGLINE}" == *"Started Master"* ]] && pkill -P $$ tail
done
./master.sh start 8001
tail -f master8001.txt | while read LOGLINE
do
[[ "${LOGLINE}" == *"Started Master"* ]] && pkill -P $$ tail
done
./master.sh start 8002
tail -f master8002.txt | while read LOGLINE
do
[[ "${LOGLINE}" == *"Started Master"* ]] && pkill -P $$ tail
done
PID=$(ps -ef | grep "Master-1.0-SNAPSHOT.jar" | grep -v grep | awk '{ print $2 }')
echo "Masters started. Showing the PIDs"
echo $PID
echo "Starting miner"
./mining.sh start
echo "Starting WebService at 8070"
./webservice.sh start
# echo "Starting Databases at 8082, 8083, 8084"
# ./database.sh start 8082
# ./database.sh start 8083
# ./database.sh start 8084
else if [ "$1" == "stop" ]; then
./master.sh stop
./mining.sh stop
./webservice.sh stop
./database.sh stop
if [ -z "$PID" ]; then
echo Application is already stopped
else
echo kill $PID
kill $PID
fi
else if [ "$1" == "status" ]; then
./master.sh status
./mining.sh status
./webservice.sh status
if [ -z "$PID" ]; then
echo Application is stopped
else
echo Application is running
echo $PID
fi
fi
fi
fi
fi
fi
