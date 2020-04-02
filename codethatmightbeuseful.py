create table followers (
        follower_id INT not null,
        followed_id INT not null,
        foreign key (follower_id) references (user_id),
        foreign key (followed_id) references (user_id)
);

CREATE TABLE tb_user ( 
        user_id INT PRIMARY KEY AUTO_INCREMENT,
        user_name varchar(50),
        user_password varchar(50),
	-- first_name VARCHAR(50),
	-- last_name VARCHAR(50),
	email VARCHAR(100),
        follower_id INT not null,
        followed_id INT not null,
        foreign key (follower_id) references (user_id),
        foreign key (followed_id) references (user_id)
);

# The users that we are following.
def following(self):
    return (
        User.select().join(
            Relationship, on=Relationship.to_user
        ).where(Relationship.from_user == self)
    )


# users following the current user
def followers(self):
    return (
        User.select().join(
            Relationship, on=Relationship.from_user
        ).where(Relationship.to_user == self)
    )

class Relationship(Model):
    from_user = ForeignKeyField(User, related_name='relationships')
    to_user = ForeignKeyField(User, related_name='related_to')

    class Meta:
        database = DATABASE
        indexes = ((('from_user', 'to_user'), True),)

---------------------------------------------------------------------------------

# code to insert reply_text into database
def reply():
    if 'loggedin' in session:
        if request.method == 'POST' and 'reply_text' in request.form:
            reply = request.form['reply_text']
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            account = cursor.fetchone()
            if account: cursor.execute('INSERT INTO tb_replies VALUES (NULL, %d, %s)', (session['id'], reply))
            mysql.connection.commit()
            msg = ''
            return render_template('home.html', username=session['username'], msg=msg)
        # User is logged in - show them the home page
        return render_template('home.html', username=session['username'])

------------------------------------------------------------------------------------

# we will be linking user instances to other instance
# for a pair of linked users in this relationship, left side user is following right side
# User is the right side entity and left side entity is the parent class
# secondary indicates the association table that is used for this relationship
# primaryjoin indicates the condition that links the left hand (follower) with the association table
# secondaryjoin indicates the condition that links right hand (followed) with the table
# backref defines how this relation will be accessed from the right side
# for a given user, the query named followed returns all the right side users
# backref is called followers and will return all the left side users that are linked to the target user on right side
# is_following method takes the followed relationship query, which returns all the (follower, followed) pairs
# that have our user as the follower, and we filter it by the followed user.

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nickname = db.Column(db.String(64), index=True, unique=True)
    email = db.Column(db.String(120), index=True, unique=True)
    posts = db.relationship('Post', backref='author', lazy='dynamic')
    about_me = db.Column(db.String(140))
    last_seen = db.Column(db.DateTime)
    followed = db.relationship('User',
                               secondary=followers,
                               primaryjoin=(followers.c.follower_id == id),
                               secondaryjoin=(followers.c.followed_id == id),
                               backref=db.backref('followers', lazy='dynamic'),
                               lazy='dynamic')

    def follow(self, user):
        if not self.is_following(user):
            self.followed.append(user)
            return self

    def unfollow(self, user):
        if self.is_following(user):
            self.followed.remove(user)
            return self

    def is_following(self, user):
        return self.followed.filter(followers.c.followed_id == user.id).count() > 0

----------------------------------------------------------------------------------------

def follow(user_name):
    user = tb_user.filter_by(user_name=user_name).first()
    if user is None:
        flash('User %s not found.' % user_name)
        return redirect(url_for("..."))
    u = g.user.follow(user)
    if u is None:
        flash('Cannot follow ' + user_name + '.')
        return redirect(url_for("..."))
    # cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    # account = cursor.fetchone()
    # if account: cursor.execute("...")
    # mysql.connection.commit()
    flash('You are now following ' + user_name + '!')
    return redirect(url_for("..."))


def unfollow(user_name):
    user = tb_user.filter_by(user_name=user_name)
    if user is None:
        flash('User %s not found.' % user_name)
        return redirect(url_for("..."))
    u = g.user.unfollow(user)
    if u is None:
        flash('Cannot unfollow ' + user_name + '.')
        return redirect(url_for("..."))
    # cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    # account = cursor.fetchone()
    # if account: cursor.execute("...")
    # mysql.connection.commit()
    flash('You have stopped following ' + user_name + '.')
    return redirect(url_for("..."))
