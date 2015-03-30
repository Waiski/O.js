OTY app
===================

Technical basis
---------------

This app is based on [Meteor], a full-stack [node.js] web framework. Meteor is pure javascript, and most of the code works both in the front- as well as back-end. Meteor application can be tested on Windows using [Vagrant] to create a Linux virtual machine, that runs Meteor. This project contains a Vagrantfile and a provision.sh shell script that set up a virtual machine for this purpose (based loosely on a [Gist by Gabriel Pugliese][1]).

The app makes use of several Javascript libraries and technologies, some of which are built-in to Meteor, and some of which are added with Meteor's packaging system. The most important ones are:

- [jQuery]
- [underscore.js]
- [MongoDB] - the database used with Meteor
- [Famo.us] - a very fancy front-end library
- [meteor-famous-views] - integration package between Famo.us and Meteor
- [Iron.Router] - Used for Meteor URI routing
- [Meteor Up] - to deploy the app

Software requirements
---------------------

In order to develop this app, your computer needs to have [Git], [VirtualBox] and [Vagrant] installed. On Windows, you also need to install the unix-like tools that come with Git or some other package to be able to run ssh from command line.

Installation
------------

1. Clone this repository to your machine
2. Run `vagrant up` in the main folder (the one with Vagrantfile). Vagrant's automated process will create a 64bit Ubuntu 14.01 virtual machine with all necessary sofware installed.
3. Run `vagrant ssh`. Now you have connected with your virtual machine.
4. Run the following commands:

    ```sh
    # Still in the home folder
    meteor create app
    cd app
    meteor run
    ```

5. Now you have created a dummy version of your app. Press Ctrl+C to stop the app. This meteor app in your home folder **will only be used to store the database, as the VirtualBox synced folder does not support it.**
6. Now you can change to the **actual** project folder and create symlinks to the dummy app too make the database work:

    ```sh
    cd /vagrant/app
    rm -rf .meteor/local
    mkdir .meteor/local
    echo "sudo mount --bind /home/vagrant/app/.meteor/local /vagrant/app/.meteor/local" >> ~/.bashrc && source ~/.bashrc
    ```

7. Now your're all set. Run `meteor run` to run the app and navigate your browser to `http://localhost:3000` to see it. To quit the app, press Ctrl+C, to exit the virtual machine connection, run `exit`, and to shut down the virtual machine, run `vagrant halt`.

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
[Famo.us]: http://famo.us/
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
