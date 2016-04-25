curl -XPUT "http://localhost:9200/_template/dftroadsafetyaccidents" -d'
{
  "template": "dftroadsafetyaccidents*",
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  },
  "mappings": {
    "_default_": {
      "dynamic_templates": [
        {
          "string_fields": {
            "mapping": {
              "index": "not_analyzed",
              "omit_norms": true,
              "type": "string"
            },
            "match_mapping_type": "string",
            "match": "*"
          }
          } , {
          "timestamp_field": {
            "mapping": {
              "type": "date",
              "format": "yyyy-MM-dd HH:mm:ss"
            },
            "match": "timestamp"
          }
        }
      ],
      "_all": {
        "enabled": true
      },
      "properties": {
        "location": { "type": "geo_point" }

      }
    }
  }
}
'
