From: Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH] block: partitions: efi: Always check for alternative GPT
 at end of drive
Date: Wed, 27 Apr 2016 08:45:41 -0700
Message-ID: <CAD=FV=WCZh-RuUghzwTkDKvVFjpLNR7RW6H_hNbS15ZqWeBjTg@mail.gmail.com>
References: <1461632806-5946-1-git-send-email-jwerner@chromium.org>
	<20160426102014.o7k77uzi32h73y3b@ws.net.home>
	<20160426183353.GB16601@linux-uzut.site>
	<94D0CD8314A33A4D9D801C0FE68B402963904365@G4W3296.americas.hpqcorp.net>
	<20160426211547.GC16601@linux-uzut.site>
	<CAMHSBOW7MBtpVPZdt8yGggUhxk_ca3U+w9Wc-vg5fX7G-jB6mQ@mail.gmail.com>
	<20160427150913.m2vvhtriq27u65tk@ws.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160427150913.m2vvhtriq27u65tk@ws.net.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Cc: Gwendal Grignou <gwendal@chromium.org>, Davidlohr Bueso <dave@stgolabs.net>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Julius Werner <jwerner@chromium.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Hi,

On Wed, Apr 27, 2016 at 8:09 AM, Karel Zak <kzak@redhat.com> wrote:
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

Presumably:

* We ended up in this situation because something (auto update,
partition resizer, etc) was making changes to the GPT and got
interrupted (power cycle, crash, etc).

* The something that was making changes will run again after the
system boots up.

* The something that was making changes will presumably be smart
enough to figure out how to fix things up.

* If we can't even boot up, that something has no chance...


...or, if we ended up in this situation because a cosmic ray hit our
storage device and corrupted the primary GPT then I'd say that we
should keep using the alternate and not care that userspace won't do
anything to fix it.  Hopefully cosmic rays are super rare and the
changes of a second one hitting and killing the secondary GPT are slim
to none.  If you're using this disk in outer space and cosmic rays are
common, presumably you've got some massive ECC going on and maybe you
even have userspace that expects periodic sector failures and knows
how to handle it.


-Doug
