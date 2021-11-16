# CC1-pipeline-martin

-- Nous allons tout d'abord nous placer sur la région "us-est-1" dans aws.
-- On remplace la clé publique dans key_pair.tf par la clé publique indiqué dans ssh-keys

# Partie 1

1) Il manque :

- Le fichier par rapport à la déclaration du bucket S3 pour envoyer les données après avoir terminé le traitement --> summary_destination
- Le fichier par rapport à la déclaration du data stream qui permettra d'ingérer les données avec datastream_ingestion

2) On créer un fichier S3_bucket.tf
avec --> summary_destination
et comme nom de bucket --> summary-destination-episen3-ds1-mdlg

# Create a S3 bucket - destination of the data pipeline
resource "aws_s3_bucket" "summary_destination" {
  bucket = "summary-destination-episen3-ds1-mdlg"
  acl    = "private"

  tags = {
    Name        = "S3 bucket"
    Environment = "test"
  }
}


-------- 

Nous allons également créer un fichier kinesis_datastream.tf :

resource "aws_kinesis_stream" "datastream_ingestion" {
  name        = "ingestion"
  shard_count = 1
  # The defaut retention period is 24h
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  tags = {
    Environment = "test"
  }
}

3) Nous allons maintenant tester la data pipeline :

Voir le dossier capture de la partie 1.

- On se connecter sur la vm ec2 : 

ssh -i "new-key-pair.pem" ec2-user@ec2-54-89-213-114.compute-1.amazonaws.com

On peut remarquer que ça marche bien --> voir capture

- On va maintenant installer le générateur de logs dans /tmp/logs

- Nous allons copier le fichier “agent.json” du répertoire Terraform dans le répertoire /etc/aws-kinesis de la VM 
EC2

- on démarre l'agent --> voir capture

on peut remarquer que ça marche bien !

4) Cette application sert à générer des fausses logs qui vont nous servir de données.

5) Cela permet de spécifier l'utilisateur et d'écrirer dans /home/user_data/

6) Il sert à faire le lien entre les logs et le kinesis data stream

7) 

On va modifier le code sql :

CREATE OR REPLACE PUMP "STREAM_PUMP" AS INSERT INTO "DESTINATION_SQL_STREAM"
SELECT STREAM ROWTIME as datetime, 
"response" as status, 
COUNT(*) AS statusCount FROM "SOURCE_SQL_STREAM_001" 
GROUP BY "response", STEP("SOURCE_SQL_STREAM_001".ROWTIME BY INTERVAL '60' SECOND);



#
# Partie 2

1) La partie ingestion :

- On commence par générer des fausses logs sur la vm ec2 qu'on va ensuite récupérer via le kinesis data streams datastream_ingestion

2) les données vont être stockées sur un bucket S3 summary_destination après avoir été transporté par kinesis data firehose depuis l'application

3) Les données vont être transformées dans kinesis data analytics avec legacy sql.

4) On pourra enfin récupérer les fichiers depuis notre bucket S3 afin de l'exposer ou bien faire une requête dessus depuis aws athena qui sert à faire des requêtes sql sur S3.

Voir le schéma dans le fichier partie 2

#
# Partie 3





