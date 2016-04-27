From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] block: partitions: efi: Always check for alternative GPT
 at end of drive
Date: Wed, 27 Apr 2016 17:09:13 +0200
Message-ID: <20160427150913.m2vvhtriq27u65tk@ws.net.home>
References: <1461632806-5946-1-git-send-email-jwerner@chromium.org>
 <20160426102014.o7k77uzi32h73y3b@ws.net.home>
 <20160426183353.GB16601@linux-uzut.site>
 <94D0CD8314A33A4D9D801C0FE68B402963904365@G4W3296.americas.hpqcorp.net>
 <20160426211547.GC16601@linux-uzut.site>
 <CAMHSBOW7MBtpVPZdt8yGggUhxk_ca3U+w9Wc-vg5fX7G-jB6mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAMHSBOW7MBtpVPZdt8yGggUhxk_ca3U+w9Wc-vg5fX7G-jB6mQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>, Julius Werner <jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 26, 2016 at 02:51:01PM -0700, Gwendal Grignou wrote:
> Julius and I were looking at the code when we spotted the issue.
> 
> As Julius said, "just pass a boot param", is not easy on certain
> machines, like phone. It is not user friendly either.
> The system won't boot at all, a typical user will have to do a full
> reinstall to fix the error.

And how typical user will fix the problem with corrupted primary
header after successful boot? I mean, use alternative header (without
force_gpt) is a good idea if we know that user will not ignore the
problem. The current solution is to force user to do anything.

It would be nice to have support for this issue in userspace 
and switch for example to single user mode, or so...

I'm also have doubts that printk() is the best way how to report 
this issue to userspace if we want to trigger any action :-)

    Karel

-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 http://karelzak.blogspot.com
