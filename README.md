# CassandraELKMonitoringMetrics
This is used for monitoring varied metrics from Cassandra to ELK Stack

##cassandra-metrics-reporting.yaml
    This is the configuration file for metrics library of Cassandra. It emits the metrics to the file mentioned in the configuration.

##cassandra-env.sh
    This is the cassandra-env.sh file containing configuration for enabling the metrics library
    
##logstash-cassandra-metrics.conf
    This is the configuration file for logstash which takes file input and writes to ElasticSearch.
    
##cassandra-metrics.sh
    This is the shell script which will parse the out file to form a JSON which then will be transferred to logstash