From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH 0/2] make all stored entries accessible.
Date: Thu, 31 Oct 2013 14:35:33 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4D01@USINDEM103.corp.hds.com>
References: <1383126294-28793-1-git-send-email-cxie@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F31D529D7@ORSMSX106.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4476@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F31D52E99@ORSMSX106.amr.corp.intel.com>
 <87d2mm6t64.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87d2mm6t64.fsf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Madper Xie <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org" <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, "anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org" <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



> 1. combine timestamp, count and part into "id".
>    for now, in efi-pstore.c, *id = part. and we could simply change it
>    to unique one. F.E. *id = (timestamp * 100 + part) * 100 + count.

My opinion close to 1.
But, the "*id" should not be the complex one like (timestamp * 100 + part) * 100 + count.
Rather, it should be a simple sequential number beginning with 1.

 - Remove "id" member from pstore_read_info struct.
 -  Introduce a global sequential counter like "static u64 efi_pstore_read_count" (or add the member to pstore_info structure?)
 - Initialize to "1" in efi_pstore_open().
 - Increment it in efi_pstore_read().

If we can do it, we don't need to touch a code of pstore filesystem and can avoid regressions of
other backend drivers.

Seiji

> -----Original Message-----
> From: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Madper Xie
> Sent: Wednesday, October 30, 2013 11:01 PM
> To: Luck, Tony
> Cc: Seiji Aguchi; Madper Xie; keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org; ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org; anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org; linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> Subject: Re: [PATCH 0/2] make all stored entries accessible.
> 
> 
> tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org writes:
> 
> >> So, do you mean efivars should fix to use the "id" in a proper way?
> >
> > It would avoid the need for all these tests, and additions to the filename to guarantee
> > uniqueness.
> >
> > Not sure what options efivars has to create a unique, persistent "id" for each
> > record.  It's a fundamental part of how ERST works (though the unique ID is just
> > based around a timestamp).
> >
> Okay, maybe there are three options here:
> 1. combine timestamp, count and part into "id".
>    for now, in efi-pstore.c, *id = part. and we could simply change it
>    to unique one. F.E. *id = (timestamp * 100 + part) * 100 + count.
> 2. change the id's type. let id become a string.
>    so every backend could write anything to id. then it will become a
>    part of filename in pstore filesystem. (but we need fix all backends
>    since we modified api.)
> 3. apply the patches I have sent... even if the filename will be ugly
>    and gory...
> Which one do you prefer?
> >> I acked Madper's patch 2/2 earlier today, but when I look at your test result, I'm not sure if
> >> it is reasonable for users to make multiple numbers visible to the file name.
> >>
> >>> -r--r--r-- 1 root root 17499 Oct 30 13:41 dmesg-erst-5940651313304961029--2129078373-1383165669
> >
> > after I added the "count = 0" initialization the filename gets a tiny bit less
> > scary:
> >
> > -r--r--r-- 1 root root 17499 Oct 30 13:41 dmesg-erst-5940651313304961029-0-1383165669
> >
> > -Tony
> 
> 
> --
> Best,
> Madper Xie.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
