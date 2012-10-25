From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH v2 3/5] efi_pstore: Remove a logic erasing entries from
 a write callback to hold multiple logs
Date: Thu, 25 Oct 2012 20:03:49 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413889851@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D4138889AD@USINDEM103.corp.hds.com>
 <CAGTjWtDVZGq7VKou10xC-zJXGmane_kKjGo1xMjgPUkKAedFqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGTjWtDVZGq7VKou10xC-zJXGmane_kKjGo1xMjgPUkKAedFqQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Luck, Tony (tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Matthew Garrett (mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Satoru Moriya <satoru.moriya-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> > -               list_del(&found->list);
> > +       sprintf(name, "dump-type%u-%u-%lu", type, part,
> > +               get_seconds());
> 
> Actually, nothing seems to be ensuring that the value used here ends up being the same as the ctime :\  Consider what happens if the
> get_seconds() call here happens at second N, and the i_ctime is collected at time N+1. The object wouldn't be able to be deleted after
> patch 4/5 is applied.  How can we better ensure that the i_ctime is the same value as serialized into the efi var name here?

 i_ctime of pstore file system is different from normal file systems.
As I said in patch v1, i_ctime of pstore means the date that the record was "originally" stored.
 
I_ctime is always set to N.
Here is the scenario.

1.  writing time
    - get_seconds() call here happens at second N
    - "N" is stored to a variable name

2. System reboots...
3. System boots up...

4. reading time
   - pstore calls a read callback, efi_pstore_read()
   -  efi_pstore_read extracts ctime, "N", from the virable name
   -  efi_pstore passes "N" to pstore file system
    - pstore create a file, /dev/pstore/dmesg* and set "N" to i_ctime

Pstore file system doesn't set i_ctime by itself but set ctime passed by platform drivers.

Seiji
