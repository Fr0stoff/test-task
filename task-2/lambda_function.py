from datetime import datetime

import boto3
import pymongo as pymongo

DEFAULT_REGION = "us-east-1"

client = boto3.client('ec2', region_name=DEFAULT_REGION)
regions = [region['RegionName'] for region in client.describe_regions()['Regions']]

connection_string = "mongodb://dbuser05:dbuser05@describedb.cluster-cwa0oeuwilw4.eu-central-1.docdb.amazonaws.com:27017/?tls=true&tlsCAFile=pem/global-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"

debug=True

db_client = pymongo.MongoClient(connection_string)
db = db_client.vpcs_subnets_watcher
db_col = db.periodic

def extract_tags(tags):
    if tags:
        for each_tag in tags:
            k, v = each_tag.values()
            if k == "Name":
                return v
    return None

def lambda_handler(event, context):
    for each_region in regions:
        ec2 = boto3.resource('ec2', region_name=each_region)
        vpc_list = ec2.vpcs.all()

        __vpc_obj = []

        for vpc in list(vpc_list):
            for each_subnet in list(vpc.subnets.all()):
                date_time_now = datetime.now()
                tag_name = extract_tags(each_subnet.tags)
                if debug:
                    print(
                        f"{date_time_now} [!] NAME: {tag_name} VPC {each_subnet.vpc_id} have subnet: {each_subnet.id} "
                        f"with CIDR block {each_subnet.cidr_block} "
                    )
                __vpc_obj.append({
                    "tag": tag_name,
                    "vpn_id": each_subnet.vpc_id,
                    "subnet_id": each_subnet.id,
                    "cidr_block": each_subnet.cidr_block,
                    "created_at": date_time_now
                })

        db_col.insert_many(__vpc_obj)

#lambda_handler(None, None)
