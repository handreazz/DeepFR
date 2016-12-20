#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <Output with label:./results/output_with_label>"
  exit
fi

OUTPUT=$1

if [ ! -f $OUTPUT ]
then
  echo "$OUTPUT does not exist."
  exit
fi

echo "$0 $1"

dir=`dirname $(readlink -f $0)`
L_DATA=$dir/list

mkdir -p ./tmp

echo "Calculating correctly predicted template at family level(Top1, Top5): "
$dir/calculate_top1_top5.py $OUTPUT $L_DATA/scoptest_family

echo "Calculating correctly predicted template at superfamily level(Top1, Top5): "
grep -F -v -f  $L_DATA/scoptest_family $OUTPUT > ./tmp/deleted-family
$dir/calculate_top1_top5.py ./tmp/deleted-family $L_DATA/scoptest_superfamily

echo "Calculating correctly predicted template at fold level(Top1, Top5): "
grep -F -v -f $L_DATA/scoptest_superfamily ./tmp/deleted-family > ./tmp/deleted-family-super
$dir/calculate_top1_top5.py ./tmp/deleted-family-super $L_DATA/scoptest_fold

rm -r ./tmp
