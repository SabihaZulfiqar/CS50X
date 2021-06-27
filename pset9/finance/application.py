import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from tempfile import mkdtemp
from werkzeug.exceptions import default_exceptions, HTTPException, InternalServerError
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd

from datetime import datetime

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True


# Ensure responses aren't cached
@app.after_request
def after_request(response):
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_FILE_DIR"] = mkdtemp()
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")

# Make sure API key is set
if not os.environ.get("API_KEY"):
    raise RuntimeError("API_KEY not set")


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""

    trans_list = []
    trans_dict = {}
    transactions = db.execute("SELECT * FROM transactions WHERE user_id = ?", session["user_id"])
    current_cash = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])
    cash = round(current_cash[0]["cash"], 2)
    grand_total = cash

    for transaction in transactions:
        value = transaction["shares_quantity"] * transaction["price"]
        shares = transaction["shares_quantity"]
        price = transaction["price"]
        symbol = transaction["symbol"]

        trans_dict["value"] = value
        trans_dict["shares_quantity"] = shares
        trans_dict["price"] = lookup(symbol)["price"]
        trans_dict["symbol"] = symbol

        trans_list.append(trans_dict.copy()) # always append a copy of the list i.e. list[:] ad dict i.e. dict.copy(), otherwise you get repeating same entries

        grand_total += value
    return render_template("index.html", trans_list = trans_list, cash = cash, grand_total = grand_total)


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""
    if request.method == "POST":
        # Ensure symbol was submitted
        if not request.form.get("symbol"):
            return apology("must provide symbol", 403)

        # Ensure symbol was valid
        symbol_request = lookup(request.form.get("symbol"))
        if not symbol_request["symbol"]:
            return apology("symbol not valid", 403)

        # Ensure shares were submitted
        if not request.form.get("shares"):
            return apology("Invalid Shares!", 403)

        # Ensure shares were valid
        if not int(request.form.get("shares")) > 0:
            return apology("Invalid Shares!", 403)

        symbol = request.form.get("symbol")
        shares = int(request.form.get("shares"))

        ## Get current share price and user's available cash
        current_price_query = lookup(request.form.get("symbol"))
        current_price = current_price_query["price"]

        purchase_total = current_price * shares

        current_cash = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])

        if current_cash[0]["cash"] < purchase_total:
            return apology("Sorry, you do not have enough balance!", 403)

        if current_cash[0]["cash"] >= purchase_total:
            updated_cash = current_cash[0]["cash"] - purchase_total
            db.execute("UPDATE users SET cash = ? WHERE id = ?", updated_cash, session["user_id"])
            db.execute("INSERT INTO transactions(user_id, transaction_type, symbol, price, shares_quantity, Timestamp) VALUES (?,?,?,?,?,?)", session["user_id"], "buy", symbol, current_price, shares, datetime.today().isoformat())

            return render_template("index.html")

    else:
        return render_template("buy.html")

@app.route("/history")
@login_required
def history():
    """Show history of transactions"""
    return apology("TODO")


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 403)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 403)

        # Query database for username
        rows = db.execute("SELECT * FROM users WHERE username = ?", request.form.get("username"))

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(rows[0]["hash"], request.form.get("password")):
            return apology("invalid username and/or password", 403)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""
    if request.method == "POST":
        quoted_value = lookup(request.form.get("symbol"))
        quoted_value = quoted_value["price"]
        return render_template("quoted.html", quoted_value = quoted_value)
    else:
        return render_template("quote.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""
    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 403)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 403)

        # Ensure passwords match
        elif request.form.get("password") != request.form.get("confirmation"):
            return apology("passwords don't match", 403)

        # Save user to database
        db.execute("INSERT INTO users (username, hash) VALUES (?, ?)", request.form.get("username"), generate_password_hash(request.form.get("password")))
        return redirect("/")

    else:
        return render_template("register.html")


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():

    """Sell shares of stock"""
    if request.method == "POST":
        # Ensure stocks was submitted
        if not request.form.get("symbol"):
            print(request.form.get("symbol"))
            return apology("must provide symbol", 403)

        # Ensure shares was submitted
        elif not request.form.get("shares"):
            return apology("must provide shares", 403)

        symbol = request.form.get("symbol")
        shares = int(request.form.get("shares"))


        # Get count (shares) minus any sell transactions => where user id is session user id and symbol is symbol
        # Ensure shares are positive and available
        # Update transactions with sell operation with symbol and shares with a negative sign

        sum_of_bought_shares = db.execute("SELECT SUM(shares_quantity) FROM transactions WHERE user_id = ? AND transaction_type = 'buy' AND symbol = ?", session["user_id"], symbol)[0]["SUM(shares_quantity)"]
        sum_of_sold_shares = db.execute("SELECT SUM(shares_quantity) FROM transactions WHERE user_id = ? AND transaction_type = 'sell' AND symbol = ?", session["user_id"], symbol)[0]["SUM(shares_quantity)"]
        print(sum_of_bought_shares,sum_of_sold_shares)

        if sum_of_bought_shares is None:
            sum_of_bought_shares = 0
        if sum_of_sold_shares is None:
            sum_of_sold_shares = 0

        sum_of_available_shares = sum_of_bought_shares - sum_of_sold_shares

        if sum_of_available_shares >= shares:
            sum_of_available_shares -= shares

            current_price_query = lookup(request.form.get("symbol"))
            current_price = current_price_query["price"]

            insertion = db.execute("INSERT INTO transactions(user_id, transaction_type, symbol, price, shares_quantity, Timestamp) VALUES (?,?,?,?,?,?)", session["user_id"], "sell", symbol, current_price, (-1 * shares), datetime.today().isoformat())
            print(insertion)

            if insertion > 0:
                current_cash = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])[0]["cash"]
                print(current_cash)
                current_cash = current_cash + (current_price * shares)
                db.execute("UPDATE users SET cash = ? WHERE id = ?", current_cash, session["user_id"])
            else:
                return apology("Database Update Failed", 403)

            return render_template("index.html")
    else:

        stocks = []

        # Selecting all entries where user_id is current user
        available_stocks = db.execute("SELECT symbol FROM transactions WHERE user_id = ?", session["user_id"])

        # for each row received, get only the symbol attribute value and save in a list
        for stock in available_stocks:
            stocks.append(stock["symbol"])

        # remove duplicates from the list to get a list of owned stocks
        available_stocks = list(dict.fromkeys(stocks))        # Turning a list into a dictionary keys eliminates duplicates as keys can not repeat, turn back into list to remove duplicates

        send_stocks = dict.fromkeys(available_stocks, "owned")

        # send stocks to template for display in select option
        return render_template("sell.html", send_stocks = send_stocks, i = 0)


def errorhandler(e):
    """Handle error"""
    if not isinstance(e, HTTPException):
        e = InternalServerError()
    return apology(e.name, e.code)


# Listen for errors
for code in default_exceptions:
    app.errorhandler(code)(errorhandler)
