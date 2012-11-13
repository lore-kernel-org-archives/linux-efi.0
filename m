From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v5 0/7] efi_pstore: multiple event logging support
Date: Tue, 13 Nov 2012 18:43:08 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D5F3A0@ORSMSX108.amr.corp.intel.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D4138C155D@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D4138C155D-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, "anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Matthew Garrett (mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Satoru Moriya <satoru.moriya-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

v4 -> v5
   - Rebase to 3.7-rc5
   - Add count to an argument of a write callback executed in pstore_console_write()
     to build successfully in case where CONSIG_PSTORE_CONSOLE=y is specified. (Patch 5/7)

Applied. It's in my
   git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git next
tree now so should pick up into linux-next by tomorrow or the day after.

-Tony
