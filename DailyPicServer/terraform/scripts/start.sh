#! /usr/bin/env bash

pkill swift
cd .build/release
./DailyPicServer
cd -
