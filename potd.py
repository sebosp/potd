#!/usr/bin/env python
import sys
import os
import pygtk
pygtk.require('2.0')
import gtk
import gnomeapplet
import gobject
def create_menu(applet):
	xml="""
<popup name="button3">
	<menuitem name="ItemAbout" verb="About" label="_About" pixtype="stock" pixname="gtk-about"/>
	<separator/>
	<submenu name="Preferences" _label="_Source">
		<menuitem name="ItemAstronomy" verb="Astronomy" label="_Astronomy Picture Of The Day" pixtype="stock" pixname="gtk-preferences"/>
		<menuitem name="ItemWikipedia" verb="Wikipedia" label="_Wikipedia Picture Of The Day" pixtype="stock" pixname="gtk-preferences"/>
		<menuitem name="ItemEarth" verb="Earth" label="_Earth Picture Of The Day" pixtype="stock" pixname="gtk-preferences"/>
	</submenu>
</popup>"""
	verbs = [('Astronomy', run_apod),('Wikipedia', run_wpod),('Earth', run_epod)]
	applet.setup_menu(xml, verbs, None)
def run_apod(*arguments):
	os.system('/usr/lib/potd/potd.sh apod > ~/potd.log 2>&1')
def run_wpod(*arguments):
	os.system('/usr/lib/potd/potd.sh wpod > ~/potd.log 2>&1')
def run_epod(*arguments):
	os.system('/usr/lib/potd/potd.sh epod > ~/potd.log 2>&1')
def applet_factory(applet, iid):
	print 'Starting POTD instance:', applet, iid
	label = gtk.Label("Pic Of The Day")
	create_menu(applet)
	applet.add(label)
	applet.show_all()
	return True
if __name__ == '__main__': # testing for execution
	if len(sys.argv) > 1 and sys.argv[1] == '-d': # debugging
		mainWindow = gtk.Window()
		mainWindow.set_title('Applet window')
		mainWindow.connect('destroy', gtk.main_quit)
		applet = gnomeapplet.Applet()
		applet_factory(applet, None)
		applet.reparent(mainWindow)
		mainWindow.show_all()
		gtk.main()
		sys.exit()
	else:
		gnomeapplet.bonobo_factory("OAFIID:GNOME_POTDApplet_Factory",gnomeapplet.Applet.__gtype__,"Picture of the Day", "0.2", applet_factory)
