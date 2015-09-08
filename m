From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Tue, 8 Sep 2015 21:41:47 +0100
Message-ID: <20150908204147.GC2854@codeblueprint.co.uk>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
 <20150907040752.GW13182@linux-rxt1.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150907040752.GW13182@linux-rxt1.site>
Sender: stable-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@Odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>, stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 07 Sep, at 12:07:52PM, joeyli wrote:
> 
> This patch works to me on Intel S1200V3RPS to fix issue:
> DMI: Intel Corporation (uefidk.com) Intel Server Board S1200V3RPS UEFI Development Kit/ROMLEY, BIOS 2.0
> 
> Tested-by: Lee, Chun-Yi <jlee@suse.com>

When you say "fix issue", do you mean that your machine has the
EFI_PROPERTIES_TABLE feature enabled, and that it doesn't boot without
this patch?

-- 
Matt Fleming, Intel Open Source Technology Center
