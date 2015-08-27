## purpose: This module should provide some often needed functions
##          while working with the Spacewalk/SUSE Manager API,
##          such as authentication.
## copyright: B1 Systems GmbH <info@b1-systems.de>, 2013.
## license: GPLv3+, http://www.gnu.org/licenses/gpl-3.0.html
## author: Mattias Giese <giese@b1-systems.de>, 2013.
## version: 0.1: Minimal functionality
import xmlrpclib
import yaml
import sys
CONFIG="/etc/b1-spacewalk-lib.conf"
class swauth:

	def __init__(self):
		try:
			self.config = yaml.load(open(CONFIG))
		except Exception, e:
			print "Could not read", CONFIG, "Exception:", e
			sys.exit(1)
		
		try:
			self.swurl = self.config["url"]
			self.swuser = self.config["user"]
			self.swpasswd = self.config["password"]
		except Exception, e:
			print "Could net set configuration parameters: ", e
			sys.exit(1)
		try:
			self.client = self.swconnect()
			self.key = self.swgetkey()

		except Exception, e:
			print "Could not login: ", e
			sys.exit(1)
	def __del__(self):
		self.swlogout()

	def swconnect(self):
		return xmlrpclib.Server(self.swurl, verbose=0)

	def swgetkey(self):
		return self.client.auth.login(self.swuser, self.swpasswd)

	def swlogout(self):
		try:
			self.client.auth.logout(self.key)
		except Exception, e:
			print "Logout failed:", e
			sys.exit(1)


if __name__=="__main__":
	authtest = swauth()

