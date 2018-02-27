From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 3/8] efi: Decode IA32/X64 Processor Error Info
 Structure
Date: Tue, 27 Feb 2018 18:04:23 +0100
Message-ID: <20180227170423.GK26382@pd.tnic>
References: <20180226193904.20532-1-Yazen.Ghannam@amd.com>
 <20180226193904.20532-4-Yazen.Ghannam@amd.com>
 <20180227142531.GF26382@pd.tnic>
 <DM5PR12MB191637C1857C5D9499D08D66F8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DM5PR12MB191637C1857C5D9499D08D66F8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ghannam, Yazen" <Yazen.Ghannam@amd.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 27, 2018 at 03:25:06PM +0000, Ghannam, Yazen wrote:
> This is the same as the other CPER code.

Dude, turn on brain!

So if it is in the other CPER code, we should copy it, no matter how
dumb it is?!?

> Also, the spec allows platform-defined GUIDs. So we should always print this
> even if the GUID is not defined by the spec.

We need to have a way to map the GUID to a hw part. Dumb numbers mean shit
because the error record is worthless.

> The Check Information will be decoded further in another patch.
> 
> I don't think there's much else to decode for the ID fields.

Again, those numbers can't help decoding the error, no need to dump
them. Or we find a way to make sense out of that info.

> Other tables may have the same fields but the offsets are usually different.
> So it may be more trouble than it's worth trying to unify the different tables.

If the structs are the same, you can use generic functions for dumping -
the offsets are meaningless then.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
