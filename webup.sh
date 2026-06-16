
while [ "a" = "a" ]
do
 DEFAULT=`curl -s http://34.148.125.179/index.html`
 OUT_3D=`curl -s https://3dlifestrategies.org/index.html | grep "3D Life Strategies" | head -1 | cut -c1-50`
 echo "`date` | 3D | $OUT_3D" | tee -a /tmp/webup.log
 echo "`date` | DEFAULT | $DEFAULT" | tee -a /tmp/webup.log
 sleep 60 
done

