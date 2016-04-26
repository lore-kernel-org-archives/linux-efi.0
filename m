From: Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] block: partitions: efi: Always check for alternative GPT
 at end of drive
Date: Tue, 26 Apr 2016 14:51:01 -0700
Message-ID: <CAMHSBOW7MBtpVPZdt8yGggUhxk_ca3U+w9Wc-vg5fX7G-jB6mQ@mail.gmail.com>
References: <1461632806-5946-1-git-send-email-jwerner@chromium.org>
 <20160426102014.o7k77uzi32h73y3b@ws.net.home> <20160426183353.GB16601@linux-uzut.site>
 <94D0CD8314A33A4D9D801C0FE68B402963904365@G4W3296.americas.hpqcorp.net> <20160426211547.GC16601@linux-uzut.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160426211547.GC16601-95RKjC4jbl+7r5TWoziOLQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Cc: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Julius Werner <jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Doug Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 26, 2016 at 2:15 PM, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org> wrote:
> On Tue, 26 Apr 2016, Elliott, Robert (Persistent Memory) wrote:
>

>
> I have nothing against the agpt, just pass a boot param and voila,
> you can use it. This is not some sort of recent regression we are
> talking about here. How is this such a burden all of a sudden?
Julius and I were looking at the code when we spotted the issue.

As Julius said, "just pass a boot param", is not easy on certain
machines, like phone. It is not user friendly either.
The system won't boot at all, a typical user will have to do a full
reinstall to fix the error.

Running with forced_gpt always on is not a solution either, because SD
card formatted with a plain MBR over an older image with a GPT won't
be mounted properly: that newer MBR will be ignored.

Gwendal.
>
> Thanks,
> Davidlohr
