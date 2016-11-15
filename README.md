# Emacs for ReactJS

emacs init.el for editing Reactjs projects.

## Background

I recently started to work on some React projects. My crusty old emacs setup wasn't cutting it, especially for editing Facebook JSX files, so I decided to try Spacemacs.  After a day of trying to retrain my fingers to learn VIM bindings and customize the hell out of the thing to be "just like emacs", I realized, except for the bindings, Spacemacs is basically built on top of emacs.

Was there a way to make good ol' Emacs act pretty much like Spacemacs?  I built a new init.el from the ground up, and I think I've got a lot of the functionality there that's needed. Plus a fixed a bunch of niggling issues that have bothered me for years (e.g. wonky shell behavior).  

I also want you to be able to do the following to get Emacs up on Ubuntu with minimal efforts:

```
apt-get update
apt-get upgrade
apt-get install -y emacs
mkdir ~/.emacs.d
```

Then install this init.el into ~/.emacs.d and you should be good to go with everything ala Spacemacs.


