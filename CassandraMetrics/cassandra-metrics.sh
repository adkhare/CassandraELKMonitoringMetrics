#!/bin/bash

line_count=$(wc -l < /var/log/cassandra/metrics/metrics.tmp)
metric_count=$(wc -l < /var/log/cassandra/metrics/metrics-process.json)
line_count=$((line_count+1))
metric_count=$((metric_count+1))
host=$HOSTNAME
#echo $line_count
tail -n+$line_count /var/log/cassandra/metrics/metrics.out >> /var/log/cassandra/metrics/metrics.tmp
tail -n+$line_count /var/log/cassandra/metrics/metrics.tmp | sed 's/^$/}/g' | awk '{print "{"$0}' | sed 's/:}/:/g' | awk '/========================================================/{if (x)print x;x="";print "\n";next}{x=(!x)?$0:x"\n"$0;}END{print x;}' | sed 's/{}/}/g' | sed 's/{/{\"/g' | sed 's/}/\"}/g' | sed '/^$/d' | sed 's/$/\"/g' | sed 's/=/\"=\"/g' | tr -d " " | awk '/org.apache/{if (x)print x;x="";}{x=(!x)?$0:x","$0;}END{print x;}' | sed 's/,\"}/}/g' | sed 's/:/\":/g' | sed 's/:\",/:/g' | sed 's/}\"/}/g' | sed 's/},{/},/g' | sed 's/=/:/g' | sed 's/\",{\"/\",\"/g' | sed 's/$/}/g' | sed 's/:\"/:/g' | sed 's/\"}/}/g' | sed 's/\",\"/,\"/g' >> /var/log/cassandra/metrics/metrics-process.json
#echo $metric_count
count=$(wc -l < /var/log/cassandra/metrics/Cache.KeyCache.json)
count=$((count+1))
tail -n+$metric_count /var/log/cassandra/metrics/metrics-process.json | grep org.apache.cassandra.metrics.Cache.KeyCache | sed 's/requests\/s//g' | sed 's/hits\/s//g' >> /var/log/cassandra/metrics/Cache.KeyCache.json
tail -n+$count /var/log/cassandra/metrics/Cache.KeyCache.json > /var/log/cassandra/metrics/metric-cache_keycache-$(echo $host).json

count=$(wc -l < /var/log/cassandra/metrics/Compaction.json)
count=$((count+1))
tail -n+$metric_count /var/log/cassandra/metrics/metrics-process.json | grep org.apache.cassandra.metrics.Compaction | sed 's/compactioncompleted\/s//g' >> /var/log/cassandra/metrics/Compaction.json
tail -n+$count /var/log/cassandra/metrics/Compaction.json > /var/log/cassandra/metrics/metric-compaction-$(echo $host).json

count=$(wc -l < /var/log/cassandra/metrics/MemtableFlushWriter.json)
count=$((count+1))
tail -n+$metric_count /var/log/cassandra/metrics/metrics-process.json | grep org.apache.cassandra.metrics.ThreadPools.internal.MemtableFlushWriter >> /var/log/cassandra/metrics/MemtableFlushWriter.json
tail -n+$count /var/log/cassandra/metrics/MemtableFlushWriter.json > /var/log/cassandra/metrics/metric-memtableflushwriter-$(echo $host).json

count=$(wc -l < /var/log/cassandra/metrics/ColumnFamily.json)
icount=$((count+1))
tail -n+$metric_count /var/log/cassandra/metrics/metrics-process.json | grep org.apache.cassandra.metrics.ColumnFamily.o365 | sed 's/us,/,/g' | sed 's/us}/}/g'  | sed 's/calls\/s//g' | sed 's/\":\[/\":\"\[/g' | sed 's/},\"EstimatedRowSizeHistogram\"/\"},\"EstimatedRowSizeHistogram\"/g' | sed 's/},\"IndexSummaryOffHeapMemoryUsed\"/\"},\"IndexSummaryOffHeapMemoryUsed\"/g' >> /var/log/cassandra/metrics/ColumnFamily.json
tail -n+$count /var/log/cassandra/metrics/ColumnFamily.json > /var/log/cassandra/metrics/metric-columnfamily-$(echo $host).json

count=$(wc -l < /var/log/cassandra/metrics/Keyspace.json)
tail -n+$metric_count /var/log/cassandra/metrics/metrics-process.json | grep org.apache.cassandra.metrics.keyspace | sed 's/us,/,/g' | sed 's/us}/}/g'  | sed 's/calls\/s//g' | sed 's/}}}}/}}}/g' >> /var/log/cassandra/metrics/Keyspace.json
tail -n+$count /var/log/cassandra/metrics/Keyspace.json > /var/log/cassandra/metrics/metric-keyspace-$(echo $host).json

count=$(wc -l < /var/log/cassandra/metrics/CQL.json)
count=$((count+1))
tail -n+$metric_count /var/log/cassandra/metrics/metrics-process.json | grep org.apache.cassandra.metrics.CQL  >> /var/log/cassandra/metrics/CQL.json
tail -n+$count /var/log/cassandra/metrics/CQL.json > /var/log/cassandra/metrics/metric-cql-$(echo $host).json

count=$(wc -l < /var/log/cassandra/metrics/ClientRequest.json)
count=$((count+1))
tail -n+$metric_count /var/log/cassandra/metrics/metrics-process.json | grep org.apache.cassandra.metrics.ClientRequest | sed 's/us,/,/g' | sed 's/us}/}/g' | sed 's/calls\/s//g' | sed 's/unavailables\/s//g' | sed 's/timeouts\/s//g' >> /var/log/cassandra/metrics/ClientRequest.json
tail -n+$count /var/log/cassandra/metrics/ClientRequest.json > /var/log/cassandra/metrics/metric-clientrequest-$(echo $host).json

count=$(wc -l < /var/log/cassandra/metrics/Storage.json)
count=$((count+1))
tail -n+$metric_count /var/log/cassandra/metrics/metrics-process.json | grep org.apache.cassandra.metrics.Storage >> /var/log/cassandra/metrics/Storage.json
tail -n+$count /var/log/cassandra/metrics/Storage.json > /var/log/cassandra/metrics/metric-storage-$(echo $host).json

count=$(wc -l < /var/log/cassandra/metrics/DiskUsage.json)
count=$((count + 1))
#echo $count
df | grep "/opt/disk" | awk '{total = $2 * 1024 ; used = $3 * 1024 ; print "{\"diskusage.metrics\":{\"Disk\":\""$6 "\",\"Total\":" total ",\"Used\":" used "}}" }' | sed 's/\/opt\///g' >> /var/log/cassandra/metrics/DiskUsage.json
df | grep "/opt/disk" | awk '{total += $2 * 1024 ; used += $3 * 1024;} ; END {print "{\"diskusage.metrics\":{\"AggTotal\":" total ",\"AggUsed\":" used "}}" }' | sed 's/\/opt\///g' >> /var/log/cassandra/metrics/DiskUsage.json
tail -n+$count /var/log/cassandra/metrics/DiskUsage.json > /var/log/cassandra/metrics/metric-diskusage-$(echo $host).json

count=$(wc -l < /var/log/cassandra/metrics/CommitLog.json)
count=$((count + 1))
tail -n+$metric_count /var/log/cassandra/metrics/metrics-process.json | grep "org.apache.cassandra.metrics.CommitLog" | sed 's/us,/,/g' | sed 's/us}/    }/g' | sed 's/calls\/s//g' >> /var/log/cassandra/metrics/CommitLog.json
tail -n+$count /var/log/cassandra/metrics/CommitLog.json > /var/log/cassandra/metrics/metric-commitlog-$(echo $host).json

scp -i /root/.ssh/logcass /var/log/cassandra/metrics/metric-*.json logstash@<logstash-server>:var/log/
ssh -i /root/.ssh/logcass logstash@<logstash-server> 'cat var/log/metric-cache_keycache-'"$host"'.json >> var/log/logstash-cache_keycache-'"$host"'.json'
ssh -i /root/.ssh/logcass logstash@<logstash-server> 'cat var/log/metric-compaction-'"$host"'.json >> var/log/logstash-compaction-'"$host"'.json'
ssh -i /root/.ssh/logcass logstash@<logstash-server> 'cat var/log/metric-memtableflushwriter-'"$host"'.json >> var/log/logstash-memtableflushwriter-'"$host"'.json'
ssh -i /root/.ssh/logcass logstash@<logstash-server> 'cat var/log/metric-columnfamily-'"$host"'.json >> var/log/logstash-columnfamily-'"$host"'.json'
ssh -i /root/.ssh/logcass logstash@<logstash-server> 'cat var/log/metric-keyspace-'"$host"'.json >> var/log/logstash-keyspace-'"$host"'.json'
ssh -i /root/.ssh/logcass logstash@<logstash-server> 'cat var/log/metric-cql-'"$host"'.json >> var/log/logstash-cql-'"$host"'.json'
ssh -i /root/.ssh/logcass logstash@<logstash-server> 'cat var/log/metric-clientrequest-'"$host"'.json >> var/log/logstash-clientrequest-'"$host"'.json'
ssh -i /root/.ssh/logcass logstash@<logstash-server> 'cat var/log/metric-storage-'"$host"'.json >> var/log/logstash-storage-'"$host"'.json'
ssh -i /root/.ssh/logcass logstash@<logstash-server> 'cat var/log/metric-diskusage-'"$host"'.json >> var/log/logstash-diskusage-'"$host"'.json'
ssh -i /root/.ssh/logcass logstash@<logstash-server> 'cat var/log/metric-commitlog-'"$host"'.json >> var/log/logstash-commitlog-'"$host"'.json'

