From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 0/8] Decode IA32/X64 CPER
Date: Thu, 1 Mar 2018 12:59:53 +0100
Message-ID: <20180301115953.GA5040@pd.tnic>
References: <20180226193904.20532-1-Yazen.Ghannam@amd.com>
 <20180228084321.GA2969@pd.tnic>
 <DM5PR12MB1916B6CA08F0D423B3635EDDF8C70@DM5PR12MB1916.namprd12.prod.outlook.com>
 <20180228163539.GC2969@pd.tnic>
 <DM5PR12MB19169CD3BC3BAE3230C1DCA3F8C70@DM5PR12MB1916.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DM5PR12MB19169CD3BC3BAE3230C1DCA3F8C70@DM5PR12MB1916.namprd12.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ghannam, Yazen" <Yazen.Ghannam@amd.com>
Cc: Tony Luck <tony.luck@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 28, 2018 at 08:58:15PM +0000, Ghannam, Yazen wrote:
> 1) We keep this set mostly as-is. This would be our fallback if we don't have
> anything better.

Yes, sounds good. We try to decode it as MCE and if we cannot, we dump
the raw CPER record.

> 2) I add the MCA decoding to this set. I was thinking to do this in a separate
> set but maybe it's better to do it all together.

I'm fine if you do it separately, as long as you do it so that we have
user-friendly decoding in the end.

> Number 2 would mean we do a quick check on the CPER to see if it contains
> MCA info. There's no spec-defined way to do this, but we can make a good
> guess by seeing if we have an "MSR register" context and that context has
> an "MSR address" that is an MCA register.

Yap.

> If we think we have MCA info, then we pull as much out of the CPER as we
> can and put it in a struct mce which we then pass to the notifier chain.
> 
> If we don't think we have MCA info, then we fallback to number 1.

Ack.

> At the moment, it seems we'll be using x86 CPER to represent MCA errors
> in BERT since there's no other option in BERT. So I think having number 2
> would catch most, if not all, errors reported with x86 CPER.

Yeah, if you think about it, CPER is a clumsy and totally useless
indirection layer between MCA and the OS. And if the error is of
different type (AER, PCI, whatever), then it wraps around it too with
some dumb table. And that doesn't bring anything - just the need for
more support added to the OS and tools around it. Basically what you're
doing now.

I don't mind the aspect of firmware seeing the errors first and even
attempting to fix them as the firmware knows the platform intimately but
doing everything in firmware just because some misguided souls think
this gives added value but in reality ends up becoming a worse problem,
is simply the wrong wrong thing to do.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
