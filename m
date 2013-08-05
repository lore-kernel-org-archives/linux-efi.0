From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [edk2] Corrupted EFI region
Date: Mon, 05 Aug 2013 14:37:08 -0700
Message-ID: <52001B04.2050806@zytor.com>
References: <20130731205431.GG4724@pd.tnic>
	<1375307727.22084.103.camel@shinybook.infradead.org>
	<20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com>
	<20130805130258.GB31845@pd.tnic> <51FFAB13.4090603@redhat.com>
	<20130805140306.GD31845@pd.tnic> <51FFB660.4060400@redhat.com>
	<20130805144010.GE31845@pd.tnic>
	<2DBE3EA4-E321-4A7B-B9AF-EDE55BC2E358@apple.com>
	<20130805181225.GH31845@pd.tnic>
Reply-To: edk2-devel@lists.sourceforge.net
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <edk2-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20130805181225.GH31845@pd.tnic>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/edk2-devel>,
	<mailto:edk2-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=edk2-devel>
List-Post: <mailto:edk2-devel@lists.sourceforge.net>
List-Help: <mailto:edk2-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/edk2-devel>,
	<mailto:edk2-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: edk2-devel-bounces@lists.sourceforge.net
To: Borislav Petkov <bp@alien8.de>
Cc: linux-efi@vger.kernel.org, Gleb Natapov <gleb@redhat.com>, David Woodhouse <dwmw2@infradead.org>, edk2-devel@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 08/05/2013 11:12 AM, Borislav Petkov wrote:
> On Mon, Aug 05, 2013 at 08:50:17AM -0700, Andrew Fish wrote:
>> AFAICT EFI pre-dates kexec merge into mainline by a number of years as
>> SetVirtualaddressMap() was part of EFI 1.0 (previous millennium)
> 
> Ok, fair enough.
> 
>> The EFI to UEFI conversion was placing EFI 1.10 into an industry
>> standard, UEFI 2.0. UEFI is an industry standard so some one just
>> needs to make a proposal to update the spec. The edk2 open source
>> project is not part of the standards body so complaining on this
>> mailing list is not going to get anything changed.
> 
> Right, I don't think that even changing the spec would help - it would
> actually make things worse because then we'd have to differentiate
> between UEFI versions: those which can do SetVirtualaddressMap() more
> than once and the older ones.
> 
> So let's drop the discussion here - it is what it is, it is too late to
> change anything. At least we talked about it. :-)
> 

All of this would be a non-problem if there weren't buggy
implementations which can't run *without* SetVirtualAddressMap().

	-=hpa



------------------------------------------------------------------------------
Get your SQL database under version control now!
Version control is standard for application code, but databases havent 
caught up. So what steps can you take to put your SQL databases under 
version control? Why should you start doing it? Read more to find out.
http://pubads.g.doubleclick.net/gampad/clk?id=49501711&iu=/4140/ostg.clktrk
