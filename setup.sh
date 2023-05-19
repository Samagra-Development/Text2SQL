sh ./src/server/migrations/import_metadata.sh

python3 -m venv venv

source venv/bin/activate

pip install -r requirements.txt

sudo apt-get install libgraphviz-dev 
pip install -r src/server/sql_graph/requirements.txt
