#!/bin/bash
gunicorn -w 4 -k uvicorn.workers.UvicornWorker course_recommender_apis:app
# -w 4,  --bind 0.0.0.0:8000 --timeout 120