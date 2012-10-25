From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH v2 3/5] efi_pstore: Remove a logic erasing entries from
 a write callback to hold multiple logs
Date: Thu, 25 Oct 2012 21:37:50 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138899AF@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D4138889AD@USINDEM103.corp.hds.com>
 <CAGTjWtDVZGq7VKou10xC-zJXGmane_kKjGo1xMjgPUkKAedFqQ@mail.gmail.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D413889851@USINDEM103.corp.hds.com>
 <CAGTjWtAUv=HzOGPDeDuTb_6z81bnSQ-F7DDERZ2tqmfaP4wXwQ@mail.gmail.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D413889905@USINDEM103.corp.hds.com>
 <CAGTjWtDEQx8mCKtNTGGSOMajAoSCJTaKWG8TBmYinQMPfx5DQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGTjWtDEQx8mCKtNTGGSOMajAoSCJTaKWG8TBmYinQMPfx5DQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Luck, Tony (tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Matthew Garrett (mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Satoru Moriya <satoru.moriya-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> > On the other hand, patch 5/5 changes the format by adding sequence counter.
> > But efi_pstore_read is modied to work correctly in it.
> >
> >         dump-type0-1-1-1351113059-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
> >
> >         Variable Name: dump-type0-1-1-1351113059
> >         GUID: cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
> >
> > If I need to elaborate more, please feel free to ask me:) I'm not sure
> > if I understand your question completely.
> 
> In this case, I think efi_pstore_read in patch 5/5 should probably fall-back to trying to do a sscanf(...) == 3 if the sscanf(...) == 4 test fails
> so that dumps for older dumps from previous kernels are still visible to users, no?  They can perhaps get a default count of 0?
> efi_pstore_erase would have to be updated to understand this as well.

OK. I understand your concern.
I will update my patch to work with an old format too.
In addition to efi_pstore_read(), efi_pstore_erase should be modified.

Anyway, I will post a patch v3 later.

Thank you for reviewing.

Seiji
