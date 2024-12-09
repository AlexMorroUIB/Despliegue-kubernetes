#!/bin/sh -l

echo "Checking status"
status=$(curl localhost$1)
echo "Status is $status " >> $GITHUB_OUTPUT

