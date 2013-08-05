From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [edk2] Corrupted EFI region
Date: Mon, 05 Aug 2013 18:41:20 +0200
Message-ID: <51FFD5B0.9080000@redhat.com>
References: <20130731205431.GG4724@pd.tnic>
	<1375307727.22084.103.camel@shinybook.infradead.org>
	<20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com>
	<20130805130258.GB31845@pd.tnic> <51FFAB13.4090603@redhat.com>
	<20130805140306.GD31845@pd.tnic> <51FFB660.4060400@redhat.com>
	<20130805144010.GE31845@pd.tnic> <51FFC19A.1020204@redhat.com>
	<20130805161247.GF31845@pd.tnic>
Reply-To: edk2-devel@lists.sourceforge.net
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <edk2-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20130805161247.GF31845@pd.tnic>
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

On 08/05/13 18:12, Borislav Petkov wrote:
> On Mon, Aug 05, 2013 at 05:15:38PM +0200, Laszlo Ersek wrote:
>> The current implementation (how pointers are converted) probably doesn't
>> accommodate a second call.
>>
>> Of course you want to know why SetVirtualAddressMap() was designed like
>> that... I didn't participate in the design so I don't know :)
>>
>> But, as I said, a kernel directly executing another kernel is an
>> unexpected idea. IMHO the second kernel in question doesn't fit the UEFI
>> phases at all. The OS booted like that (ie. the OS whose kernel is the
>> 2nd (=kexec) kernel) never goes through SEC, PEI, DXE, BDS.
> 
> Yes, the thing is, imposing unnecessary restrictions is very
> counterproductive. And kexec is just an example here - if
> SetVirtualAddressMap was callable an arbitrary number of times, this
> whole work I'm doing is unnecessary. So I'm jumping through hoops just
> to accomodate a braindead design.

I doubt it was a deliberate restriction. More like, there was no
incentive (... that the designers were aware of) *not* to design
something easy (or easier) to implement. Your use case has come later.

> This is what I cannot fathom in the face of people praising UEFI as the
> solution to all problems.

I agree that such people exist. I'm not one of them.

>> BTW there's another point I'd like to ask about -- you're saying you
>> see the region corruption during the same boot, from the first (early)
>> memmap dump to the second one (when just about to enter virtual mode).
>> But, is this one boot the very first boot, or the kexec one?
> 
> No, kexec is not even involved yet. If you look at the timestamps,
> there's 0.005 seconds between the two dumps during the *same* kernel
> booting on the machine, baremetal, straight from grub.

I didn't realize the timestamps survive kexec. (As far as I remember the
kernels I played with kexec on didn't have the automatic timestamps yet
in dmesg, but I might have messed up just as well...)

Laszlo

------------------------------------------------------------------------------
Get your SQL database under version control now!
Version control is standard for application code, but databases havent 
caught up. So what steps can you take to put your SQL databases under 
version control? Why should you start doing it? Read more to find out.
http://pubads.g.doubleclick.net/gampad/clk?id=49501711&iu=/4140/ostg.clktrk
