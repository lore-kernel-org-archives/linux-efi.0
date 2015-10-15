From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: CPER support for 32GiB 64GiB DIMMs
Date: Thu, 15 Oct 2015 21:56:04 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32B58478@ORSMSX114.amr.corp.intel.com>
References: <A4930445748CDC43B8495613130746F43CBE2BAF@G9W0735.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A4930445748CDC43B8495613130746F43CBE2BAF-s60kSRSX9iESZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Croxon, Nigel" <nigel.croxon-ZPxbGqLxI0U@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> Matt Fleming mentioned to me that Tony Luck recently fixed a 
> compatibility issue with Memory Error Record structure.
> I ask, how do we want to handle the processing of a CPER
> memory error record with support for larger DIMMs?

I looked at this a bit when I was making the compatibility patch.

The problem is how to take the larger value and report it to
user space.  We have all hard-coded field widths in the
trace structure used that make this non-trivial at the moment.

Supposedly there are changes coming to the perf infrastructure
that will make it easier in the future to widen a field from u16 to
u32.

See http://lkml.org/lkml/2015/6/24/715

Maybe the future Steven described is here now, and someone
can go in and fix the logging event and rasdaemon?

-Tony
