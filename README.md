# CassandraELKMonitoringMetrics
This is used for monitoring all metrics from Cassandra to ELK (ElasticSearch, LogStash, Kibana) Stack

#Overview
Many organisation used cassandra as NoSQL database to handle large amount of data. so its necessary to monitor health of cassandra clusters. Cassandra is a famous NoSQL database and there is no any free monitoring tool  available. 
ELK is a good solution for this and provide real time monitoring of clusters nodes.

#Key features
*	Load on Cluster Nodes
*	Process Status
*	Input/output statistics
*	Pending tasks
*	Read latency
*	Write latency

##cassandra-metrics-reporting.yaml
    This is the configuration file for metrics library of Cassandra. It emits the metrics to the file mentioned in the configuration.

##cassandra-env.sh
    This is the cassandra-env.sh file containing configuration for enabling the metrics library
    
##logstash-cassandra-metrics.conf
    This is the configuration file for logstash which takes file input and writes to ElasticSearch.
    
##cassandra-metrics.sh
    This is the shell script which will parse the out file to form a JSON which then will be transferred to logstash