#!/bin/bash

#
# This script executes $maxjobs commands in parallel 
# It will monitor for job completion and automatically
# start the next job so there are always $maxjobs running
#
#
# For example, if you want to run some program with a
# number of different combinations of parameters (param1 and param2 in
# the example below), you can place it in the next_job function and
# pass the parameter combination required for that job
# 
#

#max # of jobs to run in parallel
let maxjobs=6

#how often to check if a job has completed (in seconds)
let pollTime=15

next_job() {

    #place the code you want to execute in parallel in this function
    #any code in here will be executed in the background along
    #with other jobs. pass any parameters required

    p1=$1
    p2=$2
    echo "executing job with param $p1 $p2"
    
    #execute some program here

}

#number of jobs currently running
let running=0

#example with two parameters
for param1 in 1 2 3 4
do
    for param2 in 9 8 7 6
    do

        #start a new job
        next_job $param1 $param2 &
        let running=$running+1
        
        #maximum number of jobs are running
        if [ $running -eq $maxjobs ]
	then
	    
	    #wait for any of the jobs to finish
	    while [ 1 ] ;
	    do
	        pids=`jobs -p`
	        set -- $pids
	        
	        #max jobs still running
	        if [ $# -eq $maxjobs ];
	        then
	            sleep $pollTime
	        else
	            #at least one job finished
                    #break and let another one start
	            let running=$running-1
	            break
	        fi
	    done
        fi
    done
done

#wait for any remaining jobs
wait

#do any post processing
  
