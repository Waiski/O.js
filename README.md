OTY app
===================

Contributing
------------

**Everyone's help is needed!** No matter how little you code, there's something to do. Please check the issues at GitHub and find something where you can contribute.

To make changes to the code:

1. Read this readme
2. Install the app locally using the instructions here
3. Learn basic [JavaScript syntax](https://developer.mozilla.org/en-US/Learn/Getting_started_with_the_web/JavaScript_basics) and learn about [CoffeeScript]
4. Familiarize yourself with [Meteor basics](http://guide.meteor.com/)
5. If you want to contribute to the front-end, learn about [Semantic UI], [Font Awesome] and [LESS]
6. If you want to contribute to the back-end, learn about [Meteor collections](http://guide.meteor.com/collections.html) and [MongoDB]
7. Push commits!

Technical basis
---------------

This app is based on [Meteor], a full-stack [node.js] web framework. Meteor is pure javascript, and most of the code works both in the front- as well as back-end. Meteor application can be tested on Windows using [Vagrant] to create a Linux virtual machine, that runs Meteor. This project contains a Vagrantfile and a provision.sh shell script that set up a virtual machine for this purpose (based loosely on a [Gist by Gabriel Pugliese][1]).

The app makes use of several Javascript libraries and technologies, some of which are built-in to Meteor, and some of which are added with Meteor's packaging system. The most important ones are:

- [jQuery]
- [underscore.js]
- [MongoDB] - the database used with Meteor
- [Semantic UI] - the front-end library used in this project
- [Iron.Router] - Used for Meteor URI routing
- [Meteor Up] - to deploy the app
- [CoffeeScript] - a JS dialect used in several files
- [Font Awesome] - a library of icons for web applications
- [Meteor collection2 package] - A popular package for defining database schemas and data model validations and automations

Software requirements
---------------------

In order to develop this app, your computer needs to have [Git], [VirtualBox] and [Vagrant] installed. On Windows, you also need to install the unix-like tools that come with Git or some other package to be able to run ssh from command line. Using a virtual machine guarantees that development can be done on any platform and minimizes "works on my machine" -type problems.

Installation
------------

1. Clone this repository to your machine
2. Run `vagrant up` in the main folder (the one with Vagrantfile). Vagrant's automated process will create a 64bit Ubuntu 14.01 virtual machine with all necessary sofware installed.
3. Run `vagrant ssh`. This will connect you to your virtual machine.
4. Run the following commands:

    ```sh
    # Still in the home folder (of the freshly created virtual machine)
    meteor create app
    cd app
    meteor run
    ```

5. Now you have created a dummy version of your app. Press Ctrl+C to stop the app. This meteor app in your virtual machine's home folder **will only be used to store the database, as the VirtualBox synced folder does not support it.**
6. Now you can change to the **actual** project folder and create symlinks to the dummy app too make the database work:

    ```sh
    # Still in the same shell, within the virtual machine
    cd /vagrant/app
    rm -rf .meteor/local
    mkdir .meteor/local
    echo "sudo mount --bind /home/vagrant/app/.meteor/local /vagrant/app/.meteor/local" >> ~/.bashrc && source ~/.bashrc
    ```

7. Now your're all set. Run `meteor run` to run the app and navigate your browser to `http://localhost:3000` to see it. To quit the app, press Ctrl+C, to exit the virtual machine connection, run `exit`, and to shut down the virtual machine, run `vagrant halt`.

Practical tips
--------------

- At this point, the categories need to be added manually. This can be done from the browser javascript console by running, for example, `Categories.insert({name: 'Viskit'});` etc.
- If the virtual machine or Meteor instance gets jammed, first try booting the virtual machine by running `vagrant reload` on the host machine terminal.
- Whenever you save changes to the application files, Meteor loads them automatically and refreshes the page. This can sometimes take a little time though.
- Try stuff! The local environment *is for* playing around, you're not going to break anything.
- When using CoffeeScript, it's often helpful to have [CoffeeScript] home page open on one tab, and use the 'Try CoffeeScript' testing feature there to check if it compiles as you expect it to.
- **Ask for help!** All programmers suffer unnecessarily from inferiority complex, because it's so easy to find super-experts' answers to Stack Overflow questions etc. The fact is, you are not as bad as you think, so your question isn't as stupid as you think it is. 

Coding guidelines
-----------------

- Comments and commit messages in English.
- Write informative commit messages.
- Commit as often as possible.
- Indentation: 2 spaces.
- Meteor has lots of nice features. Try to use them.
- Most problems are better solved by someone else. Go to [Atmospherejs] to find packages for Meteor.

App structure
-------------

In Meteor framework the same code can run in the browser and server. This is a great and powerful feature. However many functions need to only work on the client or the server. Folders `app/client/` and `app/server/` house these respectively.

The basic idea is that as much of the logic as possible is run on the client. This makes for a better user experience and simpler code. The server's number one priority is security. The files `app/server/publications.coffee` and `app/server/rules.js` are most important for data security.

Meteor automatically includes all code in all files to the application, there is no need to import anything specifically. Thus you are free to place code wherever you think is best.

[Read more at Meteor docs.](http://docs.meteor.com/#/full/structuringyourapp)

Resources
---------

- [Meteor docs]
- [Vagrant]
- [Atmospherejs] - Meteor packages
- [MDN] - The best Javascript reference
- [Stack Overflow] - For everything

[1]: https://gist.github.com/gabrielhpugliese/5855677
[Meteor]: https://www.meteor.com/
[Meteor docs]: http://docs.meteor.com/
[Git]: http://git-scm.com/
[Vagrant]: https://www.vagrantup.com/
[Semantic UI]: http://semantic-ui.com/
[node.js]: http://nodejs.org/
[MongoDB]: http://www.mongodb.org/
[VirtualBox]: https://www.virtualbox.org/
[jQuery]: http://jquery.com/
[underscore.js]: http://underscorejs.org/
[Atmospherejs]: http://atmospherejs.com/
[MDN]: https://developer.mozilla.org/en-US/docs/Web/JavaScript
[Stack Overflow]: https://stackoverflow.com/
[Meteor Up]: https://github.com/arunoda/meteor-up
[meteor-famous-views]: https://famous-views.meteor.com/
[Iron.Router]: https://github.com/iron-meteor/iron-router
[CoffeeScript]: http://coffeescript.org/
[Font Awesome]: https://fortawesome.github.io/Font-Awesome/icons/
[LESS]: http://lesscss.org/
[Meteor collection2 package]: https://github.com/aldeed/meteor-collection2
