FROM python:3
WORKDIR /app
COPY . /app
# WORKDIR /app/src/server
# RUN git clone https://github.com/ChakshuGautam/sql-graph.git sql_graph
RUN apt-get update && apt-get install -y libgraphviz-dev graphviz
RUN pip install -r requirements.txt
RUN pip install -r ./src/server/sql_graph/requirements.txt
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/graphviz
RUN LDFLAGS="-L/usr/lib/x86_64-linux-gnu/" CFLAGS="-I/usr/include/graphviz" pip install pygraphviz
EXPOSE 5078
CMD ["python", "./src/server/app.py"]
