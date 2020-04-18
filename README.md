# CSC336 DATABASE PROJECT

## PROJECT NAME: VESTIGIA

**Used python program to design an web application with python flask and MYSQL**

# Requirements

  - Download and install Python, We used Python 3.7.1, make sure to check the box Add Python to PATH on the installation setup screen.
  - Download and install MySQL Community Server and MySQL Workbench, you can skip this step if you already have a MySQL server set up.
  - Install Python Flask with the command: pip install flask
  - Install Flask-MySQLdb with the command: pip install flask-mysqldb
  - ALSO, All requirements package will be on the requirements.txt and here is the references to check python flask installation: https://flask.palletsprojects.com/en/1.1.x/installation/


# File Structure & Setup
**Each file will contain the following:**
**\-- vestigia
  |-- main.py
  |-- database.sql
  \-- static
    |-- style.css
    |-- base.css
  \-- templates
    |-- index.html
    |-- register.html
    |-- home.html
    |-- profile.html
    |-- post.html
    |-- reply.html
    |-- layout.html**

  - main.py — This will be our main project file, all our Python code will be in this file (Routes, MySQL connection, validation, etc).
  - index.html — home page created with HTML5 and CSS3.
  - register.html — Registration form created with HTML5 and CSS3.
  - login.html — Login form created with HTML5 and CSS3.
  - profile.html - profile page created with HTML5 and CSS3.
  - post.html - post page created with HTML5 and CSS3.
  - reply.html - reply page created with HTML5 and CSS3.
  - layout.html - The layout template for the home and profile templates.

# The below instruction will start your web server (Windows):

- Make sure your MySQL server is up and running, it should have automatically started if you installed it via the installer.
- Make sure the database connection details below (in python) and your database should follow:
- app.secret_key = '111'
- app.config['MYSQL_HOST'] = 'localhost'
- app.config['MYSQL_USER'] = 'root'
- app.config['MYSQL_PASSWORD'] = '111111'
- app.config['MYSQL_DB'] = 'database_project'
- Open Command Prompt, make sure you have the project directory selected, you can do this with the command cd c:\your_project_folder_destination\python main.py on Windows.

# If you see the following information, you have successfully run the web application
* Serving Flask app "test" (lazy loading)
 * Environment: production
   WARNING: Do not use the development server in a production environment.
   Use a production WSGI server instead.
 * Debug mode: on
 * Restarting with stat
 * Debugger is active!
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
# Click http://127.0.0.1:5000/ or copy it to your browser 
