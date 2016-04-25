These files will load [DfT Road Safety data](https://data.gov.uk/dataset/road-accidents-safety-data) into Elasticsearch. Two routes as used, via Logstash and R.

Load the index template first (either execute the cURL command, or run the PUT via [Sense](https://www.elastic.co/guide/en/sense/current/installing.html)). 

You can then then execute the .conf file through Logstash. Update the `.conf` file `path` to point to where you've downloaded and unzipped the data. 

    ./logstash-2.3.0/bin/logstash --auto-reload --config logstash-DfTRoadSafety_Accidents.conf

The template and conf include settings to load the geo data into geo-point Elasticsearch mapppings for subsequent use in Kibana.

Alternatively, run the R script to join the data and load it directly into Elasticsearch from R.

More info: rmoff.net/2016/04/24/denormalising-data-for-analysis-in-kibana/
