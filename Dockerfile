FROM python:3.10-slim-bullseye
WORKDIR /app
COPY . /app/
RUN pip install --no-cache-dir -r /app/library-management-system-master/requirements.txt
RUN pip install flask gunicorn
EXPOSE 5000
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=/app/library-management-system-master/app.py
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--log-level", "debug", "library_management_system_master.app:app"]
RUN apt-get update && apt-get install -y curl --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN echo "--- Listing /app contents ---"
RUN ls -R /app
RUN echo "--- Verifying Python import ---"
RUN python <<EOF
import os
import sys
print('Current working directory:', os.getcwd())
print('sys.path:', sys.path)
sys.path.insert(0, '/app')
print('Updated sys.path:', sys.path)
try:
    # Attempt to import the application module/callable
    from library_management_system_master.app import app
    print('app found and importable!')
except ImportError as e:
    print('ImportError: ' + str(e))
    sys.exit(1)
except SyntaxError as e:
    print('SyntaxError: ' + str(e))
    sys.exit(1)

EOF
RUN echo "--- Python import check complete ---"