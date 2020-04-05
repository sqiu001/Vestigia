from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re
from functools import wraps

app = Flask(__name__)

# Change this to your secret key (can be anything, it's for extra protection)
app.secret_key = 'key'

# Enter your database connection details below
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'root'
app.config['MYSQL_DB'] = 'vestigia'

# Intialize MySQL
mysql = MySQL(app)


def login_required(func):  # login required decorator

    @wraps(func)
    def wrapper(*args, **kwargs):
        if session.get('user_id'):
            return func(*args, **kwargs)
        else:
            return redirect(url_for('login'))

    return wrapper


# http://localhost:5000/pythinlogin/home - this will be the home page, only accessible for loggedin users
@app.route("/")  # home page
def home():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT post_title, post_content, post_time, username, post_id, user_id'
                   ' FROM tb_post order by -post_time')
    # Fetch all records and return result
    post = cursor.fetchall()
    if post:
        return render_template('index.html', post=post)
    return render_template('index.html')


#  link the post_content to the reply page
@app.route('/reply/<post_id>/')
@login_required
def into_reply(post_id):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM tb_post WHERE post_id = %s', (post_id,))
    posted = cursor.fetchone()
    cursor.execute('SELECT reply_content, reply_time, username, user_id, post_id'
                   ' FROM tb_reply WHERE post_id = %s order by -reply_time', (post_id,))
    reply = cursor.fetchall()
    session['post_id'] = posted['post_id']
    return render_template('reply.html', posted=posted, reply=reply)


# reply feature
@app.route('/add_reply/', methods=['post'])
def add_reply():
    reply_content = request.form['reply_content']
    if not reply_content:
        return redirect(url_for('into_reply', post_id=session['post_id']))
    else:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('INSERT INTO tb_reply (username, user_id, reply_content, post_id) VALUES '
                       '(%s, %s, %s, %s)', (session['username'], session['user_id'], reply_content, session['post_id']))
        mysql.connection.commit()
        return redirect(url_for('into_reply', post_id=session['post_id']))


@app.route('/login/', methods=['GET', 'POST'])
def login():
    # Output message if something goes wrong...
    msg = ''
    # Check if "username" and "password" POST requests exist (user submitted form)
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        # Create variables for easy access
        username = request.form['username']
        password = request.form['password']
        # Check if account exists using MySQL
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM tb_user WHERE username = %s AND password = %s', (username, password))
        # Fetch one record and return result
        account = cursor.fetchone()
        # If account exists in accounts table in out database
        if account:
            # Create session data, we can access this data in other routes
            session['loggedin'] = True
            session['user_id'] = account['user_id']
            session['username'] = account['username']
            # session['password'] = account['user_password']
            # Redirect to home page
            return redirect(url_for('profile'))
        else:
            # Account doesnt exist or username/password incorrect
            msg = 'Incorrect username/password!'
    # Show the login form with message (if any)
    return render_template('login.html', msg=msg)


# http://localhost:5000/pythinlogin/register - this will be the registration page, we need to use both GET and POST requests
@app.route('/register/', methods=['GET', 'POST'])
def register():
    # Output message if something goes wrong...
    msg = ''
    # Check if "username", "password" and "email" POST requests exist (user submitted form)
    if request.method == 'POST' and 'first_name' in request.form and 'last_name' in request.form and 'username' in request.form and 'password' in request.form and 'email' in request.form:
        # Create variables for easy access
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']
        # Check if account exists using MySQL
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM tb_user WHERE email = %s', [email])
        account = cursor.fetchone()
        # If account exists show error and validation checks
        if account:
            msg = 'Account already exists!'
        elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
            msg = 'Invalid email address!'
        elif not re.match(r'[A-Za-z0-9]+', username):
            msg = 'Username must contain only characters and numbers!'
        elif not re.match(r'[A-Za-z]+', first_name):
            msg = 'First name must contain only characters!'
        elif not re.match(r'[A-Za-z]+', last_name):
            msg = 'Last name must contain only characters!'
        elif not first_name or not last_name or not username or not password or not email:
            msg = 'Please fill out the form!'
        else:
            # Account doesnt exists and the form data is valid, now insert new account into accounts table
            cursor.execute('INSERT INTO tb_user VALUES (NULL, %s, %s, %s, %s, %s)', (first_name, last_name, username,
                                                                                     password, email))
            mysql.connection.commit()
            msg = 'You have successfully registered!'
    elif request.method == 'POST':
        # Form is empty... (no POST data)
        msg = 'Please fill out the form!'
    # Show registration form with message (if any)
    return render_template('register.html', msg=msg)


@app.context_processor
def my_context_processor():
    user_id = session.get('user_id')
    if user_id:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM tb_user WHERE user_id = %s', (user_id,))
        # Fetch one record and return result
        account = cursor.fetchone()
        if account:
            return {'account': account}
    return {}


# http://localhost:5000/pythinlogin/profile - this will be the profile page, only accessible for loggedin users
@app.route('/profile/')
def profile():
    # Check if user is loggedin
    if 'loggedin' in session:
        # We need all the account info for the user so we can display it on the profile page
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM tb_user WHERE user_id = %s', [session['user_id']])
        account = cursor.fetchone()
        cursor.execute('SELECT post_title, post_content, post_time, username, post_id, user_id'
                       ' FROM tb_post WHERE user_id = %s order by -post_time', [session['user_id']])
        # Fetch all records and return result
        post = cursor.fetchall()
        # Show the profile page with account info
        return render_template('profile.html', account=account, post=post)
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))


# this will be the poster_file page
@app.route('/poster_profile/<poster_id>')
@login_required
def poster_profile(poster_id):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM tb_user WHERE user_id = %s', (poster_id,))
    account = cursor.fetchone()
    return render_template('profile.html', poster_account=account)


# http://localhost:5000/python/logout - this will be the logout page
@app.route('/logout/')
def logout():
    # Remove session data, this will log the user out
    # session.pop('loggedin', None)
    session.pop('user_id', None)
    # session.pop('username', None)

    # Redirect to login page
    return redirect(url_for('login'))


@app.route('/profile/post', methods=['GET', 'POST'])
@login_required
def post():
    msg = ''
    # Check if "username", "password" and "email" POST requests exist (user submitted form)
    if request.method == 'POST' and 'title' in request.form and 'content' in request.form:
        # Create variables for easy access
        title = request.form['title']  # get data from url form
        content = request.form['content']
        # Check if account exists using MySQL
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM tb_post WHERE post_title = %s', (title,))
        post = cursor.fetchone()
        # If account exists show error and validation checks
        if post:
            session['post_id'] = post['post_id']
            msg = 'Error: Title already exists!\n'
        elif not title or not content:
            msg = 'Error: Please fill out the form!\n'
        else:
            msg = 'You have successfully posted!'
            # Account doesnt exists and the form data is valid, now insert new account into accounts table
            cursor.execute("INSERT INTO tb_post (post_title, post_content, user_id, username)"
                           " VALUES (%s, %s, %s, %s)", (title, content, session['user_id'], session['username']))
            mysql.connection.commit()
            return redirect(url_for('home'))
    elif request.method == 'POST':
        # Form is empty... (no POST data)
        msg = 'Please fill out the form!'
        # Show registration form with message (if any)
    return render_template('post.html', msg=msg)


@app.route('/search/', methods=['GET', 'POST'])
@login_required
def search():
    if request.method == "POST" and 'username' in request.form:
        username = request.form['username']
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        # search by username
        cursor.execute('SELECT * FROM tb_post WHERE username = %s', (username,))
        account = cursor.fetchone()
        if account:
            return redirect(url_for('poster_profile', poster_id=account['user_id']))
    flash('User does not exist')
    return redirect(url_for('home'))


# @app.route('/users/', methods=['GET', 'POST'])
# @login_required
# def users():
#     cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
#     cursor.execute('SELECT first_name, last_name, username, email, user_id'
#                    ' FROM tb_user')
#     user = cursor.fetchall()
#     if user:
#         return render_template('user_profile.html', user=user)
#     return render_template('user_profile.html')

if __name__ == '__main__':
    app.run(debug=True)
