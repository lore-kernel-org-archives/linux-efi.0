From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v4 11/12] x86: reserve setup_data ranges late after
 parsing memmap cmdline
Date: Wed, 27 Nov 2013 16:07:10 +0100
Message-ID: <20131127150710.GH32267@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-12-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1385445477-9665-12-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org, hpa@zytor.com, James.Bottomley@HansenPartnership.com, vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org, greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 26, 2013 at 01:57:56PM +0800, Dave Young wrote:
> Kdump kernel using memmap=exactmap, move e820_reserve_setup_data after
> parsing early params so they can be set reserved finally. Or kdump kernel
> will warn about ioremap a normal ram range.

I had to stare for a while at this commit message, rereading it a couple
of times and looking at the code in order to understand why you're
moving the call further down.

Please rewrite it into something more readable.

The usual structure which you could use is:

1. Currently we have A
2. We need B
3. In order to achieve it, we do C

or something to that effect.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
