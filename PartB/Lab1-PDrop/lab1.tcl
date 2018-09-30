#Create Simulator
set ns [new Simulator]
set tf [open lab1.tr w]
$ns trace-all $tf
set nf [open lab1.nam w]
$ns namtrace-all $nf

#Creating nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]


#Setting colors
$ns color 1 "red"
$ns color 2 "blue"


#Creating labels
$n0 label "Source/UDP0"
$n1 label "Source/UDP1"
$n2 label "Router"
$n3 label "Dest/Null"


#Creating Links
$ns duplex-link $n0 $n2 10Mb 300ms DropTail
$ns duplex-link $n1 $n2 10Mb 300ms DropTail
$ns duplex-link $n2 $n3 1Mb 300ms DropTail


#Create queue limits
$ns set queue-limit $n0 $n2 10
$ns set queue-limit $n1 $n2 10
$ns set queue-limit $n2 $n3 5


#Specifying the connection type for node 0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0


#Specifying the connection type for node 1
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

set null3 [new Agent/Null]
$ns attach-agent $n3 $null3

$udp0 set class_ 1
$udp1 set class_ 2

$ns connect $udp0 $null3
$ns connect $udp1 $null3
$cbr1 set packetSize_ 500Mb
$cbr1 set interval_ 0.005

proc finish {} {
	global ns tf nf
	$ns flush-trace
	exec nam lab1.nam &
	close $tf
	close $nf
	exit 0
}

$ns at 0.1 "$cbr0 start"
$ns at 0.1 "$cbr1 start"
$ns at 10.00 "finish"
$ns run
