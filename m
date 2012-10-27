From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] systemd: mount the EFI variable filesystem
Date: Sat, 27 Oct 2012 11:23:22 +0800
Message-ID: <1351308202-14628-1-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, =?utf-8?q?Mantas=20Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?utf-8?q?Zbigniew=20J=C4=99drzejewski-Szmek?= <zbyszek-wrcVdnn0TatmR6Xm/wNWPw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Add efivarfs to the mount_table in mount-setup.c, so the EFI variable
filesystem will be mounted when systemd executed.

The EFI variable filesystem will merge in v3.7 or v3.8 linux kernel.

Cc: Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>
Cc: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
Cc: Mantas Mikul=C4=97nas <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Zbigniew J=C4=99drzejewski-Szmek <zbyszek-wrcVdnn0TatmR6Xm/wNWPw@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 src/core/kmod-setup.c  |    1 +
 src/core/mount-setup.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/src/core/kmod-setup.c b/src/core/kmod-setup.c
index cc2a2d9..14a4778 100644
--- a/src/core/kmod-setup.c
+++ b/src/core/kmod-setup.c
@@ -33,6 +33,7 @@
 static const char * const kmod_table[] =3D {
         "autofs4", "/sys/class/misc/autofs",
         "ipv6",    "/sys/module/ipv6",
+	"efivarfs", "/sys/firmware/efi/efivars",
         "unix",    "/proc/net/unix"
 };
=20
diff --git a/src/core/mount-setup.c b/src/core/mount-setup.c
index 0fd112f..8ce4ddc 100644
--- a/src/core/mount-setup.c
+++ b/src/core/mount-setup.c
@@ -66,6 +66,7 @@ static const MountPoint mount_table[] =3D {
         { "sysfs",    "/sys",                   "sysfs",    NULL,     =
           MS_NOSUID|MS_NOEXEC|MS_NODEV,                true,  true  },
         { "devtmpfs", "/dev",                   "devtmpfs", "mode=3D75=
5",          MS_NOSUID|MS_STRICTATIME,                    true,  true  =
},
         { "securityfs", "/sys/kernel/security", "securityfs", NULL,   =
           MS_NOSUID|MS_NOEXEC|MS_NODEV,                false, false },
+	{ "efivarfs", "/sys/firmware/efi/efivars", "efivarfs", NULL,		 MS_NOS=
UID|MS_NOEXEC|MS_NODEV,                false, false },
         { "tmpfs",    "/dev/shm",               "tmpfs",    "mode=3D17=
77",         MS_NOSUID|MS_NODEV|MS_STRICTATIME,           true,  true  =
},
         { "devpts",   "/dev/pts",               "devpts",   "mode=3D62=
0,gid=3D" STRINGIFY(TTY_GID), MS_NOSUID|MS_NOEXEC,          false, true=
  },
         { "tmpfs",    "/run",                   "tmpfs",    "mode=3D75=
5",          MS_NOSUID|MS_NODEV|MS_STRICTATIME,           true,  true  =
},
--=20
1.6.0.2
