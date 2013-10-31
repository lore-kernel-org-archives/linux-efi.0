From: Madper Xie <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] make all stored entries accessible.
Date: Thu, 31 Oct 2013 11:00:35 +0800
Message-ID: <87d2mm6t64.fsf@gmail.com>
References: <1383126294-28793-1-git-send-email-cxie@redhat.com> <3908561D78D1C84285E8C5FCA982C28F31D529D7@ORSMSX106.amr.corp.intel.com> <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4476@USINDEM103.corp.hds.com> <3908561D78D1C84285E8C5FCA982C28F31D52E99@ORSMSX106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <3908561D78D1C84285E8C5FCA982C28F31D52E99-P5GAC/sN6hlZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "keescook@chromium.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "ccross@android.com" <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, "anton@enomsg.org" <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, "linux-efi@vger.kernel.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "bbboson@gmail.com" <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org writes:

>> So, do you mean efivars should fix to use the "id" in a proper way?
>
> It would avoid the need for all these tests, and additions to the filename to guarantee
> uniqueness.
>
> Not sure what options efivars has to create a unique, persistent "id" for each
> record.  It's a fundamental part of how ERST works (though the unique ID is just
> based around a timestamp).
>
Okay, maybe there are three options here:
1. combine timestamp, count and part into "id".
   for now, in efi-pstore.c, *id = part. and we could simply change it
   to unique one. F.E. *id = (timestamp * 100 + part) * 100 + count.
2. change the id's type. let id become a string.
   so every backend could write anything to id. then it will become a
   part of filename in pstore filesystem. (but we need fix all backends
   since we modified api.)
3. apply the patches I have sent... even if the filename will be ugly
   and gory...
Which one do you prefer?
>> I acked Madper's patch 2/2 earlier today, but when I look at your test result, I'm not sure if
>> it is reasonable for users to make multiple numbers visible to the file name.
>>
>>> -r--r--r-- 1 root root 17499 Oct 30 13:41 dmesg-erst-5940651313304961029--2129078373-1383165669
>
> after I added the "count = 0" initialization the filename gets a tiny bit less
> scary:
>
> -r--r--r-- 1 root root 17499 Oct 30 13:41 dmesg-erst-5940651313304961029-0-1383165669
>
> -Tony


-- 
Best,
Madper Xie.
