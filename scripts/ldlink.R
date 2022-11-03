#!/usr/bin/env Rscript

args<-commandArgs(TRUE)

library(LDlinkR)

rsids <- read.table(args[1], header = FALSE, sep = "\n")
dim(rsids)
LDproxy_batch(snp = rsids, token = '01d8ccb6f9f1',append=TRUE)

