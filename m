From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi: Fix multiple GOP device support
Date: Wed, 14 Oct 2015 16:02:15 +0100
Message-ID: <20151014150215.GC2782@codeblueprint.co.uk>
References: <1444659236-24837-1-git-send-email-matt@codeblueprint.co.uk>
 <1444659236-24837-2-git-send-email-matt@codeblueprint.co.uk>
 <20151014144715.GA17890@gmail.com>
 <20151014145103.GB17890@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151014145103.GB17890@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, =?utf-8?B?S8WRdsOhZ8OzLCBab2x0w6Fu?= <dirty.ice.hu@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, stable@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Wed, 14 Oct, at 04:51:04PM, Ingo Molnar wrote:
> 
> Ah, I see, this is a subtle semantic conflict with pending v4.4 EFI changes in 
> tip:core/efi, which changed fb_base from u32 to u64:
> 
>   ae2ee627dc87 ("efifb: Add support for 64-bit frame buffer addresses")
 
Yeah, that's exactly the issue. I should have given you a heads up
about this but I forgot that there were two patches to this area in
separate branches. 

> (Interestingly there was no textual conflict between this patch and that commit.)
> 
> So the fix patch is fine as-is for v4.3, but needs a conflict resolution for the 
> pending v4.4 commit.
> 
> I've applied it that way.

Do you need me to send a patch on top or have you taken care of the
semantic conflict for v4.4? (the change you originally proposed,
s/u32/u64/, looked fine)

-- 
Matt Fleming, Intel Open Source Technology Center
