sh ./src/server/migrations/import_metadata.sh

pip install -r requirements.txt

sudo apt-get install libgraphviz-dev 
pip install -r src/server/sql_graph/requirements.txt
