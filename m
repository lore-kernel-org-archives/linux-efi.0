From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] efi: dmi: List SMBIOS3 table before SMBIOS table
Date: Wed, 27 May 2015 14:18:57 +0100
Message-ID: <20150527131857.GD3030@codeblueprint.co.uk>
References: <20150430152305.26b89bd3@endymion.delvare>
 <20150430160401.GF3014@codeblueprint.co.uk>
 <CAKv+Gu-7cakYGoz8oq5CoqgDvLWxyGwAK++yS8A6tvWo5d1taA@mail.gmail.com>
 <20150526181152.GA3030@codeblueprint.co.uk>
 <CAKv+Gu-SeWYkqiwj+Hin5AiVW188dtLr+GHG80SxJV-uzrkA9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-SeWYkqiwj+Hin5AiVW188dtLr+GHG80SxJV-uzrkA9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ivan.khoronzhuk" <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 27 May, at 12:30:37PM, Ard Biesheuvel wrote:
> 
> OK. Then I guess we should at least document in
> Documentation/ABI/stable/sysfs-firmware-efi-systab that the order in
> which the entries are enumerated is part of the ABI.

Makes perfect sense to me. How about this?

---

>From ccb5f08bb71ae4199c75668c6beacd6b47fa186c Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date: Wed, 27 May 2015 14:14:22 +0100
Subject: [PATCH] efi: Add 'systab' information to Documentation/ABI

It's not clear right now that the order in which entries are displayed
in /sys/firmware/efi/systab actually forms an ABI that userspace tools
rely upon.

Document the ABI along with the userspace tool that cares.

Suggested-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-firmware-efi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-firmware-efi b/Documentation/ABI/testing/sysfs-firmware-efi
index 05874da7ce80..e794eac32a90 100644
--- a/Documentation/ABI/testing/sysfs-firmware-efi
+++ b/Documentation/ABI/testing/sysfs-firmware-efi
@@ -18,3 +18,13 @@ Contact:	Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 Description:	It shows the physical address of config table entry in the EFI
 		system table.
 Users:		Kexec
+
+What:		/sys/firmware/efi/systab
+Date:		April 2005
+Contact:	linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Displays the physical addresses of all EFI Configuration
+		Tables found via the EFI System Table. The order in
+		which the tables are printed forms an ABI and newer
+		versions are always printed first, i.e. ACPI20 comes
+		before ACPI.
+Users:		dmidecode
-- 
2.1.0

-- 
Matt Fleming, Intel Open Source Technology Center
