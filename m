From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH] Lock down drivers that can have io ports, io mem, irqs
 and dma changed
Date: Mon, 28 Nov 2016 18:23:43 -0600
Message-ID: <2cd73312-c074-1367-6daa-710d11ac68f1@acm.org>
References: <a4642e43-4598-96ca-c25a-2bd844631a47@acm.org>
 <20161116222731.563fb85e@lxorguk.ukuu.org.uk>
 <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
 <26173.1479769852@warthog.procyon.org.uk>
 <10164.1480378260@warthog.procyon.org.uk>
Reply-To: minyard@acm.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <10164.1480378260@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 11/28/2016 06:11 PM, David Howells wrote:
> Corey Minyard <minyard@acm.org> wrote:
>
>> This would prevent any IPMI interface from working if any address was given
>> on the kernel command line. I'm not sure what the best policy is, but that
>> sounds like a possible DOS to me.
> Okay, reasonable point.
>
>> Can you put this check in hardcode_find_bmc()?  Thats the only place where
>> the hardcoded addresses are used, and a check there won't affect anything
>> else.
> I could do that.  I presume you'd want hardcode_find_bmc() to return 1 in that
> case without doing anything else.  Another possibility is to give a warning
> and then clear ports[], addrs[] and irqs[].
>

Just returning -EPERM from that routine is fine, without doing anything
else.  You can basically just move your check to the top of that
routine.

>> Also, the error message sounds a little vague to me.  If I was a sysadmin
>> and got this, I wouldn't be sure what was going on.  Maybe something like:
>> The kernel is locked down, but hard-coded device addresses were given on
>> the driver command line.  Ignoring these, but this is a possible security
>> issue.
>>
>> That's fairly wordy, but it gets the point across.  You could also move the
>> pr_err() into kernel_is_locked_down() and pass in the prefix, since there is
>> basically the same pr_err() after every check.
> I don't think your suggested summary quite gets it right.  A lot of drivers,
> sound drivers, for example, that aren't really critical can simply be
> disabled - and some have to be disabled because there's no other way to
> configure them.

Yeah.  My main issue was that the sysadmin would see this and not
have any idea what was going on.

>
> It would have to be more like pr_err("Hard-coded device addresses, irqs and
> dma channels are not permitted when the kernel is locked down."), possibly
> with the addition of either "The driver has been disabled" or "These settings
> have been ignored".

That sounds better than what I had.

-corey

