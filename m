From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/2] make all stored entries accessible.
Date: Thu, 31 Oct 2013 00:24:56 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D52E99@ORSMSX106.amr.corp.intel.com>
References: <1383126294-28793-1-git-send-email-cxie@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F31D529D7@ORSMSX106.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4476@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4476-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org" <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, "anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org" <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> So, do you mean efivars should fix to use the "id" in a proper way?

It would avoid the need for all these tests, and additions to the filename to guarantee
uniqueness.

Not sure what options efivars has to create a unique, persistent "id" for each
record.  It's a fundamental part of how ERST works (though the unique ID is just
based around a timestamp).

> I acked Madper's patch 2/2 earlier today, but when I look at your test result, I'm not sure if
> it is reasonable for users to make multiple numbers visible to the file name.
>
>> -r--r--r-- 1 root root 17499 Oct 30 13:41 dmesg-erst-5940651313304961029--2129078373-1383165669

after I added the "count = 0" initialization the filename gets a tiny bit less
scary:

-r--r--r-- 1 root root 17499 Oct 30 13:41 dmesg-erst-5940651313304961029-0-1383165669

-Tony
