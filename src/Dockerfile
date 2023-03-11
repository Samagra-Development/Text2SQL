FROM python:3
WORKDIR app
COPY . /app
RUN pip install -r requirements.txt
EXPOSE 5078
CMD ["python", "src/server/app.py"]