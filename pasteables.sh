#!/bin/bash

function baseline () {
  # <ignore>
  echo "<output>"
  echo "<baseline>"
  echo "<hostname>`hostname`</hostname>"
  echo "<netstat>$(netstat -pant | grep 'LISTEN')</netstat>"
  echo "<interfaces>$(ip -o addr show scope global | cut -d "\\" -f1)</interfaces>"
  echo "</baseline>"
  echo "</output>"
  # </ignore>
}
