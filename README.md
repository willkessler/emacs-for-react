# Emacs for ReactJS

_Emacs `init.el` optimized for editing Reactjs projects._

## Background

I recently started to work on some React projects. My crusty old emacs setup wasn't cutting it, especially for editing Facebook JSX files, so I decided to try [Spacemacs](http://spacemacs.org/).  After a day of trying to retrain my fingers to learn VIM bindings and customize the hell out of the thing to be "just like Emacs", I realized, except for the bindings, Spacemacs is basically just Emacs with a ton of customization to make it act sort of like Vim with a giant list of discoverable key-bindings that are semi-logically organized, but kind of overwhelming too. I like the minimalism of good 'ol Emacs.

I wondered, was there a way to make Emacs 24/25 do just as well as Spacemacs but for today's coders?  I built a new `init.el` from the ground up, and I think I've got a lot of the functionality there that you'd get out of Spacemacs. Plus I fixed a bunch of niggling issues that have bothered me for years (e.g. wonky shell behavior), and made `web-mode` happier within JSX files.  

## Usage

Just follow these steps to get Emacs up on Ubuntu with minimal efforts:

```
apt-get update
apt-get upgrade
apt-get install -y emacs
mkdir ~/.emacs.d
```

If you follow the steps above, and then install this project's `init.el` into `~/.emacs.d`, and start up emacs,  you should be good to go with everything (ala Spacemacs).

### Notes

I've added a .screenrc file I use constantly on remote systems to keep emacs running smoothly.
