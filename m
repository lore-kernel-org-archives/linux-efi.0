From: Shuah Khan <shuahkhan@gmail.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Fri, 2 Nov 2012 10:35:43 -0600
Message-ID: <CAKocOOMyfacUAzqaXLNQdBciFBS25A8AV2xai-yJs-TfsAWQ_A@mail.gmail.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
	<20121031150201.GA12394@srcf.ucam.org>
	<20121102153047.GF3300@redhat.com>
	<20121102154248.GA7681@srcf.ucam.org>
	<20121102155247.GH3300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20121102155247.GH3300@redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Matthew Garrett <mjg@redhat.com>, Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 2, 2012 at 9:52 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Nov 02, 2012 at 03:42:48PM +0000, Matthew Garrett wrote:
>> On Fri, Nov 02, 2012 at 11:30:48AM -0400, Vivek Goyal wrote:
>>
>> > "crash" utility has module which allows reading kernel memory. So leaking
>> > this private key will be easier then you are thinking it to be.
>>
>> That's not upstream, right?
>
> Yes, checked with Dave, it is not upstream. Well, still it is a concern
> for distro kernel.
>
> So if we keep private key in kernel, looks like we shall have to disable
> one more feature in secureboot mode.
>
I have been following parts of this thread and beginning to think,
"Are we over engineering" the solution for secureboot. Do we have a
list of what is must to meet the Spec.? At this point, Linux
secureboot solution is sounding so pervasive and will impact every
aspect of Linux user's and kernel developer's use pattern. So far I
picked up on the following:

Kernel need to be signed.
firmware kernel loads needs to be signed
What else?

Is there a list of what all needs to be signed? I am interested in
seeing a list of requirements. At some point, OS will be so secure
that, will it become so complex to run anything on it and continue to
do development as we are used to doing today? I don't pretend to know
much about secureboot, and I am asking as a concerned Linux user, and
kernel developer.

-- Shuah
