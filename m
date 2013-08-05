From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [edk2] Corrupted EFI region
Date: Mon, 05 Aug 2013 17:15:38 +0200
Message-ID: <51FFC19A.1020204@redhat.com>
References: <20130731205431.GG4724@pd.tnic>
	<1375307727.22084.103.camel@shinybook.infradead.org>
	<20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com>
	<20130805130258.GB31845@pd.tnic> <51FFAB13.4090603@redhat.com>
	<20130805140306.GD31845@pd.tnic> <51FFB660.4060400@redhat.com>
	<20130805144010.GE31845@pd.tnic>
Reply-To: edk2-devel@lists.sourceforge.net
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <edk2-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20130805144010.GE31845@pd.tnic>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/edk2-devel>,
	<mailto:edk2-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=edk2-devel>
List-Post: <mailto:edk2-devel@lists.sourceforge.net>
List-Help: <mailto:edk2-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/edk2-devel>,
	<mailto:edk2-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: edk2-devel-bounces@lists.sourceforge.net
To: Borislav Petkov <bp@alien8.de>
Cc: linux-efi@vger.kernel.org, Gleb Natapov <gleb@redhat.com>, edk2-devel@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
List-Id: linux-efi@vger.kernel.org

On 08/05/13 16:40, Borislav Petkov wrote:
> On Mon, Aug 05, 2013 at 04:27:44PM +0200, Laszlo Ersek wrote:
>> I wouldn't call the design of SetVirtualAddressMap() braindead.
> 
> Ok, I've always wondered and you could probably shed some light on the
> matter: why is SetVirtualAddressMap() a call-once only? Why can't I
> simply call it again and update the mappings?

The current implementation (how pointers are converted) probably doesn't
accommodate a second call.

Of course you want to know why SetVirtualAddressMap() was designed like
that... I didn't participate in the design so I don't know :)

But, as I said, a kernel directly executing another kernel is an
unexpected idea. IMHO the second kernel in question doesn't fit the UEFI
phases at all. The OS booted like that (ie. the OS whose kernel is the
2nd (=kexec) kernel) never goes through SEC, PEI, DXE, BDS.

SetVirtualAddressMap() is a firmware interface, but the kexec OS
(including its private boot loader and kernel) are not loaded by firmware.

> 
>> I'd rather call kexec unique and somewhat unexpected :)
> 
> In all fairness, it was there before UEFI, AFAICT.

That doesn't matter as long as the UEFI designers aren't aware of it :)

(Who should have made whom aware, ie. Linux people approaching UEFI
people, or UEFI people exploring Linux, is a separate topic. As always
I'm apolitical about UEFI; I'm not arguing for it or against it. My
feeble efforts for improving OVMF and interfacing code are motivated by
my employer, not my world view, but as a side-effect of working with the
code I can't help but notice some nice things in edk2 and appreciate
them :))

>>> I wouldn't wonder if we f*cked it up again like the last time. I'll give
>>> it a long hard look.
>>
>> Ah sorry, by "and you guys suspect" I didn't mean to imply anything
>> between the lines, I was simply trying to ascertain your working idea :)
> 
> As long as we get to the bottom of this, we're all fine. And I'd
> pretty much expect everyone who is dealing with EFI to have grown a
> sufficiently thick skin before starting to do so, so don't worry.
> 
> :-)

This is a unique opportunity for me to point the following. (Unique
because it wasn't me bringing up the thick skin thing :)) My skin is
*very thin*. It's not even there, you could say. So, if I mess up,
please don't insult me. (As explained before, my own language above
wasn't even tongue-in-cheek.) Insult my code or my analysis pls.

BTW there's another point I'd like to ask about -- you're saying you see
the region corruption during the same boot, from the first (early)
memmap dump to the second one (when just about to enter virtual mode).
But, is this one boot the very first boot, or the kexec one?

Thanks!
Laszlo

------------------------------------------------------------------------------
Get your SQL database under version control now!
Version control is standard for application code, but databases havent 
caught up. So what steps can you take to put your SQL databases under 
version control? Why should you start doing it? Read more to find out.
http://pubads.g.doubleclick.net/gampad/clk?id=49501711&iu=/4140/ostg.clktrk
