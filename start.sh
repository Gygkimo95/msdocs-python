#!/bin/bash

# 设置变量
APP_DIR="/test"  # 替换为实际的应用代码包路径
FLASK_HOST="0.0.0.0"
FLASK_PORT=5000  # 替换为实际使用的端口号，如果不是5000

# 切换到代码包路径下
cd "$APP_DIR" || { echo "Error: Unable to change directory to $APP_DIR"; exit 1; }

# 检查是否已经安装 python3
if ! command -v python3 &>/dev/null; then
  echo "Python3 is not installed. Installing..."
  yum install -y python3 || { echo "Error: Failed to install python3"; exit 1; }
else
  echo "Python3 is already installed."
fi

# 确保虚拟环境目录存在
if [[ ! -d ".venv" ]]; then
  echo "Creating virtual environment..."
  python3 -m venv .venv || { echo "Error: Failed to create virtual environment"; exit 1; }
else
  echo "Virtual environment already exists."
fi

# 激活虚拟环境
source .venv/bin/activate || { echo "Error: Failed to activate virtual environment"; exit 1; }

# 检查是否已经安装 Flask
if ! python3 -m pip show flask &>/dev/null; then
  echo "Flask is not installed. Installing..."
  # 升级 pip
  pip install --upgrade pip || { echo "Error: Failed to upgrade pip"; exit 1; }
  # 安装 Flask
  pip install -i https://mirrors.aliyun.com/pypi/simple flask || { echo "Error: Failed to install Flask"; exit 1; }
else
  echo "Flask is already installed."
fi

# 检查并终止已有的 Flask 进程
FLASK_PID=$(lsof -t -i:$FLASK_PORT)
if [ -n "$FLASK_PID" ]; then
  echo "Terminating existing Flask process with PID $FLASK_PID..."
  kill -9 "$FLASK_PID" || { echo "Error: Failed to terminate Flask process"; exit 1; }
fi

# 启动 Flask 应用并使其在后台运行
nohup flask run -h $FLASK_HOST -p $FLASK_PORT > flask.log 2>&1 &

# 打印提示信息
echo "Flask application started in the background. Logs are available in flask.log."
