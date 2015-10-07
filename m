From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/3] UEFI stub FDT handling fixes
Date: Wed,  7 Oct 2015 09:35:26 +0100
Message-ID: <1444206929-13374-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is an alternative approach to some of the issues addressed by my series
'arm64 UEFI early FDT handling', of which the latest version (v3) can be found
here: http://thread.gmane.org/gmane.linux.kernel.efi/6334

The issues that are addressed by the original series are:
- when booting via UEFI, memreserve entries are removed from the device tree but
  the /reserved-memory node is not
- memory nodes are removed from the device tree in a way that is not officially
  supported by the libfdt API (i.e., you cannot delete nodes while traversing
  the tree)
- removal of memory nodes may discard annotations (such as NUMA topology) that
  should ideally be retained, or may corrupt the tree by discarding nodes
  referenced by phandles.

After having discussed this offline between Grant, Leif and myself, we have come
to the [preliminary] conclusion that discarding the /reserved-memory is not the
way to go, and we will be far better off honoring those reservations to the
extent possible. At the same time, the /memory node binding does not contain any
annotations, so discarding those prevents more issues than it creates as long as
we do it cautiously.

This series addresses both issues: it it sanity check the /reserved-memory node
to ensure that it does not contain any reservations we will not be able to
honor (patch #1, #2) and updates the /memory removal loop to restart from the
root of the tree each time a /memory node is found and removed (patch #3)

Ard Biesheuvel (3):
  efi/libstub: move FDT sanity check out of allocation loop
  efi/libstub: sanity check the /reserved-memory DT node
  efi/libstub: fix deletion of FDT memory nodes

 drivers/firmware/efi/libstub/fdt.c | 187 ++++++++++++++++++--
 1 file changed, 169 insertions(+), 18 deletions(-)

-- 
1.9.1
