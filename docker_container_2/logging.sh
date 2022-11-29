#!/bin/bash

while [[ true ]]; do
	date +"%H:%M:%S" >> /var/log/time.log
	sleep 5
done &

bash
