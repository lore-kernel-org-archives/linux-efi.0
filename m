From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] EFI changes for v3.16
Date: Mon, 19 May 2014 17:17:01 -0700
Message-ID: <537A9EFD.9050208@zytor.com>
References: <20140503130447.GW26088@console-pimps.org> <20140519105129.GF4798@console-pimps.org> <537A8A03.8060604@zytor.com> <20140519231012.GF6311@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140519231012.GF6311@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>
List-Id: linux-efi@vger.kernel.org

On 05/19/2014 04:10 PM, Borislav Petkov wrote:
> 
> The question is, why can't that pstore mumbo jumbo go and do its dance
> in !irq context?
> 
> And how useful is the whole deal really, btw? I wanted to use it for
> saving oopses into it, for example, but Tony said its write speed is
> horribly low for that.
> 
> So why do we even bother with this thing and do the dance in irq context
> for it? Is it worth it at all?
> 

I thought the whole point of allowing pstore in IRQ context was to write
oopsen (panics?)

	-hpa
