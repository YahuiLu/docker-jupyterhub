FROM dclong/jupyterlab

RUN npm install -g configurable-http-proxy \
    && pip3 install --no-cache-dir jupyterhub \
    && npm cache clean --force

RUN apt-get update -y \
    && apt-get install -y openjdk-8-jdk \
    && apt-get install -y maven gradle \
    && apt-get autoremove \
    && apt-get clean 
    
RUN pip3 install --no-cache-dir --upgrade --ignore-installed entrypoints

RUN pip3 install --no-cache-dir \
        mypy pylint flake8 yapf pytest xonsh \
        numpy scipy pandas pyarrow==0.12.1 dask[complete] \
        scikit-learn xgboost \
        matplotlib bokeh holoviews[recommended] hvplot \
        tabulate \
        JPype1==0.6.3 JayDeBeApi sqlparse \
        requests[socks] lxml \
        nltk spacy pattern gensim jieba

RUN jupyter labextension install @pyviz/jupyterlab_pyviz \
    && npm cache clean --force
   
RUN sudo python -m nltk.downloader -d /usr/local/share/nltk_data all
    
ADD settings/jupyter_notebook_config.py /etc/jupyter/
ADD settings/jupyterhub_config.py /etc/jupyterhub/
ADD scripts /scripts

ENV M2_HOME=/usr/share/maven
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

EXPOSE 8000
