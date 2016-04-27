From: Julius Werner <jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] block: partitions: efi: Always check for alternative GPT
 at end of drive
Date: Wed, 27 Apr 2016 14:44:11 -0700
Message-ID: <CAODwPW9CyyhfB-0e_xefaE8NbLQ8Yi2OCRKeXqZtdTq6CDyqLg@mail.gmail.com>
References: <1461632806-5946-1-git-send-email-jwerner@chromium.org>
	<20160426102014.o7k77uzi32h73y3b@ws.net.home>
	<20160426183353.GB16601@linux-uzut.site>
	<94D0CD8314A33A4D9D801C0FE68B402963904365@G4W3296.americas.hpqcorp.net>
	<20160426211547.GC16601@linux-uzut.site>
	<CAMHSBOW7MBtpVPZdt8yGggUhxk_ca3U+w9Wc-vg5fX7G-jB6mQ@mail.gmail.com>
	<20160427150913.m2vvhtriq27u65tk@ws.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160427150913.m2vvhtriq27u65tk-xkT7n84Rsxv/9pzu0YdTqQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>, Julius Werner <jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 27, 2016 at 8:09 AM, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Apr 26, 2016 at 02:51:01PM -0700, Gwendal Grignou wrote:
>> Julius and I were looking at the code when we spotted the issue.
>>
>> As Julius said, "just pass a boot param", is not easy on certain
>> machines, like phone. It is not user friendly either.
>> The system won't boot at all, a typical user will have to do a full
>> reinstall to fix the error.
>
> And how typical user will fix the problem with corrupted primary
> header after successful boot? I mean, use alternative header (without
> force_gpt) is a good idea if we know that user will not ignore the
> problem. The current solution is to force user to do anything.
>
> It would be nice to have support for this issue in userspace
> and switch for example to single user mode, or so...
>
> I'm also have doubts that printk() is the best way how to report
> this issue to userspace if we want to trigger any action :-)

Holding the whole system hostage and forcing manual action is *not*
user-friendly behavior. Linux is no longer just something for hobbyist
hackers to install on their converted Windows machines at home... it
is a mature, modern operating system kernel used on a wide range of
devices (server farms, phones, embedded systems, etc.) and it should
behave like one. Not all of these platforms necessarily make it easy
for the user to drop into grub and add some command line parameters,
and it's the kernel's job to provide a suitable environment for all of
them so that policy decisions can be left to userspace.

So yes, userspace should resolve this problem, but in order to do that
you need to allow userspace to boot first! dmesg is one suitable way
to communicate the problem, and there are others which I wouldn't be
opposed to either, but no matter which channel we choose the kernel
still has to continue booting to allow the rest of the OS to deal with
it. Whether to ignore, silently repair or fail to boot from a
corrupted primary GPT is a policy decision and it should be made in
user space... if you need to retain the current behavior, it's easy to
add an init script that greps for GPT warnings and hangs to your
distro.
