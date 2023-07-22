sh ./src/server/migrations/import_metadata.sh

sudo apt-get update
sudo apt-get install python3-venv

# Create and activate a virtual environment (without sudo)
python3 -m venv venv
source venv/bin/activate

# Install dependencies inside the virtual environment (without sudo)
pip3 install -r requirements.txt

# Additional installations (without sudo)
sudo apt-get install python3-dev libgraphviz-dev
pip3 install -r src/server/sql_graph/requirements.txt
python3 src/server/app.py
