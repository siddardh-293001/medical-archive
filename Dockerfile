FROM python:3.12-slim

WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    STREAMLIT_BROWSER_GATHER_USAGE_STATS=false

ADD app-source.tar.gz /app/
RUN pip install --no-cache-dir -r requirements-dashboard.txt

EXPOSE 8501
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD python -c "import os, urllib.request; urllib.request.urlopen('http://127.0.0.1:' + os.getenv('PORT', '8501') + '/_stcore/health', timeout=3)"
CMD ["sh", "-c", "exec python -m streamlit run dashboard/app.py --server.address=0.0.0.0 --server.port=${PORT:-8501}"]
