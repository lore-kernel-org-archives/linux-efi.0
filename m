From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI changes for v3.9-rc3
Date: Thu, 21 Mar 2013 13:17:28 +0000
Message-ID: <514B0868.8040905@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi guys,

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-for-3.9-rc3

for you to fetch changes up to e971318bbed610e28bb3fde9d548e6aaf0a6b02e:

  efivars: Handle duplicate names from get_next_variable() (2013-03-21 12:43:46 +0000)

----------------------------------------------------------------
EFI changes for v3.9-rc3,

  * A new config option and efivars module parameter have been added to
    allow the efivars pstore backend to be disabled as we're still seeing
    issues on machines despite adding heuristics to workaround known bugs.
    Distributions now have a way to disable EFI variable pstore code
    completely - from Seth Forshee.

  * A couple of efivars patches to workaround quirky implementations
    of GetNextVariableName() which resulted in machines hanging and
    sysfs files being created with garbage names.

----------------------------------------------------------------
Matt Fleming (2):
      efivars: explicitly calculate length of VariableName
      efivars: Handle duplicate names from get_next_variable()

Seth Forshee (2):
      efivars: Allow disabling use as a pstore backend
      efivars: Add module parameter to disable use as a pstore backend

 drivers/firmware/Kconfig   |  18 ++++++
 drivers/firmware/efivars.c | 150 +++++++++++++++++++++++++++++++--------------
 2 files changed, 122 insertions(+), 46 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
