"""
Yum plugin for accessing LINBIT repositories.
"""
## see http://yum.baseurl.org/wiki/WritingYumPlugins


import os
import sys
import re
import base64
import platform

from yum.plugins import TYPE_CORE

requires_api_version = '2.3'
plugin_type = (TYPE_CORE)

SCRIPT_VERSION = 1

# Utility Functions that might need update (e.g., if we add distro-types)
# XXX: we have to check if we can use yum plugins on SLES, if not we should
# remove these code paths.
def getHostInfo():
    if platform.system() != "Linux":
        err("You have to run this script on a GNU/Linux based system")

    distname, version, distid = platform.linux_distribution()

    distname = distname.strip().lower()
    version = version.strip()

    # python spec is bit fuzzy about the hostname:
    # "may not be fully qualified!". To be save, use the first part only
    hostname = platform.node().strip().split('.')[0]

    if distname.startswith("red hat enterprise linux server") or \
       distname.startswith("centos"):
        version_split = version.split('.')
        if len(version_split) > 2:
            version = "%s.%s" % tuple(version_split[:2])
        dist = "rhel%s" % (version)
    elif distname.startswith("suse linux enterprise server"):
        dist = "sles%s" % (version)
        # patchlevel is not included in platform-info
        patchlevel = getSuSEPatchLevel()
        if patchlevel and patchlevel != '0':
            dist = dist + "-sp" + patchlevel
    else:
        dist = False

    # it seems really hard to get MAC addresses if you want:
    # a python only solution, e.g., no extra C code
    # no extra non-built-in modules
    # support for legacy python versions
    macs = set()
    # we are Linux-only anyways...
    CLASSNET = "/sys/class/net"
    if os.path.isdir(CLASSNET):
        for dev in os.listdir(CLASSNET):
            devpath = os.path.join(CLASSNET, dev)

            if not os.path.islink(devpath):
                continue

            with open(os.path.join(devpath, "type")) as t:
                dev_type = t.readline().strip()
                if dev_type != '1':  # this filters for example ib/lo devs
                    continue

            # try to filter non permanent interfaces
            # very old kernels do not have /sys/class/net/*/addr_assign_type
            addr_assign_path = os.path.join(devpath, "addr_assign_type")
            if os.path.isfile(addr_assign_path):
                with open(addr_assign_path) as a:
                    dev_aatype = a.readline().strip()
                    if dev_aatype != '0':  # NET_ADDR_PERM
                        continue
            else:  # try our best to manually filter them
                if dev.startswith("vir") or \
                   dev.startswith("vnet") or \
                   dev.startswith("bond"):
                    continue

            with open(os.path.join(devpath, "address")) as addr:
                mac = addr.readline().strip()
                macs.add(mac)

    def getFamily(dist):
        family = False
        if dist:
            if dist.startswith("rhel"):
                family = "redhat"
            if dist.startswith("sles"):
                family = "suse"
        return family

    def getSuSEPatchLevel():
        with open("/etc/SuSE-release") as SuSErel:
            for line in SuSErel:
                line = line.strip()
                if line.startswith("PATCHLEVEL"):
                    return line.split('=')[1].strip()
        return False

    return dist, getFamily(dist), hostname, macs



#def predownload(conduit):
#def postreposetup_hook(conduit):
def prelistenabledrepos_hook(conduit):
    (_, _, hostname, macs) = getHostInfo()
    info_str = chr(SCRIPT_VERSION) + hostname + '\0' + '\1'.join(macs)
    pad = '\0\0\0'[len(info_str) % 3:]
    add_info = base64.urlsafe_b64encode(info_str + pad)
    for repo in conduit.getRepos().repos.values():
        repo.baseurl = map(lambda u: re.sub(r"^(https?://packages.linbit.com/\w{40})/", "\\1" + add_info + "/", u, 1), repo.baseurl)

# vim: sw=4 ts=4 et :
