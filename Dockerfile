FROM python:3.11.3-alpine3.18
LABEL mantainer="amaurisantospro@gmail.com"

# This environment variable is used to control whether Python must
# write bytecode files (.pyc) on disk. 1 = No, 0 = Yes
ENV PYTHONDONTWRITEBYTECODE 1

# Defines that Python output will be displayed iemediately on the 
# console or in other output devices, without being stored in the buffer.
# In summary, you will see outputs from Python in real-time.
ENV PYTHONUNBUFFERED 1

# Copy the "djangoapp" and "scripts" folders inside the container.
COPY ./djangoapp /djangoapp
COPY .scripts /scripts

# Enter in "djangoapp" folder on container
WORKDIR /djangoapp

# The 8000 port will be available for external connections to the container
# It's the port that we will use for the Django.
EXPOSE 8000

# RUN executa comandos em um shell dentro do container para construir a imagem. 
# O resultado da execução do comando é armazenado no sistema de arquivos da 
# imagem como uma nova camada.
# Agrupar os comandos em um único RUN pode reduzir a quantidade de camadas da 
# imagem e torná-la mais eficiente.
RUN python -m venv /venv && \
  /venv/bin/pip install --upgrade pip && \
  /venv/bin/pip install -r /djangoapp/requirements.txt && \
  adduser --disabled-password --no-create-home wuser && \
  mkdir -p /data/web/static && \
  mkdir -p /data/web/media && \
  chown -R wuser:wuser /venv && \
  chown -R wuser:wuser /data/web/static && \
  chown -R wuser:wuser /data/web/media && \
  chmod -R 755 /data/web/static && \
  chmod -R 755 /data/web/media && \
  chmod -R +x /scripts

# Adiciona a pasta scripts e venv/bin 
# no $PATH do container.
ENV PATH="/scripts:/venv/bin:$PATH"

# Muda o usuário para wuser
USER wuser

# Executa o arquivo scripts/commands.sh
CMD ["commands.sh"]