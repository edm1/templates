#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Ed Mountjoy
#
'''
# You need the JDBC sqlite driver from https://bitbucket.org/xerial/sqlite-jdbc/downloads/ e.g.
mkdir -p ~/software/jdbc
cd ~/software/jdbc
wget https://bitbucket.org/xerial/sqlite-jdbc/downloads/sqlite-jdbc-3.30.1.jar


# Then submit the script using e.g.
spark-submit --driver-class-path ~/software/jdbc/sqlite-jdbc-3.30.1.jar --jars ~/software/jdbc/sqlite-jdbc-3.30.1.jar pyspark_sqlite.py

'''

import os
import sys
import pyspark.sql
from pyspark.sql.types import *
from pyspark.sql.functions import *
from pyspark.sql.window import Window
import sqlite3
from pprint import pprint

def main():

    # Args
    in_path = 'example_data/phenotypes.sqlite'

    #
    # Get tables and schemas --------------------------------------------------
    #

    # Using python sqlite3
    schemas = get_sqlite_tables_schemas(in_path)
    print(list(schemas.keys()))
    # pprint("Full schemas", schemas)

    #
    # Load in spark -----------------------------------------------------------
    #

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
    data = spark.read.jdbc(
        url=f'jdbc:sqlite:{in_path}',
        table=list(schemas.keys())[0],
    )

    data.show()
    data.printSchema()

    return 0

def get_sqlite_tables_schemas(in_path):
    ''' Loads tables and schemas from sqlite
    Params:
        in_path (str): path to sqlite db
    Returns:
        dict {table_name: list of tuples}
    '''
    # Connect
    db = sqlite3.connect(in_path)
    cursor = db.cursor()
    
    # Get table names
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = [i[0] for i in cursor.fetchall()]

    # Get schemas for each table
    schemas = {}
    for table in tables:
        schemas[table] = []
        for row in cursor.execute(f"PRAGMA table_info('{table}')").fetchall():
            schemas[table].append(row)
    
    # Close connection
    cursor.close()
    db.close()

    return schemas

if __name__ == '__main__':

    main()
