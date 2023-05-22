FROM python:3
WORKDIR /app
COPY . /app
# WORKDIR /app/src/server
# RUN git clone https://github.com/ChakshuGautam/sql-graph.git sql_graph
# WORKDIR /app
RUN apt-get update && apt-get install -y libgraphviz-dev graphviz
RUN pip install -r requirements.txt
RUN pip install -r src/server/sql_graph/requirements.txt
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/graphviz
RUN pip install --global-option=build_ext --global-option="-I/usr/include/graphviz" --global-option="-L/usr/lib/x86_64-linux-gnu/" --install-option="--library-path=/usr/lib/x86_64-linux-gnu/graphviz" pygraphviz
EXPOSE 5078
CMD ["python", "src/server/app.py"]