from tkinter import *
import login


class WelcomeWindow:

    # create a constructor
    def __init__(self):
        # create a tkinter window
        self.win = Tk()

        # reset the window and background color
        self.canvas = Canvas(self.win, width=600, height=400, bg='white')
        self.canvas.pack(expand=YES, fill=BOTH)

        # show window in center of the screen
        width = self.win.winfo_screenwidth()
        height = self.win.winfo_screenheight()
        x = int(width / 2 - 600 / 2)
        y = int(height / 2 - 400 / 2)
        str1 = "600x400+" + str(x) + "+" + str(y)
        self.win.geometry(str1)
        # disable resize of the window
        self.win.resizable(width=False, height=False)
        # change the title of the window
        self.win.title("Vestigia")

    def add_frame(self):
        self.labeltitle = Label(text="Welcome to Vestigia")
        self.labeltitle.config(font=("Courier", 20, 'bold'))
        self.labeltitle.place(x=130, y=170)

        self.button = Button(text="Login", font=('helvetica', 20)
                             , bg='light blue', fg='white', command=self.login)
        self.button.place(x=150, y=220)

        self.button = Button(text="Register", font=('helvetica', 20)
                             , bg='light blue', fg='white', command=self.login)
        self.button.place(x=300, y=220)

        self.win.mainloop()

    # open a new window on button press
    def login(self):
        self.win.destroy()  # destroy current window
        log = login.LoginWindow()  # open the new window
        log.add_frame()


if __name__ == "__main__":
    x = WelcomeWindow()
    x.add_frame()
