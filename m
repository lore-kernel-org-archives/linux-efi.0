From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 2/8] efi: Decode IA32/X64 Processor Error Section
Date: Tue, 27 Feb 2018 18:44:46 +0100
Message-ID: <20180227174446.GN26382@pd.tnic>
References: <20180226193904.20532-1-Yazen.Ghannam@amd.com>
 <20180226193904.20532-3-Yazen.Ghannam@amd.com>
 <20180227112234.GE26382@pd.tnic>
 <DM5PR12MB1916B6AEE434A345E78BE234F8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
 <20180227170034.GJ26382@pd.tnic>
 <DM5PR12MB1916F8C7DF93C1C9402AE3ECF8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DM5PR12MB1916F8C7DF93C1C9402AE3ECF8C00@DM5PR12MB1916.namprd12.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ghannam, Yazen" <Yazen.Ghannam@amd.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 27, 2018 at 05:27:39PM +0000, Ghannam, Yazen wrote:
> Sure, we can print the fields unconditionally if Ard is okay with that.
> 
> The issue is that the x86 behavior will be different from all the others, so that
> might be confusing.

Confusing for whom?

Are we sharing tools with other arches or what am I missing?

> This set does decode everything fully so that people can read the error.

No, it doesn't. It dumps

        printk("%sValidation Bits: 0x%016llx\n", pfx, proc->validation_bits);

        printk("%sError Structure Type: %pUl\n", newpfx,
                &err_info->err_type);

        printk("%sCheck Information: 0x%016llx\n", newpfx,
                 err_info->check_info);

and so on which are half-baked.

Think of it this way: if you look at the error record and you still need
to look at the spec to decode it, then it is still not good enough.

Users don't care about validation bits, or unreadable GUIDs or WTF is
"Check Information" even?

"This section details the layout of the Processor Error Information
Structure and the detailed check information which is contained within."

And that "Check Information" thing is mentioned only twice in the whole
spec.

StructureErrorType only there in the table.

Very informative that.

So no, users don't care about any of that internal crap - they wanna
know what is wrong with their box and that should be written in plain
english.

> I already mentioned in the Context info patch that there could be
> further decoding which we can do in the future.

Then decode only those pieces fully now which you can do now and when
you add something in the future, add it then with the full decoding
functionality. No fields which need additional decoding with the spec
opened on one side.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
