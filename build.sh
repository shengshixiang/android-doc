#!/bin/bash

#有错误退出
set -e

make clean

make html

make docs
