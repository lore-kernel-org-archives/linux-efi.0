From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 3/8] efi: Decode IA32/X64 Processor Error Info
 Structure
Date: Tue, 27 Feb 2018 19:02:31 +0100
Message-ID: <20180227180231.GO26382@pd.tnic>
References: <20180226193904.20532-1-Yazen.Ghannam@amd.com>
 <20180226193904.20532-4-Yazen.Ghannam@amd.com>
 <20180227142531.GF26382@pd.tnic>
 <DM5PR12MB191637C1857C5D9499D08D66F8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
 <20180227170423.GK26382@pd.tnic>
 <DM5PR12MB1916D78FE4EEF146EE1D8612F8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DM5PR12MB1916D78FE4EEF146EE1D8612F8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ghannam, Yazen" <Yazen.Ghannam@amd.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 27, 2018 at 05:46:54PM +0000, Ghannam, Yazen wrote:
> I think there's value in following the conventions in a subsystem.

"conventions in a subsystem" my ass. That's brainless copy-pasting.

It was added by

f6edea77c8c8 ("ACPI, APEI, CPER: Cleanup CPER memory error output format")

and then replicated everywhere.

It is simply a dumb way of writing:

	snprintf(newpfx, sizeof(newpfx), "%s ", pfx);


> I can change this if you give a reason besides "it's dumb".

Two can play that game: you get to keep it if you give a good reason
why.

> We do map the spec-defined GUIDs in patch 4 of this set. I don't know if there's
> a central place where all vendor-defined GUIDs are listed. I can look into this.

Yes, at least for the most prominent ones.

> And the raw value should still be printed because
> 1) It may represent a type that we can't decode. Maybe a type that's not part of
> the spec.

If we can't decode it, *then* you dump it:

	"Unrecognized type: 0x%llx ..."

> 2) It's good to have the raw value for reference. We do this with MCA_STATUS
> where we print the raw value followed by the decoding.

1. No one stares at the raw value if the bits are decoded
2. MCA_STATUS is one register - this error record is huge.

> The structs are all different even though some fields may be the same.

Fair enough. Only if it makes sense.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
