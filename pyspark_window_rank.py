#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Ed Mountjoy
#
'''
Joins the drug data with the genetic and network scores

# Set SPARK_HOME and PYTHONPATH to use 2.4.0
export PYSPARK_SUBMIT_ARGS="--driver-memory 8g pyspark-shell"
export SPARK_HOME=/Users/em21/software/spark-2.4.0-bin-hadoop2.7
export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-2.4.0-src.zip:$PYTHONPATH
'''

import os
import sys
import pyspark.sql
from pyspark.sql.types import *
from pyspark.sql.functions import *
from pyspark.sql.window import Window

def main():

    # Args
    in_data = 'output_data/19.06_evidence_data.unaggregated.parquet'
    out_path = 'output_data/19.06_evidence_data.aggregated.parquet'
    
    # Make spark session
    global spark
    spark = (
        pyspark.sql.SparkSession.builder
        # .config("spark.master", "local[16]")
        # .config("spark.local.dir", "/local/scratch/edm/spark-temp")
        .getOrCreate()
    )
    print('Spark version: ', spark.version)
    
    # Load data
    data = (
        spark.read.parquet(in_data)
    )

    # Use window function to add rank info
    window_spec = (
        Window
        .partitionBy('target_ensembl_id', 'drug_name', 'disease_id')
        .orderBy(desc('evidence_trial_phase_num'), 'tiebreak')
    )
    agg = (
        agg
        .withColumn('tiebreak', monotonically_increasing_id())
        .withColumn('rn', row_number().over(window_spec))
        .filter(col('rn') == 1)
        .drop('rn', 'tiebreak')
    )

    #
    # Broadcast dict ----------------------------------------------------------
    #
    
    eco_dict = spark.sparkContext.broadcast(load_eco_dict(in_csq_eco))
    
    # Extract most sereve csq per gene.
    get_most_severe = udf(
        lambda arr: sorted(arr, key=lambda x: eco_dict.value.get(x, 0), reverse=True)[0],
        StringType()
    )

    return 0

if __name__ == '__main__':

    main()
