FROM oggm/oggm:latest

RUN useradd -ms /bin/bash bokeh
USER bokeh
WORKDIR /home/bokeh

RUN python3 -m venv --system-site-packages venv

ENV PATH=/home/bokeh/venv/bin:$PATH
ENV PIP=/home/bokeh/venv/bin/pip PYTHON=/home/bokeh/venv/bin/python

RUN $PIP install --no-cache-dir --upgrade pip wheel setuptools
RUN $PIP install --no-cache-dir --upgrade bokeh "tornado<6" jupyter
RUN $PIP install --no-cache-dir --upgrade panel holoviews geoviews datashader colorcet pyviz-comms param hvplot tables

RUN python3 -c 'import oggm; oggm.utils.download_oggm_files()'

ENV \
	BOKEH_ALLOW_WS_ORIGIN=auto \
	BOKEH_NUM_PROCS=0 \
	BOKEH_PREFIX=/ \
	BOKEH_DEV=false \
	BOKEH_DOCS_CDN=local

EXPOSE 8080

COPY run_bokeh.sh /home/bokeh/run.sh
ENTRYPOINT ["/home/bokeh/run.sh"]
