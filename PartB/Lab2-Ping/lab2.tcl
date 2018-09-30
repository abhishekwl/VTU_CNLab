#Create Simulator ad trace and nam files
set ns [new Simulator]
set tf [open lab2.tr w]
$ns trace-all $tf
set nm [open lab2.nam w]
$ns namtrace-all $nm



#Creating nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]



#Creating labels
$n0 label "ping 0"
$n4 label "ping 4"
$n5 label "ping 5"
$n6 label "ping 6"
$n2 label "router"

#Setting colors
$ns color 1 "red"
$ns color 2 "blue"
$ns color 3 "brown"
$ns color 4 "yellow"



#Creating Links- IP data rate > Op Data rate
$ns duplex-link $n0 $n2 100Mb 300ms DropTail
$ns duplex-link $n2 $n4 1Mb 300ms DropTail

$ns duplex-link $n5 $n2 100Mb 300ms DropTail
$ns duplex-link $n2 $n6 1Mb 300ms DropTail

$ns duplex-link $n1 $n2 1Mb 300ms DropTail
$ns duplex-link $n3 $n2 1Mb 300ms DropTail



#Create queue limits
$ns set queue-limit $n0 $n2 3
$ns set queue-limit $n2 $n4 5

$ns set queue-limit $n5 $n2 2
$ns set queue-limit $n2 $n6 5



#Connecting Ping Agents
set ping0 [new Agent/Ping]
$ns attach-agent $n0 $ping0

set ping4 [new Agent/Ping]
$ns attach-agent $n4 $ping4

set ping5 [new Agent/Ping]
$ns attach-agent $n5 $ping5

set ping6 [new Agent/Ping]
$ns attach-agent $n6 $ping6



#Setting traffic for ping0 & ping 5 as only they act as source
$ping0 set packetSize_ 500
$ping0 set interval_ 0.001 

$ping5 set packetSize_ 600
$ping5 set interval_ 0.001 



#Connect Src-->Dest via pings
$ns connect $ping0 $ping4 
$ns connect $ping5 $ping6 

#Assigning colors to src nodes
$ping0 set class_ 1
$ping5 set class_ 2
$ping4 set class_ 3
$ping6 set class_ 4




#To define procedures
proc sendPingPacket {} {
	global ns ping0 ping5
	set intervalTime 0.0001
	set now [$ns now]
	$ns at [expr $now+$intervalTime] "$ping0 send"
	$ns at [expr $now+$intervalTime] "$ping5 send"
	$ns at [expr $now+$intervalTime] "sendPingPacket"
}
$ns at 0.01 "sendPingPacket"


Agent/Ping instproc recv {from rtt} {
	$self instvar node_
	puts "The node [$node_ id] received a reply from $from with roundtrip time $rtt"
}


proc finish {} {
	global ns tf nm
	$ns flush-trace
	exec nam lab2.nam &
	close $tf
	close $nm
	exit 0
}
$ns at 2.0 "finish"
$ns run














