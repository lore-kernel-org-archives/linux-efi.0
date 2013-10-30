From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/2] make all stored entries accessible.
Date: Wed, 30 Oct 2013 21:11:51 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D529D7@ORSMSX106.amr.corp.intel.com>
References: <1383126294-28793-1-git-send-email-cxie@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383126294-28793-1-git-send-email-cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org" <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, "anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org" <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, "seiji.aguchi-7rDLJAbr9SE@public.gmane.org" <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> 1. checking type, id, psi, count and timespec when finding duplicate entries.
> 2. adding count and timestamp  for differentiating.

Ah - I was expecting that the backend driver would have a unique "id" for
each record stored ... but is seems that this isn't true for efivars.

I just tried this patch series out with the erst backend. It seems to work, but
I was confused for a while by the filenames that I see in the pstore filesystem. There is a "--"
in the name that I couldn't quite figure out:

-r--r--r-- 1 root root 17498 Oct 30 13:41 dmesg-erst-5940651313304961025--2129078373-1383165669
-r--r--r-- 1 root root 17511 Oct 30 13:41 dmesg-erst-5940651313304961026--2129078373-1383165669
-r--r--r-- 1 root root 17530 Oct 30 13:41 dmesg-erst-5940651313304961027--2129078373-1383165669
-r--r--r-- 1 root root 17492 Oct 30 13:41 dmesg-erst-5940651313304961028--2129078373-1383165669
-r--r--r-- 1 root root 17499 Oct 30 13:41 dmesg-erst-5940651313304961029--2129078373-1383165669
-r--r--r-- 1 root root 17512 Oct 30 13:41 dmesg-erst-5940651313304961030--2129078373-1383165669
-r--r--r-- 1 root root 17531 Oct 30 13:41 dmesg-erst-5940651313304961031--2129078373-1383165669
-r--r--r-- 1 root root 17488 Oct 30 13:44 dmesg-erst-5940652283967569921--2129078373-1383165895
-r--r--r-- 1 root root 17512 Oct 30 13:44 dmesg-erst-5940652283967569922--2129078373-1383165895
-r--r--r-- 1 root root 17512 Oct 30 13:44 dmesg-erst-5940652283967569923--2129078373-1383165895
-r--r--r-- 1 root root 17500 Oct 30 13:44 dmesg-erst-5940652283967569924--2129078373-1383165895
-r--r--r-- 1 root root 17536 Oct 30 13:44 dmesg-erst-5940652283967569925--2129078373-1383165895
-r--r--r-- 1 root root 17513 Oct 30 13:44 dmesg-erst-5940652283967569926--2129078373-1383165895
-r--r--r-- 1 root root 17513 Oct 30 13:44 dmesg-erst-5940652283967569927--2129078373-1383165895
-r--r--r-- 1 root root 17501 Oct 30 13:44 dmesg-erst-5940652283967569928--2129078373-1383165895

The filename came from:
+               sprintf(name, "dmesg-%s-%lld-%d-%ld%s", psname, id, count,
+                       timestamp, compressed ? ".enc.z" : "");

So I guess that "count" is  -2129078373 - which is some uninitialized junk from the stack frame
of pstore_get_records() for the "int count" variable ... the erst reader function doesn't touch it.

I'll add an initializer "int count = 0;" there when applying the patches.

-Tony
